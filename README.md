# AM-CP-Log-Analyzer
Log analysis tool for Windows

Файлы:
-------------------

1. ***logs.ps1***
Импортирует список серверов из Active Directory
По завершении действия скрипта на выходе получаются файлы вида: ComputerName-JournalName.json.
2. ***domain.ps1*** добавляет компьютер в домен.
3. ***autostart.ps1*** добавляет сборщик логов в планировщик Windows.


Презентация: https://docs.google.com/presentation/d/1KlxMZUGtOr5bJX2GlkVYG9da65k3kQpimqKqIFnp39o

## Сбор логов
Для того, чтобы воспользоваться сборщиком логов logs.ps1, необходимо внутри него указать следующие параметры: $domain, $username, $password, $searchbase. $logdir и $logjournals при желании тоже можно изменить.

## Subscriptions and GetWmi Object
<h4>Windows Event Collector and Subscriptions</h4> <br/>
You can subscribe to receive and store events on a local computer (event collector) that are forwarded from a remote computer (event source). 
Event collection allows administrators to get events from remote computers and store them in a local event log on the collector computer. The destination log path for the events is a property of the subscription. All data in the forwarded event is saved in the collector computer event log (none of the information is lost). Additional information related to the event forwarding is also added to the event.
<h4> GetWmi Object </h4><br/>
Windows Management Instrumentation (WMI) is a key technology in Windows system administration because it provides a wide range of information in a unified way. Since the range of capabilities of WMI tools is quite wide, the Get-WmiObject Windows PowerShell cmdlet, which is used to access WMI objects, is one of the most useful.
WMI tasks for event logs obtain event data from event log files and perform operations like backing up or clearing log files. 
