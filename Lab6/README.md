# Домашнее задание №6. Поставка ПО
## Задание 
Создать свой RPM пакет (можно взять свое приложение, либо собрать, например, nginx с определенными опциями);
Создать свой репозиторий и разместить там ранее собранный RPM.
## 1. Создание своего RPM пакета.
Сначала установим необходимые компоненты командой `yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils`
Результат:

```bash
Loading mirror speeds from cached hostfile
 * base: mirror.axelname.ru
 * centos-sclo-rh: mirror.logol.ru
 * epel: ftp.lysator.liu.se
 * extras: mirror.logol.ru
 * updates: mirror.corbina.net
Пакет wget-1.14-18.el7_6.1.x86_64 уже установлен, и это последняя версия.
Пакет createrepo-0.9.9-28.el7.noarch уже установлен, и это последняя версия.
Пакет yum-utils-1.1.31-54.el7_8.noarch уже установлен, и это последняя версия.
...
Downloading packages:
(1/4): redhat-lsb-core-4.1-27.el7.centos.1.x86_64.rpm                                                                                                                                       |  38 kB  00:00:00     
(2/4): rpmdevtools-8.3-8.el7_9.noarch.rpm                                                                                                                                                   |  97 kB  00:00:00     
(3/4): redhat-lsb-submod-security-4.1-27.el7.centos.1.x86_64.rpm                                                                                                                            |  15 kB  00:00:00     
(4/4): spax-1.5.2-13.el7.x86_64.rpm                                                                                                                                                         | 260 kB  00:00:00
...
Установлено:
  redhat-lsb-core.x86_64 0:4.1-27.el7.centos.1                                                                   rpmdevtools.noarch 0:8.3-8.el7_9                               
Установлены зависимости:
  redhat-lsb-submod-security.x86_64 0:4.1-27.el7.centos.1                                                                spax.x86_64 0:1.5.2-13.el7                            
Обновлено:
  rpm-build.x86_64 0:4.11.3-45.el7                                                                                                                                  
Обновлены зависимости:
  rpm.x86_64 0:4.11.3-45.el7          rpm-build-libs.x86_64 0:4.11.3-45.el7          rpm-libs.x86_64 0:4.11.3-45.el7          rpm-python.x86_64 0:4.11.3-45.el7          rpm-sign.x86_64 0:4.11.3-45.el7 
```
Далее переключимся на root(для удобства) и установим пакет с источником с оффициального сайта nginx командой `wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-2.el7.ngx.src.rpm` Распакуем его (`rpm -i nginx-1.18.0-2.el7.ngx.src.rpm`). В результате у нас будет source пакет nginx:

```bash
sudo wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-2.el7.ngx.src.rpm
--2020-12-21 00:34:39--  https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-2.el7.ngx.src.rpm
Распознаётся nginx.org (nginx.org)... 3.125.197.172, 52.58.199.22, 2a05:d014:edb:5702::6, ...
Подключение к nginx.org (nginx.org)|3.125.197.172|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 1055846 (1,0M) [application/x-redhat-package-manager]
Сохранение в: «nginx-1.18.0-2.el7.ngx.src.rpm»
100%[=========================================================================================================================================================================>] 1 055 846   2,67MB/s   за 0,4s   
2020-12-21 00:34:39 (2,67 MB/s) - «nginx-1.18.0-2.el7.ngx.src.rpm» сохранён [1055846/1055846]
[root@localhost ~]$ ls -l | grep nginx
-rw-r--r--. 1 root          root          1055846 окт 29 18:35 nginx-1.18.0-2.el7.ngx.src.rpm
```
Произведём те же команды для **OpenSSL** (`wget https://www.openssl.org/source/latest.tar.gz` + `tar -xvf latest.tar.gz`):

