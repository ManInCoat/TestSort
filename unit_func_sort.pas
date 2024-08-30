unit unit_func_sort;

interface
uses windows;
type mytype=int32;
     tda=array of mytype;
var K_stek:uint32=0;
    K_depth:uint32=0;
    K_calls:uint32=0;
//��������� ������� ��������� ������
function gen_ar(n,Lb,Rb,rand,pos:int32):tda;
//����� ������� ������
procedure out_ar(ar:tda;n1,n2:int32;f_name:ansistring);
//������� ���������� �������� �� ����������� (insert)
procedure sort_ins0_u(var ar:tda;out t:real);
//������� ���������� �������� �� �������� (insert)
procedure sort_ins0_d(var ar:tda;out t:real);
//������� ���������� ������� �� ����������� (selection)
procedure sort_sel0(var ar:tda;out t:real);
//������� ���������� ��������� �� ����������� (swap)
procedure sort_bubble0(var ar:tda;out t:real);
//������� ���������� ��������� � ����������� ��������� swap
procedure sort_bubble1(var ar:tda;out t:real);
//��������� ����������
procedure sort_shaker(var ar:tda;out t:real);
//������������ ������ ����������
procedure Gnom0(var ar:tda;out t:real);
//��������������� ������ ����������
procedure Gnom1(var ar:tda;out t:real);
//��������� ���������� � �������
procedure shaker_opt(var ar:tda;out t:real);
//���������� �������� � �������� ������� � ������� �������
procedure ins_bin_move(var ar:tda;out t:real);
//���������� ������� ����� ��� k=2
procedure shell0(var ar:tda;out t:real);
//���������� ������� ����� ��� k=3
procedure shell1(var ar:tda;out t:real);
//���������� ������� ����� � ���������� �. �. ����������
procedure shellT(var ar:tda;out t:real);
//��������������� ���������� ������� ����� �� ������ �������
procedure shellTOpt(var ar:tda;out t:real);
//���������� ������� ����� � ���������� �����
procedure shellK(var ar:tda;out t:real);
//���������� ������� ����� � �������� ��������� ����
procedure shellRes(var ar:tda;out t:real; dmax,ddiv,dsub:int32);
//������������ ������� ����������
procedure QSort_dt(var ar:tda; out t:real);
//�������������� "������� �����������" ���� ����� �������
procedure SiftUp(var ar:tda; k:int32);
//���������� ���� �� ������ SiftUp
procedure BuildHeapSiftUp(var ar:tda);
//���������� ���� �� ������ SiftUp � ���������� �������
procedure BuildHeapSiftUp_dt(var ar:tda; var dt:real);
//�������������� "������� �����������" ���� ����� ������� ���� (1 ������)
procedure SiftDown1(var ar:tda; s:int32);
// ���������� ����� �� ������ SiftDown1
procedure HeapSort1(var m:tda; var dt: real);
//�������������� "������� �����������" ���� ����� ������� ���� (2 ������)
procedure SiftDown2(var m1:tda; i:int32);
//���������� ���� �� ������ ��������� SiftDown2
procedure BuildHeapSiftDown2(var m1:tda; var dt:real);
//���������� ����� �� ������ SiftDown2
procedure HeapSort2(var m:tda; var dt: real);
//���������� ��������� �� �����������
procedure CountSortU(var ar:tda; out t:real; min:int32; max:int32);
//���������� ��������� �� ��������
procedure CountSortD(var ar:tda; out t:real; min:int32; max:int32);
//
implementation
//������ �������� ����� ����� ����������� (��������� ���������)
procedure swap(var a,b:integer);
var c:integer;
begin
  c:=a;
  a:=b;
  b:=c;
end;
//��������� ������� ��������� ������
function gen_ar(n,Lb,Rb,rand,pos:int32):tda;
var i,m:int32;
begin
  randseed:=rand;
  m:=Rb-Lb+1;
  setlength(result,n);
  for i:=0 to n-1 do
    result[i]:=random(m)+Lb;
  if pos<0 then writeln('������ ������� ������!');
