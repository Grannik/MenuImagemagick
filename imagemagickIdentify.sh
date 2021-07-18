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
MARK(){ $e "\e[90m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
# R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";}; # в этом варианте закрашивается весь фон терминала
# R(){ CLEAR ;stty sane;$e "\ec\e[0;45m\e[";};   # в этом варианте закрашивается только фон меню
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 HEAD(){ for (( a=1; a<=14; a++ ))
  do
   TPUT $a 1
        $E "\xE2\x94\x82                                               \xE2\x94\x82";
  done
  TPUT 3 2
        $E    "$(tput bold)  Справочник редактирования изображений     $(tput sgr 0)";
  TPUT 4 2
        $E "$(tput setaf 2)  Редактирование утилитой Imagemagick identify $(tput sgr 0)";
  TPUT 13 2
        $E "$(tput setaf 2)  Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter                  $(tput sgr 0)";
 MARK;TPUT 1 2
        $E "  Программа написана на bash tput             " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 14 2
        $E "  Grannik | 2021.07.10 | ©             ";UNMARK;}
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
 M0(){ TPUT  6 3; $e " Получение информации об изображении     ";}
 M1(){ TPUT  7 3; $e " Показать размер изображения             ";}
 M2(){ TPUT  8 3; $e " Просмотреть доступные режимы смешивания ";}
 M3(){ TPUT  9 3; $e " Пoдробная информация о изображении      ";}
 M4(){ TPUT 10 3; $e " Разрешение                              ";}
 M5(){ TPUT 11 3; $e " EXIT                                    ";}
# далее идет переменная LM=16 позволяющая бегать по списоку.
LM=5
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
 identify image.jpg
 или
 identify -ping image.jpg
";ES;fi;;
        1) S=M1 ;SC;if [[ $cur == enter ]];then R;echo "
 identify -format \"%wx%h\" image.jpg
или
 identify -ping -format '%w %h' image.jpg
или
 identify -verbose zemly.jpg | grep -E '(Geometry:)'
";ES;fi;;
        2) S=M2 ;SC;if [[ $cur == enter ]];then R;echo "
 identify -list compose
";ES;fi;;
        3) S=M3 ;SC;if [[ $cur == enter ]];then R;echo "
 identify -verbose image.jpg
";ES;fi;;
        4) S=M4 ;SC;if [[ $cur == enter ]];then R;echo "
 identify -verbose zemly.jpg | grep -E '(Resolution:)'
";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
