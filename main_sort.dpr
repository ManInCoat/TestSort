program main_sort;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,windows,Classes,
  unit_func_sort in 'unit_func_sort.pas',
  unit_service in 'unit_service.pas';
//
var f_name:ansistring=''; //script file
    fd_name:ansistring=''; //dates file
    arw:tars; //�������� � unit_service
    ard:tda; //�������� � unit_func_sort
    n,n1,n2,lb,rb,rand,np,nc:int32; //np - ���������� ����������; nc - ����� �������
    dmax,ddiv,dsub:int32;
    k_Rpt:uint32=0;
    K_t,n_line:uint32;
    FileError:int32=0; //������ ��� ������ � ������
    f_pos:int32=-1;
    S_list,plan_exp:TStringList;
    str_plan:ansistring;
    plan_line:uint32; //����� ������ � ����� ������
    plan_pos:int32=-1; //����� ������, ��� ����������� ������� CreateTable
    f_plan:ansistring='';
    sort_name:shortstring='';
    dt:real; //����� ����������
    s:ansistring;
label UseStr;
//
begin
SetConsoleTitle(Pchar('������������ ���������� ����������'));
Writeln('��� ������������ ������� "Help" ��� "Help <�������>".');
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
arw:=str_to_arr(s); // �������� ������ ����
np:=length(arw); // ���������� ���� � �������
nc:=find_com(ar_com,arw[0]); // �������� ����� �������
//
//main
case nc of
//������� ������
//Help [<Name_com>]
1: begin
  help(ar_com,arw);
  end;
// ����� ��������� �������
// Outm <N1-����� ������� ��������> <N2-����������> (<��� �����>|<``>)')
2: begin
  if not(np in [3,4]) then raise EConvertError.Create('������������ ���������� ����������!');
  n1:=StrToInt(arw[1]);
  n2:=StrToInt(arw[2]);
  if np=3 then fd_name:='' else fd_name:=arw[3];
  out_ar(ard,n1,n2,fd_name);
  end;
//��������� ������� ������
//Genm <N-���������� ���������> <Lb-����� ������� ��������� ��������> <Rb-������ ������� ��������� ��������> <Randseed-����� ������������� �������>
3 :begin
    if np<>5 then raise EConvertError.Create('������������ ���������� ����������!');
      n:=StrToInt(arw[1]);
      lb:=StrToInt(arw[2]);
      rb:=StrToInt(arw[3]);
      rand:=StrToInt(arw[4]);
      ard:=gen_ar(n,lb,rb,rand,f_pos);
      { TODO -c������������ : ������, ����� �� �������� �� ������� ����� ��� ������ }
      {if (K_t=1) and (rec_t.count=0) then} begin
        rec_t.count:=n;
        rec_t.lown:=lb;
        rec_t.highn:=rb;
        rec_t.rand:=rand;
      end;
  end;
//����� �� ���������
//Exit
4: begin
    if f_name<>'' then begin
      f_name:='';
      S_List.Free;
    end
    else break;
  end;
//��������� ����������
//Exec <��� script ����� ��� ����������>
5: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    f_name:=arw[1];
    S_List:=TStringList.Create;
    S_List.LoadFromFile(f_name+'.txt');
    n_line:=0;
    continue;
  end;
//������� ���������� �������� �� ����������� (insert) - ����� �������
//Ins0_u
6: begin
    sort_ins0_u(ard,dt);
    if f_pos<0 then writeln('���������� ������� �������� �� �����������. Time = ',dt:0:3,'ms');
  end;
//������� ���������� �������� �� �������� (insert) - ����� ������
//Ins0_d
7: begin
    sort_ins0_d(ard,dt);
    if f_pos<0 then writeln('���������� ������� �������� �� ��������. Time = ',dt:0:3,'ms');
  end;
//������� ���������� ������� �� ����������� (selection) - ����� �������
//Sel0
8: begin
    sort_sel0(ard,dt);
    if f_pos<0 then writeln('���������� ������� ������� �� �����������. Time = ',dt:0:3,'ms');
  end;
//������� ���������� ��������� �� ����������� (swap) - ����� �������
//Bubble0
9: begin
    sort_bubble0(ard,dt);
    if f_pos<0 then writeln('������� ���������� ��������� �� �����������. Time = ',dt:0:3,'ms');
  end;
//���������� ��������� � ����������� ��������� swap - ����� �������
//Bubble1
10: begin
    sort_bubble1(ard,dt);
    if f_pos<0 then writeln('������� ���������� ��������� � ����������� ��������� swap. Time = ',dt:0:3,'ms');
  end;
//��������� ����������
//Shaker0
11: begin
    sort_shaker(ard,dt);
    if f_pos<0 then writeln('��������� ����������. Time = ',dt:0:3,'ms');
  end;
