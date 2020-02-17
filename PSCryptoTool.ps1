<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Generate-CSR
.SYNOPSIS
    Generates private key and certificate signing request.
.DESCRIPTION
    Builds custom CertUtil configuration file based on user input to generate private key and certificate signing request. 
#>

# Parameters
Param
(
[parameter()]
[String]
$ScriptVer="0.0.1",
[parameter()]
[Array]
$Crypto=@("Suite B: SECP256r1","Suite B: SECP384r1","RSA 4096 SHA-384","RSA 2048 SHA-384")
)

# GUI
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$PSCryptoTool                    = New-Object system.Windows.Forms.Form
$PSCryptoTool.ClientSize         = '423,549'
$PSCryptoTool.text               = "PSCryptoTool"
$PSCryptoTool.TopMost            = $false

$LabelName                       = New-Object system.Windows.Forms.Label
$LabelName.text                  = "Name"
$LabelName.AutoSize              = $true
$LabelName.width                 = 100
$LabelName.height                = 10
$LabelName.location              = New-Object System.Drawing.Point(14,17)
$LabelName.Font                  = 'Microsoft Sans Serif,9'

$RDNGroup                        = New-Object system.Windows.Forms.Groupbox
$RDNGroup.height                 = 217
$RDNGroup.width                  = 399
$RDNGroup.text                   = "RDN"
$RDNGroup.location               = New-Object System.Drawing.Point(12,17)

$LabelOU                         = New-Object system.Windows.Forms.Label
$LabelOU.text                    = "Org. Unit"
$LabelOU.AutoSize                = $true
$LabelOU.width                   = 25
$LabelOU.height                  = 10
$LabelOU.location                = New-Object System.Drawing.Point(15,66)
$LabelOU.Font                    = 'Microsoft Sans Serif,9'

$LabelO                          = New-Object system.Windows.Forms.Label
$LabelO.text                     = "Organization"
$LabelO.AutoSize                 = $true
$LabelO.width                    = 25
$LabelO.height                   = 10
$LabelO.location                 = New-Object System.Drawing.Point(14,116)
$LabelO.Font                     = 'Microsoft Sans Serif,9'

$LabelCity                       = New-Object system.Windows.Forms.Label
$LabelCity.text                  = "City"
$LabelCity.AutoSize              = $true
$LabelCity.width                 = 100
$LabelCity.height                = 10
$LabelCity.location              = New-Object System.Drawing.Point(232,16)
$LabelCity.Font                  = 'Microsoft Sans Serif,9'

$LabelState                      = New-Object system.Windows.Forms.Label
$LabelState.text                 = "State"
$LabelState.AutoSize             = $true
$LabelState.width                = 25
$LabelState.height               = 10
$LabelState.location             = New-Object System.Drawing.Point(232,66)
$LabelState.Font                 = 'Microsoft Sans Serif,9'

$InputOU                         = New-Object system.Windows.Forms.TextBox
$InputOU.multiline               = $false
$InputOU.width                   = 150
$InputOU.height                  = 20
$InputOU.location                = New-Object System.Drawing.Point(15,85)
$InputOU.Font                    = 'Microsoft Sans Serif,10'

$InputOrg                        = New-Object system.Windows.Forms.TextBox
$InputOrg.multiline              = $false
$InputOrg.width                  = 150
$InputOrg.height                 = 20
$InputOrg.location               = New-Object System.Drawing.Point(14,135)
$InputOrg.Font                   = 'Microsoft Sans Serif,10'

$InputCity                       = New-Object system.Windows.Forms.TextBox
$InputCity.multiline             = $false
$InputCity.width                 = 150
$InputCity.height                = 20
$InputCity.location              = New-Object System.Drawing.Point(234,35)
$InputCity.Font                  = 'Microsoft Sans Serif,10'

$InputState                      = New-Object system.Windows.Forms.TextBox
$InputState.multiline            = $false
$InputState.width                = 150
$InputState.height               = 20
$InputState.location             = New-Object System.Drawing.Point(234,85)
$InputState.Font                 = 'Microsoft Sans Serif,10'

$LabelCountry                    = New-Object system.Windows.Forms.Label
$LabelCountry.text               = "Country"
$LabelCountry.AutoSize           = $true
$LabelCountry.width              = 25
$LabelCountry.height             = 10
$LabelCountry.location           = New-Object System.Drawing.Point(234,116)
$LabelCountry.Font               = 'Microsoft Sans Serif,9'

$InputCountry                    = New-Object system.Windows.Forms.TextBox
$InputCountry.multiline          = $false
$InputCountry.width              = 150
$InputCountry.height             = 20
$InputCountry.location           = New-Object System.Drawing.Point(234,135)
$InputCountry.Font               = 'Microsoft Sans Serif,10'

$LabelVersion                    = New-Object system.Windows.Forms.Label
$LabelVersion.text               = "$ScriptVer"
$LabelVersion.AutoSize           = $true
$LabelVersion.width              = 25
$LabelVersion.height             = 10
$LabelVersion.location           = New-Object System.Drawing.Point(13,529)
$LabelVersion.Font               = 'Microsoft Sans Serif,6'
$LabelVersion.ForeColor          = "#101010"

