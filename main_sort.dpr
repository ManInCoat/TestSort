program main_sort;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,windows,Classes,
  unit_func_sort in 'unit_func_sort.pas',
  unit_service in 'unit_service.pas';
//
var f_name:ansistring=''; //script file
    fd_name:ansistring=''; //dates file
    arw:tars; //Объявлен в unit_service
    ard:tda; //Объявлен в unit_func_sort
    n,n1,n2,lb,rb,rand,np,nc:int32; //np - количество параметров; nc - номер команды
    dmax,ddiv,dsub:int32;
    k_Rpt:uint32=0;
    K_t,n_line:uint32;
    FileError:int32=0; //ошибка при работе с файлом
    f_pos:int32=-1;
    S_list,plan_exp:TStringList;
    str_plan:ansistring;
    plan_line:uint32; //номер строки в плане команд
    plan_pos:int32=-1; //номер строки, где встретилась команда CreateTable
    f_plan:ansistring='';
    sort_name:shortstring='';
    dt:real; //время выполнения
    s:ansistring;
label UseStr;
//
begin
SetConsoleTitle(Pchar('Исследование алгоритмов сортировки'));
Writeln('Для ознакомления введите "Help" или "Help <команда>".');
//
Repeat
Fileerror:=1;
if f_name='' then write('>> ');
try
if f_name='' then readln(s);
if f_name<>'' then if (S_List.Count>n_line) then s:=S_List[n_line]
  else s:='Exit';
UseStr:
if s='' then continue;
arw:=str_to_arr(s); // получаем массив слов
np:=length(arw); // количество слов в массиве
nc:=find_com(ar_com,arw[0]); // получили номер команды
//
//main
case nc of
//Команда помощи
//Help [<Name_com>]
1: begin
  help(ar_com,arw);
  end;
// Вывод элементов массива
// Outm <N1-номер первого элемента> <N2-количество> (<Имя файла>|<``>)')
2: begin
  if not(np in [3,4]) then raise EConvertError.Create('Неправильное количество параметров!');
  n1:=StrToInt(arw[1]);
  n2:=StrToInt(arw[2]);
  if np=3 then fd_name:='' else fd_name:=arw[3];
  out_ar(ard,n1,n2,fd_name);
  end;
//Генерация массива данных
//Genm <N-количество элементов> <Lb-левая граница возможных значений> <Rb-правая граница возможных значений> <Randseed-номер генерируемого массива>
3 :begin
    if np<>5 then raise EConvertError.Create('Неправильное количество параметров!');
      n:=StrToInt(arw[1]);
      lb:=StrToInt(arw[2]);
      rb:=StrToInt(arw[3]);
      rand:=StrToInt(arw[4]);
      ard:=gen_ar(n,lb,rb,rand,f_pos);
      { TODO -cИсследование : Решить, нужна ли проверка на наличие цикла для записи }
      {if (K_t=1) and (rec_t.count=0) then} begin
        rec_t.count:=n;
        rec_t.lown:=lb;
        rec_t.highn:=rb;
        rec_t.rand:=rand;
      end;
  end;
//Выход из программы
//Exit
4: begin
    if f_name<>'' then begin
      f_name:='';
      S_List.Free;
    end
    else break;
  end;
//Выполнить скриптфайл
//Exec <Имя script файла без расширения>
5: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    f_name:=arw[1];
    S_List:=TStringList.Create;
    S_List.LoadFromFile(f_name+'.txt');
    n_line:=0;
    continue;
  end;
//Базовая сортировка вставкой по возрастанию (insert) - вывод времени
//Ins0_u
6: begin
    sort_ins0_u(ard,dt);
    if f_pos<0 then writeln('Сортировка простой вставкой по возрастанию. Time = ',dt:0:3,'ms');
  end;
//Базовая сортировка вставкой по убыванию (insert) - вывод времен
//Ins0_d
7: begin
    sort_ins0_d(ard,dt);
    if f_pos<0 then writeln('Сортировка простой вставкой по убыванию. Time = ',dt:0:3,'ms');
  end;
//Базовая сортировка выбором по возрастанию (selection) - вывод времени
//Sel0
8: begin
    sort_sel0(ard,dt);
    if f_pos<0 then writeln('Сортировка простым выбором по возрастанию. Time = ',dt:0:3,'ms');
  end;
//Базовая сортировка пузырьком по возрастанию (swap) - вывод времени
//Bubble0
9: begin
    sort_bubble0(ard,dt);
    if f_pos<0 then writeln('Базовая сортировка пузырьком по возрастанию. Time = ',dt:0:3,'ms');
  end;
//Сортировка пузырьком с применением процедуры swap - вывод времени
//Bubble1
10: begin
    sort_bubble1(ard,dt);
    if f_pos<0 then writeln('Базовая сортировка пузырьком с применением процедуры swap. Time = ',dt:0:3,'ms');
  end;
