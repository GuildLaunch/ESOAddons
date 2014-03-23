--[[----------------------------------------------------------
    Debug Functions
    ----------------------------------------------------------
    * Provides core profile support for Guild Launch
  ]]--

function GLP.EmitMessage(text)
    if(CHAT_SYSTEM)
    then
        if(text == "")
        then
            text = "[Empty String]"
        end

        CHAT_SYSTEM:AddMessage(text)
    end
end

function GLP.EmitTable(t, indent, tableHistory)
    indent          = indent or "."
    tableHistory    = tableHistory or {}

    for k, v in pairs(t)
    do
        local vType = type(v)

        GLP.EmitMessage(indent.."("..vType.."): "..tostring(k).." = "..tostring(v))

        if(vType == "table")
        then
            if(tableHistory[v])
            then
                GLP.EmitMessage(indent.."....")
            else
                tableHistory[v] = true
                GLP.EmitTable(v, indent.."  ", tableHistory)
            end
        end
    end
end

function GLP.Debug(...)
    if GLP.savedVars.internal.debug == "1" then
        for i = 1, select("#", ...) do
            local value = select(i, ...)
            if(type(value) == "table")
            then
                GLP.EmitTable(value)
            else
                GLP.EmitMessage(tostring (value))
            end
        end
    end
end