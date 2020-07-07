#Author: William Bennet
#Date:7/3/2020
#Function: Creates user accound and enables MFA
#First of 3 scripts in user creation process scripts for Office365 only accounts


$list = Get-Content .\users.txt
if ($creds -eq ''){$creds = get-credential}

$groupId = '' #<group id in string format here> 
$primarySTMP = '@iwanttohelp.org' #Can change to french one if need be

function Capitalize($wordIn){
    $text = $wordIn
    $output = ( Get-Culture ).TextInfo.ToTitleCase( $text.ToLower() )
    return $output
}

function ToLower($stuffIn) {
    $output = $stuffIn
    $output = $output.ToLower()
    return $output
    
}

function AddGroupStuff {
    foreach($user in $list){
        $userOb = Get-MsolUser -UserPrincipalName $user.ToLower()
        $upn = $user.ToLower()
        echo 'Add Msol Group'
        Add-MsolGroupMember -GroupMemberObjectId $userOb.ObjectId -GroupObjectId $groupId
        echo 'Add Distro Group'
        Add-DistributionGroupMember -Identity "TeamB all" -Member "$upn"
    }
}
function TimeStampFiles(){
    $times = Get-Date
    echo "   ">> .\failed.txt
    echo "$times">> .\failed.txt
    echo "   ">> .\created.txt
    echo "$times">> .\created.txt
}

TimeStampFiles

foreach($user in $list){
    $user = $user.ToLower()
    $domain = "@we.org"
    $Alias = $user.Split("@")[0]
    $FirstName =$Alias.Split(".")[0]
    $Surname = $Alias.Split(".")[1]
    try{
    $Firstname = Capitalize($FirstName)}catch{echo 'Failed'}
    try{
    $Surname = Capitalize($Surname)}catch{echo "last name failed"}
    $Location = "CA" #Canada
    $license = 'freethechildren:ENTERPRISEPACK' #E3 License
    #Block of code above changes options and formats string


    try{
    $displayName = $FirstName + " " + $Surname
    }
    catch{
        try{
            $displayName = $FirstName
        }
        catch{
            $displayName = $Surname
        }
    }
    $upn = $FirstName + '.' + $Surname + $domain
    $upn = ToLower($upn)
    $newdomain = $FirstName + '.' + $Surname + $primarySTMP
    #More string formatting please leave be

    try{
    New-MsolUser -UserPrincipalName $upn -DisplayName $displayName -FirstName $FirstName -LastName $Surname -UsageLocation $Location >> userinfo.txt 
    echo 'Created User ' , $upn
    #Creates blank account
    
    #BLOCK###############################################################################
    #echo "Adding License"
    #Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $license
    #Adds license, moved to whole separate script
    #UNCOMMENT THIS BLOCK OF CODE IF GROUP USER IS ADDED TO DOES NOT AUTO LICENSE ENABLED

    $userOb = Get-MsolUser -UserPrincipalName $upn
    echo "got user info"
    #Gets the new account imported for manipulation

    #echo "Adding $upn to $newdomain"
    #Set-Mailbox -Identity $upn -WindowsEmailAddress $newdomain
    echo "setting mailbox"
    #New-Mailbox -UserPrincipalName $upn -Alias chris -Name $displayName -Password $password -FirstName $FirstName -LastName $Surname -DisplayName $displayName
    echo $upn >> created.txt;

    }

    catch{TimeStampFiles;echo $upn >> failed.txt}

}

#Goes through list again to enable MFA
foreach ($user in $list)
{
    $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $st.RelyingParty = "*"
    $st.State = "Enabled"
    $sta = @($st)
    Set-MsolUser -UserPrincipalName $user -StrongAuthenticationRequirements $sta
}

<#This block of code will auto run the next 2 scripts. Not recommended
Start-Sleep -Seconds 3
echo "RUNNING : addUserToGroup "
& "C:\office\addUserToGroup.ps1"
Start-Sleep -Seconds 3
echo "RUNNING : ConvertMail "
& "C:\office\convertMail.ps1"#>