//Шейкерная сортировка
//Shaker0
11: begin
    sort_shaker(ard,dt);
    if f_pos<0 then writeln('Шейкерная сортировка. Time = ',dt:0:3,'ms');
  end;
//Классическая Гномья сортировка
//Gnom0
12: begin
    Gnom0(ard,dt);
    if f_pos<0 then writeln('Классическая Гномья сортировка. Time = ',dt:0:3,'ms');
  end;
//Оптимизировання Гномья сортировка
//Gnom1
13: begin
    Gnom1(ard,dt);
    if f_pos<0 then writeln('Оптимизировання Гномья сортировка. Time = ',dt:0:3,'ms');
  end;
//Вывод комментария из скрипт-файла
14: begin
    if f_name<>'' then writeln(s);
  end;
//Шейкерная сортировка с флажком
//Shaker1
15: begin
    shaker_opt(ard,dt);
    if f_pos<0 then writeln('Шейкерная сортировка с флажком. Time = ',dt:0:3,'ms');
  end;
//Сортировка вставкой с бинарным поиском и блочным сдвигом
//Ins_bin_move
16: begin
    ins_bin_move(ard,dt);
    if f_pos<0 then writeln('Сортировка вставкой с бинарным поиском и блочным сдвигом. Time = ',dt:0:3,'ms');
  end;
//Сортировка методом Шелла при k=2
//Shell0
17: begin
    shell0(ard,dt);
    if f_pos<0 then writeln('Сортировка методом Шелла при k=2. Time = ',dt:0:3,'ms');
  end;
//Сортировка методом Шелла при k=3
//Shell1
18: begin
    shell1(ard,dt);
    if f_pos<0 then writeln('Сортировка методом Шелла при k=3. Time = ',dt:0:3,'ms');
  end;
//Сортировка методом Шелла в реализации А. С. Третьякова
//ShellT
19: begin
    shellT(ard,dt);
    if f_pos<0 then writeln('Сортировка методом Шелла в реализации А. С. Третьякова. Time = ',dt:0:3,'ms');
  end;
//Оптимизировання сортировка методом Шелла на основе вставки
//ShellTOpt
20: begin
    shellTOpt(ard,dt);
    if f_pos<0 then writeln('Оптимизировання сортировка методом Шелла на основе вставки. Time = ',dt:0:3,'ms');
  end;
//Сортировка методом Шелла в реализации Кнута
//ShellK
21: begin
    shellK(ard,dt);
    if f_pos<0 then writeln('Сортировка методом Шелла в реализации Кнута. Time = ',dt:0:3,'ms');
  end;
//Сортировка методом Шелла с заданным перебором шага
//ShellRes <dmax-максимальный шаг> <ddiv-делитель шага> <dsub-вычитаемое из шага>
22: begin
    if np<>4 then raise EConvertError.Create('Неправильное количество параметров!');
    dmax:=StrToInt(arw[1]);
    ddiv:=StrToInt(arw[2]);
    dsub:=StrToInt(arw[3]);
    ShellRes(ard,dt,dmax,ddiv,dsub);
    if f_pos<0 then writeln('Сортировка методом Шелла при dmax=',dmax,'. Time = ',dt:0:3,'ms');
  end;
//Команда начала цикла при работе от файла
//Repeat
23: begin
    if f_name='' then raise EConvertError.Create('Поддерживается только в скрипт-файле!');
    K_t:=1;
    init_rec_time(rec_t);
    //Запомнить положение в скрипт-файле
    f_pos:=n_line;
  end;
//Команда закрытия цикла при работе от файла
//Until <K-количество итераций>
24: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    if f_name='' then raise EConvertError.Create('Поддерживается только в скрипт-файле!');
    K_Rpt:=StrToInt(arw[1]);
    if K_Rpt>K_t then begin
      n_line:=f_pos+1;
      inc(K_t);
      continue;
    end
    else begin
      if plan_pos=-1 then writeln('Цикл выполнен ',K_t,' раз!');
      f_pos:=-1;
      OutRecord(rec_t,K_Rpt);
    end;
  end;
//Запомнить временные значения сортировки для набора данных
//AddTime <r|u|d>
25: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    if f_name='' then raise EConvertError.Create('Поддерживается только в скрипт-файле!');
    if not(arw[1][1] in ['r','u','d']) then raise EConvertError.Create('Ошибка в параметре!');
    rec_t.sort_name:=sort_name;
    AddTime(rec_t,dt,arw[1][1]);
  end;
//Начать эксперимент согласно плану в файле
//CreateTable <Имя плана-файла>
26: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    if f_name='' then raise EConvertError.Create('Поддерживается только в скрипт-файле!');
    f_plan:=arw[1];
    plan_exp:=TStringList.Create;
    plan_exp.LoadFromFile(f_plan+'.txt');
    plan_line:=0;
    plan_pos:=n_line+1; //положение команды CreateTable в скрипт-файле + 1
    str_plan:=plan_exp[plan_line]; //строка для подстановки
  end;
