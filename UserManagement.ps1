# Variables
$machines = @("FS01", "DC01", "APP01", "SQL01", "WEB01", "DomainController")
$usernames = @("Administrator")
$password = ConvertTo-SecureString "!!Only_4_c0olPeoplez" -AsPlainText -Force
$password = ConvertTo-SecureString "Potato1" -AsPlainText -Force

# Loop through each machine and create user accounts
for ($i = 0; $i -lt $usernames.Length; $i++) {
    $machine = $machines[$i]
    $username = $usernames[$i]

    # Create local user account on the specified machine
    Invoke-Command -ComputerName $machine -ScriptBlock {
        param($username, $password)
        # Check if the user already exists
        if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
            New-LocalUser -Name $username -Password $password -PasswordNeverExpires -UserMayNotChangePassword
            Add-LocalGroupMember -Group "Administrators" -Member $username
            Write-Host "User $username created and added to Administrators group on $($env:COMPUTERNAME)."
        } else {
            Write-Host "User $username already exists on $($env:COMPUTERNAME)."
        }
    } -ArgumentList $username, $password
}
