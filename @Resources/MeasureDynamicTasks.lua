function Initialize()

	sDynamicMeterFile = SELF:GetOption('DynamicMeterFile')
	sTaskListFile = SELF:GetOption('TaskListFile')
	sLogFile = SELF:GetOption('LogFile')

end


function Update()

	dynamicOutput = {}
	tasks = {}
	checked = ""
	recurring = ""

	-- Iterate through each line in the task list
	for line in io.lines(sTaskListFile) do

		-- check if the task is complete
		if string.sub(line,1,1) == "+" then
			checked = checked.."|"..#tasks + 1
			line = string.sub(line,2,string.len(line))
		end

		-- check if the task is recurring
		if string.sub(line,-2,-1) == "|R" then
			recurring = recurring.."|"..#tasks + 1
			line = string.sub(line,1,-3)
		end

		tasks[#tasks + 1] = line
	end

	-- add delimeter to end of checked string
	checked=checked.."|"

	-- add delimeter to end of recurring string
	recurring=recurring.."|"

	-- dynamic measures checking task status
	for i=1,#tasks,1 do
		dynamicOutput[#dynamicOutput + 1] = "[MeasureTaskIcon"..i.."]"
		dynamicOutput[#dynamicOutput + 1] = "Measure=String"
		dynamicOutput[#dynamicOutput + 1] = "String=#check"..i.."state#"
		dynamicOutput[#dynamicOutput + 1] = "IfMatch=0"
		dynamicOutput[#dynamicOutput + 1] = "IfMatchAction=[!SetVariable check"..i.." fa-sq]"
		dynamicOutput[#dynamicOutput + 1] = "IfNotMatchAction=[!SetVariable check"..i.." fa-check-sq]"
		dynamicOutput[#dynamicOutput + 1] = "IfMatchMode=1"
		dynamicOutput[#dynamicOutput + 1] = "DynamicVariables=1"
	end

	-- title for tasks
	dynamicOutput[#dynamicOutput + 1] = "[MeterTitle]"
	dynamicOutput[#dynamicOutput + 1] = "Meter=String"
	dynamicOutput[#dynamicOutput + 1] = "Group=TextGroup | BackgroundGroup"
	dynamicOutput[#dynamicOutput + 1] = "Text=#Title#"
	dynamicOutput[#dynamicOutput + 1] = "AntiAlias=1"
	dynamicOutput[#dynamicOutput + 1] = "FontFace=#DisplayFont#"
	dynamicOutput[#dynamicOutput + 1] = "FontSize=20"
	dynamicOutput[#dynamicOutput + 1] = "W=([MeterTaskIcon1:W] + [MeterRepeatingTask1:W] - (#SidePadding# * 2))"
	dynamicOutput[#dynamicOutput + 1] = "Padding=#PaddingSize#"
	dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!CommandMeasure MeasureRenameTitleBox \"ExecuteBatch 1\"]"
	dynamicOutput[#dynamicOutput + 1] = "ClipString=2"

	dynamicOutput[#dynamicOutput + 1] = "[MeasureRenameTitleBox]"
	dynamicOutput[#dynamicOutput + 1] = "Measure=Plugin"
	dynamicOutput[#dynamicOutput + 1] = "Plugin=InputText"
	dynamicOutput[#dynamicOutput + 1] = "H=([MeterTitle:H] - (#SidePadding# * 2))"
	dynamicOutput[#dynamicOutput + 1] = "W=([MeterTitle:W] - (#SidePadding# * 2))"
	dynamicOutput[#dynamicOutput + 1] = "X=#SidePadding#"
	dynamicOutput[#dynamicOutput + 1] = "Y=#SidePadding#"
	dynamicOutput[#dynamicOutput + 1] = "FontSize=20"
	dynamicOutput[#dynamicOutput + 1] = "FontFace=#DisplayFont#"
	dynamicOutput[#dynamicOutput + 1] = "DefaultValue=#Title#"
	dynamicOutput[#dynamicOutput + 1] = "Group=TextBoxGroup | TextGroup"
	dynamicOutput[#dynamicOutput + 1] = "Command1=[!WriteKeyValue Variables Title \"$UserInput$\"][!Refresh][!Refresh]"

	-- dynamic meters
	for i=1,#tasks,1 do
		dynamicOutput[#dynamicOutput + 1] = "[MeterTaskIcon"..i.."]"
		dynamicOutput[#dynamicOutput + 1] = "Meter=String"
		dynamicOutput[#dynamicOutput + 1] = "MeasureName=MeasureTaskIcon"..i
		dynamicOutput[#dynamicOutput + 1] = "Text=[#[#check"..i.."]]"
		dynamicOutput[#dynamicOutput + 1] = "FontFace=#RegularIconFace#"
		dynamicOutput[#dynamicOutput + 1] = "FontSize=18"
		dynamicOutput[#dynamicOutput + 1] = "Group=BackgroundGroup | TextGroup"
		dynamicOutput[#dynamicOutput + 1] = "AntiAlias=1"
		dynamicOutput[#dynamicOutput + 1] = "X=0"
		dynamicOutput[#dynamicOutput + 1] = "Y=R"
		dynamicOutput[#dynamicOutput + 1] = "H=([MeterRepeatingTask"..i..":H] - (#SidePadding# * 2))"
		dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!SetVariable check"..i.."state (1-#check"..i.."state#)][!CommandMeasure \"MeasureDynamicTasks\" \"CheckLine("..i..")\"]"
		dynamicOutput[#dynamicOutput + 1] = "DynamicVariables=1"
		dynamicOutput[#dynamicOutput + 1] = "GradientAngle=180"
		dynamicOutput[#dynamicOutput + 1] = "Padding=#PaddingSize#"
		dynamicOutput[#dynamicOutput + 1] = "MouseOverAction=[!SetOption MeterRepeatingTask"..i.." SolidColor #LightHighlight#,#NoGradientTransparency#][!UpdateMeter MeterRepeatingTask"..i.."][!Redraw]"
		dynamicOutput[#dynamicOutput + 1] = "MouseLeaveAction=[!SetOption MeterRepeatingTask"..i.." SolidColor 0,0,0,0][!UpdateMeter MeterRepeatingTask"..i.."][!Redraw]"		dynamicOutput[#dynamicOutput + 1] = "[MeterRepeatingTask"..i.."Background]"
		dynamicOutput[#dynamicOutput + 1] = "Meter=Image"
		dynamicOutput[#dynamicOutput + 1] = "Group=OpaqueBackgroundGroup"
		dynamicOutput[#dynamicOutput + 1] = "X=R"
		dynamicOutput[#dynamicOutput + 1] = "Y=r"
		dynamicOutput[#dynamicOutput + 1] = "W=300"
		dynamicOutput[#dynamicOutput + 1] = "H=(14 + #SidePadding#)"
		dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!CommandMeasure MeasureRenameTextBox"..i.." \"ExecuteBatch 1\"]"
		dynamicOutput[#dynamicOutput + 1] = "Padding=#PaddingSize#"
		dynamicOutput[#dynamicOutput + 1] = "[MeterRepeatingTask"..i.."]"
		dynamicOutput[#dynamicOutput + 1] = "Meter=String"
		dynamicOutput[#dynamicOutput + 1] = "Text="..tasks[i]
		dynamicOutput[#dynamicOutput + 1] = "FontFace=#FontFace#"
		dynamicOutput[#dynamicOutput + 1] = "FontSize=14"
		if string.find(recurring, "|"..i.."|") ~= nil then
			dynamicOutput[#dynamicOutput + 1] = "FontColor=#LightHighlight#"
		else
			dynamicOutput[#dynamicOutput + 1] = "Group=TextGroup"
		end
		dynamicOutput[#dynamicOutput + 1] = "AntiAlias=1"
		dynamicOutput[#dynamicOutput + 1] = "ClipString=2"
		dynamicOutput[#dynamicOutput + 1] = "X=r"
		dynamicOutput[#dynamicOutput + 1] = "Y=r"
		dynamicOutput[#dynamicOutput + 1] = "W=300"
		dynamicOutput[#dynamicOutput + 1] = "Padding=#PaddingSize#"
		dynamicOutput[#dynamicOutput + 1] = "MouseOverAction=[!SetOption MeterRepeatingTask"..i.." SolidColor #LightHighlight#,#NoGradientTransparency#][!UpdateMeter MeterRepeatingTask"..i.."][!Redraw]"
		dynamicOutput[#dynamicOutput + 1] = "MouseLeaveAction=[!SetOption MeterRepeatingTask"..i.." SolidColor 0,0,0,0][!UpdateMeter MeterRepeatingTask"..i.."][!Redraw]"
	end

	for i=1,#tasks,1 do
		dynamicOutput[#dynamicOutput + 1] = "[MeasureRenameTextBox"..i.."]"
		dynamicOutput[#dynamicOutput + 1] = "Measure=Plugin"
		dynamicOutput[#dynamicOutput + 1] = "Plugin=InputText"
		dynamicOutput[#dynamicOutput + 1] = "DefaultValue="..tasks[i]
		dynamicOutput[#dynamicOutput + 1] = "FontFace=#FontFace#"
		dynamicOutput[#dynamicOutput + 1] = "FontSize=14"
		dynamicOutput[#dynamicOutput + 1] = "Group=TextBoxGroup | TextGroup"
		dynamicOutput[#dynamicOutput + 1] = "AntiAlias=1"
		dynamicOutput[#dynamicOutput + 1] = "X=(30 + (#SidePadding# * 2))"
		dynamicOutput[#dynamicOutput + 1] = "Y=([MeterRepeatingTask"..i..":Y] + #SidePadding#)"
		dynamicOutput[#dynamicOutput + 1] = "W=305"
		-- minus additional padding for the height, if any
		dynamicOutput[#dynamicOutput + 1] = "H=([MeterRepeatingTask"..i..":H] - (#SidePadding# * 2))"
		dynamicOutput[#dynamicOutput + 1] = "Command1=[!CommandMeasure \"MeasureDynamicTasks\" \"RenameTask("..i..", '$UserInput$')\"][!Refresh][!Refresh]"
	end

	dynamicOutput[#dynamicOutput + 1] = "[Variables]"

	-- variables for each task
	for i=1,#tasks,1 do
		if string.find(checked, "|"..i.."|") ~= nil then
			dynamicOutput[#dynamicOutput + 1] = "check"..i.."state=1"
			dynamicOutput[#dynamicOutput + 1] = "check"..i.."=fa-check-sq"
		else
			dynamicOutput[#dynamicOutput + 1] = "check"..i.."state=0"
			dynamicOutput[#dynamicOutput + 1] = "check"..i.."=fa-sq"
		end
	end

	-- include Font Awesome icons
	dynamicOutput[#dynamicOutput + 1] = "@Include=#@#FontAwesome.inc"

	-- style for button
	dynamicOutput[#dynamicOutput + 1] = "[styleButton]"
	dynamicOutput[#dynamicOutput + 1] = "FontFace=#IconFace#"
	dynamicOutput[#dynamicOutput + 1] = "FontSize=16"
	dynamicOutput[#dynamicOutput + 1] = "Group = TextGroup | BackgroundGroup"
	dynamicOutput[#dynamicOutput + 1] = "AntiAlias=1"
	dynamicOutput[#dynamicOutput + 1] = "X=R"
	dynamicOutput[#dynamicOutput + 1] = "Y=r"
	dynamicOutput[#dynamicOutput + 1] = "Padding=#PaddingSize#"

	-- refresh button
	dynamicOutput[#dynamicOutput + 1] = "[MeterRefreshTasks]"
	dynamicOutput[#dynamicOutput + 1] = "Meter=String"
	dynamicOutput[#dynamicOutput + 1] = "MeterStyle=styleButton"
	dynamicOutput[#dynamicOutput + 1] = "Text=#fa-refresh#"
	dynamicOutput[#dynamicOutput + 1] = "X=0"
	dynamicOutput[#dynamicOutput + 1] = "Y=R"
	dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!Refresh][!Refresh]"
	dynamicOutput[#dynamicOutput + 1] = "ToolTipText=Refresh"

	-- reset button
	dynamicOutput[#dynamicOutput + 1] = "[MeterUndoTasks]"
	dynamicOutput[#dynamicOutput + 1] = "Meter=String"
	dynamicOutput[#dynamicOutput + 1] = "MeterStyle=styleButton"
	dynamicOutput[#dynamicOutput + 1] = "Text=#fa-undo#"
	dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!CommandMeasure \"MeasureDynamicTasks\" \"ResetAll()\"][!Refresh][!Refresh]"
	dynamicOutput[#dynamicOutput + 1] = "ToolTipText=Clear"

	-- add button
	dynamicOutput[#dynamicOutput + 1] = "[MeterAddTasks]"
	dynamicOutput[#dynamicOutput + 1] = "Meter=String"
	dynamicOutput[#dynamicOutput + 1] = "MeterStyle=styleButton"
	dynamicOutput[#dynamicOutput + 1] = "Text=#fa-plus-sq#"
	dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=[!CommandMeasure MeasureInput \"ExecuteBatch 1-2\"]"
	dynamicOutput[#dynamicOutput + 1] = "ToolTipText=Add"

	-- view button
	dynamicOutput[#dynamicOutput + 1] = "[MeterViewTasks]"
	dynamicOutput[#dynamicOutput + 1] = "Meter=String"
	dynamicOutput[#dynamicOutput + 1] = "MeterStyle=styleButton"
	dynamicOutput[#dynamicOutput + 1] = "Text=#fa-book#"
	dynamicOutput[#dynamicOutput + 1] = "LeftMouseUpAction=#@#Logs.txt"
	dynamicOutput[#dynamicOutput + 1] = "ToolTipText=View"

	-- create dynamic meter file
	local File = io.open(sDynamicMeterFile, 'w')

	-- error handling
	if not File then
		print('Update: unable to open file at ' .. sDynamicMeterFile)
		return
	end

	output = table.concat(dynamicOutput, '\n')

	File:write(output)
	File:close()

	return true

end


function CheckLine(lineNumber)

	local hFile = io.open(sTaskListFile, "r")
	local lines = {}
	local restOfFile
	local lineCt = 1

	-- read through task list
	for line in hFile:lines() do

		-- find the line to be altered
		if(lineCt == lineNumber) then
			-- toggle completion status of line
			if string.sub(line,1,1) ~= "+" then
				lines[#lines + 1] = "+"..line

				if (string.sub(line,-2,-1) == "|R") then
					LogTask(string.sub(line,1,string.len(line) - 2))
				else
					LogTask(string.sub(line,1,string.len(line)))
				end
			else
				lines[#lines + 1] = string.sub(line,2,string.len(line))
			end

			-- read the rest of the file
			restOfFile = hFile:read("*a")
			-- and break from loop
			break
		else
			-- write the lines of the file before altered line
			lineCt = lineCt + 1
			lines[#lines + 1] = line
		end

	end

	-- close task list for reading
	hFile:close()

	-- open task list for writing
	hFile = io.open(sTaskListFile, "w")

	-- write lines of file from start to altered line
	for i, line in ipairs(lines) do
	  hFile:write(line, "\n")
	end

	hFile:write(restOfFile)
	hFile:close()

	return true

end


function ResetAll()

	local hFile = io.open(sTaskListFile, "r")
	local lines = {}

	-- read through task list
	for line in hFile:lines() do
		-- do not delete recurring tasks
  		if string.sub(line,-2,-1) == "|R" then
  			if string.sub(line,1,1) == "+" then
	  			lines[#lines + 1] = string.sub(line,2,string.len(line))
	  		else
	  			lines[#lines + 1] = line
	  		end
	  	-- do not delete uncompleted tasks
	  	elseif string.sub(line,1,1) ~= "+" and string.sub(line,-2,-1) ~= "|R" then
	  		lines[#lines + 1] = line
	  	end

  	end

  	-- close task list for reading
	hFile:close()

	-- open task list for writing
	hFile = io.open(sTaskListFile, "w")

	for i, line in ipairs(lines) do
	  hFile:write(line, "\n")
	end

	hFile:close()

	return true

end


function AddTask(newline)

	-- read entire task list
	local hFile = io.open(sTaskListFile, "r")
	local wholeFile = hFile:read("*a")
	hFile:close()

	-- write task list back to itself and add new line
	hFile = io.open(sTaskListFile, "w")
	hFile:write(wholeFile)
	hFile:write(newline, "\n")
	hFile:close()

	return true

end

function LogTask(task)
	local logFile = io.open(sLogFile, "r")

	-- create a new log file if it doesn't exist
	if(logFile == nil) then
		logFile = io.open(sTaskListFile, "w")
		logFile:close()
		logFile = io.open(sTaskListFile, "r")
	end

	local readFile = logFile:read("*a")
	logFile:close()

	logFile = io.open(sLogFile, "w")
	logFile:write(readFile)
	logFile:write(os.date())
	logFile:write(': ')
	logFile:write(task, "\n")
	logFile:close()
end

function RenameTask(lineNumber, newTaskName)
	local hFile = io.open(sTaskListFile, "r")
	local lines = {}
	local restOfFile
	local lineCt = 1

	-- read through task list
	for line in hFile:lines() do

		-- find the line to be altered
		if(lineCt == lineNumber) then
			-- rename task
			if (newTaskName ~= "") then
				lines[#lines + 1] = newTaskName
			end

			-- read the rest of the file
			restOfFile = hFile:read("*a")
			-- and break from loop
			break
		else
			-- write the lines of the file before altered line
			lineCt = lineCt + 1
			lines[#lines + 1] = line
		end

	end

	-- close task list for reading
	hFile:close()

	-- open task list for writing
	hFile = io.open(sTaskListFile, "w")

	-- write lines of file from start to altered line
	for i, line in ipairs(lines) do
	  hFile:write(line, "\n")
	end

	hFile:write(restOfFile)
	hFile:close()
end
