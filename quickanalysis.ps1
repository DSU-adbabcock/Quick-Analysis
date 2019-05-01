param
(
    [string]$ConfigPath = ".\config.xml"
)

Function BinaryClick()
{
    $binaryDialog = New-Object System.Windows.Forms.OpenFileDialog
    $binaryDialog.Filter = "Executables/Binaries (*.exe;*.bin)|*.exe;*.bin|All Files|*.*"
    $binaryDialog.FilterIndex = 1;
    $binaryDialog.ShowDialog()

    $binaryTextBox.Text = $binaryDialog.FileName
    $md5 = Get-FileHash $binaryDialog.FileName -Algorithm MD5
    $sha256 = Get-FileHash $binaryDialog.FileName

    $sha256hashTextBox.Text = "SHA256 Hash: " + $sha256.hash
    $md5hashTextBox.Text = "MD5 Hash: " + $md5.hash
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
$form.Size = New-Object System.Drawing.Size(450, 400)

$bigfont = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Regular)
$boldbigfont = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$smallfont = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
$boldsmallfont = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold)
$form.Font = $smallfont
#$label = New-Object System.Windows.Forms.Label
#$label.Text = "Programs to run on supplied bin/capture:"
#$label.AutoSize = $true
#$form.Controls.Add($label) 

$binaryFileBrowserButton = New-Object System.Windows.Forms.Button
$binaryFileBrowserButton.Location = New-Object System.Drawing.Size(10,30)
$binaryFileBrowserButton.Size = New-Object System.Drawing.Size(205,40)
$binaryFileBrowserButton.Text = "Choose Binary"
$binaryFileBrowserButton.Font = $boldsmallfont
$form.Controls.Add($binaryFileBrowserButton)
$binaryFileBrowserButton.Add_Click({BinaryClick})

$binaryTextBox = New-Object System.Windows.Forms.TextBox
$binaryTextBox.Location = New-Object System.Drawing.Point(10,73)
$binaryTextBox.Size = New-Object System.Drawing.Size(205, 30)
$binaryTextBox.Text = "Test text oh yeah"
$binaryTextBox.Font = $smallfont
$binaryTextBox.ReadOnly = $true
$form.Controls.Add($binaryTextBox)

$captureFileBrowserButton = New-Object System.Windows.Forms.Button
$captureFileBrowserButton.Location = New-Object System.Drawing.Size(220,30)
$captureFileBrowserButton.Size = New-Object System.Drawing.Size(205,40)
$captureFileBrowserButton.Text = "Choose Capture"
$captureFileBrowserButton.Font = $boldsmallfont
$form.Controls.Add($captureFileBrowserButton)
$captureFileBrowserButton.Add_Click({CaptureClick})

$captureTextBox = New-Object System.Windows.Forms.TextBox
$captureTextBox.Location = New-Object System.Drawing.Point(220,73)
$captureTextBox.Size = New-Object System.Drawing.Size(205, 30)
$captureTextBox.Text = "Test text oh yeah"
$captureTextBox.Font = $smallfont
$captureTextBox.ReadOnly = $true
$form.Controls.Add($captureTextBox)

$checkboxPEiD = New-Object System.Windows.Forms.Checkbox
$checkboxPEiD.Location = New-Object System.Drawing.Size(10,100)
$checkboxPEiD.Size = New-Object System.Drawing.Size(180,20)
$checkboxPEiD.Text = "PEiD"
$checkboxPEiD.Check
$form.Controls.Add($checkboxPEiD)

$checkboxDetectItEasy = New-Object System.Windows.Forms.Checkbox
$checkboxDetectItEasy.Location = New-Object System.Drawing.Size(10,120)
$checkboxDetectItEasy.Size = New-Object System.Drawing.Size(180,20)
$checkboxDetectItEasy.Text = "Detect It Easy"
$checkboxDetectItEasy.Check
$form.Controls.Add($checkboxDetectItEasy)

$checkboxPEStudio = New-Object System.Windows.Forms.Checkbox
$checkboxPEStudio.Location = New-Object System.Drawing.Size(10,140)
$checkboxPEStudio.Size = New-Object System.Drawing.Size(180,20)
$checkboxPEStudio.Text = "PEStudio"
$checkboxPEStudio.Check
$form.Controls.Add($checkboxPEStudio)

$checkboxBinaryNinja = New-Object System.Windows.Forms.Checkbox
$checkboxBinaryNinja.Location = New-Object System.Drawing.Size(10,160)
$checkboxBinaryNinja.Size = New-Object System.Drawing.Size(180,20)
$checkboxBinaryNinja.Text = "BinaryNinja"
$checkboxBinaryNinja.Check
$form.Controls.Add($checkboxBinaryNinja)