```bash
[root@localhost ~]$ wget https://www.openssl.org/source/latest.tar.gz
--2020-12-21 02:09:41--  https://www.openssl.org/source/latest.tar.gz
Распознаётся www.openssl.org (www.openssl.org)... 2a02:26f0:1200:3b4::c1e, 2a02:26f0:1200:39f::c1e
Подключение к www.openssl.org (www.openssl.org)|2a02:26f0:1200:3b4::c1e|:443... ошибка: Сеть недоступна.
Подключение к www.openssl.org (www.openssl.org)|2a02:26f0:1200:39f::c1e|:443... ошибка: Сеть недоступна.
[root@localhost ~]$ sudo wget https://www.openssl.org/source/latest.tar.gz
--2020-12-21 02:09:51--  https://www.openssl.org/source/latest.tar.gz
Распознаётся www.openssl.org (www.openssl.org)... 23.13.40.208, 2a02:26f0:1200:3b4::c1e, 2a02:26f0:1200:39f::c1e
Подключение к www.openssl.org (www.openssl.org)|23.13.40.208|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 302 Moved Temporarily
Адрес: https://www.openssl.org/source/openssl-1.1.1i.tar.gz [переход]
--2020-12-21 02:09:52--  https://www.openssl.org/source/openssl-1.1.1i.tar.gz
Повторное использование соединения с www.openssl.org:443.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 9808346 (9,4M) [application/x-gzip]
Сохранение в: «latest.tar.gz»

100%[=========================================================================================================================================================================>] 9 808 346   10,2MB/s   за 0,9s   

2020-12-21 02:09:53 (10,2 MB/s) - «latest.tar.gz» сохранён [9808346/9808346]

[root@localhost ~]$ tar -xvf latest.tar.gz
openssl-1.1.1i/
openssl-1.1.1i/ACKNOWLEDGEMENTS
openssl-1.1.1i/AUTHORS
...
openssl-1.1.1i/util/shlib_wrap.sh.in
openssl-1.1.1i/util/su-filter.pl
openssl-1.1.1i/util/unlocal_shlib.com.in
[root@localhost ~]$ ls | grep latest
latest.tar.gz
```
После чего выполним команду `yum-builddep rpmbuild/SPECS/nginx.spec`:

```
Установлено:
  openssl-devel.x86_64 1:1.0.2k-21.el7_9                                    pcre-devel.x86_64 0:8.32-17.el7                                    zlib-devel.x86_64 0:1.2.7-18.el7                                   

Установлены зависимости:
  keyutils-libs-devel.x86_64 0:1.5.8-3.el7     krb5-devel.x86_64 0:1.15.1-50.el7     libcom_err-devel.x86_64 0:1.42.9-19.el7     libselinux-devel.x86_64 0:2.5-15.el7     libsepol-devel.x86_64 0:2.5-10.el7    
  libverto-devel.x86_64 0:0.2.5-4.el7         

Обновлены зависимости:
  e2fsprogs.x86_64 0:1.42.9-19.el7       e2fsprogs-libs.x86_64 0:1.42.9-19.el7       krb5-libs.x86_64 0:1.15.1-50.el7       krb5-workstation.x86_64 0:1.15.1-50.el7       libcom_err.x86_64 0:1.42.9-19.el7      
  libkadm5.x86_64 0:1.15.1-50.el7        libss.x86_64 0:1.42.9-19.el7                openssl.x86_64 1:1.0.2k-21.el7_9       openssl-libs.x86_64 1:1.0.2k-21.el7_9        

Выполнено!
```
Поправим файл `sudo vim rpmbuild/SPECS/nginx.spec`:

```bash
[root@localhost ~]# sudo yum install gcc
Загружены модули: fastestmirror, langpacks, product-id, search-disabled-repos, subscription-manager
This system is not registered with an entitlement server. You can use subscription-manager to register.
Loading mirror speeds from cached hostfile
 * base: mirror.axelname.ru
 * centos-sclo-rh: mirror.logol.ru
 * epel: ftp.lysator.liu.se
 * extras: mirror.logol.ru
 * updates: mirror.corbina.net
Разрешение зависимостей
...
Обновлено:
  gcc.x86_64 0:4.8.5-44.el7                                                                                                                    
Обновлены зависимости:
  cpp.x86_64 0:4.8.5-44.el7            gcc-c++.x86_64 0:4.8.5-44.el7            gcc-gfortran.x86_64 0:4.8.5-44.el7             libgcc.x86_64 0:4.8.5-44.el7           libgfortran.x86_64 0:4.8.5-44.el7           
  libgomp.x86_64 0:4.8.5-44.el7        libquadmath.x86_64 0:4.8.5-44.el7        libquadmath-devel.x86_64 0:4.8.5-44.el7        libstdc++.x86_64 0:4.8.5-44.el7        libstdc++-devel.x86_64 0:4.8.5-44.el7       
Выполнено!
```
И выполняем непосредственно упаковку командой `rpmbuild -bb rpmbuild/SPECS/nginx.spec`:

```
[root@localhost ~]# rpmbuild -bb rpmbuild/SPECS/nginx.spec
Выполняется(%prep): /bin/sh -e /var/tmp/rpm-tmp.OmVqti
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd /root/rpmbuild/BUILD
+ rm -rf nginx-1.18.0
+ /usr/bin/gzip -dc /root/rpmbuild/SOURCES/nginx-1.18.0.tar.gz
...
Записан: /root/rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm
Записан: /root/rpmbuild/RPMS/x86_64/nginx-debuginfo-1.18.0-2.el7.ngx.x86_64.rpm
Выполняется(%clean): /bin/sh -e /var/tmp/rpm-tmp.OUatwG
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd nginx-1.18.0
+ /usr/bin/rm -rf /root/rpmbuild/BUILDROOT/nginx-1.18.0-2.el7.ngx.x86_64
+ exit 0
[root@localhost ~]# 
```
Проверим что пакет собран `ls -la rpmbuild/RPMS/x86_64/`:

