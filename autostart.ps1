#создаем расписание запуска (ежедневно в полпятого вечера, в течении 10 дней)
$t = New-JobTrigger -Daily -At 4:30PM -DaysInterval 10
#сохраняем в переменной учетные данные
$cred = Get-Credential ivan.admin
#В качестве опции указываем запуск задания с повышенными привилегиями
$o = New-ScheduledJobOption -RunElevated
#регистрируем задание с именем GetLogs
Register-ScheduledJob -Name GetLogs -FilePath C:\Users\ivan.admin\Desktop\GetLogs.ps1 -Trigger $t -Credential $cred -ScheduledJobOption $o