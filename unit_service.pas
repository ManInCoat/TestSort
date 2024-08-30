unit unit_service;

interface
uses
  System.SysUtils,
  unit_func_sort;
const ncom=39; //���������� ������
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
    ar_com : tcom=(('Help','������� ������','Help [<�������>]'),
('Outm','����� �������','Outm <N1-����� ������� ��������> <N2-���������� ���������> [<��� �����>]'),
('Genm','��������� ������� ������','Genm <N-���������� ���������> <Lb-����� ������� ��������� ��������> <Rb-������ ������� ��������� ��������> <Randseed-����� ������������� �������>'),
('Exit','����� �� ���������','Exit'),
('Exec','��������� ����������','Exec <��� script ����� ��� ����������>'),
('Ins0_u','������� ���������� �������� �� ����������� (insert) - ����� �������','Ins0_u'),
('Ins0_d','������� ���������� �������� �� �������� (insert) - ����� �������','Ins0_d'),
('Sel0','������� ���������� ������� �� ����������� (selection) - ����� �������','Sel0'),
('Bubble0','������� ���������� ��������� �� ����������� (swap) - ����� �������','Bubble0'),
('Bubble1','���������� ��������� � ����������� ��������� swap - ����� �������','Bubble1'),
('Shaker0','��������� ����������','Shaker0'),
('Gnom0','������������ ������ ����������','Gnom0'),
('Gnom1','��������������� ������ ����������','Gnom1'),
('//','����� ����������� �� ������-�����','// <Text>'),
('Shaker1','��������� ���������� � �������','Shaker1'),
('Insb_move','���������� �������� � �������� ������� � ������� �������','Ins_bin_move'),
('Shell0','���������� ������� ����� ��� k=2','Shell0'),
('Shell1','���������� ������� ����� ��� k=3','Shell1'),
('ShellT','���������� ������� ����� � ���������� �. �. ����������','ShellT'),
('ShellTOpt','��������������� ���������� ������� ����� �� ������ �������','ShellTOpt'),
('ShellK','���������� ������� ����� � ���������� �����','ShellK'),
('ShellRes','���������� ������� ����� � �������� ��������� ����','ShellRes <dmax-������������ ���> <ddiv-�������� ����> <dsub-���������� �� ����>'),
('Repeat','������� ������ ����� ��� ������ �� �����','Repeat'),
('Until','������� �������� ����� ��� ������ �� �����','Until <K-���������� ��������>'),
('AddTime','��������� ��������� �������� ���������� ��� ������ ������','AddTime <r|u|d>'),
('CreateTable','������ ����������� �������� ����� � �����','CreateTable <��� �����-�����>'),
('EndTable','��������� ����������� � ������� � ����','EndTable <��� ����� � ������������>'),
('UseStr','������������ ������ �� �����-�����','UseStr'),
('QSort','������������ ������� ����������','QSort'),
('OutTree','����� ��������� ������� � ���� ������','OutTree <k-������ ���������� ��������>'),
('SiftUp','����������� �����','SiftUp <i>'),
('BuildTree','���������� ������������ ����','BuildTree'),
('BuildTree_dt','���������� ������������ ���� � ���������� t','BuildTree_dt'),
('SiftDown1','����������� �������� ����','SiftDown1'),
('HeapSort1','���������� ����� � ������� SiftDown1','HeapSort1'),
('BuildTree2_dt','���������� ������������ ���� �� ������ SiftDown2 � ���������� t','BuildTree2_dt'),
('HeapSort2','���������� ����� � ������� SiftDown2','HeapSort2'),
('CountSortU','���������� ��������� �� �����������','CountSortU'),
('CountSortD','���������� ��������� �� ��������','CountSortD'));
//����� ���������� ����������
procedure help(ar_com:tcom; arw :tars);
//��������� ������ �� ������ ����
function str_to_arr(s:ansistring):tars;
//����� ������ �������
function find_com(a:tcom;s:ansistring):uint8;
//������� � ���������� �����
procedure ScriptToKb(var ff:textfile; var f_name:ansistring; i:int32=0);
//������������� rec_time
procedure init_rec_time(var r:trec_time);
//����������� ��������� ������������� � ������
//r-��������� ������, u-��������������� ������, d-�������� ������
procedure AddTime(var trec:trec_time; dt:real; c:ansichar);
//���������� ������� ��������, ����� K_Rpt � �������� �����
procedure OutRecord(var trec:trec_time; var k:uint32);
//��������� ������ ��� ������� �� ����������� ������
function RecToStr(trec:trec_time):ansistring;
//����� ��������� ������� � ���� ������
procedure OutTree(const ar:tda; k:uint32);
//
implementation
//����� ���������� ����������
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
    writeln('������ � ���������� ���������� ������� Help!');
    exit;
  end;
  i:=find_com(ar_com,arw[1]);
  if i>0 then Writeln(ar_com[i,2],#10,ar_com[i,3])
    else Writeln('������� "',arw[1],'" �� ����������!');
end;

//��������� ������ �� ������ ����
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

//����� ������ �������
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

//������� � ���������� �����
procedure ScriptToKb(var ff:textfile; var f_name:ansistring; i:int32=0);
begin
  if i=0 then closefile(ff);
  f_name:='';
  assignfile(ff,'');
  reset(ff);
end;

//������������� rec_time
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

//����������� ��������� ������������� � ������
//r-��������� ������, u-��������������� ������, d-�������� ������
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

//���������� ������� ��������, ����� K_Rpt � �������� �����
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

//��������� ������ ��� ������� �� ����������� ������
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

//����� ��������� ������� � ���� ������
procedure OutTree(const ar:tda; k:uint32);
var i,j,n, n1,nlen:uint32;
begin
nlen:=128;
n:=length(ar);
writeln('�������� ������� :');
  for i:=0 to 5 do // ���� �� �������
    begin
    n1:=1 shl i ; // ���-�� ��������� ������ i
    nlen:=nlen div 2 ; // ����� �������� ������� �� ������
    // k - ������ ������� ��-�� i-�� ������
    for j:= k to k+n1-1 do  // ���� �� �������� ��������� i ������
      if j<n then  // ������ �� ������ �� ������� �������
        if j=k then write(ar[j]:(nlen+2))  // ������ ������ 1-�� �������
          else write(ar[j]:(2*nlen))
            else break;   // �������� �����������
    writeln(#10);  // ���������� 2 ������ ��� ������ ������������
    k:=2*k+1; // ������ 1-�� ������� ����. ������
    end;
end;

end.
