# ***** Select file *****

$files = Get-ChildItem *.ini -Path C:\Users\DEV-RODOLFO\.android\avd

$title = ''
$subtitle = 'Choose a emulator'

$fileChoices = @()

for ($i = 0; $i -lt $files.Count; $i++) {
    $fileChoices += [System.Management.Automation.Host.ChoiceDescription]("$($files[$i].Name) &$($i + 1)")
}

$userChoice = $host.UI.PromptForChoice($title, $subtitle, $fileChoices, 0)
$nameChoice = $([System.IO.Path]::GetFileNameWithoutExtension($files[$userChoice].FullName))

Write-Host "You choose $nameChoice"

# ***** Delete snapshots *****

$pathExist = Test-Path -Path "C:\Users\DEV-RODOLFO\.android\avd\$nameChoice.avd\snapshots"

if ($pathExist) {
    $title = ''
    $subtitle = 'Do you want to delete snapshots?'
    $choices = '&Yes', '&No'
    
    $decision = $Host.UI.PromptForChoice($title, $subtitle, $choices, 1)
    if ($decision -eq 0) {
        Remove-Item -Path "C:\Users\DEV-RODOLFO\.android\avd\$nameChoice.avd\snapshots" -Recurse
    }
}

# ***** Wipe data *****

$fileExist = Test-Path -Path "C:\Users\DEV-RODOLFO\.android\avd\$nameChoice.avd\userdata-qemu.img" -PathType Leaf

if ($fileExist) {
    $title = ''
    $subtitle = 'Do you want to clear the data?'
    $choices = '&Yes', '&No'
    
    $decision = $Host.UI.PromptForChoice($title, $subtitle, $choices, 1)
    if ($decision -eq 0) {
        Remove-Item -Path "C:\Users\DEV-RODOLFO\.android\avd\$nameChoice.avd\userdata-qemu.img" -Force
    }
}

C:\Users\DEV-RODOLFO\AppData\Local\Android\Sdk\emulator\emulator.exe -avd $nameChoice