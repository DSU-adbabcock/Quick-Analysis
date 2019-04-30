param
(
    [string]$ConfigPath = ".\config.xml",
    [string]$BinaryPath = "x",
    [string]$CapturePath = "x",
    [switch]$Quick = $false
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "quickanalysis"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(400, 400)

$font = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Regular)
$form.Font = $font
$label = New-Object System.Windows.Forms.Label
$label.Text = "Programs to run on supplied bin/capture:"
$label.AutoSize = $true
$form.Controls.Add($label) 

$checkboxPEiD = New-Object System.Windows.Forms.Checkbox
$checkboxPEiD.Location = New-Object System.Drawing.Size(10,30)
$checkboxPEiD.Size = New-Object System.Drawing.Size(400,20)
$checkboxPEiD.Text = "PEiD"
$checkboxPEiD.Check
$form.Controls.Add($checkboxPEiD)

$okbutton = New-Object System.Windows.Forms.Button
$okbutton.Dock = "Bottom"
$okbutton.Height = 80
$okbutton.Text = "Go"
$okbutton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okbutton
$form.Controls.Add($okbutton)
$form.ShowDialog()

if(Test-Path $ConfigPath)
{
    [xml]$config = Get-Content $ConfigPath
}
else
{
    Write-Output "Bad config path. Specify with -ConfigPath (default is .\config.xml)"
    exit
}

foreach($item in $config.Paths.Program)
{
    if($item.Name -eq "PEiD")
    {
       $command = $item.Path + " " + $BinaryPath
      # Invoke-Expression $command
    }
    #Write-Output $item.Name
    #Write-Output $item.Path
}

if($checkboxPEiD.Checked)
{
    Write-Output "Good things"
}
