# ***** Select file *****

$files = Get-ChildItem *.ini -Path C:\Users\Rodolfo\.android\avd

$title = ''
$subtitle = 'Choose a emulator'

$fileChoices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]

for ($i = 0; $i -lt $files.Count; $i++) {
    #$fileChoices += [System.Management.Automation.Host.ChoiceDescription[]]("$($files[$i].Name) &$($i + 1)")
    $fileChoices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $files[$i].Name))
}

$userChoice = $host.UI.PromptForChoice($title, $subtitle, $fileChoices, 0)
$nameChoice = $([System.IO.Path]::GetFileNameWithoutExtension($files[$userChoice].FullName))

Write-Host "You choose $nameChoice"

# ***** Delete snapshots *****

$pathExist = Test-Path -Path "C:\Users\Rodolfo\.android\avd\$nameChoice.avd\snapshots"

if ($pathExist) {
    #$title = ''
    #$subtitle = 'Do you want to delete snapshots?'
    #$choices = '&Yes', '&No'
    
    #$decision = $Host.UI.PromptForChoice($title, $subtitle, $choices, 1)
    #if ($decision -eq 0) {
    #    Remove-Item -Path "C:\Users\Rodolfo\.android\avd\$nameChoice.avd\snapshots" -Recurse
    #}

    Remove-Item -Path "C:\Users\Rodolfo\.android\avd\$nameChoice.avd\snapshots" -Recurse
}

# ***** Wipe data *****

$fileExist = Test-Path -Path "C:\Users\Rodolfo\.android\avd\$nameChoice.avd\userdata-qemu.img" -PathType Leaf

if ($fileExist) {
    $title = ''
    $subtitle = 'Do you want to clear the data?'
    $choices = '&Yes', '&No'
    
    $decision = $Host.UI.PromptForChoice($title, $subtitle, $choices, 1)
    if ($decision -eq 0) {
        Remove-Item -Path "C:\Users\Rodolfo\.android\avd\$nameChoice.avd\userdata-qemu.img" -Force
    }
}

C:\Users\Rodolfo\AppData\Local\Android\Sdk\emulator\emulator.exe -avd $nameChoice