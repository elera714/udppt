unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, IdUDPClient, IdUDPServer, IdSocketHandle, IdGlobal;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    IdUDPClient1: TIdUDPClient;
    IdUDPServer1: TIdUDPServer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
uses LCLType;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
begin

  if(CheckBox2.Checked) then
  begin

    s := Edit1.Text;
    IdUDPClient1.Host := Edit2.Text;
    IdUDPClient1.Send(s);

    Memo2.Lines.Add(Format('%s: %s', [DateTimeToStr(Now), s]));

  end else ShowMessage('Lütfen öncelikle bağlantı portunu aktifleştiriniz!');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  Memo1.Clear;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  Memo2.Clear;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

  if(CheckBox1.Checked = False) then
  begin

    Edit3.Enabled := True;
    IdUDPServer1.Active := CheckBox1.Checked
  end
  else
  begin

    try

      IdUDPServer1.DefaultPort := StrToInt(Edit3.Text);
      IdUDPServer1.Active := CheckBox1.Checked;
      Edit3.Enabled := False;
    except

      on E: Exception do
      begin

        ShowMessage(E.Message);
        CheckBox1.Checked := False;
        Edit3.Clear;
        Edit3.SetFocus;
      end;
    end;
  end;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin

  if(CheckBox2.Checked = False) then
  begin

    IdUDPClient1.Active := CheckBox2.Checked;
    Edit2.Enabled := True;
    Edit5.Enabled := True;
  end
  else
  begin

    try

      IdUDPClient1.Port := StrToInt(Edit5.Text);
      IdUDPClient1.Active := CheckBox2.Checked;
      Edit2.Enabled := False;
      Edit5.Enabled := False;
      Edit1.SetFocus;
    except

      on E: Exception do
      begin

        ShowMessage(E.Message);
        CheckBox2.Checked := False;
      end;
    end;
  end;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if(Key = VK_RETURN) then Button1Click(Self);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  if(IdUDPServer1.Active) then IdUDPServer1.Active := False;
  if(IdUDPClient1.Active) then IdUDPClient1.Active := False;
end;

procedure TForm1.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
var
  s: string;
begin

  s := BytesToString(AData);
  Memo1.Lines.Add(Format('%s: %s', [DateTimeToStr(Now), s]));
end;

end.
