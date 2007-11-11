{*
 * VimTray is copyright 2007 SUNAOKA Norifumi <http://pocari.org/>.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *}

unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UShell, CoolTrayIcon, Menus, ShellAPI, ImgList, StdCtrls,
  IniFiles;

type
  TConfigForm = class(TForm)
    imgIcon: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    editVimPath: TEdit;
    editMruPath: TEdit;
    btnVimPath: TButton;
    btnMruPath: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    lblURL: TLabel;
    OpenDialog: TOpenDialog;
    chkTab: TCheckBox;
    menuMRU: TPopupMenu;
    menuOpen: TMenuItem;
    menuConfig: TMenuItem;
    menuExit: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    TrayIcon: TCoolTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
    procedure lblURLMouseEnter(Sender: TObject);
    procedure lblURLMouseLeave(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnVimPathClick(Sender: TObject);
    procedure btnMruPathClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuExitClick(Sender: TObject);
    procedure menuConfigClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuOpenClick(Sender: TObject);
  private
    mruSubMenu: array of TMenuItem;
    mruItems: TStringList;
    iniFile: String;
    isClose: Boolean;
    SessionEnding: Boolean;
    procedure menuMRUClick(Sender: TObject);
    procedure ExecuteVim(path: String = '');
    procedure loadMUR(path: String = '');
    function SplitStrings(str: String; Delimiter: String; list: TStringList): Integer;
    function ExtractSmallIcon(filename: String; icon: TIcon): Integer;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
  public
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.dfm}

procedure TConfigForm.WMQueryEndSession(var Message: TMessage);
begin
  SessionEnding := True;
  Message.Result := 1;
end;

procedure TConfigForm.loadMUR(path: String = '');
var
  text, mru: TStringList;
  tmp, filename: String;
  i, n: Integer;
  icon: TIcon;
begin
  if Not FileExists(path) then begin 
    Exit;
  end;

  text := TStringList.Create;
  text.LoadFromFile(path);

  mru := TStringList.Create;

  for i := 0 to text.Count - 1 do begin
    if Copy(text[i], 1, 13) = 'let MRU_files' then begin
      tmp := Copy(text[i], 16, Length(text[i]) - 17); // 17 = [let MRU_files='] + [|']
      SplitStrings(tmp, '|', mru);
    end
  end;
  text.Free;

  icon := TIcon.Create;
  imgIcon.Clear;
  mruItems.Clear;
  for i := 0 to Length(mruSubMenu) - 1 do begin
    mruSubMenu[i].Free;
  end;

  n := 0;
  for i := 0 to mru.Count - 1 do begin
    filename := StringReplace(mru[i], '''''', '''', [ rfReplaceAll ]); // '' -> '

    if FileExists(filename) = false then begin
      continue;
    end;

    ExtractSmallIcon(filename, icon);
    imgIcon.AddIcon(icon);

    SetLength(mruSubMenu, n + 1);
    mruSubMenu[n] := TMenuItem.Create(Self);
    mruSubMenu[n].Caption := ExtractFileName(filename);
    mruSubMenu[n].onClick := menuMRUClick;
    mruSubMenu[n].ImageIndex := imgIcon.Count - 1;
    mruSubMenu[n].Tag := n;
    menuMRU.Items.Insert(Length(mruSubMenu) - 1, mruSubMenu[n]);

    mruItems.Insert(n, filename);
    n := n + 1;
  end;

  icon.Free;
  mru.Free;
end;

function TConfigForm.ExtractSmallIcon(filename: String; icon: TIcon): Integer;
var
  shfinfo :TSHFileinfo;
begin
  result := SHGetFileInfo(PChar(filename), FILE_ATTRIBUTE_NORMAL, SHFInfo, SizeOf(shfinfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES);
  icon.Handle := SHFinfo.hIcon;
end;

procedure TConfigForm.ExecuteVim(path: String = '');
var
  shell: TShell;
  dir: String;
begin
  if path <> '' then begin
    dir := ExtractFileDir(path);
    path := '"' + path + '"';
  end else begin
    dir := ExtractFileDir(editVimPath.Text);
  end;

  if chkTab.Checked = true then begin
    if path <> '' then begin
      path := '--remote-tab-silent ' + path
    end else begin
      if FindWindow('Vim', nil) <> 0 then begin
        path := '--remote-send <ESC>:tabnew<CR>'
      end else begin
        path := '-p'
      end;
    end;
  end;

  shell := TShell.Create(Handle);
  shell.Execute(editVimPath.Text, path, dir);
  
  if shell.isError() then begin
    MessageBox(Handle, PChar(shell.errorMessage()), PChar(Application.Title), MB_ICONERROR);
  end;
  shell.Free();
end;

function TConfigForm.SplitStrings(str: String; Delimiter: String; list: TStringList): Integer;
var
  len, pos: Integer;
begin
  list.Clear;
  if str <> '' then
  begin
    len := Length(Delimiter) - 1;
    pos := AnsiPos(Delimiter, str);
    while pos > 0 do
    begin
      list.Add(Copy(str, 1, pos - 1));
      Delete(str, 1, pos + len);
      pos := AnsiPos(Delimiter, str)
    end;
    list.Add(str);
  end;
  Result := list.Count;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  isClose := false;

  Application.ShowMainForm := False;
  ShowWindow(Application.Handle, SW_HIDE);

  iniFile := ExtractFilePath(Application.ExeName) + 'vimtray.ini';
  ini := TIniFile.Create(iniFile);

  editVimPath.Text := ini.ReadString('config', 'vim', 'gvim.exe');
  editMruPath.Text := ini.ReadString('config', 'mru', 'mru_files');
  chkTab.Checked := ini.ReadBool('config', 'tab', true);

  ini.Free;

  mruItems := TStringList.Create;
end;

procedure TConfigForm.lblURLClick(Sender: TObject);
var
  shell: TShell;
begin
  shell := TShell.Create(Handle);
  shell.Execute('http://pocari.org', '', '');
  if shell.isError() then begin
    MessageBox(Handle, PChar(shell.errorMessage()), PChar(Application.Title), MB_ICONERROR);
  end;
  shell.Free();
end;

procedure TConfigForm.lblURLMouseEnter(Sender: TObject);
begin
  lblURL.Font.Color := clBlue;
  lblURL.Font.Style := [ fsUnderline ];
end;

procedure TConfigForm.lblURLMouseLeave(Sender: TObject);
begin
  lblURL.Font.Color := clBtnShadow;
  lblURL.Font.Style := [ ];
end;

procedure TConfigForm.btnCancelClick(Sender: TObject);
begin
    Application.ShowMainForm := False;
    ShowWindow(Application.Handle, SW_HIDE);
    ConfigForm.Hide;
end;

procedure TConfigForm.btnOKClick(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(iniFile);

  ini.WriteString('config', 'vim', editVimPath.Text);
  ini.WriteString('config', 'mru', editMruPath.Text);
  ini.WriteBool('config', 'tab', chkTab.Checked);
  ini.Free;

  btnCancelClick(Sender);
end;

procedure TConfigForm.btnVimPathClick(Sender: TObject);
begin
  OpenDialog.Filter := 'vim.exe, gvim.exe|vim.exe;gvim.exe';
  if OpenDialog.Execute then begin
    editVimPath.Text := OpenDialog.FileName;
  end;
end;

procedure TConfigForm.btnMruPathClick(Sender: TObject);
begin
  OpenDialog.Filter := 'mru_files|mru_files';
  if OpenDialog.Execute then begin
    editMruPath.Text := OpenDialog.FileName;
  end;
end;

procedure TConfigForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mruItems.Free;
end;

procedure TConfigForm.menuExitClick(Sender: TObject);
begin
  isClose := true;
  close;
end;

procedure TConfigForm.menuConfigClick(Sender: TObject);
begin
  ConfigForm.Show;
end;

procedure TConfigForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (isClose or SessionEnding);
  if not CanClose then
  begin
    TrayIcon.HideMainForm;
    TrayIcon.IconVisible := True;
  end;
end;

procedure TConfigForm.TrayIconMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  loadMUR(editMruPath.Text);
end;

procedure TConfigForm.menuMRUClick(Sender: TObject);
begin
  ExecuteVim(mruItems[TMenuItem(Sender).Tag]);
end;

procedure TConfigForm.menuOpenClick(Sender: TObject);
begin
  ExecuteVim();
end;

end.
