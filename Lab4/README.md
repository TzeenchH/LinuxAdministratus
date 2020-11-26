# Работа с RAID массивами с использованием mdadm.
## 1. Собрать R0/R5/R10 массив на выбор.
Добавим несколько виртуальных дисков в систему - в данном случае 5 фиксированных жёстких дисков по 2Гб (размер может быть неодинаковым).

![](https://sun9-51.userapi.com/impg/FgrI7M-DBVjJ9MQxVLi1waN43JTxcgcQJ45YXA/fTjt2CaXO4k.jpg?size=518x241&quality=96&proxy=1&sign=73877ada798efc976ec6ff3364ed1fc2)

После зайдём в систему и установим непосредственно утилиту - `sudo yum install mdadm`. Был выбран R10 массив, потому что в таком массиве сохраняется скорость R0 при надёжности R1, а недостатком высокой цены массива в рамках лабораторной можно пренебречь. поэтому были добавлены 4 диска - основное требование для этого массива - **чётное количество дисков не менее четырёх**. Используем команду `sudo mdadm --create /dev/md0 -l 10 -n 4 /dev/sd{b..e}` для сборки массива.

![](https://sun9-45.userapi.com/impg/oeWerwBIu-FTA4ROIjtroNepzo2P8a4Sy5w7mg/2BpYZ-V-SZ0.jpg?size=679x388&quality=96&proxy=1&sign=3757e144660a22fda286d87b001f06af)

Проверяем корректность сборки командой `mdadm --detail /dev/md0`:

![](https://sun9-1.userapi.com/impg/lguNSUuMj7xRm-gMa0UrISdxlTT0_1ADP8VAnA/ijYGYlsdze0.jpg?size=724x620&quality=96&proxy=1&sign=a45063f95f9dbe68db03934215c5c42c)

Как видим все диски активны и синхронизированны.

## 2. Сымитировать поломку и починку одного из дисков RAID массива.
Поскольку все диски виртуальные, то "выдернуть" один из них физически нет возможности, поэтому просто отключим его поставив метку **fail** и извлечём. для этого используем команды `sudo mdadm /dev/md0 --fail /dev/sdd` и `sudo mdadm /dev/md0 --remove /dev/sdd`. При проверке статуса "скоррапченый" диск отображается как извлечённый:

![](https://sun9-40.userapi.com/impg/dtXq4rvGb99KTwgtso_VGUVpUTrCLgG9hxtPQw/vzHSAPzVmko.jpg?size=731x695&quality=96&proxy=1&sign=79bee1f34e7088830166ed3bef800aa6)

Заменим его неповреждённым диском командой `sudo mdadm --add /dev/md0 /dev/sdf`. Если у вас быстрые пальцы (или медленный ноутбук) то командой `mdadm --detail /dev/md0` можно поймать момент когда диск в процессе монтирования в систему:

![](https://sun9-72.userapi.com/impg/6a50GFWjp7YwE0-YD82ZLj4IhjfxL5DeW1AwiQ/v1oaj-3TuRM.jpg?size=729x709&quality=96&proxy=1&sign=c62c43b847d40bcd50fb8a7b73e0b973)

После диски синхронизируются и система снова готова к полноценной работе:

![](https://sun9-22.userapi.com/impg/vT12nvwhmDU-0qm_3O88ka7zU6FFBMMdf5OobA/IJNS6BlSQHE.jpg?size=724x616&quality=96&proxy=1&sign=9cb25f2564b06a2c2c1a8e9565c599fd)

Если мы вернём в систему починенный диск d - `sudo mdadm --add /dev/md0 /dev/sdd` - то он будет помечен как запасной (spare), потому что у него нет пары и нарушится чётность:

![](https://sun9-6.userapi.com/impg/BED920xyEf8iCkscHqvYx6UPhZiOIT3N8d8oSw/jggrXipGiNc.jpg?size=782x674&quality=96&proxy=1&sign=a5e52dfc40069fe127ade3763d868ed3)

## 3. Проверить, что RAID собирается при перезагрузке. 
Для этого создадим конфигурационный файл последовательностью команд (может потребоваться перход в root пользователя): 
```bash 
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
```
В результате будет сгенерирован конфигурационный файл следующего вида:

![](https://sun9-5.userapi.com/impg/iU_sm9jjn0QbNkb1LWHfMKtVcUam146zVmiyZQ/TOUHBrr4srU.jpg?size=1196x72&quality=96&proxy=1&sign=638931b08a2efbf5391249f094fbc658)

После чего выполняем команды `sudo mdadm --stop /dev/md0` и `sudo mdadm --assemble /dev/md0`для остановки и перезапуска массива соответственно:

![](https://sun9-23.userapi.com/impg/uZG2gP0FKWqg0qDPM5ybSNJ_fdbxEiAiO6Wp_A/N5xOenfmGrc.jpg?size=546x90&quality=96&proxy=1&sign=8aa96b69f1c60d91ab7cdd28f2b823f0)

Далее выполняем перезагрузку и проверяем. Массив корректно собирается: 

![](https://sun9-60.userapi.com/impg/I7_7lad68pYGbBGirxYNB3IKbDmDsIfW7inmiQ/6j7XCSuMMkM.jpg?size=498x344&quality=96&proxy=1&sign=4de755ade0c40ac8f32ce28fbfb78924)

## 4. Создать на RAID массиве раздел и файловую систему.
Для добавления раздела воспользуемся командой `sudo fdisk /dev/md0`. После выбираем команды **n** - новый раздел, **p** - тип раздела основной, **1** или **ENTER** - номер раздела, указываем размер раздела (в данном случае выбран христоматийный размер в 512Мб) - **+512M**:

![](https://sun9-70.userapi.com/impg/RsZ9rlUCoU6pO90h0sgph3-ehBBlBntsOOJqGg/grJd1eo_6Tw.jpg?size=799x323&quality=96&proxy=1&sign=33097b1df1a2c82437582e7f3d1577ad)

После чего сохраняем ключём w и выходим (u).
Создадим файловую систему командой `sudo mkfs.ext4 /dev/md0p1`. В результате получаем такой вид:
![](https://sun9-38.userapi.com/impg/HKPkEgXIoNk0guvsBdpmVf9-DVJJ_0K0-gxFMw/OBcDdetjNi8.jpg?size=610x388&quality=96&proxy=1&sign=f9ec48d085fa7b3ef739a89dae037221)

![](https://sun9-11.userapi.com/impg/3PdKfWgOpwxjy7TsQZIMs0gsd9IqDJ3R85ZfDQ/gnXz1ARCUtc.jpg?size=502x419&quality=96&proxy=1&sign=b6f4320f3f2ed24889993dde969b16ad)

## 5. Добавить запись в fstab для монтирования при перезагрузке
Сначала вводим команду `sudo blkid /dev/md0p1` чтобы узнать нужный UUID, после чего редактируем файл fstab - добавим туда строку **UUID=24d17f2f-53d3-4f79-a047-2410aa8d13ed /mnt ext4 defaults 0 0**. 

![](https://sun9-43.userapi.com/impg/DgeGW--3NbMOZrv6nFkR5UE9qPP89HVmNDAm-Q/bkQtUcbUaug.jpg?size=714x107&quality=96&proxy=1&sign=5a372d856302ded10407dfcd231b0251)

после чего выполняем команду mount -a.
