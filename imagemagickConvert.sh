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
 HEAD(){ for (( a=1; a<=27; a++ ))
  do
   TPUT $a 1
        $E "\xE2\x94\x82                                                                              \xE2\x94\x82";
  done
  TPUT 3 2
        $E    "$(tput bold)  Справочник редактирования изображений     $(tput sgr 0)";
  TPUT 4 2
        $E "$(tput setaf 2)  Редактирование утилитой Imagemagick convert $(tput sgr 0)";
 MARK;TPUT 1 2
        $E "  Программа написана на bash tput             " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 27 2
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
 M0(){ TPUT  6 3; $e " Просмотр списка всех шрифтов в системе                                     ";}
 M1(){ TPUT  7 3; $e " Создаём превью для всех картинок в каталоге                                ";}
 M2(){ TPUT  8 3; $e " Добавить текст Flower на картинку                                          ";}
 M3(){ TPUT  9 3; $e " Разместить текст Flower внизу, по центру, добавив прозрачный фон           ";}
 M4(){ TPUT 10 3; $e " Сконвертировать                                                            ";}
 M5(){ TPUT 11 3; $e " Собрать из jpg-файлов gif анимацию                                         ";}
 M6(){ TPUT 12 3; $e " Собрать из jpg-файлов gif-анимацию с задержкой между кадрами в 1.5 секунды ";}
 M7(){ TPUT 13 3; $e " Сделать картинку со словом                                                 ";}
 M8(){ TPUT 14 3; $e " Увеличить картинку                                                         ";}
 M9(){ TPUT 15 3; $e " Изменить размер                                                            ";}
M10(){ TPUT 16 3; $e " Рамка и подпись                                                            ";}
M11(){ TPUT 17 3; $e " Сделать картинку с предложением                                            ";}
M12(){ TPUT 18 3; $e " Сделать картинку с текстом                                                 ";}
M13(){ TPUT 19 3; $e " Пояснения к аргументам                                                     ";}
M14(){ TPUT 20 3; $e " Создать картинку с непрозрачным фоном                                      ";}
M15(){ TPUT 21 3; $e " Наложить изображение поверх другого                                        ";}
M16(){ TPUT 22 3; $e " Наложить эффект                                                            ";}
M17(){ TPUT 23 3; $e " Показать все эффекты в одном файле                                         ";}
M18(){ TPUT 24 3; $e " Показать все опции options                                                 ";}
M19(){ TPUT 25 3; $e " EXIT                                                                       ";}
# далее идет переменная LM=16 позволяющая бегать по списоку.
LM=19
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
 Просмотреть список шрифтов, с которыми может работать imagemagick 
 convert -list Type
 convert -list type
 convert -list Font
 convert -list font
 convert -list font | grep Font
";ES;fi;;
#
        1) S=M1 ;SC;if [[ $cur == enter ]];then R;echo "
for file in *.jpg;  do convert -scale 100 \$file tn_\$file ; done
";ES;fi;;
        2) S=M2 ;SC;if [[ $cur == enter ]];then R;echo "
 convert flower.jpg -font courier -fill white -pointsize 20 -annotate +50+50 'Flower' flower_annotate1.jpg
";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;echo "
 convert tn_zemly.jpg -fill white -box '#00770080' -gravity South -pointsize 20 -annotate +0+5 'Flower' flower_annotate2.jpg
";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;echo " convert file.ai file.jpg";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;echo " convert *.jpg images.gif";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;echo " convert -delay 150 *.jpg images.gif";ES;fi;;
        7) S=M7;SC;if [[ $cur == enter ]];then R;echo "
#!/bin/bash
 convert -background lightblue \\
         -fill blue \\
         -font URW-Palladio-Bold-Italic \\
         -pointsize 72 \\
          label:Text \\
 label.png
";ES;fi;;
#
        8) S=M8;SC;if [[ $cur == enter ]];then R;echo " convert -sample 1000% in.jpg out.jpg";ES;fi;;
        9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
 convert -size 800x600 temporary-image.gif -resize 400x300 resized-image.gif
";ES;fi;;
#
       10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
#!/bin/bash
 convert CiberPank.png \\
 -bordercolor black -border 3   -bordercolor white -border 2 \\
\\( -background black -fill white -pointsize 24 \\
 label:Ubuntu   -trim +repage \\
 -bordercolor black -border 10 \\
\\) -gravity South -append \\
 -bordercolor black -border 10   -gravity South -chop 0x10 \\
 border_framework.png
";ES;fi;;
       11) S=M11;SC;if [[ $cur == enter ]];then R;echo "
