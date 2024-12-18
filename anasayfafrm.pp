{

  Program Adı: UDP Port Test
  Program Exe Adı: udppt.exe
  Kodlayan: Fatih KILIÇ
  Mail: hs.fatih.kilic@gmail.com

  Tanım: program, UDP protokolünün cihazlarda test edilmesi amacıyla tasarlanmıştır

}
unit anasayfafrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, IdUDPClient, IdUDPServer, IdSocketHandle, IdGlobal;

type
  TfrmAnaSayfa = class(TForm)
    btnIMesaj: TButton;
    btnSTemizle: TButton;
    btnITemizle: TButton;
    cbSAktif: TCheckBox;
    cbIAktif: TCheckBox;
    edtIMesaj: TEdit;
    edtIIpAdres: TEdit;
    edtSPort: TEdit;
    edtIPort: TEdit;
    idUDPIstemci: TIdUDPClient;
    idUDPSunucu: TIdUDPServer;
    lblIMesaj: TLabel;
    lblIIpAdres: TLabel;
    lblSPort: TLabel;
    lblIPort: TLabel;
    mmSunucu: TMemo;
    mmIstemci: TMemo;
    pnlSAna: TPanel;
    pnlSUst: TPanel;
    pnlSBilgi: TPanel;
    pnlSunucu: TPanel;
    pnlIstemci: TPanel;
    pnlIUst: TPanel;
    pblIAna: TPanel;
    pnlIBilgi: TPanel;
    pnlIAlt: TPanel;
    spAna: TSplitter;
    procedure btnIMesajClick(Sender: TObject);
    procedure btnSTemizleClick(Sender: TObject);
    procedure btnITemizleClick(Sender: TObject);
    procedure cbSAktifChange(Sender: TObject);
    procedure cbIAktifChange(Sender: TObject);
    procedure edtIMesajKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure idUDPSunucuUDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
  end;

var
  frmAnaSayfa: TfrmAnaSayfa;

implementation

{$R *.lfm}
uses LCLType;

procedure TfrmAnaSayfa.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  if(idUDPSunucu.Active) then idUDPSunucu.Active := False;
  if(idUDPIstemci.Active) then idUDPIstemci.Active := False;
end;

procedure TfrmAnaSayfa.cbSAktifChange(Sender: TObject);
begin

  if(cbSAktif.Checked = False) then
  begin

    edtSPort.Enabled := True;
    idUDPSunucu.Active := cbSAktif.Checked
  end
  else
  begin

    try

      idUDPSunucu.DefaultPort := StrToInt(edtSPort.Text);
      idUDPSunucu.Active := cbSAktif.Checked;
      edtSPort.Enabled := False;
    except

      on E: Exception do
      begin

        ShowMessage(E.Message);
        cbSAktif.Checked := False;
        edtSPort.Clear;
        edtSPort.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmAnaSayfa.btnSTemizleClick(Sender: TObject);
begin

  mmSunucu.Clear;
end;

procedure TfrmAnaSayfa.cbIAktifChange(Sender: TObject);
begin

  if(cbIAktif.Checked = False) then
  begin

    idUDPIstemci.Active := cbIAktif.Checked;
    edtIIpAdres.Enabled := True;
    edtIPort.Enabled := True;
  end
  else
  begin

    try

      idUDPIstemci.Port := StrToInt(edtIPort.Text);
      idUDPIstemci.Active := cbIAktif.Checked;
      edtIIpAdres.Enabled := False;
      edtIPort.Enabled := False;
      edtIMesaj.SetFocus;
    except

      on E: Exception do
      begin

        ShowMessage(E.Message);
        cbIAktif.Checked := False;
      end;
    end;
  end;
end;

procedure TfrmAnaSayfa.btnITemizleClick(Sender: TObject);
begin

  mmIstemci.Clear;
end;

procedure TfrmAnaSayfa.btnIMesajClick(Sender: TObject);
var
  s: string;
begin

  if(cbIAktif.Checked) then
  begin

    s := edtIMesaj.Text;
    idUDPIstemci.Host := edtIIpAdres.Text;
    idUDPIstemci.Send(s);

    mmIstemci.Lines.Add(Format('%s: %s', [DateTimeToStr(Now), s]));

  end else ShowMessage('Lütfen öncelikle bağlantı portunu aktifleştiriniz!');
end;

procedure TfrmAnaSayfa.edtIMesajKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if(Key = VK_RETURN) then btnIMesajClick(Self);
end;

procedure TfrmAnaSayfa.idUDPSunucuUDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
var
  s: string;
begin

  s := BytesToString(AData);
  mmSunucu.Lines.Add(Format('%s (%s) - %s', [DateTimeToStr(Now), ABinding.PeerIP, s]));
end;

end.
