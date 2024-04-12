# Load the Winforms assembly
[reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")

function do_exit
{
     $form.close()
}

# Send message to a specific machine
function send_msg
{
     foreach ($Computer in $Computers)
     {
        if (Test-Connection -ComputerName $Computer -Count 1 -Quiet)
        {
            Invoke-WmiMethod -Credential $Cred -Path Win32_Process -Name Create -ArgumentList "C:\Windows\System32\msg.exe * /Server:Machinename1 /time:9999 $($textfield.text)" -ComputerName "Machinename1"
		} 
    }}

# Set MSG Credential

$password = ConvertTo-SecureString "Adminpassword" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("domain\user", $password)

$remoteKeyParams = @{
    ComputerName = $env:COMPUTERNAME
    Path = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
    Name = 'EnableRemoteManagement'
    Value = '1'
}

# Get target computers
$ComputersFile = "\\Path\Computers.txt"
$Computers = Get-Content $ComputersFile

# Create the form
$form = New-Object Windows.Forms.Form

#Set the dialog title
$form.text = "Message title"
$form.Size = New-Object Drawing.Point 400,200

# Create the label control and set text, size and location
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point 80,30
$label.Size = New-Object Drawing.Point 500,15
$label.text = "Insert the message to be delivered"

# Create TextBox and set text, size and location
$textfield = New-Object Windows.Forms.TextBox
$textfield.Location = New-Object Drawing.Point 50,60
$textfield.Size = New-Object Drawing.Point 300,30


# Create Button and set text and location
$button = New-Object Windows.Forms.Button
$button.text = "Enviar"
$button.Location = New-Object Drawing.Point 120,90
$button.Size = New-Object Drawing.Point 150,30

# Set up event handler to extract text from TextBox and display it on the Label.

$button.add_click({
send_msg;
$label.Text = "The message was sent.";
$form.controls.remove($button);
$form.controls.remove($textfield);

# Create Close Button and set text and location
$closebutton = New-Object Windows.Forms.Button;
$closebutton.text = "Close";
$closebutton.Location = New-Object Drawing.Point 120,90;
$closebutton.Size = New-Object Drawing.Point 150,30;
$form.controls.add($closebutton);

(
# Set up event handler to close form.
$closebutton.add_click({
$form.Close()
})
)

})

# Add the controls to the Form
$form.controls.add($button)
$form.controls.add($label)
$form.controls.add($textfield)

# Display the dialog
$form.ShowDialog()