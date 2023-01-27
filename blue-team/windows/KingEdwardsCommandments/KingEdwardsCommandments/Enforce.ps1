restore-gpo KingEdwardsCommandments -path C:\KingEdwardsCommandments

$id = read-host "Enter GUID: "

$ou = read-host "Enter organizational unit"

new-gplink -guid $id -target $ou -linkenabled yes -enforced yes