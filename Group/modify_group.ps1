# Récupération des postes depuis un fichier csv
$postes= Import-Csv .\Desktop\postes.csv -Delimiter ";" | select -ExpandProperty postes

# remplir la variable action en fonction de la demande ajout - change - supprimer
$action= "change"

# variable du scope cible pilote - prod
$scope="pilote"

# configuration si transfert vers pilote :
$targetdskgroup=WSUS_Pilote_Desktop_OPEN                                          
$targetlapgroup=WSUS_Pilote_Laptop_OPEN
$targetsrvgroup=WSUS_SRV_PREPROD_OPEN

# configuration si transfert vers prod : 
#$targetdskgroup=WSUS_Prod_Desktop_OPEN                                          
#$targetlapgroup=WSUS_Prod_Laptop_OPEN
#$targetsrvgroup=WSUS_SRV_PROD_4Me2h_OPEN


foreach($poste in $postes){
    $poste=Get-ADComputer -Identity $poste

    if($poste.name -like "*LAP*"){
        Add-ADGroupMember $targetlapgroup -Members $poste.DistinguishedName
    }
    elseif($poste.name -like "*DSK*"){
        Add-ADGroupMember $targetdskgroup -Members $poste.DistinguishedName
    }
    else{
        Add-ADGroupMember $targetsrvgroup -Members $poste.DistinguishedName
    }
}