#!/bin/bash
 convert -density 96 \\
         -background yellow \\
         -fill black \\
         -pointsize 24 \\
         -font Bookman-Demi label:'Христианство, ислам, буддизм и иудаизм занимают видное место.' \\
 sovety.png
";ES;fi;;
       12) S=M12;SC;if [[ $cur == enter ]];then R;echo "
 #!/bin/bash
  convert -density 96 \\
          -background silver \\
          -size 1280x720 \\
          -gravity center \\
          -fill red \\
          -pointsize 24 \\
          -font Bookman-Demi label:'После вхождения Республики Крым и города Севастополя
 в состав Российской Федерации
 21 марта 2014 года
 был основан девятый федеральный округ Крым.\n
 ' \
 perevod.png
";ES;fi;;
       13) S=M13;SC;if [[ $cur == enter ]];then R;echo "
 --------------------------------------------------------------------------------------------------------
    *** ПАРАМЕТРЫ ***
 ------------+-----------+-------------------------------------------------------------------------------
 -size       | 1280x720  | задаёт размер картинки
 -gravity    | Center    | текст по центру
 -density    |           | задаёт предполагаемое разрешение устройства просмотра (в точках на дюйм),
 -background |           | определяет цвет фона (цвета можно задавать в HTML-формате, например, #aa0000),
 -undercolor | lightblue | цвет фона строки
 -fill       |           | цвет букв,
 -pointsize  |           | размер шрифта,
 -font       |           | собственно используемый шрифт, а label:что-нибудь задаёт сам текст.
";ES;fi;;
       14) S=M14;SC;if [[ $cur == enter ]];then R;echo "
 convert -size 1280x720 xc:'rgba(192, 192, 192, 1.0)' backgroundGray.png
";ES;fi;;
       15) S=M15;SC;if [[ $cur == enter ]];then R;echo " convert -composite -gravity center fonGainsboro.png 1str20.png result.png
";ES;fi;;
       16) S=M16;SC;if [[ $cur == enter ]];then R;echo " convert antitela.jpg fon.png -compose blend -composite output.jpg";ES;fi;;
       17) S=M17;SC;if [[ $cur == enter ]];then R;echo "
#!/bin/bash
 for blend in $(identify -list compose|grep -v Blur ); do 
  convert -label \"\blend\ antitela.jpg fon.png -compose \blend -composite miff:-
 done | montage - -tile 5x result.png
";ES;fi;;
       18) S=M18;SC;if [[ $cur == enter ]];then R;echo "
  -adaptive-blur geometry       adaptively blur pixels; decrease effect near edges
  -adaptive-resize geometry     adaptively resize image with data dependent triangulation.
  -adaptive-sharpen geometry    adaptively sharpen pixels; increase effect near edges
  -adjoin                       join images into a single multi-image file
  -affine matrix                affine transform matrix
  -alpha                        on, activate, off, deactivate, set, opaque, copy, transparent, extract, background, or shape the alpha channel
  -annotate geometry text       annotate the image with text
  -antialias                    remove pixel-aliasing
  -append                       объединение последовательности изображений (+ - справа-налево, - - сверху-вниз)
  -authenticate value           decipher image with this password
  -auto-gamma                   automagically adjust gamma level of image
  -auto-level                   automagically adjust color levels of image
  -auto-orient                  automagically orient image
  -background color             цвет фона
  -bench iterations             measure performance
  -bias value                   add bias when convolving an image
  -black-threshold value        force all pixels below the threshold into black
  -blue-primary point           chromaticity blue primary point
  -blue-shift factor            simulate a scene at nighttime in the moonlight
  -blur geometry                ослабление шума изображения и уровня детализации (Гауссово размытие ?)
  -border geometry              surround image with a border of color
  -bordercolor color            border color
  -brightness-contrast geometry improve brightness / contrast of the image
  -caption string               assign a caption to an image
  -cdl filename                 color correct with a color decision list
  -channel type                 apply option to select image channels
  -charcoal radius              simulate a charcoal drawing
  -chop geometry                remove pixels from the image interior
  -clamp                        set each pixel whose value is below zero to zero and any the pixel whose value is above the quantum range to the quantum range (e.g. 65535) otherwise the pixel value remains unchanged.
  -clip                        clip along the first path from the 8BIM profile
  -clip-mask filename          associate clip mask with the image
  -clip-path id                clip along a named path from the 8BIM profile
  -clone index                 клонирование изображения
  -clut                         apply a color lookup table to the image
  -contrast-stretch geometry   improve the contrast in an image by stretching the range of intensity value
  -coalesce                     merge a sequence of images
