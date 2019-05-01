#only parameter is -ConfigPath to specify location of XML file. Fairly user friendly, no real way to mess stuff up aside from picking bad files
param
(
    [string]$ConfigPath = ".\config.xml" #default config path
)

#escape spaces in path to avoid problems
$ConfigPath = $ConfigPath -replace ' ','` '

#import config file if it exists
if(Test-Path $ConfigPath)
{
    [xml]$config = Get-Content $ConfigPath
}
else
{
    Write-Output "Bad config path. Specify with -ConfigPath (default is .\config.xml)"
    exit
}

#################################### ONCLICK EVENTS ###############################################
Function BinaryClick()
{
    #dialog for file chooser
    $binaryDialog = New-Object System.Windows.Forms.OpenFileDialog
    $binaryDialog.Filter = "Executables/Binaries (*.exe;*.bin)|*.exe;*.bin|All Files|*.*" #look for specific types of files or all files option
    $binaryDialog.FilterIndex = 1;
    $binaryDialog.ShowDialog()

    #populate text box with filename
    $binaryTextBox.Text = $binaryDialog.FileName

    #get hashes
    $md5 = Get-FileHash $binaryDialog.FileName -Algorithm MD5
    $sha256 = Get-FileHash $binaryDialog.FileName

    #populate hash text boxes
    $sha256hashTextBox.Text = "SHA256 Hash: " + $sha256.hash
    $md5hashTextBox.Text = "MD5 Hash: " + $md5.hash

}

#similar to binaryclick
Function CaptureClick()
{
    $captureDialog = New-Object System.Windows.Forms.OpenFileDialog
    $captureDialog.Filter = "Wireshark Packet Capture (*.pcap;*pcapng)|*.pcap;*.pcapng|All Files|*.*"
    $captureDialog.FilterIndex = 1;
    $captureDialog.ShowDialog()

    $captureTextBox.Text = $captureDialog.FileName

}

Function ProcessExplorerClick()
{
    #sanitize path and open program
    $path = $config.Paths.ProcessExplorer
    $path = $path -replace ' ','` '
    Invoke-Expression $path
}

Function HashSearchClick()
{
    if($md5hashTextBox.Text -eq "MD5 Hash:") #default value of text box
    {
        [System.Windows.Forms.MessageBox]::Show("No file supplied!")
        return
    }
    else
    {
        #get hash and open google search with default browser
        $md5 = $md5hashTextBox.Text.split()
        $md5 = $md5[2]
        $md5searchString = "https://google.com/search?q=" + $md5
        start $md5searchString

        $sha256 = $sha256hashTextBox.Text.split()
        $sha256 = $sha256[2]
        $sha256searchString = "https://google.com/search?q=" + $sha256
        start $sha256searchString
    }

}

####################################### FORM CREATION ##################################################


#BUTTONS
#make sure we have stuff for forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#create base form
$form = New-Object System.Windows.Forms.Form
$form.Text = "quickanalysis"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(450, 400)

#fonts to select from easily
$bigfont = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Regular)
$boldbigfont = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$smallfont = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
$boldsmallfont = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold)
$form.Font = $smallfont

#button to trigger file selection
$binaryFileBrowserButton = New-Object System.Windows.Forms.Button
$binaryFileBrowserButton.Location = New-Object System.Drawing.Size(10,30)
$binaryFileBrowserButton.Size = New-Object System.Drawing.Size(205,40)
$binaryFileBrowserButton.Text = "Choose Binary"
$binaryFileBrowserButton.Font = $boldsmallfont
$form.Controls.Add($binaryFileBrowserButton)
$binaryFileBrowserButton.Add_Click({BinaryClick})

#text box for binary
$binaryTextBox = New-Object System.Windows.Forms.TextBox
$binaryTextBox.Location = New-Object System.Drawing.Point(10,73)
$binaryTextBox.Size = New-Object System.Drawing.Size(205, 30)
$binaryTextBox.Text = "No file selected"
$binaryTextBox.Font = $smallfont
$binaryTextBox.ReadOnly = $true
$form.Controls.Add($binaryTextBox)

#see binary button
$captureFileBrowserButton = New-Object System.Windows.Forms.Button
$captureFileBrowserButton.Location = New-Object System.Drawing.Size(220,30)
$captureFileBrowserButton.Size = New-Object System.Drawing.Size(205,40)
$captureFileBrowserButton.Text = "Choose Capture"
$captureFileBrowserButton.Font = $boldsmallfont
$form.Controls.Add($captureFileBrowserButton)
$captureFileBrowserButton.Add_Click({CaptureClick})

#see binary text box
$captureTextBox = New-Object System.Windows.Forms.TextBox
$captureTextBox.Location = New-Object System.Drawing.Point(220,73)
$captureTextBox.Size = New-Object System.Drawing.Size(205, 30)
$captureTextBox.Text = "Test text oh yeah"
$captureTextBox.Font = $smallfont
$captureTextBox.ReadOnly = $true
$form.Controls.Add($captureTextBox)

#CHECKBOXES
#checkbox for PEID program
$checkboxPEiD = New-Object System.Windows.Forms.Checkbox
$checkboxPEiD.Location = New-Object System.Drawing.Size(10,100)
$checkboxPEiD.Size = New-Object System.Drawing.Size(180,20)
$checkboxPEiD.Text = "PEiD"
$checkboxPEiD.Check
$form.Controls.Add($checkboxPEiD)

#these are all the same
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