```bash
[root@localhost ~]# ls -la rpmbuild/RPMS/x86_64/
итого 2516
drwxr-xr-x. 2 root root      98 дек 21 02:54 .
drwxr-xr-x. 3 root root      20 дек 21 02:54 ..
-rw-r--r--. 1 root root  786404 дек 21 02:54 nginx-1.18.0-2.el7.ngx.x86_64.rpm
-rw-r--r--. 1 root root 1789388 дек 21 02:54 nginx-debuginfo-1.18.0-2.el7.ngx.x86_64.rpm
```
Установим свежесобранный пакет `yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm`:

```bash
[root@localhost ~]# yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm
Загружены модули: fastestmirror, langpacks, product-id, search-disabled-repos, subscription-manager
Проверка rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm: 1:nginx-1.18.0-2.el7.ngx.x86_64
rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm отмечен как обновление для 1:nginx-1.16.1-2.el7.x86_64
Разрешение зависимостей
--> Проверка сценария
---> Пакет nginx.x86_64 1:1.16.1-2.el7 помечен для обновления
---> Пакет nginx.x86_64 1:1.18.0-2.el7.ngx помечен как обновление
--> Проверка зависимостей окончена
Зависимости определены
==============================================================================================================================================================================
 Package                                  Архитектура                               Версия                                                 Репозиторий                                                       Размер
==============================================================================================================================================================================
Обновление:
 nginx                                    x86_64                                    1:1.18.0-2.el7.ngx                                     /nginx-1.18.0-2.el7.ngx.x86_64                                    2.7 M
Итого за операцию
==============================================================================================================================================================================
Обновить  1 пакет
Общий размер: 2.7 M
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Обновление  : 1:nginx-1.18.0-2.el7.ngx.x86_64                                                                                                                                                                1/2 
предупреждение: /etc/nginx/nginx.conf создан как /etc/nginx/nginx.conf.rpmnew
  Очистка     : 1:nginx-1.16.1-2.el7.x86_64                                                                                                                                                                    2/2 
  Проверка    : 1:nginx-1.18.0-2.el7.ngx.x86_64                                                                                                                                                                1/2 
  Проверка    : 1:nginx-1.16.1-2.el7.x86_64                                                                                                                                                                    2/2 
Обновлено:
  nginx.x86_64 1:1.18.0-2.el7.ngx                                                                                                                                             
Выполнено!
[root@localhost ~]# 
```
## 2. Создать свой репозиторий и загрузить туда rpm пакет.
Создадим папку `mkdir /usr/share/nginx/html/repo` и скопируем туда пакеты `cp rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/` `wget https://repo.percona.com/centos/7Server/RPMS/noarch/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm`:

```bash
[root@localhost ~]# mkdir /usr/share/nginx/html/repo
[root@localhost ~]# cp rpmbuild/RPMS/x86_64/nginx-1.18.0-2.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
[root@localhost ~]# wget https://repo.percona.com/centos/7Server/RPMS/noarch/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm
--2020-12-21 03:51:29--  https://repo.percona.com/centos/7Server/RPMS/noarch/percona-release-1.0-9.noarch.rpm
Распознаётся repo.percona.com (repo.percona.com)... 157.245.68.135
Подключение к repo.percona.com (repo.percona.com)|157.245.68.135|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: нет данных [application/x-redhat-package-manager]
Сохранение в: «/usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm»
    [ <=>                                                                                                                                                                      ] 16 664      --.-K/s   за 0s      
2020-12-21 03:51:33 (175 MB/s) - «/usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm» сохранён [16664]
[root@localhost ~]# 
```
После этого инициализируем репозиторий `createrepo /usr/share/nginx/html/repo/`:

```bash
[root@localhost ~]# createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 1 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
[root@localhost ~]#
```
Добавим автоиндексирование в файл nginx.conf:

```bash
location / {
            proxy_pass https://services;
            proxy_set_header Host $host;
            autoindex on;
}
```

тестируем:

```bash
sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
service nginx reload
```
Добавляем репозиторий и проверяем:

```bash
 cat >> /etc/yum.repos.d/lab.repo << EOF
[lab]
name=lab-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
[root@localhost ~]# yum repolist enabled | grep lab
lab                         lab-linux
```
Наконец переустановим nginx `yum reinstall nginx`:

```bash
yum reinstall nginx
...
Downloading packages:
nginx-1.18.0-2.el7.ngx.x86_64.rpm                                                                                                                          | 2.1 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 1:nginx-1.18.0-2.el7.ngx.x86_64                                                                                                                                            1/1 
  Verifying  : 1:nginx-1.18.0-2.el7.ngx.x86_64                                                                                                                                            1/1 
Installed:
  nginx.x86_64 1:1.18.0-2.el7.ngx                                                                                                                             
Complete!
```
