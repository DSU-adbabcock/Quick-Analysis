param
(
    [string]$ConfigPath = ".\config.xml",
    [string]$BinaryPath = "x",
    [string]$CapturePath = "x",
    [switch]$Quick = $false
)

Function BinaryClick()
{
    $binaryDialog = New-Object System.Windows.Forms.OpenFileDialog
    $binaryDialog.Filter = "Executables/Binaries (*.exe;*.bin)|*.exe;*.bin|All Files|*.*"
    $binaryDialog.FilterIndex = 1;
    $binaryDialog.ShowDialog()

    $binaryTextBox.Text = $binaryDialog.FileName
    #[System.Windows.Forms.MessageBox]::Show($binaryDialog.FileName)

}

Function CaptureClick()
{
    $captureDialog = New-Object System.Windows.Forms.OpenFileDialog
    $captureDialog.Filter = "Wireshark Packet Capture (*.pcap;*pcapng)|*.pcap;*.pcapng|All Files|*.*"
    $captureDialog.FilterIndex = 1;
    $captureDialog.ShowDialog()

    $captureTextBox.Text = $captureDialog.FileName

}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "quickanalysis"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(400, 400)

$bigfont = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Regular)
$smallfont = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
$form.Font = $smallfont
#$label = New-Object System.Windows.Forms.Label
#$label.Text = "Programs to run on supplied bin/capture:"
#$label.AutoSize = $true
#$form.Controls.Add($label) 

$binaryFileBrowserButton = New-Object System.Windows.Forms.Button
$binaryFileBrowserButton.Location = New-Object System.Drawing.Size(10,30)
$binaryFileBrowserButton.Size = New-Object System.Drawing.Size(180,40)
$binaryFileBrowserButton.Text = "Choose Binary"
$binaryFileBrowserButton.Font = $smallfont
$form.Controls.Add($binaryFileBrowserButton)
$binaryFileBrowserButton.Add_Click({BinaryClick})

$binaryTextBox = New-Object System.Windows.Forms.TextBox
$binaryTextBox.Location = New-Object System.Drawing.Point(10,73)
$binaryTextBox.Size = New-Object System.Drawing.Size(180, 30)
$binaryTextBox.Text = "Test text oh yeah"
$binaryTextBox.Font = $smallfont
$binaryTextBox.ReadOnly = $true
$form.Controls.Add($binaryTextBox)

$captureFileBrowserButton = New-Object System.Windows.Forms.Button
$captureFileBrowserButton.Location = New-Object System.Drawing.Size(195,30)
$captureFileBrowserButton.Size = New-Object System.Drawing.Size(180,40)
$captureFileBrowserButton.Text = "Choose Capture"
$captureFileBrowserButton.Font = $smallfont
$form.Controls.Add($captureFileBrowserButton)
$captureFileBrowserButton.Add_Click({CaptureClick})

$captureTextBox = New-Object System.Windows.Forms.TextBox
$captureTextBox.Location = New-Object System.Drawing.Point(195,73)
$captureTextBox.Size = New-Object System.Drawing.Size(180, 30)
$captureTextBox.Text = "Test text oh yeah"
$captureTextBox.Font = $smallfont
$captureTextBox.ReadOnly = $true
$form.Controls.Add($captureTextBox)

$checkboxPEiD = New-Object System.Windows.Forms.Checkbox
$checkboxPEiD.Location = New-Object System.Drawing.Size(10,100)
$checkboxPEiD.Size = New-Object System.Drawing.Size(100,20)
$checkboxPEiD.Text = "PEiD"
$checkboxPEiD.Check
$form.Controls.Add($checkboxPEiD)

$checkboxPEStudio = New-Object System.Windows.Forms.Checkbox
$checkboxPEStudio.Location = New-Object System.Drawing.Size(10,120)
$checkboxPEStudio.Size = New-Object System.Drawing.Size(100,20)
$checkboxPEStudio.Text = "PEStudio"
$checkboxPEStudio.Check
$form.Controls.Add($checkboxPEStudio)

$okbutton = New-Object System.Windows.Forms.Button
$okbutton.Dock = "Bottom"
$okbutton.Height = 80
$okbutton.Text = "Go"
$okbutton.Font = $bigfont
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

$BinaryPath = $binaryTextBox.Text
$CapturePath = $captureTextBox.Text

if($checkboxPEiD.Checked)
{
    if($config.Paths.PEID)
    {
        $command = $config.Paths.PEID + " " + $BinaryPath
        Invoke-Expression $command
    }
    else
    {
        Write-Output "PEiD path not found. Please specify in config.xml"
    }
}
