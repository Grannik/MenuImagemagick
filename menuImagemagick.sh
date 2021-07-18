#!/bin/bash

 E='echo -e';    # -e включить поддержку вывода Escape последовательностей
 e='echo -en';   # -n не выводить перевод строки
 trap "R;exit" 2 # 
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
# 25 возможно это 
  CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
MARK(){ $e "\e[93m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
# R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";}; # в этом варианте закрашивается весь фон терминала
# R(){ CLEAR ;stty sane;$e "\ec\e[0;45m\e[";};   # в этом варианте закрашивается только фон меню
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 HEAD(){ for (( a=2; a<=23; a++ ))
  do
   TPUT $a 1
        $E "\xE2\x94\x82                                                               \xE2\x94\x82";
  done
  TPUT 3 2
        $E    "$(tput bold)  Справочник редактирования изображений     $(tput sgr 0)";
  TPUT 4 2
        $E "$(tput setaf 2)  Редактирование утилитой Imagemagick (Магия изображений) $(tput sgr 0)";
  TPUT 21 2
        $E "$(tput setaf 2)  Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter                  $(tput sgr 0)";
  FOOT(){ MARK;TPUT 22 2
        $E "  Grannik | 2021.07.15 | ©             ";UNMARK;}
  TPUT 1 1
        $E "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+";
  TPUT 23 1
        $E "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+";
 MARK;TPUT 2 2
        $E "  Программа написана на bash tput             " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
# 4 и далее это отступ сверху и 48 это расстояние слева
 M0(){ TPUT  6 3; $e " Официальный сайт                                 site      |";}
 M1(){ TPUT  7 3; $e " Установка и удаление                             install   |";}
 M2(){ TPUT  8 3; $e " Показать информацию о изображении              | identify  |";}
 M3(){ TPUT  9 3; $e " Позволяет сделать screenshot экрана            | import    |";}
 M4(){ TPUT 10 3; $e " Вывести изображение на экран                   | display   |";}
 M5(){ TPUT 11 3; $e " Вывести анимированное изображение на экран     | animate   |";}
 M6(){ TPUT 12 3; $e " Конвертирование с сохранения исходного файла   | convert   |";}
 M7(){ TPUT 13 3; $e " Конвертирование без сохранения исходного файла | mogrify   |";}
 M8(){ TPUT 14 3; $e " Разницa между изображением и модификацией      | compare   |";}
 M9(){ TPUT 15 3; $e " Composite                                      | composite |";}
M10(){ TPUT 16 3; $e " Монтаж файлов                                  | montage   |";}
M11(){ TPUT 17 3; $e " Conjure                                        | conjure   |";}
M12(){ TPUT 18 3; $e " Stream                                         | stream    |";}
M13(){ TPUT 19 3; $e " EXIT                                                       |";}
# далее идет переменная LM=16 позволяющая бегать по списоку.
LM=13
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
# Здесь необходимо следить за двумя перепенными 0) и S=M0 Они должны совпадать между собой и переменной списка M0().
        0) S=M0 ;SC;if [[ $cur == enter ]];then R;echo "
#
 https://imagemagick.org/
#
 Официальное руководство (на английском)
 http://www.imagemagick.org/script/command-line-tools.php
#
 Список примеров
 https://legacy.imagemagick.org/Usage/text/#label
#
 ImageMagick v6 Examples --Text to Image Handling | Примеры ImageMagick v6 - Текст для обработки изображений
 https://legacy.imagemagick.org/Usage/text/#label_bestfit
 ";ES;fi;;
        1) S=M1 ;SC;if [[ $cur == enter ]];then R;echo "
 Установка:                          | Удаление:
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 sudo apt update                     | sudo apt-get remove imagemagick
 sudo apt-get install imagemagick    |
 sudo apt-get -y install imagemagick |
";ES;fi;;
        2) S=M2 ;SC;if [[ $cur == enter ]];then R;./imagemagickIdentify.sh;ES;fi;;
        3) S=M3 ;SC;if [[ $cur == enter ]];then R;echo "
 import screen.png
";ES;fi;;
        4) S=M4 ;SC;if [[ $cur == enter ]];then R;echo "
 display image.jpg           | просмотр файла
 display -update 1 image.jpg | просмотр файла и перерисовка его при изменении через 1 сек
 display \"vid:*.jpg\"         | просмотр графических файлов в виде визуального каталога
";ES;fi;;
        5) S=M5 ;SC;if [[ $cur == enter ]];then R;echo "
 animate images.gif
";ES;fi;;
        6) S=M6 ;SC;if [[ $cur == enter ]];then R;./imagemagickConvert.sh;ES;fi;;
        7) S=M7 ;SC;if [[ $cur == enter ]];then R;./imagemagickMogrify.sh;ES;fi;;
        8) S=M8;SC;if [[ $cur == enter ]];then R;echo "
 compare - разницa между изображением и модификацией
";ES;fi;;
        9) S=M9;SC;if [[ $cur == enter ]];then R;echo " composite";ES;fi;;
       10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
 Собрать из картинок {1,2,3}.png один файл,
 добавляя к отступам по 4 пикселя и располагая их в две колонки
 montage -geometry +4+4 -tile 2 1.png 2.png 3.png out.png
";ES;fi;;
       11) S=M11;SC;if [[ $cur == enter ]];then R;echo " conjure";ES;fi;;
       12) S=M12;SC;if [[ $cur == enter ]];then R;echo " stream";ES;fi;;
       13) S=M13;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