//������������ ������ ����������
//Gnom0
12: begin
    Gnom0(ard,dt);
    if f_pos<0 then writeln('������������ ������ ����������. Time = ',dt:0:3,'ms');
  end;
//��������������� ������ ����������
//Gnom1
13: begin
    Gnom1(ard,dt);
    if f_pos<0 then writeln('��������������� ������ ����������. Time = ',dt:0:3,'ms');
  end;
//����� ����������� �� ������-�����
14: begin
    if f_name<>'' then writeln(s);
  end;
//��������� ���������� � �������
//Shaker1
15: begin
    shaker_opt(ard,dt);
    if f_pos<0 then writeln('��������� ���������� � �������. Time = ',dt:0:3,'ms');
  end;
//���������� �������� � �������� ������� � ������� �������
//Ins_bin_move
16: begin
    ins_bin_move(ard,dt);
    if f_pos<0 then writeln('���������� �������� � �������� ������� � ������� �������. Time = ',dt:0:3,'ms');
  end;
//���������� ������� ����� ��� k=2
//Shell0
17: begin
    shell0(ard,dt);
    if f_pos<0 then writeln('���������� ������� ����� ��� k=2. Time = ',dt:0:3,'ms');
  end;
//���������� ������� ����� ��� k=3
//Shell1
18: begin
    shell1(ard,dt);
    if f_pos<0 then writeln('���������� ������� ����� ��� k=3. Time = ',dt:0:3,'ms');
  end;
//���������� ������� ����� � ���������� �. �. ����������
//ShellT
19: begin
    shellT(ard,dt);
    if f_pos<0 then writeln('���������� ������� ����� � ���������� �. �. ����������. Time = ',dt:0:3,'ms');
  end;
//��������������� ���������� ������� ����� �� ������ �������
//ShellTOpt
20: begin
    shellTOpt(ard,dt);
    if f_pos<0 then writeln('��������������� ���������� ������� ����� �� ������ �������. Time = ',dt:0:3,'ms');
  end;
//���������� ������� ����� � ���������� �����
//ShellK
21: begin
    shellK(ard,dt);
    if f_pos<0 then writeln('���������� ������� ����� � ���������� �����. Time = ',dt:0:3,'ms');
  end;
//���������� ������� ����� � �������� ��������� ����
//ShellRes <dmax-������������ ���> <ddiv-�������� ����> <dsub-���������� �� ����>
22: begin
    if np<>4 then raise EConvertError.Create('������������ ���������� ����������!');
    dmax:=StrToInt(arw[1]);
    ddiv:=StrToInt(arw[2]);
    dsub:=StrToInt(arw[3]);
    ShellRes(ard,dt,dmax,ddiv,dsub);
    if f_pos<0 then writeln('���������� ������� ����� ��� dmax=',dmax,'. Time = ',dt:0:3,'ms');
  end;
//������� ������ ����� ��� ������ �� �����
//Repeat
23: begin
    if f_name='' then raise EConvertError.Create('�������������� ������ � ������-�����!');
    K_t:=1;
    init_rec_time(rec_t);
    //��������� ��������� � ������-�����
    f_pos:=n_line;
  end;
//������� �������� ����� ��� ������ �� �����
//Until <K-���������� ��������>
24: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    if f_name='' then raise EConvertError.Create('�������������� ������ � ������-�����!');
    K_Rpt:=StrToInt(arw[1]);
    if K_Rpt>K_t then begin
      n_line:=f_pos+1;
      inc(K_t);
      continue;
    end
    else begin
      if plan_pos=-1 then writeln('���� �������� ',K_t,' ���!');
      f_pos:=-1;
      OutRecord(rec_t,K_Rpt);
    end;
  end;
//��������� ��������� �������� ���������� ��� ������ ������
//AddTime <r|u|d>
25: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    if f_name='' then raise EConvertError.Create('�������������� ������ � ������-�����!');
    if not(arw[1][1] in ['r','u','d']) then raise EConvertError.Create('������ � ���������!');
    rec_t.sort_name:=sort_name;
    AddTime(rec_t,dt,arw[1][1]);
  end;
//������ ����������� �������� ����� � �����
//CreateTable <��� �����-�����>
26: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    if f_name='' then raise EConvertError.Create('�������������� ������ � ������-�����!');
    f_plan:=arw[1];
    plan_exp:=TStringList.Create;
    plan_exp.LoadFromFile(f_plan+'.txt');
    plan_line:=0;
    plan_pos:=n_line+1; //��������� ������� CreateTable � ������-����� + 1
    str_plan:=plan_exp[plan_line]; //������ ��� �����������
  end;