end;
//����� ������� ������
procedure out_ar(ar:tda;n1,n2:int32;f_name:ansistring);
var i,n:int32;
    f:textfile;
begin
  //n1 - ������ ������� ��������
  //n2 - ���������� ���������
  if f_name<>'' then f_name:=f_name+'.txt';
  assignfile(f,f_name);
  Rewrite(f);
  n:=high(ar);
  if n1<low(ar) then n1:=low(ar);
  if n1>n then begin
    writeln('��������� ��������� �� ���������� � �������!');
    exit;
  end;
  //�������, ��� n1>=0
  if (n1+n2-1)<=n then n:=n1+n2-1;
  writeln(f,'Elements array ',n1,'..',n,':');
  for i := n1 to n do
    if (i+1-n1) mod 10 = 0 then writeln(f,ar[i]:5)
      else write(f,ar[i]:5);
  writeln(f);
  closefile(f);
end;
//������� ���������� �������� �� ����������� (insert)
procedure sort_ins0_u(var ar:tda;out t:real);
var i,x,j:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
for i := 1 to high(ar) do begin
    x:=ar[i];
    j:=i;
    while (j>0) and (x<ar[j-1]) do begin
      ar[j]:=ar[j-1];
      dec(j);
    end;
    ar[j]:=x;
  end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//������� ���������� �������� �� �������� (insert)
procedure sort_ins0_d(var ar:tda;out t:real);
var i,x,j:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
for i := 1 to high(ar) do begin
    x:=ar[i];
    j:=i;
    while (j>0) and (x>ar[j-1]) do begin
      ar[j]:=ar[j-1];
      dec(j);
    end;
    ar[j]:=x;
  end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//������� ���������� ������� �� ����������� (selection)
procedure sort_sel0(var ar:tda;out t:real);
var i,x,j,min:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
for i := 0 to length(ar)-2 do
   begin
      min:=length(ar);
      for j := i to length(ar)-1 do
        if ar[j]<min then begin
        min:=ar[j];
        x:=j;
        end;
      ar[x]:=ar[i];
      ar[i]:=min;
   end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//������� ���������� ��������� �� ����������� (swap)
procedure sort_bubble0(var ar:tda;out t:real);
var i,p,c:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
for p := 0 to length(ar)-2 do begin
  for i := 1 to length(ar)-1-p do
    if ar[i-1]>ar[i] then begin
      c:=ar[i-1];
      ar[i-1]:=ar[i];
      ar[i]:=c;
    end;
  end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//������� ���������� ��������� � ����������� ��������� swap
procedure sort_bubble1(var ar:tda;out t:real);
var i,p:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
for p := 0 to length(ar)-2 do begin
  for i := 1 to length(ar)-1-p do
    if ar[i-1]>ar[i] then begin
      swap(ar[i-1],ar[i]);
    end;
  end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//��������� ����������
procedure sort_shaker(var ar:tda;out t:real);
var i,p,c,n:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
for p := 0 to n shr 1 do begin
  for i := p+1 to n-1-p do
    if ar[i-1]>ar[i] then begin
      c:=ar[i-1];
      ar[i-1]:=ar[i];
      ar[i]:=c;
    end;
  for i := n-1-p downto p+1 do
      if ar[i-1]>ar[i] then begin
        c:=ar[i-1];
        ar[i-1]:=ar[i];
        ar[i]:=c;
      end;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//������������ ������ ����������
procedure Gnom0(var ar:tda;out t:real);
var i,x:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
i:=1;
while i<length(ar) do begin
  x:=ar[i];
  if ar[i-1]<=x then inc(i)
  else begin
    ar[i]:=ar[i-1];
    ar[i-1]:=x;
    if i>1 then dec(i);
  end;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//��������������� ������ ����������
procedure Gnom1(var ar:tda;out t:real);
var i,j,x:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
i:=1;
j:=2;
while i<length(ar) do begin
  x:=ar[i];
  if ar[i-1]<=x then begin
    i:=j;
    inc(j);
  end
  else begin
    ar[i]:=ar[i-1];
    ar[i-1]:=x;
    dec(i);
    if i=0 then begin
      i:=j;
      inc(j);
    end;
  end;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//��������� ���������� � �������
