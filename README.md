Softone InProcess DLL Customization

Μια επιπλέον δυνατότητα παραμετροποίησης της λειτουργικότητας  της εφαρμογής δίνεται στο εξής με την προσάρτηση DLLs από τον οποιοδήποτε που έχει την δυνατότητα ανάπτυξης DLL σε όποιο περιβάλλον επιθυμεί.

 Στο κείμενο αυτό γίνεται μια συνοπτική τεχνική αναφορά στον τρόπο που καλείται αλλά και στον τρόπο με τον οποίο θα πρέπει να είναι γραμμένο ένα DLL.

Για να κληθεί από την εφαρμογή ένα DLL θα πρέπει να υπάρχει η σχετική δήλωση (ADDON=<DLLNAME>.DLL) στο [APPLICATION] section στο ανάλογο XCO.

Παράδειγμα XCO.
[APPLICATION]
MPR=Menu
NAME=Softone ERP
SN=11100000223803
ADDON=MYDLL.DLL

[DBCONNECT]
TYPE=MSSQL
DATABASE=softone
SERVER=soft1db1
USER=sa
PASSWORD=mypassword


Κατά το Login άμεσα αρχικοποιείτε  το DLL και καλεί τη μέθοδο Initialize με Mode=0 και  κενές τις άλλες παραμέτρους της. Το DLL σε αυτή την περίπτωση επιστρέφει τα ονόματα των Object για τα οποία ζητά από την εφαρμογή να  το καλέσει.

Στη συνέχεια για κάθε Object που ανοίγει και το όνομα του είχε δηλωθεί στην πρώτη κλήση, ξανακαλείται η Initialize με παραμέτρους : 
•	Mode=1
•	Το όνομα του Object που την κάλεσε.
•	Το Object interface Object που την κάλεσε.
•	User Pointer. (Επιστρέφει ένα Pointer)
 
Η τιμή που θα επιστρέψει η User Pointer παράμετρος καθώς και το αποτέλεσμα που θα επιστρέψει η function, είναι και οι  παράμετροι  ( UserPointer, UserData) με τις οποίες θα κληθούν τα Events.
Σε αυτήν της την κλήση επίσης θα πρέπει να δηλώνονται και οι μέθοδοι που θα κληθούν ανά EVENT  με την χρήση της  ρουτίνας AddMethod  του Object interface. 
 

Κατά το κλείσιμο του Object ξανακαλείται η Initialize με παραμέτρους : 
•	Mode=2
•	Το όνομα του Object που την κάλεσε.
•	Null
•	User Pointer. (Ο ίδιος που δωθηκε στην κλήση με mode=1 )
 

ΠΡΟΣΟΧΗ.
Σε κάθε κλήση της Initialize το Object interface είναι διαφορετικό και αφορά το Object του οποίου το όνομα είναι πρώτη παράμετρος. 


Η μέθοδος Initialize είναι η μόνη που θα πρέπει να γίνεται Export από το DLL. Θα πρέπει επίσης όπως και όλες οι άλλες μέθοδοι πού θα κληθούν από την εφαρμογή να είναι δηλωμένη σαν STDCALL.  
Η μορφή της σε Delphi είναι η ακόλουθη.

Function Initialize (Mode: Integer; 
Const ObjectName: OleVariant; 
                    Const ObjectIntf: OleVariant;
Var UserPointer: Pointer): OleVariant; stdcall;


Με την χρήση της  ρουτίνας AddMethod  του Object interface δηλώνονται οι μέθοδοι που θα κληθούν ανά EVENT. Η AddMethod  έχει δύο παραμέτρους :
•	Το όνομα του Event. (Τα ονόματα των events υπάρχουν στο HELP αλλά και στο ανάλογο κείμενο παραμετροποίησης)
•	Την διεύθυνση της μεθόδου που θα κληθεί γι’ αυτό το EVENT. 

Η μορφή event μεθόδου σε Delphi είναι η ακόλουθη.

