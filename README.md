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