//Завершить эксперимент с записью в файл
//EndTable <Имя файла с результатами>
27: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    if f_name='' then raise EConvertError.Create('Поддерживается только в скрипт-файле!');
    f_plan:=arw[1]; //данная переменная уже свободна
    //добавляем строку в plan_exp из записи
    plan_exp[plan_line]:=RecToStr(rec_t);
    if plan_line<(plan_exp.Count-1) then begin
      inc(plan_line);
      str_plan:=plan_exp[plan_line];
      n_line:=plan_pos;
      continue;
    end;
    //записываем результаты из plan_exp
    plan_exp.Insert(0,' N Сортировка         Параметры набора данных         '+'Random        (avg) UP (min)         Down');
    plan_exp.SaveToFile(f_plan+'.txt');
    writeln('Результаты записаны в файл: '+f_plan+'.txt');
    writeln('Рекомендация: открыть файл в блокноте и выбрать Вид->Перенос по словам->Без переноса');
    plan_exp.Free;
    str_plan:='';
    plan_pos:=-1;
  end;
//Использовать строку из файла-плана
//UseStr
28: begin
    s:=str_plan;
    goto UseStr;
  end;
//Классическая Быстрая сортировка
//QSort
29: begin
    QSort_dt(ard,dt);
    if f_pos<0 then writeln('Классическая Быстрая сортировка. Time = ',dt:0:3,'ms');
  end;
//Вывод элементов массива в виде дерева
//OutTree <k-индекс начального элемента>
30: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    OutTree(ard,StrToInt(arw[1]));
  end;
//Просеивание вверх
//SiftUp <i>
31: begin
    if np<>2 then raise EConvertError.Create('Неправильное количество параметров!');
    SiftUp(ard,StrToInt(arw[1]));
  end;
//Построение максимальной кучи
//BuildTree
32: begin
    BuildHeapSiftUp(ard);
  end;
//Построение максимальной кучи с измерением t
//BuildTree_dt
33: begin
    BuildHeapSiftUp_dt(ard,dt);
    if f_pos<0 then writeln('Построение кучи на основе SiftUp. Time = ',dt:0:3,'ms');
  end;
//Просеивание элемента вниз
//SiftDown1
34: begin
    SiftDown1(ard,length(ard));
  end;
//Сортировка кучей с помощью SiftDown1
//HeapSort1
35: begin
    HeapSort1(ard,dt);
    if f_pos<0 then writeln('Сортировка кучей с помощью SiftDown1. Time = ',dt:0:3,'ms');
  end;
//Построение максимальной кучи на основе SiftDown2 с измерением t
//BuildTree2_dt
36: begin
    BuildHeapSiftDown2(ard,dt);
    if f_pos<0 then writeln('Построение кучи на основе SiftDown2. Time = ',dt:0:3,'ms');
  end;
//Сортировка кучей с помощью SiftDown2
//HeapSort2
37: begin
    HeapSort2(ard,dt);
    if f_pos<0 then writeln('Сортировка кучей на основе SiftDown2. Time = ',dt:0:3,'ms');
  end;
//Сортировка подсчётом по возрастанию
//CountSortU
38: begin
    CountSortU(ard,dt,rec_t.lown,rec_t.highn);
    if f_pos<0 then writeln('Сортировка подсчётом по возрастанию. Time = ',dt:0:3,'ms');
  end;
//Сортировка подсчётом по убыванию
//CountSortD
39: begin
    CountSortD(ard,dt,rec_t.lown,rec_t.highn);
    if f_pos<0 then writeln('Сортировка подсчётом по убыванию. Time = ',dt:0:3,'ms');
  end
else raise EConvertError.Create('');
end;
FileError:=0;
except
    on E:ERangeError do writeln('Значение выходит за пределы диапазона!');
    on E:EIntError do writeln('Неправильное значение!');
    on E:EinoutError do begin
      case E.ErrorCode of
      2: writeln('Файл имени ', f_name,' не найден!');
      3: writeln('Файл имени ', f_name,' не найден!');
      123: writeln('Имя файла ', f_name,' не поддерживается в Windows!');
      161: writeln('Имя файла ', f_name,' не поддерживается в Windows!');
      else writeln('Ошибка при работе с файлом! Код ошибки: ', IntToStr(E.ErrorCode));
      end;
      f_name:='';
      FileError:=0;
    end;
    on E:EConvertError do begin
    writeln('Ошибка в команде ',arw[0],'! ',E.Message);
    if f_name<>'' then begin
      Writeln('Проверьте скрипт-файл!');
      f_name:='';
      end;
    end;
    on E:Exception do writeln(E.classname,' ',E.message);
  end;
//При работе от скрипт-файла переходим в интерактивный режим
if FileError=1 then begin
  if f_name<>'' then begin
    S_List.Free;
    plan_exp.Free;
    str_plan:='';
    f_name:='';
  end;
  FileError:=0;
end;
inc(n_line);
sort_name:=arw[0];//имя последней команды
arw:=nil;
Until false;
S_List.Free;
arw:=nil;
ard:=nil;
end.