$checkboxWireshark = New-Object System.Windows.Forms.Checkbox
$checkboxWireshark.Location = New-Object System.Drawing.Size(220,100)
$checkboxWireshark.Size = New-Object System.Drawing.Size(180,20)
$checkboxWireshark.Text = "Wireshark" #lordandsaviortulloss.jpg
$checkboxWireshark.Check
$form.Controls.Add($checkboxWireshark)

$checkboxNetworkMiner = New-Object System.Windows.Forms.Checkbox
$checkboxNetworkMiner.Location = New-Object System.Drawing.Size(220,120)
$checkboxNetworkMiner.Size = New-Object System.Drawing.Size(180,20)
$checkboxNetworkMiner.Text = "NetworkMiner"
$checkboxNetworkMiner.Check
$form.Controls.Add($checkboxNetworkMiner)

#OTHER BUTTONS
#button to launch process explorer
$ProcessExplorerButton = New-Object System.Windows.Forms.Button
$ProcessExplorerButton.Location = New-Object System.Drawing.Size(220,145)
$ProcessExplorerButton.Size = New-Object System.Drawing.Size(205,40)
$ProcessExplorerButton.Text = "Start Process Explorer"
$ProcessExplorerButton.Font = $smallfont
$form.Controls.Add($ProcessExplorerButton)
$ProcessExplorerButton.Add_Click({ProcessExplorerClick})

#button to google hashes
$HashSearchButton = New-Object System.Windows.Forms.Button
$HashSearchButton.Location = New-Object System.Drawing.Size(220,190)
$HashSearchButton.Size = New-Object System.Drawing.Size(205,40)
$HashSearchButton.Text = "Google Hashes"
$HashSearchButton.Font = $smallfont
$form.Controls.Add($HashSearchButton)
$HashSearchButton.Add_Click({HashSearchClick})

#HASH TEXT BOXES
#these populate once a binary is chosen
$md5hashTextBox = New-Object System.Windows.Forms.TextBox
$md5hashTextBox.Dock = "Bottom"
$md5hashTextBox.Size = New-Object System.Drawing.Size(180, 30)
$md5hashTextBox.Text = "MD5 Hash:"
$md5hashTextBox.Font = $smallfont
$md5hashTextBox.ReadOnly = $true
$form.Controls.Add($md5hashTextBox)

$sha256hashTextBox = New-Object System.Windows.Forms.TextBox
$sha256hashTextBox.Dock = "Bottom"
$sha256hashTextBox.Size = New-Object System.Drawing.Size(180, 30)
$sha256hashTextBox.Text = "SHA256 Hash:"
$sha256hashTextBox.Font = $smallfont
$sha256hashTextBox.ReadOnly = $true
$form.Controls.Add($sha256hashTextBox)

#CONFIRM BUTTON
#this button closes the form when clicked. variables can still be referenced later
$okbutton = New-Object System.Windows.Forms.Button
$okbutton.Dock = "Bottom"
$okbutton.Height = 80
$okbutton.Text = "Go"
$okbutton.Font = $bigfont
$okbutton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okbutton
$form.Controls.Add($okbutton)
$form.ShowDialog()

############################################ PROGRAM LAUNCHING LOGIC #######################################
#make sure paths are good, sanitize, assign
if(Test-Path $binaryTextBox.Text)
{
    $BinaryPath = $binaryTextBox.Text
    $BinaryPath = $BinaryPath -replace ' ','` '
}
if(Test-Path $captureTextBox.Text)
{
    $CapturePath = $captureTextBox.Text
    $CapturePath = $CapturePath -replace ' ','` '
}


if($checkboxPEiD.Checked) #check if box has been ticked
{
    if(!(Test-Path $config.Paths.PEID)) #if path is bad
    {
        Write-Output "PEiD path not found. Please specify in config.xml"
    }
    elseif(!$BinaryPath) #binary wasn't supplied
    {
        Write-Output "Binary path not supplied. Cannot run PEiD."
    }
    else
    {
        $path = $config.Paths.PEID
        $path = $path -replace ' ','` ' #sanitize path
        $command = $path + " " + $BinaryPath #form command
        Invoke-Expression $command   #run following string as a command
    }
}

if($checkboxDetectItEasy.Checked)
{
    if(!(Test-Path $config.Paths.DetectItEasy))
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
    if(!(Test-Path $config.Paths.PEStudio))
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
        $command = $path + " -file:" + $BinaryPath #this program takes a different input
        Invoke-Expression $command  
    }
}

if($checkboxBinaryNinja.Checked)
{
    if(!(Test-Path $config.Paths.BinaryNinja))
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
    if(!(Test-Path $config.Paths.IDAProDemo))
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
    if(!(Test-Path $config.Paths.IDAFree))
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

if($checkboxWireshark.Checked)
{
    if(!(Test-Path $config.Paths.Wireshark))
    {
        Write-Output "Wireshark path not found. Please specify in config.xml"
    }
    elseif(!$CapturePath)
    {
        Write-Output "Capture path not supplied. Cannot run Wireshark."
    }
    else
    {
        $path = $config.Paths.Wireshark
        $path = $path -replace ' ','` '
        $command = $path + " " + $CapturePath
        Invoke-Expression $command
    }
}

if($checkboxNetworkMiner.Checked)
{
    if(!(Test-Path $config.Paths.NetworkMiner))
    {
        Write-Output "NetworkMiner path not found. Please specify in config.xml"
    }
    elseif(!$CapturePath)
    {
        Write-Output "Capture path not supplied. Cannot run NetworkMiner."
    }
    else
    {
        $path = $config.Paths.NetworkMiner
        $path = $path -replace ' ','` '
        $command = $path + " " + $CapturePath
        Invoke-Expression $command
    }
}