Function CustPost (UserPointer: Pointer;
 		    Const UserData: OleVariant): OleVariant; stdcall;

Τέλος οι ίδιες μέθοδοι που υπάρχουν διαθέσιμες για την συγγραφή VB Script και Java Script χρησιμοποιούνται και εδώ με τον ίδιο ακριβός τρόπο.(Περιγράφεται στο HELP αλλά και στο ανάλογο κείμενο παραμετροποίησης).   
Η μόνη διαφορά υπάρχει στον τρόπο χρήσης των TABLES του OBJECT. Ενώ στο VB Script και Java Script είναι άμεσα διαθέσιμα όλα, εδώ για να χρησιμοποιήσουμε κάποιο TABLE θα πρέπει πρώτα να το «καλέσουμε» με την με την χρήση της  ρουτίνας FINDTABLE του Object interface.

Παράδειγμα της FindTable σε  DELPΗI.

var
  CustomerTable: OleVariant;
begin
  CustomerTable:= CustomerObject.FindTable('CUSTOMER');



 


Πλήρες παράδειγμα σε DELPHI.

library mydll;
uses
  SysUtils,
  Classes,
  ComObj,
  Variants,
  Dialogs;


function CustomerPost(UserPointer:pointer; const CustObject:OleVariant):OleVariant; stdcall;
var
  ATable: OleVariant;
  s: string;
begin
  ATable:= CustObject.FindTable('CUSBRANCH');
  ATable.first;
  while not ATable.EOF do
  begin
    s := s + ATable.code+' *** '+ATable.name+' *** '+ATable.ADDRESS+#13;
    ATable.Next;
  end;
  ShowMessage(s);
end;

function NewItemProc(UserPointer:pointer; const AObject:OleVariant):OleVariant; stdcall;
var
  ATable, ACustTable: OleVariant;
begin
  ATable:= AObject.FindTable('ITEM');
  ATable.Code := '000-00*';
  ATable.Name := 'New Item for dll test';
  AObject.FieldColor('ITEM.CODE', $00D5C7FE);
  AObject.FieldColor('MTRSUBSTITUTE.NAME', $00D5C7FE);
end;

function Proc1(UserPointer:pointer; const CustObject:OleVariant):OleVariant; stdcall;
begin
  ShowMessage('On Show Message');
end;

function Proc2(UserPointer:pointer; const CustObject:OleVariant):OleVariant; stdcall;
begin
  ShowMessage('On Accept Message');
end;

function Proc3(UserPointer:pointer; const CustObject:OleVariant):OleVariant; stdcall;
begin
  ShowMessage('On Cancel Message');
end;

function Initialize(Mode: integer; const ObjectName:OleVariant; const ObjectIntf:OleVariant; var UserPointer:pointer):OleVariant; stdcall;
begin
  case mode of
    0: Result:='CUSTOMER;ITEM;SALDOC';
    1: begin
         Result:= ObjectIntf;
         if SameText(ObjectName,'CUSTOMER') then
         begin
           ObjectIntf.AddMethod('ON_POST', Integer(@CustomerPost));
           UserPointer:= nil;
         end else if SameText(ObjectName,'ITEM') then
         begin
           ObjectIntf.AddMethod('ON_INSERT', Integer(@NewItemProc));
           UserPointer:= nil;
         end else if SameText(ObjectName,'SALDOC') then
         begin
           ObjectIntf.AddMethod('ON_SFVAT_SHOW',  Integer(@Proc1));
           ObjectIntf.AddMethod('ON_SFVAT_ACCEPT', Integer(@Proc2));
           ObjectIntf.AddMethod('ON_SFVAT_CANCEL', Integer(@Proc3));
           UserPointer:= nil;
         end;
       end;
    2: if SameText(ObjectName,'CUSTOMER') then
       begin
         // customer object finalization code if needed
       end else if SameText(ObjectName,'ITEM') then
       begin
         // item object finalization code if needed
       end;
  end;
end;

exports
  Initialize;

begin
end.

  



 