//��������� ����������� � ������� � ����
//EndTable <��� ����� � ������������>
27: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    if f_name='' then raise EConvertError.Create('�������������� ������ � ������-�����!');
    f_plan:=arw[1]; //������ ���������� ��� ��������
    //��������� ������ � plan_exp �� ������
    plan_exp[plan_line]:=RecToStr(rec_t);
    if plan_line<(plan_exp.Count-1) then begin
      inc(plan_line);
      str_plan:=plan_exp[plan_line];
      n_line:=plan_pos;
      continue;
    end;
    //���������� ���������� �� plan_exp
    plan_exp.Insert(0,' N ����������         ��������� ������ ������         '+'Random        (avg) UP (min)         Down');
    plan_exp.SaveToFile(f_plan+'.txt');
    writeln('���������� �������� � ����: '+f_plan+'.txt');
    writeln('������������: ������� ���� � �������� � ������� ���->������� �� ������->��� ��������');
    plan_exp.Free;
    str_plan:='';
    plan_pos:=-1;
  end;
//������������ ������ �� �����-�����
//UseStr
28: begin
    s:=str_plan;
    goto UseStr;
  end;
//������������ ������� ����������
//QSort
29: begin
    QSort_dt(ard,dt);
    if f_pos<0 then writeln('������������ ������� ����������. Time = ',dt:0:3,'ms');
  end;
//����� ��������� ������� � ���� ������
//OutTree <k-������ ���������� ��������>
30: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    OutTree(ard,StrToInt(arw[1]));
  end;
//����������� �����
//SiftUp <i>
31: begin
    if np<>2 then raise EConvertError.Create('������������ ���������� ����������!');
    SiftUp(ard,StrToInt(arw[1]));
  end;
//���������� ������������ ����
//BuildTree
32: begin
    BuildHeapSiftUp(ard);
  end;
//���������� ������������ ���� � ���������� t
//BuildTree_dt
33: begin
    BuildHeapSiftUp_dt(ard,dt);
    if f_pos<0 then writeln('���������� ���� �� ������ SiftUp. Time = ',dt:0:3,'ms');
  end;
//����������� �������� ����
//SiftDown1
34: begin
    SiftDown1(ard,length(ard));
  end;
//���������� ����� � ������� SiftDown1
//HeapSort1
35: begin
    HeapSort1(ard,dt);
    if f_pos<0 then writeln('���������� ����� � ������� SiftDown1. Time = ',dt:0:3,'ms');
  end;
//���������� ������������ ���� �� ������ SiftDown2 � ���������� t
//BuildTree2_dt
36: begin
    BuildHeapSiftDown2(ard,dt);
    if f_pos<0 then writeln('���������� ���� �� ������ SiftDown2. Time = ',dt:0:3,'ms');
  end;
//���������� ����� � ������� SiftDown2
//HeapSort2
37: begin
    HeapSort2(ard,dt);
    if f_pos<0 then writeln('���������� ����� �� ������ SiftDown2. Time = ',dt:0:3,'ms');
  end;
//���������� ��������� �� �����������
//CountSortU
38: begin
    CountSortU(ard,dt,rec_t.lown,rec_t.highn);
    if f_pos<0 then writeln('���������� ��������� �� �����������. Time = ',dt:0:3,'ms');
  end;
//���������� ��������� �� ��������
//CountSortD
39: begin
    CountSortD(ard,dt,rec_t.lown,rec_t.highn);
    if f_pos<0 then writeln('���������� ��������� �� ��������. Time = ',dt:0:3,'ms');
  end
else raise EConvertError.Create('');
end;
FileError:=0;
except
    on E:ERangeError do writeln('�������� ������� �� ������� ���������!');
    on E:EIntError do writeln('������������ ��������!');
    on E:EinoutError do begin
      case E.ErrorCode of
      2: writeln('���� ����� ', f_name,' �� ������!');
      3: writeln('���� ����� ', f_name,' �� ������!');
      123: writeln('��� ����� ', f_name,' �� �������������� � Windows!');
      161: writeln('��� ����� ', f_name,' �� �������������� � Windows!');
      else writeln('������ ��� ������ � ������! ��� ������: ', IntToStr(E.ErrorCode));
      end;
      f_name:='';
      FileError:=0;
    end;
    on E:EConvertError do begin
    writeln('������ � ������� ',arw[0],'! ',E.Message);
    if f_name<>'' then begin
      Writeln('��������� ������-����!');
      f_name:='';
      end;
    end;
    on E:Exception do writeln(E.classname,' ',E.message);
  end;
//��� ������ �� ������-����� ��������� � ������������� �����
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
sort_name:=arw[0];//��� ��������� �������
arw:=nil;
Until false;
S_List.Free;
arw:=nil;
ard:=nil;
end.
