{*
 * PuTTray is copyright 2007 Sunaoka Norifumi.
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

unit UShell;

interface

uses
  Windows, SysUtils, ShellAPI;

type
  TShell = class
  private
  public
    constructor Create(Handle: HWND);
    class function isError(): Boolean;
    class function errorMessage(): String;
    class procedure Execute(FileName: String; Parameters: String; Directory: String; Verb: String = 'open');
end;

implementation

var
  gError: Boolean;
  gMessage: String;
  gHandle: HWND;

constructor TShell.Create(Handle: HWND);
begin
  gHandle := Handle;
  gError := False;
  gMessage := '';
end;

class function TShell.isError(): Boolean;
begin
  Result := gError;
  gError := False;
end;

class function TShell.errorMessage(): String;
begin
  Result := gMessage;
  gMessage := '';
end;

class procedure TShell.Execute(FileName: String; Parameters: String; Directory: String; Verb: String = 'open');
var
  hRet: HWND;
begin
  hRet := ShellExecute(gHandle, PChar(Verb), PChar(FileName), PChar(Parameters), PChar(Directory), SW_SHOWNORMAL);
  if hRet <= 32 then begin
    gError := True;
    gMessage := SysErrorMessage(GetLastError());
  end;
end;

end.
