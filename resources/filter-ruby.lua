function Inlines (inlines)
    -- Initialize a simple "state" variable
    collect = false

    -- Initialize buffer for kana and return list for pandoc
    buffer = {}
    plist = pandoc.List()

    -- Loop over each element of the inlines list
    for i = 1, #inlines, 1 do

        -- Check if element matches a special case
        if inlines[i] == pandoc.RawInline("html", "<rt>") then
            collect = true
        elseif inlines[i] == pandoc.RawInline("html", "</rt>") then
            collect = false
        elseif inlines[i] == pandoc.RawInline("html", "<ruby>") then
            plist:insert(pandoc.RawInline("latex", "\\ruby{"))
        elseif inlines[i] == pandoc.RawInline("html", "</ruby>") then
            plist:insert(pandoc.RawInline("latex", "}{"))
            plist:insert(pandoc.Str(table.concat(buffer)))
            plist:insert(pandoc.RawInline("latex", "}"))

            -- Flush buffer after we write it out
            for j = 1, #buffer, 1 do
                buffer[j] = nil
            end

        -- Otherwise push element to the proper list
        elseif collect then
            table.insert(buffer, inlines[i].text)
        else
            plist:insert(inlines[i])
        end
    end

    -- Finally return the new list of elements
    return plist
end