procedure shaker_opt(var ar:tda;out t:real);
var i,p,c,n,flag:integer;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
flag:=0;
for p := 0 to n shr 1 do begin
  for i := p+1 to n-1-p do
    if ar[i-1]>ar[i] then begin
      c:=ar[i-1];
      ar[i-1]:=ar[i];
      ar[i]:=c;
      flag:=1;
    end;
  if flag=0 then break;
  flag:=0;
  for i := n-1-p downto p+1 do
      if ar[i-1]>ar[i] then begin
        c:=ar[i-1];
        ar[i-1]:=ar[i];
        ar[i]:=c;
      end;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//���������� �������� � �������� ������� � ������� �������
procedure ins_bin_move(var ar:tda;out t:real);
var i,j,L,R,m,k:integer;
    x:mytype;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
k:=sizeof(mytype);
for i := 1 to high(ar) do
   begin
     x:=ar[i];
     L:=0;
     R:=i;
     while L<R do
       begin
         m:=(L+R) shr 1;
         if x<ar[m] then R:=m else L:=m+1;
       end;
       if R<>i then move(ar[R],ar[R+1],(i-R)*k);
       ar[R]:=x;
   end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//���������� ������� ����� ��� k=2
procedure shell0(var ar:tda;out t:real);
var n,d,i,c:integer;
    st:boolean;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
d:=n shr 1;
while d>0 do begin
  st:=True;
  while st do begin
    st:=False;
    for i := 0 to n-d-1 do
      if ar[i]>ar[i+d] then begin
        c:=ar[i];
        ar[i]:=ar[i+d];
        ar[i+d]:=c;
        st:=True;
      end;
  end;
  d:=d shr 1;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//���������� ������� ����� ��� k=3
procedure shell1(var ar:tda;out t:real);
var n,d,i,c:integer;
    st:boolean;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
d:=n div 3;
while d>0 do begin
  st:=True;
  while st do begin
    st:=False;
    for i := 0 to n-d-1 do
      if ar[i]>ar[i+d] then begin
        c:=ar[i];
        ar[i]:=ar[i+d];
        ar[i+d]:=c;
        st:=True;
      end;
  end;
  if (d<>1) and (d div 3=0) then d:=1
  else d:=d div 3;
end;
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
end;
//���������� ������� ����� � ���������� �. �. ����������
procedure shellT(var ar:tda;out t:real);
var i,j,n,d:int32;
    x:mytype;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
d:=n shr 1;
while d>0 do begin
  for i:=0 to n-d-1 do begin
    j:=i;
    while (j>=0) and (ar[j]>ar[j+d]) do begin
      x:=ar[j];
      ar[j]:=ar[j+d];
      ar[j+d]:=x;
      j:=j-d;
      end;
    end;
  d:=d shr 1;
end;
QueryPerformanceCounter(t2);
t := (t2 - t1) * 1000 / fr;
end;
//��������������� ���������� ������� ����� �� ������ �������
procedure shellTOpt(var ar:tda;out t:real);
var i,j,n,d,k:int32;
    x:mytype;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
d:=n shr 2;
while d>0 do begin
  for i:=d to n-1 do begin
    x:=ar[i];
    j:=i;
    k:=j-d;
    while (j>=d) and (x<ar[k]) do begin
      ar[j]:=ar[k];
      j:=k;
      k:=k-d;
      end;
    ar[j]:=x;
    end;
  d:=d shr 1;
end;
QueryPerformanceCounter(t2);
t := (t2 - t1) * 1000 / fr;
end;
//���������� ������� ����� � ���������� �����
procedure shellK(var ar:tda;out t:real);
var i,j,k,m,s,n:integer;
    x:mytype;
    t1,t2,fr:int64;

begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
k:=127;
while k>1 do begin
  k:=k shr 1;
  for i:=k to n-1 do begin
    x:=ar[i];
    j:=i-k;
    while (j>=k) and (x<ar[j]) do begin
      ar[j+k]:=ar[j];
      dec(j,k);
      end;
    if (j>=k) or (x>=ar[j]) then ar[j+k]:=x
    else begin
      ar[j+k]:=ar[j];
      ar[j]:=x;
      end;
    end;
  end;
QueryPerformanceCounter(t2);
t := (t2 - t1) * 1000 / fr;
end;
//���������� ������� ����� � �������� ��������� ����
procedure shellRes(var ar:tda;out t:real; dmax,ddiv,dsub:int32);
var i,j,n,d,k:int32;
    x:mytype;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
n:=length(ar);
d:=dmax;
while d>0 do begin
  for i:=d to n-1 do begin
    x:=ar[i];
    j:=i;
    k:=j-d;
    while (j>=d) and (x<ar[k]) do begin
      ar[j]:=ar[k];
      j:=k;
      k:=k-d;
      end;
    ar[j]:=x;
    end;
  if (d<>1) and (d div ddiv=0) then d:=1
  else d:=(d-dsub) div ddiv;
end;
QueryPerformanceCounter(t2);
t := (t2 - t1) * 1000 / fr;
end;
//������������ ������� ���������� (��������)
procedure QSort(L,R:int32; var ar:tda);
var
  i,j:int32;
  x,c:mytype;
  //k:int32;
begin
i:=L;
j:=R;
//inc(K_calls);
//inc(k_stek);
//if k_stek>k_depth then k_depth:=k_stek;
X:=ar[(i+j)shr 1];
{ TODO -c������������ : ������ k_stek � k ����� ������������ }
  repeat
    while ar[i]<X do begin inc(i);{inc(k);} end;
    while ar[j]>X do begin dec(j);{inc(k);} end;
    if i<=j then begin
                  c:=ar[i];
                  ar[i]:=ar[j];
                  ar[j]:=c;
                  inc(i);
                  dec(j);
                  {inc(ks);}
                  end;
  until i>j;
  if i<R then QSort(i,R,ar);
  if j>L then QSort(L,j,ar);
  //dec(k_stek);
end;
//������������ ������� ���������� (�����)
procedure QSort_dt(var ar:tda; out t:real);
var t1,t2,fr:int64;
begin
  { TODO 1 -c������������ : ������ ��� ���������� K_ ����� ������������! }
K_stek:=0;
K_depth:=0;
K_calls:=0;
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
QSort(0,high(ar),ar);
QueryPerformanceCounter(t2);
t:=(t2-t1)*1000/fr;
//Writeln('������������ �������: ',K_depth);
//Writeln('���������� ������: ',K_calls);
end;
//�������������� "������� �����������" ���� ����� �������
procedure SiftUp(var ar:tda; k:int32);
var x:mytype;
    i:uint32;
begin
  x:=ar[k];
  i:=(k-1) shr 1;
  while (k>0) and (x>ar[i]) do begin
    ar[k]:=ar[i];
    k:=i;
    i:=(k-1) shr 1;
  end;
  ar[k]:=x;
end;
//���������� ���� �� ������ SiftUp
procedure BuildHeapSiftUp(var ar:tda);
var i:uint32;
begin
  for i := 1 to high(ar) do SiftUp(ar,i);
end;
//���������� ���� �� ������ SiftUp � ���������� �������
procedure BuildHeapSiftUp_dt(var ar:tda; var dt:real);
var i:uint32;
    t1, t2, fr: int64;
begin
   QueryPerformanceFrequency(fr);
   QueryPerformanceCounter(t1);

   for i:=1 to  high(ar) do
     SiftUp(ar,i);

  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;
//�������������� "������� �����������" ���� ����� ������� ���� (1 ������)
procedure SiftDown1(var ar:tda; s:int32);
var i,k,k1:int32;
    x:mytype;
begin
x:=ar[s-1];
i:=0;
k:=i shl 1 + 1;// ������ ������ �������
while k<s do
  begin
  k1:=k+1;// ������ ������� �������
  if k1<s then
    if ar[k1]>ar[k] then k:=k1;// ��������� ������ �������������� �������� �����
  if x<ar[k] then begin
                  ar[i]:=ar[k];
                  i:=k;
                  k:=i shl 1 + 1;// ������ ����. ������ �������
                  end else break;
  end;
