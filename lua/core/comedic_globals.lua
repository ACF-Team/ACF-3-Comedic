do -- Update checker
    hook.Add("ACF_OnLoadAddon", "ACF Comedic Update Checker", function()
        ACF.AddRepository("ACF-Team", "ACF-3-Comedic")

        hook.Remove("ACF_OnLoadAddon", "ACF Comedic Update Checker")
    end)
end