$InputEmail                      = New-Object system.Windows.Forms.TextBox
$InputEmail.multiline            = $false
$InputEmail.width                = 150
$InputEmail.height               = 20
$InputEmail.location             = New-Object System.Drawing.Point(14,183)
$InputEmail.Font                 = 'Microsoft Sans Serif,10'

$LabelEmail                      = New-Object system.Windows.Forms.Label
$LabelEmail.text                 = "Email"
$LabelEmail.AutoSize             = $true
$LabelEmail.width                = 25
$LabelEmail.height               = 10
$LabelEmail.location             = New-Object System.Drawing.Point(14,164)
$LabelEmail.Font                 = 'Microsoft Sans Serif,9'

$GroupOptions                    = New-Object system.Windows.Forms.Groupbox
$GroupOptions.height             = 134
$GroupOptions.width              = 399
$GroupOptions.text               = "Key Options"
$GroupOptions.location           = New-Object System.Drawing.Point(13,248)

$ComboCipher                     = New-Object system.Windows.Forms.ComboBox
$ComboCipher.width               = 372
$ComboCipher.height              = 20
$ComboCipher.location            = New-Object System.Drawing.Point(12,41)
$ComboCipher.Font                = 'Microsoft Sans Serif,9'

$ButtonGenerate                  = New-Object system.Windows.Forms.Button
$ButtonGenerate.text             = "Generate"
$ButtonGenerate.width            = 106
$ButtonGenerate.height           = 30
$ButtonGenerate.location         = New-Object System.Drawing.Point(306,509)
$ButtonGenerate.Font             = 'Microsoft Sans Serif,10,style=Bold,Underline'

$ButtonCancel                    = New-Object system.Windows.Forms.Button
$ButtonCancel.text               = "Cancel"
$ButtonCancel.width              = 60
$ButtonCancel.height             = 30
$ButtonCancel.location           = New-Object System.Drawing.Point(230,509)
$ButtonCancel.Font               = 'Microsoft Sans Serif,10'

$InputPath                       = New-Object system.Windows.Forms.TextBox
$InputPath.multiline             = $false
$InputPath.text                  = "$SavePath"
$InputPath.width                 = 318
$InputPath.height                = 20
$InputPath.location              = New-Object System.Drawing.Point(12,459)
$InputPath.Font                  = 'Microsoft Sans Serif,9'

$LabelPath                       = New-Object system.Windows.Forms.Label
$LabelPath.text                  = "Save location..."
$LabelPath.AutoSize              = $true
$LabelPath.width                 = 25
$LabelPath.height                = 10
$LabelPath.location              = New-Object System.Drawing.Point(12,439)
$LabelPath.Font                  = 'Microsoft Sans Serif,9'

$ButtonBrowse                    = New-Object system.Windows.Forms.Button
$ButtonBrowse.text               = "Browse..."
$ButtonBrowse.width              = 74
$ButtonBrowse.height             = 30
$ButtonBrowse.location           = New-Object System.Drawing.Point(338,449)
$ButtonBrowse.Font               = 'Microsoft Sans Serif,9'

$InputCN                         = New-Object system.Windows.Forms.TextBox
$InputCN.multiline               = $false
$InputCN.width                   = 150
$InputCN.height                  = 20
$InputCN.location                = New-Object System.Drawing.Point(15,37)
$InputCN.Font                    = 'Microsoft Sans Serif,10'

$ComboUsage                      = New-Object system.Windows.Forms.ComboBox
$ComboUsage.width                = 372
$ComboUsage.height               = 20
$ComboUsage.location             = New-Object System.Drawing.Point(12,94)
$ComboUsage.Font                 = 'Microsoft Sans Serif,9'

$LabelSize                       = New-Object system.Windows.Forms.Label
$LabelSize.text                  = "Key Parameters"
$LabelSize.AutoSize              = $true
$LabelSize.width                 = 25
$LabelSize.height                = 10
$LabelSize.location              = New-Object System.Drawing.Point(12,21)
$LabelSize.Font                  = 'Microsoft Sans Serif,9'

$LabelExtensions                 = New-Object system.Windows.Forms.Label
$LabelExtensions.text            = "Extensions"
$LabelExtensions.AutoSize        = $true
$LabelExtensions.width           = 25
$LabelExtensions.height          = 10
$LabelExtensions.location        = New-Object System.Drawing.Point(12,72)
$LabelExtensions.Font            = 'Microsoft Sans Serif,9'

$RDNGroup.controls.AddRange(@($LabelName,$LabelOU,$LabelO,$LabelCity,$LabelState,$InputOU,$InputOrg,$InputCity,$InputState,$LabelCountry,$InputCountry,$InputEmail,$LabelEmail,$InputCN))
$PSCryptoTool.controls.AddRange(@($RDNGroup,$LabelVersion,$GroupOptions,$ButtonGenerate,$ButtonCancel,$InputPath,$LabelPath,$ButtonBrowse))
$GroupOptions.controls.AddRange(@($ComboCipher,$ComboUsage,$LabelSize,$LabelExtensions))

# Logic
 Function Get-Folder($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
[void]$PSCryptoTool.ShowDialog()