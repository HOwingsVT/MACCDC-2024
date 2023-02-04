$ESUrl = "http://10.250.115.144:9200"
$IndexName = "logstash"

#Get the path for logs
$Path = "C:\Logs\*.log"

#Iterate through all log files in the directory
Get-ChildItem $Path | ForEach-Object {

#Get contents of log file
$Content = Get-Content $_.FullName

#Convert content to JSON
$JsonContent = ConvertTo-Json $Content -Depth 5

#Send data to elasticsearch
Invoke-RestMethod -Method Post -Uri $ESUrl/$IndexName/logs -Body $JsonContent -ContentType "application/json"

}
