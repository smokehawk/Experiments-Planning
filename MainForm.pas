unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    RadioGroup1: TRadioGroup;
    LevelsEdit: TEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    FactorsEdit: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    ComboBox2: TComboBox;
    RangeEdit: TEdit;
    Button1: TButton;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Button2: TButton;
    procedure FactorsEditKeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroup1Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure LevelsEditKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Select(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure RangeEditKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ResetForm;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure UpdateCmb(SenderCmb:TComboBox;N:integer;Str:string);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure StringGrid1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ints:array of array of real;
  plan:byte;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var N,NI,k,i,j,z:integer; ii:array of integer; flag:boolean;
str:string; tmp,H:real;
begin
  k:=length(ints)-1;
  flag:=CheckBox1.Checked;
  for I := 0 to k do
    if flag then
    begin
      for j := 0 to length(ints[i]) - 1 do
        for z := 0 to length(ints[i]) - 2 - j do
          if ints[i][z] > ints[i][z+1] then
            begin
              tmp:=ints[i][z];
              ints[i][z]:=ints[i][z+1];
              ints[i][z+1]:=tmp;
            end;
    end
    else begin
      if ints[i][0]>ints[i][length(ints[i])-1] then
      begin
        tmp:=ints[i][0];
        ints[i][0]:=ints[i][length(ints[i])-1];
        ints[i][length(ints[i])-1]:=tmp;
      end;
      if length(ints[i])>2 then
      begin
        H:=(ints[i][length(ints[i])-1]-ints[i][0])/(length(ints[i])-1);
        for j := 1 to length(ints[i])-2 do
          ints[i][j]:=ints[i][j-1]+H;
      end;
    end;
  setlength(ii,length(ints));
  NI:=1;
  stringgrid1.ColCount:=length(ints)+1;
  StringGrid1.Cells[0,0]:='� ������������';
  for I := 0 to k do
    stringgrid1.Cells[i+1,0]:=inttostr(i+1)+'-� ������';
  if plan=2 then dec(k);
  case plan of
    1:begin
      str:=inputbox('��������� ���������',
      '������� ���������� ������������� N = ','');
      val(str,N,j);
      if (j<>0) or (N<=0) then
      begin
        showmessage('������� ������������� ����� (������ 0)!');
        exit;
      end;
      stringGrid1.RowCount:=N+1;
      for j := 1 to N do begin
        for i := 0 to k do
        begin
          stringgrid1.Cells[0,j]:=inttostr(j);
          stringgrid1.Cells[i+1,j]:=floattostrf(random*(ints[i][1]-ints[i][0])
          +ints[i][0],fffixed,10,2);
        end;
      end;
    end;//1 inputbox

    3:begin
      N:=0;
      for i:=0 to k do N:=N+length(ints[i]);
      stringGrid1.RowCount:=N+1;
      for I := 0 to length(ints)-1 do
        for j := 0 to length(ints[i])-1 do
        begin
          ii[0]:=0;
          while ii[0]<length(ints) do
          begin
            stringgrid1.Cells[0,NI]:=inttostr(NI);
            if ii[0]=i then
              stringgrid1.Cells[ii[0]+1,NI]:=floattostrf(ints[i][j],fffixed,10,2)
            else stringgrid1.Cells[ii[0]+1,NI]:=floattostrf(
              abs(ints[ii[0]][0]+ints[ii[0]][length(ints[ii[0]])-1])/2,fffixed,10,2);
            inc(ii[0]);
          end;
          inc(NI);
        end;
    end;//3

    else begin
      N:=1;
      for i := 0 to k do N:=N*length(ints[i]);
      stringGrid1.RowCount:=N+1;

      if plan=0 then
      begin
        while ii[0]<length(ints[0]) do
        begin
          flag:=false;
          for I := 1 to k do
              if ii[i]=length(ints[i]) then
              begin
                inc(ii[i-1]);
                for j := i to k do ii[j]:=0;
                flag:=true;
                break;
              end;
          if flag then continue;
          while ii[k]<length(ints[k]) do
          begin
            for j := 0 to k do
                stringgrid1.Cells[j+1,NI]:=floattostrf(ints[j,ii[j]],fffixed,10,2);
            stringgrid1.Cells[0,NI]:=inttostr(NI);
            inc(ii[k]);
            inc(NI);
          end;
        end;
      end;//0

      if plan=2 then
      begin
        for I := 0 to length(ints[0])-1 do
        begin
          ii[0]:=ii[1];
          for j := 0 to length(ints[0])-1 do
          begin
            stringgrid1.Cells[0,NI]:=inttostr(NI);
            stringgrid1.Cells[1,NI]:=floattostrf(ints[0][i],fffixed,10,2);
            stringgrid1.Cells[2,NI]:=floattostrf(ints[1][j],fffixed,10,2);
            stringgrid1.Cells[3,NI]:=floattostrf(ints[2][ii[0]],fffixed,10,2);
            if ii[0]=length(ints[0])-1 then ii[0]:=0
              else inc(ii[0]);
            inc(NI);
          end;
          inc(ii[1]);
        end;
      end;//2

      if plan=4 then
      begin
        for I := 0 to N-1 do
        begin
          for j := length(ints) - 1 downto 0 do
          begin
            stringgrid1.Cells[0,I+1]:=inttostr(I+1);
            if ii[j]=1 then
              stringgrid1.Cells[j+1,I+1]:=floattostrf(ints[j][1],fffixed,10,2)
            else stringgrid1.Cells[j+1,I+1]:=floattostrf(ints[j][0],fffixed,10,2);
          end;
          inc(ii[length(ints)-1]);
          for z := length(ints) - 1 downto 1 do
            if (ii[z]=2) then begin  ii[z]:=0; inc(ii[z-1]) end;
        end;
      end;//4

    end;//else
  end;//case
end;//proc

procedure TForm1.Button2Click(Sender: TObject);
begin
  ResetForm;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Form1.ComboBox3Select(ComboBox3);
end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var ent:char;
begin
  if not levelsEdit.Enabled then LevelsEdit.Enabled:=true;
  if (plan=4) or (plan=1) then begin
    LevelsEdit.ReadOnly:=true;
    LevelsEdit.Text:='2';
    ent:=#13;
    LevelsEditKeyPress(LevelsEdit,ent);
  end;
  LevelsEdit.Text:=inttostr(length(ints[ComboBox1.ItemIndex]));
end;

procedure TForm1.ComboBox2Select(Sender: TObject);
begin
  RangeEdit.Enabled:=true;
  if (CheckBox1.Checked=False)and(ComboBox2.ItemIndex=1) then
    RangeEdit.Text:=
    floattostrf(ints[ComboBox3.ItemIndex][length(ints[ComboBox3.ItemIndex])-1],
    fffixed,10,2)
  else
  RangeEdit.Text:=floattostrf(ints[ComboBox3.ItemIndex][ComboBox2.ItemIndex],
  fffixed,10,2);
end;

procedure TForm1.ComboBox3Select(Sender: TObject);
begin
  if Checkbox1.Checked then
    UpdateCmb(ComboBox2,length(ints[ComboBox3.ItemIndex]),'�������')
  else
  begin
    if not ComboBox2.Enabled then ComboBox2.Enabled:=true;
    ComboBox2.Items.Clear;
    ComboBox2.Items.Add('������� 1');
    ComboBox2.Items.Add('������� '+inttostr(length(ints[ComboBox3.ItemIndex])));
    ComboBox2.ItemIndex:=0;
  end;
  Form1.ComboBox2Select(ComboBox2);
end;

procedure TForm1.LevelsEditKeyPress(Sender: TObject; var Key: Char);
var i:integer; same:boolean;
begin
  same:=false;
  if (plan=2) or (plan=4) then same:=true;
  case Key of
    '0'..'9',Chr(8):;
    Chr(13): if (length(LevelsEdit.Text)=0) or (strtoint(LevelsEdit.Text)=0)
      then showmessage('������� ���������� ������� (����� ����� > 0)')
      else
      begin
        setlength(ints[ComboBox1.ItemIndex],strtoint(LevelsEdit.Text));
        for I := 0 to length(ints)-1 do
          if (i<>ComboBox1.ItemIndex) and ((same) or (length(ints[i])=0))
            then setlength(ints[i],length(ints[ComboBox1.ItemIndex]));
        if(plan<>1)and(plan<>4) then
        CheckBox1.Enabled:=true else CheckBox1.Enabled:=false;
        ComboBox3.Enabled:=true;
        Form1.CheckBox1Click(CheckBox1);
      end;
    else
    Key:=Chr(0);
  end;
end;

procedure TForm1.FactorsEditKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9',Chr(8):;
    Chr(13): if (length(FactorsEdit.Text)=0) or (strtoint(FactorsEdit.Text)=0)
      then showmessage('������� ���������� �������� (����� ����� > 0)')
      else begin
        setlength(ints,strtoint(FactorsEdit.Text));
        UpdateCmb(ComboBox1,length(ints),'������');
        UpdateCmb(ComboBox3,length(ints),'������');
        ComboBox3.Enabled:=false;
      end
    else
    Key:=Chr(0);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:='� ������������';
  StringGrid1.Cells[1,0]:='������ i';
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
var ent:char;
begin
  plan:=RadioGroup1.ItemIndex;
  RadioGroup1.Enabled:=False;
  Button2.Enabled:=true;
  FactorsEdit.Enabled:=true;
  case plan of
    1,4:begin
      showmessage(RadioGroup1.Items[plan]+
      ' ���� �� ����������� ��������������� ������������� ��������');
    end;//1

    2:begin
      showmessage(RadioGroup1.Items[plan]+
      ' ����� ����������� ���������� �������� (3)');
      FactorsEdit.ReadOnly:=true;
      FactorsEdit.Text:='3';
      ent:=#13;
      FactorsEditKeyPress(FactorsEdit,ent);
    end;//2

  end;//case

end;//proc

procedure TForm1.RangeEditKeyPress(Sender: TObject; var Key: Char);
var compos:byte;
begin
  case Key of
    '0'..'9',Chr(8):;
    '.':begin
      Key:=',';
      RangeEditKeyPress(RangeEdit,key);
    end;
    ',':begin
      compos:=pos(',',RangeEdit.Text);
      if(compos<>0) or ((compos=0) and (length(RangeEdit.Text)=0))
        then Key:=Chr(0);
    end;
    '-':begin
      if length(RangeEdit.Text)<>0 then key:=chr(0);
    end;
    Chr(13):
    begin
      if (length(RangeEdit.Text)=0) or (RangeEdit.Text='-') then begin
        showmessage('�� ������ �� �����!');
        exit;
      end;
      if (CheckBox1.Checked=False)and(ComboBox2.ItemIndex=1) then
        ints[ComboBox3.ItemIndex][length(ints[ComboBox3.ItemIndex])-1]:=
          strtofloat(RangeEdit.Text)
      else
      ints[ComboBox3.ItemIndex,ComboBox2.ItemIndex]:=strtofloat(RangeEdit.Text);
      Button1.Enabled:=true;
    end;
    else
    Key:=Chr(0);
  end;
end;

procedure Tform1.ResetForm;
var Form2:Tform;
begin
  Form2:=Tform1.Create(Application);
  Form1.Free;
  Form1:=Tform1.Create(Application);
  Form2.Free;
  Form1.Show;
end;

procedure TForm1.StringGrid1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  StringGrid1.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
  Handled := True;
end;

procedure TForm1.StringGrid1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  StringGrid1.Perform(WM_VSCROLL, SB_PAGEUP, 0);
  Handled := True;
end;

procedure Tform1.UpdateCmb(SenderCmb:TComboBox;N:integer;Str:string);
var i:integer;
begin
  if not SenderCmb.Enabled then SenderCmb.Enabled:=true;
  SenderCmb.Items.Clear;
  for I := 0 to N-1 do
    SenderCmb.Items.Add(Str+' '+inttostr(i+1));
  SenderCmb.ItemIndex:=0;
end;

end.