-colorize value               colorize the image with the fill color
  -color-matrix matrix         apply color correction to the image.
  -colors value                 preferred number of colors in the image
  -colorspace type              установка цветового пространства изображения
  -combine                      combine a sequence of images
  -comment string               annotate image with comment
  -compare                      compare image
  -compose operator             set image composite operator
  -composite                    composite image
  -compress type                тип сжатия изображения
  -contrast                     enhance or reduce the image contrast
  -convolve coefficients        apply a convolution kernel to the image
  -crop geometry                обрезка изображения
  -cycle amount                 cycle the image colormap
  -decipher filename            convert cipher pixels to plain
  -debug events                display copious debugging information
  -define format:option        define one or more image format options
  -deconstruct                 break down an image sequence into constituent parts
  -delay value                 показ следующего изображения после задержки
  -delete index                 delete the image from the image sequence
  -density geometry             horizontal and vertical density of the image
  -depth value                 разрядность изображения
  -despeckle                    reduce the speckles within an image
  -direction type              render text right-to-left or left-to-right
  -display server              get image or font from this X server
  -dispose method               layer disposal method
  -distribute-cache port        launch a distributed pixel cache server
  -distort type coefficients    distort image
  -dither method               apply error diffusion to image
  -draw string                 annotate the image with a graphic primitive
  -duplicate count,indexes      duplicate an image one or more times
  -edge radius                 apply a filter to detect edges in the image
  -emboss radius                emboss an image
  -encipher filename            convert plain pixels to cipher pixels
  -encoding type                text encoding type
  -endian type                 endianness (MSB or LSB) of the image
  -enhance                      apply a digital filter to enhance a noisy image
  -equalize                     perform histogram equalization to an image
  -evaluate operator value      evaluate an arithmetic, relational, or logical expression
  -evaluate-sequence operator   evaluate an arithmetic, relational, or logical expression for an image sequence
  -extent geometry              установка размера изображения
  -extract geometry             извлечение области из изображения
  -family name                 render text with this font family
  -features distance            analyze image features (e.g. contract, correlations, etc.).
  -fft                         implments the discrete Fourier transform (DFT)
  -fill color                   color to use when filling a graphic primitive
  -filter type                 использовать фильтр когда изменяется размер изображения
  -flatten                      flatten a sequence of images
  -flip                         переворачивание изображения в вертикальной плоскости (отражение по вертикали)
  -floodfill geometry color     floodfill the image with color
  -flop                         переворачивание изображения в горизонтальной плоскости (отражение по горизонтали)
  -font name                    render text with this font
  -format string                output formatted image characteristics
  -frame geometry               surround image with an ornamental border
  -function name                apply a function to the image
  -fuzz distance                colors within this distance are considered equal
  -fx expression                apply mathematical expression to an image channel(s)
  -gamma value                 уровень гамма-коррекции
  -gaussian-blur geometry       reduce image noise and reduce detail levels
  -geometry geometry            preferred size or location of the image
  -gravity type                 horizontal and vertical text placement
  -grayscale method             convert image to grayscale
  -green-primary point         chromaticity green primary point
  -help                         вывод на экран параметров запуска программы
  -identify                     identify the format and characteristics of the image
  -ift                         implements the inverse discrete Fourier transform (DFT)
  -implode amount               implode image pixels about the center
  -insert index                insert last image into the image sequence
  -intensity method            method to generate an intensity value from a pixel
  -intent type                 type of rendering intent when managing the image color
  -interlace type               type of image interlacing scheme
  -interline-spacing value      the space between two text lines
  -interpolate method           pixel color interpolation method
  -interword-spacing value      the space between two words
  -kerning value                the space between two characters
  -label string                 assign a label to an image
  -lat geometry                 local adaptive thresholding
  -layers method                optimize or compare image layers
  -level value                 adjust the level of image contrast
  -limit type value             pixel cache resource limit
  -linear-stretch geometry      linear with saturation histogram stretch
  -liquid-rescale geometry      rescale image with seam-carving
  -list type                    Color, Configure, Delegate, Format, Magic, Module, Resource, or Type
  -log format                   format of debugging information
  -loop iterations              add Netscape loop extension to your GIF animation
  -mask filename                associate a mask with the image
  -mattecolor color             frame color
  -median radius               apply a median filter to the image
  -metric type                 measure differences between images with this metric
  -mode radius                 make each pixel the 'predominant color' of the neighborhood
  -modulate value               vary the brightness, saturation, and hue
  -monitor                      monitor progress
  -monochrome                   transform image to black and white
  -morph value                 morph an image sequence
  -morphology method kernel     apply a morphology method to the image
  -motion-blur geometry         simulate motion blur
  -negate                       замена каждого пиксела изображения противоположным (инвертирование цвета)
  -noise radius                 add or reduce noise in an image
  -normalize                    transform image to span the full range of colors
  -opaque color                 change this color to the fill color
  -ordered-dither NxN           ordered dither the image
  -orient type                 image orientation
  -page geometry                size and location of an image canvas (setting)
  -paint radius                 simulate an oil painting
  -perceptible                 set each pixel whose value is less than |epsilon| to -epsilon or epsilon (whichever is closer) otherwise the pixel value remains unchanged.
  -ping                         efficiently determine image attributes
  -pointsize value              font point size
  -polaroid angle               simulate a Polaroid picture
  -poly terms                   build a polynomial from the image sequence and the corresponding terms (coefficients and degree pairs).
  -posterize levels             reduce the image to a limited number of color levels
  -precision value              set the maximum number of significant digits to be printed
  -preview type                 image preview type
  -print string                 interpret string and print to console
  -process image-filter         process the image with a custom image filter
  -profile filename             add, delete, or apply an image profile
  -quality value                уровень сжатия JPEG/MIFF/PNG (качество изображения)
  -quantize colorspace          reduce image colors in this colorspace
  -quiet                        suppress all warning messages
  -radial-blur angle            radial blur the image
  -raise value                 lighten/darken image edges to create a 3-D effect
  -random-threshold low,high    random threshold the image
  -red-primary point            chromaticity red primary point
  -regard-warnings              pay attention to warning messages.
  -region geometry              apply options to a portion of the image
  -remap filename               transform image colors to match this set of colors
  -render                       render vector graphics
  -repage geometry              size and location of an image canvas
  -resample geometry            change the resolution of an image
  -resize geometry              изменение размеров изображения
  -respect-parentheses         settings remain in effect until parenthesis boundary
  -roll geometry                roll an image vertically or horizontally
  -rotate degrees               вращение изображения
  -sample geometry              scale image with pixel sampling
  -sampling-factor geometry     horizontal and vertical sampling factor
  -scale geometry               масштабирование изображение
  -scene value                 image scene number
  -seed value                  seed a new sequence of pseudo-random numbers
  -segment values              segment an image
  -selective-blur geometry     selectively blur pixels within a contrast threshold
  -separate                    separate an image channel into a grayscale image
  -sepia-tone threshold        simulate a sepia-toned photo
  -set attribute value         set an image attribute
  -shade degrees                shade the image using a distant light source
  -shadow geometry              simulate an image shadow
  -sharpen geometry             sharpen the image
  -shave geometry               shave pixels from the image edges
  -shear geometry               slide one edge of the image along the X or Y axis
  -sigmoidal-contrast geometry  increase the contrast without saturating highlights or shadows
  -smush offset                 smush an image sequence together
  -size geometry                ширина и высота изображения
  -sketch geometry              simulate a pencil sketch
  -solarize threshold           negate all pixels above the threshold level
  -splice geometry              splice the background color into the image
  -spread radius                displace image pixels by a random amount
  -statistic type geometry      replace each pixel with corresponding statistic from the neighborhood
  -strip                        strip image of all profiles and comments
  -stroke color                 graphic primitive stroke color
  -strokewidth value            graphic primitive stroke width
  -stretch type                 render text with this font stretch
  -style type                   render text with this font style
  -swap indexes                 swap two images in the image sequence
  -swirl degrees                swirl image pixels about the center
  -synchronize                 synchronize image to storage device
  -taint                        mark the image as modified
  -texture filename             name of texture to tile onto the image background
  -threshold value              threshold the image
  -thumbnail geometry           create a thumbnail of the image
  -tile filename                tile image when filling a graphic primitive
  -tile-offset geometry         set the image tile offset
  -tint value                   tint the image with the fill color
  -transform                    affine transform image
  -transparent color            make this color transparent within the image
  -transparent-color color      transparent color
  -transpose                    flip image in the vertical direction and rotate 90 degrees
  -transverse                   flop image in the horizontal direction and rotate 270 degrees
  -treedepth value              color tree depth
  -trim                         trim image edges
  -type type                    image type
  -undercolor color             annotation bounding box color
  -unique-colors                discard all but one of any pixel color.
  -units type                   the units of image resolution
  -unsharp geometry             sharpen the image
  -verbose                      print detailed information about the image
  -version                      print version information
  -view                         FlashPix viewing transforms
  -vignette geometry            soften the edges of the image in vignette style
  -virtual-pixel method         access method for pixels outside the boundaries of the image
  -wave geometry               alter an image along a sine wave
  -weight type                 render text with this font weight
  -white-point point            chromaticity white point
  -white-threshold value       force all pixels above the threshold into white
  -write filename              write images to this file
";ES;fi;;
       19) S=M19;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
