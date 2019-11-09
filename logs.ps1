Clear-Host

# импортируем список серверов из Active Directory (для этого в powershell должен быть дополнительно установлен модуль для Active Directory)
import-module activedirectory
$computers = Get-ADComputer -SearchBase "OU=Servers,DC=domain,DC=ru" -Filter * | ForEach-Object {$_.Name} | Sort-Object

# определяем директорию для логирования 
$logdir = "\\storage\Logs\ServersLog\" + $(Get-Date -UFormat "%Y_%m")
# если директория отсутствует, то создаем 
if((Test-Path $logdir) -eq 0) {
	New-Item -ItemType directory $logdir -Force
}

# указываем данные пользователя под которым будут выполнятся команды
$domain = "domain"
$username = "username" 
$password = 'password'

$account = "$domain"+"\"+$($username)
$accountpwd = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PsCredential($account, $accountpwd)

# для того, чтобы делать выгрузку за предыдущий час, нужно ограничить время за которое лог был сформирован следующим образом: верхний предел - минус час, нижний предел - начало текущего часа.
# получается примерно следующее:
# BiginDate = 08/26/2014 12:00:00
# EndDate = 08/26/2014 13:00:00
# в результате будет выгружен лог созданый в пределах от BiginDate = 08/26/2014 12:00:00 до EndDate = 08/26/2014 13:00:00

$date = Get-Date
Write-Host "Date = $date"
$m = $date.Minute
$s = $date.Second
$begindate = (($date.AddSeconds(-$s)).AddMinutes(-$m)).addHours(-1)
Write-Host "BiginDate = $begindate"
$enddate = ($date.AddSeconds(-$s)).AddMinutes(-$m)
Write-Host "EndDate = $enddate"

# перевод времени в формат WMI
$wmibegindate=[System.Management.ManagementDateTimeConverter]::ToDMTFDateTime($begindate)
Write-Host "WMIBiginDate = $wmibegindate"
$wmienddate=[System.Management.ManagementDateTimeConverter]::ToDMTFDateTime($enddate)
Write-Host "WMIEndDate = $wmienddate"

$logjournals = "System", "Application", "Security"

foreach ($computer in $computers) {
	Write-Host "Processing computer: $computer"
	foreach ($logjournal in $logjournals) {
		Write-Host "Processing log: $logjournal"
		$systemlog = Get-WmiObject -Class win32_NTLogEvent -filter "logfile = '$logjournal' AND (TimeWritten>='$wmibegindate') AND (TimeWritten<'$wmienddate')" -computerName $computer -Credential $credential -ErrorAction SilentlyContinue
		
        foreach ($logstring in $systemlog) {
			$wmitime = $logstring.TimeGenerated
			$time = [System.Management.ManagementDateTimeconverter]::ToDateTime("$wmitime")
			#Write-Host $logtime
				
			$level = $logstring.Type
			#Write-Host "$level"
				
			$journal = $logstring.LogFile
			#Write-Host "$journal"
			
			$category = $logstring.CategoryString
			#Write-Host "$category"
			
			$source = $logstring.SourceName
			#Write-Host "$source"
			
			$message = $logstring.Message
			#Write-Host "$message"
			
			$code = $logstring.EventCode
			#Write-Host "$code"
			
            @{Server="$computer";Time="$time";Level="$level";Journal="$journal";Category="$category";Source="$source";Message="$message";Code="$code"} | ConvertTo-Json -depth 10 -Compress | Out-File "$logdir\$computer-$logjournal.json" -Encoding utf8 -Append
		}
	}
}