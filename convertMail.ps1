#Author: William Bennet
#Date:7/3/2020
#Function:Converts mailbox to a different primary email address.
#edit $primarySMTP to change to desired domain.
#@we.org will still be users login. Only email address is changed in outlook

#uses string 
$primarySTMP = #'@contoso.org'
$list = Get-Content .\users.txt

foreach($user in $list){
    echo $user
    echo "going through"
    try{
        $name = $user.Split('@')[0]
        $name = $name.ToLower() + $primarySTMP
        $user = $user.ToLower()
        echo $name
        echo $user
        try{
        Set-Mailbox $user -WindowsEmailAddress $name}
        catch{echo' could not convert';echo $name >> .\failed.txt}
    }
    catch{
        echo "nope"
        echo $user >> failConvert.txt
    }
}
