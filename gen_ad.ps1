param([Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup(){
    param([Parameter(Mandatory=$true)] $groupObject)
    
    $name = $groupObject.name
    New-ADGroup -name $group -GroupScope Global

}

function CreateADUser(){
    param([Parameter(Mandatory=$true)] $userObject)

    # Pull out the name from the JSON object
    $name = $userObject.name
    $password = $userObject.password
    
    # Generate "first inital, last name" structure for username
    $username = ($firstname[0] + $lastname).ToLower()
    $firstname, $lastname = $name.Split(" ") 
    $samAccountName = $username
    $principalname = $username


    # Actually create AD User object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName  $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 



    foreach($group in $userObject.groups){
        Add-ADGroupMember -Identity $group -Members $username
    }
}


$json = ( Get-Content $JSONFile | ConvertFrom-Json)

$Global:Domain = $json.domain

foreach ( $group_name in $json.groups){
    try {
        Get-ADComputer -Identity $group_name -Members $username
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        Write-Warning "User $name NOT added to group $group_name because it does not exist"
    }
    Add-ADGroup



    CreateADGroup $group
}


foreach ( $user in $json.users){
    CreateADUser $user
}

