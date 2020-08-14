# Create list of string objects removing emptys
$users = (Invoke-Expression -Command "net user").split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)

# Cleanup end of user list.
$users = $users[5..($users.Count - 5)]

# Array to store User and Groups
$myArray = @()

# Get the groups for each user
ForEach($user in $users)
{
    # Create object to store user with groups and add username to objects
    $myObj = New-Object -TypeName PSObject
    Add-Member -InputObject $myObj -MemberType NoteProperty -Name 'User' -Value $user
    
    # Get user groups with net user command, split by space and remove blanks.
    # Add groups to user object
    $userGroups = (Invoke-Expression -Command "net user $user" | Select-String -Pattern "Local Group Members*").ToString().split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
    Add-Member -InputObject $myObj -MemberType NoteProperty -Name 'Groups' -Value ($userGroups[3..($userGroups.Count)]).Replace("*","") 
    
    # Store user in array of users
    $myArray += $myObj
}

# Print Array
$myArray | ForEach-Object {$_ -join ','} 