$checkboxIDAProDemo = New-Object System.Windows.Forms.Checkbox
$checkboxIDAProDemo.Location = New-Object System.Drawing.Size(10,180)
$checkboxIDAProDemo.Size = New-Object System.Drawing.Size(180,20)
$checkboxIDAProDemo.Text = "IDA Pro/Demo"
$checkboxIDAProDemo.Check
$form.Controls.Add($checkboxIDAProDemo)

$checkboxIDAFree = New-Object System.Windows.Forms.Checkbox
$checkboxIDAFree.Location = New-Object System.Drawing.Size(10,200)
$checkboxIDAFree.Size = New-Object System.Drawing.Size(180,20)
$checkboxIDAFree.Text = "IDA Freeware"
$checkboxIDAFree.Check
$form.Controls.Add($checkboxIDAFree)

$md5hashTextBox = New-Object System.Windows.Forms.TextBox
#$md5hashTextBox.Location = New-Object System.Drawing.Point(10,73)
$md5hashTextBox.Dock = "Bottom"
$md5hashTextBox.Size = New-Object System.Drawing.Size(180, 30)
$md5hashTextBox.Text = "MD5 Hash: "
$md5hashTextBox.Font = $smallfont
$md5hashTextBox.ReadOnly = $true
$form.Controls.Add($md5hashTextBox)

$sha256hashTextBox = New-Object System.Windows.Forms.TextBox
#$sha256TextBox.Location = New-Object System.Drawing.Point(10,73)
$sha256hashTextBox.Dock = "Bottom"
$sha256hashTextBox.Size = New-Object System.Drawing.Size(180, 30)
$sha256hashTextBox.Text = "SHA256 Hash: "
$sha256hashTextBox.Font = $smallfont
$sha256hashTextBox.ReadOnly = $true
$form.Controls.Add($sha256hashTextBox)

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


if(Test-Path $binaryTextBox.Text)
{
    $BinaryPath = $binaryTextBox.Text
    $BinaryPath = $BinaryPath -replace ' ','` '
}
if(Test-Path $binaryTextBox.Text)
{
    $CapturePath = $captureTextBox.Text
    $CapturePath = $CapturePath -replace ' ','` '
}

if($checkboxPEiD.Checked)
{
    if(!$config.Paths.PEID)
    {
        Write-Output "PEiD path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run PEiD."
    }
    else
    {
        $path = $config.Paths.PEID
        $path = $path -replace ' ','` '
        $command = $path + " " + $BinaryPath
        Invoke-Expression $command  
    }
}

if($checkboxDetectItEasy.Checked)
{
    if(!$config.Paths.DetectItEasy)
    {
        Write-Output "DetectItEasy path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run Detect It Easy."
    }
    else
    {
        $path = $config.Paths.DetectItEasy
        $path = $path -replace ' ','` '
        $command = $path + " " + $BinaryPath
        Invoke-Expression $command  
    }
}

if($checkboxPEStudio.Checked)
{
    if(!$config.Paths.PEStudio)
    {
        Write-Output "PEStudio path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run PEStudio."
    }
    else
    {
        $path = $config.Paths.PEStudio 
        $path = $path -replace ' ','` '
        $command = $path + " -file:" + $BinaryPath
        Invoke-Expression $command  
    }
}

if($checkboxBinaryNinja.Checked)
{
    if(!$config.Paths.BinaryNinja)
    {
        Write-Output "BinaryNinja path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run BinaryNinja."
    }
    else
    {
        $path = $config.Paths.BinaryNinja
        $path = $path -replace ' ','` '
        $command = $path + " " + $BinaryPath
        Invoke-Expression $command  
    }
}

if($checkboxIDAProDemo.Checked)
{
    if(!$config.Paths.IDAProDemo)
    {
        Write-Output "IDAProDemo path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run IDA Pro/Demo."
    }
    else
    {
        $path = $config.Paths.IDAProDemo
        $path = $path -replace ' ','` '
        $command = $path + " " + $BinaryPath
        Invoke-Expression $command
    }
}

if($checkboxIDAFree.Checked)
{
    if(!$config.Paths.IDAFree)
    {
        Write-Output "IDAFree path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath)
    {
        Write-Output "Binary path not supplied. Cannot run IDA Freeware."
    }
    else
    {
        $path = $config.Paths.IDAFree
        $path = $path -replace ' ','` '
        $command = $path + " " + $BinaryPath
        Invoke-Expression $command
    }
}
