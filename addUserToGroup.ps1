#Author: William Bennet
#Date:7/3/2020
#Function:2nd in creation process adds users to groups. Depending on how group is setup it will auto license user

$list = Get-Content .\users.txt
if ($creds -eq ''){$creds = get-credential}

$groupId = '8ef758e6-a982-4800-b685-381d26ff961b' #GroupID# "CSSG - E5, Calling"
#$groupId = 'fe7c0b1a-c46b-40f9-855b-ffc16fbe3875' #TeamB all

echo " << ADDING USERS TO GROUP >>"


foreach($user in $list){
    echo $user
    try{
        echo 'adding to distro group'
    $userOb = Get-MsolUser -UserPrincipalName $user
    #This adds user to group here
    Add-DistributionGroupMember -Identity "TeamB all" -Member $userOb.UserPrincipalName}
    #This command is needed for mail enabled security groups otherwise user add-msol
    catch{echo "failed to add to MSOL group"}
    try{
        echo 'adding to MsolGroups'
    Add-MsolGroupMember -GroupMemberObjectId $userOb.ObjectId -GroupObjectId $groupId}
    #This adds user to group here
    catch{echo "Failed To Add to distro Groups"}
}
