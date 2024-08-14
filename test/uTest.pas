unit uTest;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Classes,
  System.Threading;

type
  [TestFixture]
  TMyTestObject = class
  public
    [Test]
    procedure Test1;
  end;

implementation

{ TMyTestObject }

uses ThreadingEx;

procedure TMyTestObject.Test1;
begin
  TTaskEx.Run(
  procedure
  begin
    Sleep(1000);
    raise Exception.Create('Test Error')
  end)
  .ContinueWith(
    procedure(const LTaskEx: ITaskEx)
    begin
      TThread.Queue(TThread.CurrentThread,
      procedure
      begin
        raise Exception.Create(LTaskEx.ExceptObj.ToString);
      end);
    end
  , OnlyOnFaulted);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
