unit uMain;

interface

uses
  System.SysUtils,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.Threading;

function CreateTask(const ATableName: string; const AProc: TProc<string>): ITask;
begin
  Result := TTask.Create(
    procedure
    var
      LTableName: string;
    begin
      LTableName := ATableName;
      TThread.Queue(
        nil,
        procedure
        begin
          AProc(LTableName);
        end
      );
    end
  );
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  LTables: TArray<string>;
begin
  LTables := ['table1', 'table2', 'table3', 'table4', 'table5'];

  for var LTable in LTables do
  begin
    CreateTask(
      LTable,
      procedure(ATableName: string)
      begin
        Memo1.Lines.Add(ATableName);
      end
    ).Start;
  end;
end;

end.