ar[i]:=x;
end;
//���������� ����� �� ������ SiftDown1
procedure HeapSort1(var m:tda; var dt: real);
var s,n:int32;
    x:mytype;
    t1, t2, fr: int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
BuildHeapSiftUp(m);
//
n:=length(m);
for s:=n downto  2 do
   begin
   x:=m[0]; //Extract max
   //m[s-1]:=x;//n-1 ..1
   SiftDown1(m,s); //n..2
   m[s-1]:=x;//n-1 ..1
   end;
QueryPerformanceCounter(t2);
dt := (t2 - t1) * 1000 / fr;
end;
//�������������� "������� �����������" ���� ����� ������� ���� (2 ������)
procedure SiftDown2(var m1:tda; i:int32);
var k,k1,s :int32;
     x: mytype;
begin
k:=i shl 1 + 1;
s:=length(m1);
x:=m1[i];
while k<s do
  begin
  k1:=k+1;
  if (k1<s) and (m1[k1]>m1[k]) then k:=k1;
  if x<m1[k] then begin
                  m1[i]:=m1[k];
                  i:=k;
                  k:=i shl 1 + 1;
                  end else break;
  end;
m1[i]:=x;
end;
//���������� ���� �� ������ ��������� SiftDown2
procedure BuildHeapSiftDown2(var m1:tda; var dt:real);
var i,k: int32;
    x:mytype;
    t1,t2,fr:int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
//
k:=high(m1);
for i := (k-1) shr 1 downTo 0 do
SiftDown2(m1,i);
//
QueryPerformanceCounter(t2);
dt := (t2 - t1) * 1000 / fr;
end;
//���������� ����� �� ������ SiftDown2
procedure HeapSort2(var m:tda; var dt: real);
var s,n,k,i:int32;
    x:mytype;
    t1, t2, fr: int64;
begin
QueryPerformanceFrequency(fr);
QueryPerformanceCounter(t1);
BuildHeapSiftDown2(m,dt);
//
n:=length(m);
for s:=n downto  2 do
   begin
   x:=m[0]; //Extract max
   //m[s-1]:=x;//n-1 ..1
   SiftDown1(m,s); //n..2
   m[s-1]:=x;//n-1 ..1
   end;
QueryPerformanceCounter(t2);
dt := (t2 - t1) * 1000 / fr;
end;
//���������� ��������� �� �����������
procedure CountSortU(var ar:tda; out t:real; min:int32; max:int32);
var i,j,summ,c:uint32;
    ex:array of int32;
    t1,t2,fr:int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  summ:=-min+max+1;
  setlength(ex,summ);
  for i := 0 to summ-1 do ex[i]:=0;
  for i := 0 to high(ar) do inc(ex[ar[i]-min]); //���������� ��������
  c:=0;
  for i := 0 to summ-1 do //������������� ������� ��������� � �������� �������
    for j := 1 to ex[i] do begin
      ar[c]:=i+min;
      inc(c);
    end;
  QueryPerformanceCounter(t2);
  t := (t2 - t1) * 1000 / fr;
  ex:=nil;
end;
//���������� ��������� �� ��������
procedure CountSortD(var ar:tda; out t:real; min:int32; max:int32);
var i,j,summ,c:uint32;
    ex:array of int32;
    t1,t2,fr:int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  summ:=-min+max+1;
  setlength(ex,summ);
  for i := 0 to summ-1 do ex[i]:=0;
  for i := 0 to high(ar) do inc(ex[ar[i]-min]); //���������� ��������
  c:=0;
  for i := summ-1 downto 0 do //������������� ������� ��������� � �������� �������
    for j := 1 to ex[i] do begin
      ar[c]:=i+min;
      inc(c);
    end;
  QueryPerformanceCounter(t2);
  t := (t2 - t1) * 1000 / fr;
  ex:=nil;
end;
//
end.
