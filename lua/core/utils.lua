---@return boolean
function IsFolded()
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    local fold_closed = vim.api.nvim_eval("foldclosed(" .. line_number .. ")")
    return fold_closed ~= -1
end

function MoveLineOrItemUp()
    vim.cmd(":m .-2")
end

function MoveLineOrItemDown()
    vim.cmd(":m .+1")
end

local function buffer_to_string_array()
    return vim.api.nvim_buf_get_lines(
        0,
        0,
        vim.api.nvim_buf_line_count(0),
        false)
end

function GetCharactersAmountInCurrentBuffer()
    local lines = buffer_to_string_array()
    local count = 0
    for _, line in ipairs(lines) do
        count = count + string.len(line)
    end

    return count
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function get_file_name(line)
    local line_chars = {}
    for c in line:gmatch(".") do
        table.insert(line_chars, c)
    end

    while true do
        local s, e = string.find(line, "[\128-\191]")

        if not s then
            break
        end

        line = string.sub(line, e + 1, line:len())
    end
    return line:gsub("%s+", "")
end

local function spaces_in_string_left(str)
    local count = 0
    for c in str:gmatch "." do
        if c == " " then
            count = count + 1
        else
            return count
        end
    end
    return count
end

DIRECTORY = 0
FILE = 1
NON_EXISTENT = 2

---@return boolean
---@param path string
function Exists(path)
    local ok, _, code = os.rename(path, path)
    if not ok then
        if code == 13 then
            return true
        end
    end
    return ok
end

---@return integer
---@param path string
local function get_file_type(path)
    if not Exists(path) then
        return NON_EXISTENT
    end

    if Exists(path .. "/") then
        return DIRECTORY
    end

    return FILE
end
---@return string, boolean
local function find_file_recursive(path, file_name)
    local dir = io.popen('ls -a "' .. path .. '"')
    local file_name_without_extention = path:match("[^/]+$")
    if file_name_without_extention == "target" then
        return "", false
    end
    if get_file_type(path) ~= DIRECTORY or dir == nil then
        return "", false
    end

    for current_file_name in dir:lines() do
        local full_path = path .. "/" .. current_file_name
        if get_file_type(full_path) == DIRECTORY then
            local found_path, ok = find_file_recursive(full_path, file_name)
            if ok then
                return found_path, true
            end
        end
        if current_file_name == file_name then
            return full_path, true
        end
    end

    return "", false
end

---@return string, boolean
function GetSelectedFileOrDirPath()
    local current_buffer_name = vim.fn.expand("%")
    if not current_buffer_name:find("NvimTree") then
        print("Current buffer is not NvimTree")
        return "", false
    end

    local cwd = vim.loop.cwd();
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_pos = cursor_pos[1]
    local lines = buffer_to_string_array()
    local file_name = get_file_name(lines[line_pos])
    return find_file_recursive(cwd, file_name)
end

---@param command string
function PerformCommandOnSelectedFile(command)
    local current_buffer_name = vim.fn.expand("%")
    if not current_buffer_name:find("NvimTree") then
        print("Current buffer is not NvimTree")
        return
    end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_pos = cursor_pos[1]
    local lines = buffer_to_string_array()

    local full_file_name = get_file_name(lines[line_pos])
    local min_spaces_count = spaces_in_string_left(lines[line_pos])
    for i = line_pos, 1, -1 do
        local current_line = lines[i]
        local spaces_count = spaces_in_string_left(current_line)
        if spaces_count < min_spaces_count then
            min_spaces_count = spaces_count
            -- if line_is_open_folder(current_line) then
            local folder_name = get_file_name(current_line)
            full_file_name = folder_name .. "/" .. full_file_name
        end
    end

    local cwd = vim.loop.cwd();
    full_file_name = cwd .. "/" .. full_file_name
    print(full_file_name)
    if not file_exists(full_file_name) then
        return
    end
    vim.fn.jobstart(command .. " " .. full_file_name)
end
