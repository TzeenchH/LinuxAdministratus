# Часть 1
## 1. Создать нескольких пользователей, задать им пароли, домашние директории и шеллы.
Для создания пользователя используется команда **useradd** с ключами -d ( directory ) для указания директории и -s ( shell ) для указания пути до оболочки - bash, Zsh и т.д.
для добавления пароля используется команда **passwd** sudo passwd username, после чего вводим и повторяем пароль (возможно сообщение о недостаточной сложности пароля, но оно не блокирует его использование если не созданы соответствующие политики).

![](https://sun9-54.userapi.com/impg/EU_Y0x-jyMCuKbfk_VXosMCr5As10yDCb8eXJA/UICYqimNMo8.jpg?size=766x126&quality=96&proxy=1&sign=4a14b538626d8257e01e3597109c69be)

Производим те же действия для создания ещё нескольких пользователей:

![](https://sun9-41.userapi.com/impg/djjQQZdWSgp1xqJuH8DdJL2yWiYPve2mbKBn0g/w5Njsx-svno.jpg?size=804x280&quality=96&proxy=1&sign=4f2f9431868acd24c012acf057287645)

## 2. Создать группу **admin** и добавить в неё нескольких пользователей и пользователя root 
Создание группы производится практически аналогичной командой **groupadd**. после этого можно добавить туда пользователей командой **usermod** с ключами -aG. Для проверки выполним команду _id username_ которая покажет группы, к которым принадлежит пользователь. Как итог - в группе админ есть добавленные пользователи (пользователь _root_ был добавлен аналогично)

![](https://sun9-45.userapi.com/impg/s6UiIkWRAnhDQ_Z5ZDJ7g7tXfbhoFrefcVAVug/f48dg01WMI0.jpg?size=733x158&quality=96&proxy=1&sign=2b8683aa96025d518eb21137f896fe2a)
![](https://sun9-42.userapi.com/impg/5BHuROHKUvlE7eU-8Z0WogH8mUmxnffKfMgu1A/J1weKzzFWpI.jpg?size=540x73&quality=96&proxy=1&sign=cb833e1e0c7c03d937907cf726d403b2)

