local preview_win_id = nil
-- local preview_buf_id = nil

local function close_preview()
  if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
    vim.api.nvim_win_close(preview_win_id, true)
  end
  preview_win_id = nil
  -- preview_buf_id = nil
end

local function float_preview()
  local idx = vim.fn.line('.')
  local entry = vim.fn.getqflist()[idx]
  if not entry or not entry.bufnr then
    vim.notify('No quickfix list!', vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(entry.bufnr)
  local lnum = entry.lnum
  if file == '' then
    vim.notify('No relative file!', vim.log.levels.WARN)
    return
  end

  local buf = entry.bufnr
  if not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.fn.bufadd(file)
    vim.fn.bufload(buf)
  end

  -- 如果预览窗口已存在，直接更新内容
  if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
    vim.api.nvim_win_set_buf(preview_win_id, buf)
    vim.api.nvim_win_set_cursor(preview_win_id, { lnum, 0 })
    vim.api.nvim_win_call(preview_win_id, function()
      vim.cmd('normal! zz')   -- 目标行居中
    end)
    return
  end

  close_preview()

  -- 窗口尺寸：可自行调整，这里使用屏幕的 50% 宽、60% 高
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  -- 左上角：row = 0, col = 0
  -- local row = 0
  -- local col = 0
  -- 右上角定位
  local row = 0                         -- 顶部
  local col = vim.o.columns - width - 2 -- 右对齐，-2 保留边框空间

  preview_win_id = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = file:gsub('^.*/', ''),  -- 窗口标题显示文件名
    title_pos = 'center',
  })

  -- 设置窗口选项（Neovim 0.12 新写法）
  vim.wo[preview_win_id].cursorline = true
  vim.wo[preview_win_id].number = true
  vim.wo[preview_win_id].relativenumber = true
  vim.wo[preview_win_id].signcolumn = 'yes'
  vim.wo[preview_win_id].winblend = 25

  -- 光标定位并居中
  vim.api.nvim_win_set_cursor(preview_win_id, { lnum, 0 })
  vim.api.nvim_win_call(preview_win_id, function()
    vim.cmd('normal! zz')
  end)

  -- 预览 buffer 设为只读
  vim.bo[buf].modifiable = false

  -- 预览窗口关闭时清理
  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = buf,
    once = true,
    callback = function()
      preview_win_id = nil
      -- preview_buf_id = nil
    end,
  })
end

-- 滚动预览窗口的辅助函数
local function scroll_preview(direction)
  if not preview_win_id or not vim.api.nvim_win_is_valid(preview_win_id) then
    return
  end
  -- 获取预览窗口当前光标位置
  local cur = vim.api.nvim_win_get_cursor(preview_win_id)
  local cur_line = cur[1]
  -- 预览窗口高度（行数）
  local win_height = vim.api.nvim_win_get_height(preview_win_id)
  -- 半页偏移量（模仿 <C-u>/<C-d> 的默认行为）
  local offset = math.floor(win_height / 2)
  if direction == 'up' then
    offset = -offset
  end
  local new_line = math.max(1, cur_line + offset)
  -- 获取 buffer 总行数，防止超出
  local buf = vim.api.nvim_win_get_buf(preview_win_id)
  local total = vim.api.nvim_buf_line_count(buf)
  new_line = math.min(new_line, total)
  -- 设置新光标位置并居中显示
  vim.api.nvim_win_set_cursor(preview_win_id, { new_line, 0 })
  vim.api.nvim_win_call(preview_win_id, function()
    vim.cmd('normal! zz')
  end)
end

local function get_main_window()
  -- 返回第一个非 quickfix、非浮动的普通窗口
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= 'qf' then
      local cfg = vim.api.nvim_win_get_config(win)
      if not cfg.relative or cfg.relative == '' then  -- 排除浮动窗口
        return win
      end
    end
  end
  -- 如果找不到（比如只有 quickfix 窗口），则回退到当前窗口
  return vim.api.nvim_get_current_win()
end

-- 将浮动预览窗口转换为正式 buffer 窗口（垂直分割）
local function convert_preview_to_split()
  if not preview_win_id or not vim.api.nvim_win_is_valid(preview_win_id) then
    vim.notify('没有可转换的预览窗口', vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_win_get_buf(preview_win_id)
  local lnum = vim.api.nvim_win_get_cursor(preview_win_id)[1]

  close_preview()

  -- 关键：确保该 buffer 出现在 buffer 列表中
  vim.bo[buf].buflisted = true

  -- 切换到主窗口（非 quickfix 窗口）
  local main_win = get_main_window()
  vim.api.nvim_set_current_win(main_win)

  -- 在主窗口创建垂直分屏（可改为 'split' 做水平分屏）
  vim.cmd('vsplit')
  -- 新分屏就是当前窗口
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_cursor(0, { lnum, 0 })
  vim.cmd('normal! zz')

  -- 取消只读，方便编辑
  vim.bo[buf].modifiable = true
end

-- 智能 <CR>：预览/转换二合一
local function smart_cr()
  if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
    -- 预览已打开：转换为正式窗口
    convert_preview_to_split()
  else
    -- 预览未打开：创建浮动预览
    float_preview()
  end
end

-- 在 quickfix 窗口添加映射
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    -- <p> 打开/更新浮动预览
    vim.keymap.set('n', 'p', float_preview, { buffer = true, nowait = true, silent = true })

    -- <CR>：首次创建浮动预览，预览已存在时转换为正式窗口
    vim.keymap.set('n', '<CR>', smart_cr, { buffer = true, nowait = true, silent = true })

    -- Ctrl+u/d 滚动预览窗口（始终可用）
    vim.keymap.set('n', '<C-u>',
            function() scroll_preview('up') end,
            { buffer = true, silent = true, nowait = true })
    vim.keymap.set('n', '<C-d>',
            function() scroll_preview('down') end,
            { buffer = true, silent = true, nowait = true })

    -- q 关闭预览窗口，若已无预览则关闭 quickfix 窗口
    vim.keymap.set('n', 'q', function()
      if preview_win_id and vim.api.nvim_win_is_valid(preview_win_id) then
        close_preview()
      else
        vim.cmd('close')
      end
    end, { buffer = true, silent = true })
  end,
})
