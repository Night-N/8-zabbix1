# Домашнее задание к занятию "`Система мониторинга Zabbix`" - `Горбунов Владимир`



### Задание 1

`1. Скриншот админки Zabbix:`<br>
![Название скриншота](https://github.com/Night-N/8-zabbix1/blob/master/zabbix1-adminpanel.jpg)<br>

`2. Написал плэйбук ансибла для установки забикс-сервера на дебиан 11:`<br>
https://github.com/Night-N/8-zabbix1/blob/master/zabbix-server.yml<br>

`плейбук ансибла для установки забикс-агента на дебиан 11:`<br>
https://github.com/Night-N/8-zabbix1/blob/master/zabbix-agent.yml<br>


`Забикс сервер и два сервера с агентами создаются терраформом в яндекс клауде:`<br>
![Название скриншота](https://github.com/Night-N/8-zabbix1/blob/master/zabbix1-tf.jpg)<br>
https://github.com/Night-N/8-zabbix1/blob/master/main.tf<br>
`Терраформом создаются три машины - забикс сервер и две с агентом. С помощью null-resource и команды sed получившиеся внешние IP адреса 
записываются сразу же в инвентарь ансибла ./hosts, после этого вручную запускаются плейбуки для server и agent,
на забикс агентах с помощью ансибла записывается айпишник забикс сервера.`


### Задание 2

`1. Агенты, подключенные к серверу:`<br>
![Название скриншота](https://github.com/Night-N/8-zabbix1/blob/master/zabbix1-hosts.jpg)<br>


`2. Лог заббикс-агента:`<br>
![Название скриншота](https://github.com/Night-N/8-zabbix1/blob/master/zabbix1-agentlog.jpg)<br>


`3. Latest data для двух хостов:`<br>
![Название скриншота](https://github.com/Night-N/8-zabbix1/blob/master/zabbix1-latestdata.jpg)<br>

`4. Команды - с официального сайта Zabbix, на их основе написан плэйбук ансибла`<br>
https://github.com/Night-N/8-zabbix1/blob/master/zabbix-agent.yml<br>
