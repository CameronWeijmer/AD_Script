Import-Module ActiveDirectory

#Auswahl menü
Write-Host "1. OUs erstellen"
Write-Host "2. Gruppen erstellen"
Write-Host "3. Benutzer erstellen"

$selection = Read-Host "Geben die Nummer der Aktion ein"

#Neue OU
if ($selection -eq "1") {
    $ouName = Read-Host "Geben Sie den Namen der OU ein"
    New-ADOrganizationalUnit -Name $ouName -Path "DC=bbw,DC=lab"
}
#Neue Gruppe erstellen
elseif ($selection -eq "2") {
    $groupName = Read-Host "Geben Sie den Namen der Gruppe ein"
    $ouName = Read-Host "Geben Sie den Namen der Ou ein"
    New-ADGroup -Name $groupName -GroupCategory Security -GroupScope DomainLocal -Path "OU=$ouName,DC=bbw,DC=lab"
}
#Neuen Benutzer erstellen
elseif ($selection -eq "3") {
    $userName = Read-Host "Geben Sie den Namen des Benutzers ein"
    $password = Read-Host -AsSecureString "Geben Sie das Passwort des Benutzers ein"
    $ouName = Read-Host "Geben Sie den Namen der OU ein, in die der Benutzer kommen soll"
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
    $user = New-ADUser -Name $userName -AccountPassword $securePassword -Path "OU=$ouName,DC=bbw,DC=lab" -PassThru

    Enable-ADAccount -Identity $user

    #Benutzer hinzufügen
    $groupName = Read-Host "Geben Sie den Namen der Gruppe ein wo der Benutzer hinzugefügt wird"
    Add-ADGroupMember -Identity $groupName -Members $userName

}
else {
    Write-Host "Ungültige Auswahl"
}
