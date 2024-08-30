unit unit_service;

interface
uses
  System.SysUtils,
  unit_func_sort;
const ncom=39; //Количество команд
type tcom = array [1..ncom,1..3] of ansistring;
     tars = array of ansistring;
     trec_time=record
       sort_name:shortstring;
       count:uint32;
       lown,highn:int32;
       rand:int32;
       tr_min,tr_avg:real;
       tu_min,tu_avg:real;
       td_min,td_avg:real;
     end;
     {mytype=int32;
     tda=array of mytype;}
var rec_t:trec_time;
    ar_com : tcom=(('Help','Команда помощи','Help [<команда>]'),
('Outm','Вывод массива','Outm <N1-номер первого элемента> <N2-количество элементов> [<Имя файла>]'),
('Genm','Генерация массива данных','Genm <N-количество элементов> <Lb-левая граница возможных значений> <Rb-правая граница возможных значений> <Randseed-номер генерируемого массива>'),
('Exit','Выход из программы','Exit'),
('Exec','Выполнить скриптфайл','Exec <Имя script файла без расширения>'),
('Ins0_u','Базовая сортировка вставкой по возрастанию (insert) - вывод времени','Ins0_u'),
('Ins0_d','Базовая сортировка вставкой по убыванию (insert) - вывод времени','Ins0_d'),
('Sel0','Базовая сортировка выбором по возрастанию (selection) - вывод времени','Sel0'),
('Bubble0','Базовая сортировка пузырьком по возрастанию (swap) - вывод времени','Bubble0'),
('Bubble1','Сортировка пузырьком с применением процедуры swap - вывод времени','Bubble1'),
('Shaker0','Шейкерная сортировка','Shaker0'),
('Gnom0','Классическая Гномья сортировка','Gnom0'),
('Gnom1','Оптимизировання Гномья сортировка','Gnom1'),
('//','Вывод комментария из скрипт-файла','// <Text>'),
('Shaker1','Шейкерная сортировка с флажком','Shaker1'),
('Insb_move','Сортировка вставкой с бинарным поиском и блочным сдвигом','Ins_bin_move'),
('Shell0','Сортировка методом Шелла при k=2','Shell0'),
('Shell1','Сортировка методом Шелла при k=3','Shell1'),
('ShellT','Сортировка методом Шелла в реализации А. С. Третьякова','ShellT'),
('ShellTOpt','Оптимизировання сортировка методом Шелла на основе вставки','ShellTOpt'),
('ShellK','Сортировка методом Шелла в реализации Кнута','ShellK'),
('ShellRes','Сортировка методом Шелла с заданным перебором шага','ShellRes <dmax-максимальный шаг> <ddiv-делитель шага> <dsub-вычитаемое из шага>'),
('Repeat','Команда начала цикла при работе от файла','Repeat'),
('Until','Команда закрытия цикла при работе от файла','Until <K-количество итераций>'),
('AddTime','Запомнить временные значения сортировки для набора данных','AddTime <r|u|d>'),
('CreateTable','Начать эксперимент согласно плану в файле','CreateTable <Имя плана-файла>'),
('EndTable','Завершить эксперимент с записью в файл','EndTable <Имя файла с результатами>'),
('UseStr','Использовать строку из файла-плана','UseStr'),
('QSort','Классическая Быстрая сортировка','QSort'),
('OutTree','Вывод элементов массива в виде дерева','OutTree <k-индекс начального элемента>'),
('SiftUp','Просеивание вверх','SiftUp <i>'),
('BuildTree','Построение максимальной кучи','BuildTree'),
('BuildTree_dt','Построение максимальной кучи с измерением t','BuildTree_dt'),
('SiftDown1','Просеивание элемента вниз','SiftDown1'),
('HeapSort1','Сортировка кучей с помощью SiftDown1','HeapSort1'),
('BuildTree2_dt','Построение максимальной кучи на основе SiftDown2 с измерением t','BuildTree2_dt'),
('HeapSort2','Сортировка кучей с помощью SiftDown2','HeapSort2'),
('CountSortU','Сортировка подсчётом по возрастанию','CountSortU'),
('CountSortD','Сортировка подсчётом по убыванию','CountSortD'));
//Вывод справочной информации
procedure help(ar_com:tcom; arw :tars);
//Разбивает строку на массив слов
function str_to_arr(s:ansistring):tars;
//Поиск номера команды
function find_com(a:tcom;s:ansistring):uint8;
//Перевод в консольный режим
procedure ScriptToKb(var ff:textfile; var f_name:ansistring; i:int32=0);
//Инициализация rec_time
procedure init_rec_time(var r:trec_time);
//Запоминание временных характеристик в записи
//r-рандомные данные, u-отсортированные данные, d-обратные данные
procedure AddTime(var trec:trec_time; dt:real; c:ansichar);
//Вычисление средних значений, сброс K_Rpt и красивый вывод
procedure OutRecord(var trec:trec_time; var k:uint32);
//Получение строки для таблицы из заполненной записи
function RecToStr(trec:trec_time):ansistring;
//Вывод элементов массива в виде дерева
procedure OutTree(const ar:tda; k:uint32);
//
implementation
//Вывод справочной информации
procedure help(ar_com:tcom; arw :tars);
var i,n:uint8;
begin
  n:=length(arw);
  if n=1 then begin
      for i := 1 to length(ar_com) do
        if ar_com[i,1]<>'' then Writeln(ar_com[i,1],'   ',ar_com[i,2]);
      exit;
  end;
  if n>2 then begin
    writeln('Ошибка в количестве параметров команды Help!');
    exit;
  end;
  i:=find_com(ar_com,arw[1]);
  if i>0 then Writeln(ar_com[i,2],#10,ar_com[i,3])
    else Writeln('Команды "',arw[1],'" не существует!');
end;

//Разбивает строку на массив слов
function str_to_arr(s:ansistring):tars;
var i:uint8;
    str_el:ansistring;
begin
result:=nil;
str_el:='';
for i:= 1 to length(s) do
  if s[i]<>' ' then str_el:=str_el+s[i]
  else if str_el<>'' then begin
    result:=result+[str_el];
    str_el:='';
  end;
result:=result+[str_el];
end;

//Поиск номера команды
function find_com(a:tcom;s:ansistring):uint8;
var i:uint8;
begin
  result:=0;
  if s='' then exit;
  for i := 1 to length(a) do
    if s=a[i,1] then begin
    result:=i;
    break;
    end;
end;

//Перевод в консольный режим
procedure ScriptToKb(var ff:textfile; var f_name:ansistring; i:int32=0);
begin
  if i=0 then closefile(ff);
  f_name:='';
  assignfile(ff,'');
  reset(ff);
end;

//Инициализация rec_time
procedure init_rec_time(var r:trec_time);
begin
  with r do begin
    sort_name:='';
    count:=0;
    lown:=0;
    highn:=0;
    rand:=0;
    tr_min:=0.0;
    tr_avg:=0.0;
    tu_min:=0.0;
    tu_avg:=0.0;
    td_min:=0.0;
    td_avg:=0.0;
  end;
end;

//Запоминание временных характеристик в записи
//r-рандомные данные, u-отсортированные данные, d-обратные данные
procedure AddTime(var trec:trec_time; dt:real; c:ansichar);
begin
  with trec do
    case c of
    'r': begin
        if (dt<tr_min) or (tr_min=0.0) then tr_min:=dt;
        tr_avg:=tr_avg+dt;
      end;
    'u': begin
        if (dt<tu_min) or (tu_min=0.0) then tu_min:=dt;
        tu_avg:=tu_avg+dt;
      end;
    'd': begin
        if (dt<td_min) or (td_min=0.0) then td_min:=dt;
        td_avg:=td_avg+dt;
      end;
    end;
end;

//Вычисление средних значений, сброс K_Rpt и красивый вывод
procedure OutRecord(var trec:trec_time; var k:uint32);
var s:string;
begin
  with trec do begin
    tr_avg:=tr_avg/K;
    tu_avg:=tu_avg/K;
    td_avg:=td_avg/K;
    sort_name:=IntToStr(k)+' '+sort_name;
    k:=0;
    s:=inttostr(count)+' '+inttostr(lown)+' '+inttostr(highn)+' '+ inttostr(rand);
    writeln(sort_name);
    writeln(s,' ':(20-length(s)),'r_avg=',tr_avg:0:3,' r_min=',tr_min:0:3,'  u_avg=',tu_avg:0:3,' u_min=',tu_min:0:3,'  d_avg=',td_avg:0:3,' d_min=',td_min:0:3);
  end;
end;

//Получение строки для таблицы из заполненной записи
function RecToStr(trec:trec_time):ansistring;
var len:uint8;
begin
  with trec do begin
    len:=length(sort_name);
    result:=sort_name+StringOfChar(' ',16-len);
    result:=result+Format('%10d %5d %6d %5d',[count,lown,highn,rand]);
    result:=result+Format('%10.3f%8.3f%10.3f%8.3f%10.3f%8.3f',[tr_avg,tr_min,tu_avg,tu_min,td_avg,td_min]);
  end;
end;

//Вывод элементов массива в виде дерева
procedure OutTree(const ar:tda; k:uint32);
var i,j,n, n1,nlen:uint32;
begin
nlen:=128;
n:=length(ar);
writeln('Элементы массива :');
  for i:=0 to 5 do // цикл по уровням
    begin
    n1:=1 shl i ; // кол-во элементов уровня i
    nlen:=nlen div 2 ; // длина базового отрезка на экране
    // k - индекс первого эл-та i-го уровня
    for j:= k to k+n1-1 do  // цикл по индексам элементов i уровня
      if j<n then  // защита от выхода за пределы массива
        if j=k then write(ar[j]:(nlen+2))  // формат вывода 1-го элемета
          else write(ar[j]:(2*nlen))
            else break;   // элементы закончились
    writeln(#10);  // пропускаем 2 строки для лучшей визуализации
    k:=2*k+1; // индекс 1-го элемета след. уровня
    end;
end;

end.
