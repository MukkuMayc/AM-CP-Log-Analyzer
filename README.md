# AM-CP-Log-Analyzer
Log analysis tool for Windows

 Workflow:
-------------------

1. [Setup Active directory](https://github.com/MukkuMayc/AM-CP-Log-Analyzer/wiki/Active-Directory-Setup)
2. [Choose ways to collect logs](https://github.com/MukkuMayc/AM-CP-Log-Analyzer/wiki/%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1%D1%8B-%D1%81%D0%B1%D0%BE%D1%80%D0%B0-%D0%BB%D0%BE%D0%B3%D0%BE%D0%B2)
3. [Use ELK-stack](https://github.com/MukkuMayc/AM-CP-Log-Analyzer/wiki/%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0-ELK-Stack-%D0%B4%D0%BB%D1%8F-%D0%BF%D1%80%D0%BE%D1%81%D0%BC%D0%BE%D1%82%D1%80%D0%B0-%D1%81%D0%BE%D0%B1%D1%80%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%BB%D0%BE%D0%B3%D0%BE%D0%B2)

Презентация: https://docs.google.com/presentation/d/1KlxMZUGtOr5bJX2GlkVYG9da65k3kQpimqKqIFnp39o

## Пример
Допустим, что нам необходимо выяснить, кто производил вход в систему на компьютерах в домене. Для этого мы клонируем наш репозиторий на компьютер-сборщик и переходим в него.

```
git clone https://github.com/MukkuMayc/AM-CP-Log-Analyzer
cd AM-CP-Log-Analyzer
```

Далее в скрипте logs.ps1 мы указываем параметры, перечисленные выше в пункте "Сбор логов", например,
```
# определяем директорию для логирования, если она отсутствует, то будет создана
$logdir = "c:\\forwarded-logs" + $(Get-Date -UFormat "%Y_%m")
# указываем данные пользователя под которым будут выполнятся команды
$domain = "TESTDOMAIN"
$username = "ivan.admin" 
$password = "EXAMPLE_PASSWORD"
#указываем журналы, которые мы хотим получить
$logjournals = "System", "Application", "Security"
#указываем путь в Active Directory, по которому будем искать
$searchbase = "DC=TESTDOMAIN,DC=internal"
```
Запускаем скрипт. После этого у нас появится папка C:\forwarded_logs2019_12, в которой будут лежать логи с компьютеров в домене. Теперь мы должны поставить ELK для их просмотра, можно воспользоваться [этим](../../wiki/Настройка-ELK-Stack-для-просмотра-собранных-логов) руководством.
Далее мы заходим в Kibana по адресу localhost:5601 и в разделе Dashboard добавляем фильтр для поля `event.code`, оператором указываем `is`, а значением "4624". После добавления в ленте у нас должны появиться логи, ответственные за вход с учётной записи.

## Collecting logs: Subscriptions and GetWmi Object
<h4>Windows Event Collector and Subscriptions</h4> <br/>
You can subscribe to receive and store events on a local computer (event collector) that are forwarded from a remote computer (event source). 
Event collection allows administrators to get events from remote computers and store them in a local event log on the collector computer. The destination log path for the events is a property of the subscription. All data in the forwarded event is saved in the collector computer event log (none of the information is lost). Additional information related to the event forwarding is also added to the event.
<h4> GetWmi Object </h4><br/>
Windows Management Instrumentation (WMI) is a key technology in Windows system administration because it provides a wide range of information in a unified way. Since the range of capabilities of WMI tools is quite wide, the Get-WmiObject Windows PowerShell cmdlet, which is used to access WMI objects, is one of the most useful.
WMI tasks for event logs obtain event data from event log files and perform operations like backing up or clearing log files. 
