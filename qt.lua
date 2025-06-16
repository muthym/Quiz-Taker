local ansi = {
    reset = "\27[0m", red = "\27[31m", green = "\27[32m",
    yellow = "\27[33m", blue = "\27[34m", cyan = "\27[36m",
    magenta = "\27[35m", bold = "\27[1m"
}

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function confirm(prompt)
    io.write(prompt .. " (y/n): ")
    local ans = io.read("*l"):lower()
    return ans == "y"
end

-- Get command line arguments
local filename = arg[1]
local max_quiz = tonumber(arg[2])

if not filename or not max_quiz then
    print(ansi.red .. "Usage: lua qt.lua filename.tsv max_quiz_score" .. ansi.reset)
    os.exit(1)
end

local students = {}

-- Load file
local function load_file()
    students = {}
    local file = io.open(filename, "r")
    if not file then
        print(ansi.red .. "Error: Cannot open file " .. filename .. ansi.reset)
        os.exit(1)
    end
    for line in file:lines() do
        local name, score = line:match("([^\t]+)\t?(.*)")
        name = trim(name)
        score = tonumber(score) or nil
        table.insert(students, { name = name, score = score })
    end
    file:close()
end

-- Save file
local function save_file()
    local file = assert(io.open(filename, "w"))
    for _, s in ipairs(students) do
        local line = s.name
        if s.score then
            line = line .. "\t" .. s.score
        end
        file:write(line .. "\n")
    end
    file:close()
end

-- View all students
local function view_students()
    print(ansi.cyan .. ansi.bold .. "\nUpdated Student List:\n" .. ansi.reset)
    for i, s in ipairs(students) do
        if s.score then
            print(string.format("%s%2d.%s %s - %s%d%s",
                ansi.yellow, i, ansi.reset,
                ansi.green .. s.name .. ansi.reset,
                ansi.green, s.score, ansi.reset))
        else
            print(string.format("%s%2d.%s %s - %s-%s",
                ansi.yellow, i, ansi.reset,
                ansi.red .. s.name .. ansi.reset,
                ansi.red, ansi.reset))
        end
    end
end

-- List only unscored students
local function list_unscored()
    print(ansi.red .. ansi.bold .. "\nStudents without scores:\n" .. ansi.reset)
    local none_left = true
    for i, s in ipairs(students) do
        if not s.score then
            print(string.format("%s%2d.%s %s",
                ansi.yellow, i, ansi.reset,
                ansi.red .. s.name .. ansi.reset))
            none_left = false
        end
    end
    if none_left then
        print(ansi.green .. "All students have scores." .. ansi.reset)
    end
end

-- Help menu
local function show_help()
    print(ansi.cyan .. ansi.bold .. "\nHelp - Command Guide:\n" .. ansi.reset)
    print(string.format("%s%-5s%s  %s", ansi.blue, "V", ansi.reset, "View all students with scores"))
    print(string.format("%s%-5s%s  %s", ansi.red, "L", ansi.reset, "List only unscored students"))
    print(string.format("%s%-5s%s  %s", ansi.magenta, "Q", ansi.reset, "Quit the program (confirmation required)"))
    print(string.format("%s%-5s%s  %s", ansi.yellow, "[number]", ansi.reset, "Enter score for that student"))
    print(string.format("%s%-5s%s  %s", ansi.green, "[Enter]", ansi.reset, "Auto-advance to next unscored student"))
    print(string.format("%s%-5s%s  %s", ansi.cyan, "H", ansi.reset, "Show this help menu\n"))
end

-- Load and display list
load_file()
view_students()

-- Main input loop
local i = 1
while true do
    io.write(string.format(
        "\n%sEnter student number, %sV%s=view, %sL%s=list, %sQ%s=quit, %sH%s=help [%sEnter%s = next unscored]: ",
        ansi.green, ansi.blue, ansi.reset, ansi.red, ansi.reset,
        ansi.magenta, ansi.reset, ansi.cyan, ansi.reset, ansi.bold, ansi.reset
    ))
    local input = io.read("*l")

    if input == "" then
        -- Find next unscored student
        local nextIndex = nil
        for idx = i, #students do
            if not students[idx].score then
                nextIndex = idx
                break
            end
        end
        if not nextIndex then
            print(ansi.red .. "All students have been scored." .. ansi.reset)
        else
            local student = students[nextIndex]
            io.write(string.format("Enter score for %s: ", student.name))
            local score = tonumber(io.read("*l"))
            if not score then
                print(ansi.red .. "Invalid score!" .. ansi.reset)
            elseif score > max_quiz then
                print(ansi.red .. "Score exceeds maximum of " .. max_quiz .. "!" .. ansi.reset)
            else
                student.score = score
                save_file()
                print(ansi.blue .. string.format("Recorded: %s - %d", student.name, student.score) .. ansi.reset)
                i = nextIndex + 1
            end
        end

    elseif input:lower() == "q" then
        if confirm(ansi.magenta .. "Are you sure you want to quit?" .. ansi.reset) then
            print(ansi.cyan .. "Goodbye!" .. ansi.reset)
            break
        else
            print(ansi.yellow .. "Continuing..." .. ansi.reset)
        end

    elseif input:lower() == "v" then
        view_students()

    elseif input:lower() == "l" then
        list_unscored()

    elseif input:lower() == "h" then
        show_help()

    else
        local index = tonumber(input)
        if not index or index < 1 or index > #students then
            print(ansi.red .. "Invalid number!" .. ansi.reset)
        else
            local student = students[index]
            io.write(string.format("Enter score for %s: ", student.name))
            local score = tonumber(io.read("*l"))
            if not score then
                print(ansi.red .. "Invalid score!" .. ansi.reset)
            elseif score > max_quiz then
                print(ansi.red .. "Score exceeds maximum of " .. max_quiz .. "!" .. ansi.reset)
            else
                student.score = score
                save_file()
                print(ansi.blue .. string.format("Recorded: %s - %d", student.name, student.score) .. ansi.reset)
                i = index + 1
            end
        end
    end
end
