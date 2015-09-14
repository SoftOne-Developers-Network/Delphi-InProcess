Softone InProcess DLL Customization</br>


Για να κληθεί από την εφαρμογή ένα DLL θα πρέπει να υπάρχει η σχετική δήλωση (ADDON=<DLLNAME>.DLL) στο [APPLICATION] section στο ανάλογο XCO.


Παράδειγμα XCO.</br>

[APPLICATION]</br>
MPR=Menu</br>
NAME=Softone ERP</br>
SN=11100000223803</br>
ADDON=MYDLL.DLL</br>
</br></br>
[DBCONNECT]</br>
TYPE=MSSQL</br>
DATABASE=softone</br>
SERVER=soft1db1</br>
USER=sa</br>
PASSWORD=mypassword</br>
</br></br>

Κατά το Login άμεσα αρχικοποιείτε  το DLL και καλεί τη μέθοδο Initialize με Mode=0 και  κενές τις άλλες παραμέτρους της.
Το DLL σε αυτή την περίπτωση επιστρέφει τα ονόματα των Object για τα οποία ζητά από την εφαρμογή να  το καλέσει.
</br></br>
Στη συνέχεια για κάθε Object που ανοίγει και το όνομα του είχε δηλωθεί στην πρώτη κλήση, ξανακαλείται η Initialize με παραμέτρους : </br>
•	Mode=1</br>
•	Το όνομα του Object που την κάλεσε.</br>
•	Το Object interface Object που την κάλεσε.</br>
•	User Pointer. (Επιστρέφει ένα Pointer)</br>
 
Η τιμή που θα επιστρέψει η User Pointer παράμετρος καθώς και το αποτέλεσμα που θα επιστρέψει η function, είναι και οι  παράμετροι  ( UserPointer, UserData) με τις οποίες θα κληθούν τα Events.
Σε αυτήν της την κλήση επίσης θα πρέπει να δηλώνονται και οι μέθοδοι που θα κληθούν ανά EVENT  με την χρήση της  ρουτίνας AddMethod  του Object interface. 
 </br>

Κατά το κλείσιμο του Object ξανακαλείται η Initialize με παραμέτρους : </br>
•	Mode=2</br>
•	Το όνομα του Object που την κάλεσε.</br>
•	Null</br>
•	User Pointer. (Ο ίδιος που δωθηκε στην κλήση με mode=1 )</br>
 
</br>
ΠΡΟΣΟΧΗ.</br>
Σε κάθε κλήση της Initialize το Object interface είναι διαφορετικό και αφορά το Object του οποίου το όνομα είναι πρώτη παράμετρος. 

</br>
Η μέθοδος Initialize είναι η μόνη που θα πρέπει να γίνεται Export από το DLL. Θα πρέπει επίσης όπως και όλες οι άλλες μέθοδοι πού θα κληθούν από την εφαρμογή να είναι δηλωμένη σαν STDCALL.  
Η μορφή της σε Delphi είναι η ακόλουθη.</br>

Function Initialize (Mode: Integer; 
Const ObjectName: OleVariant; 
                    Const ObjectIntf: OleVariant;
Var UserPointer: Pointer): OleVariant; stdcall;

</br>
Με την χρήση της  ρουτίνας AddMethod  του Object interface δηλώνονται οι μέθοδοι που θα κληθούν ανά EVENT. Η AddMethod  έχει δύο παραμέτρους :</br>
•	Το όνομα του Event. (Τα ονόματα των events υπάρχουν στο HELP αλλά και στο ανάλογο κείμενο παραμετροποίησης)</br>
•	Την διεύθυνση της μεθόδου που θα κληθεί γι’ αυτό το EVENT. </br>

Η μορφή event μεθόδου σε Delphi είναι η ακόλουθη.</br>

Function CustPost (UserPointer: Pointer;
 		    Const UserData: OleVariant): OleVariant; stdcall;
</br>
Τέλος οι ίδιες μέθοδοι που υπάρχουν διαθέσιμες για την συγγραφή VB Script και Java Script χρησιμοποιούνται και εδώ με τον ίδιο ακριβός τρόπο.(Περιγράφεται στο HELP αλλά και στο ανάλογο κείμενο παραμετροποίησης).   
Η μόνη διαφορά υπάρχει στον τρόπο χρήσης των TABLES του OBJECT. Ενώ στο VB Script και Java Script είναι άμεσα διαθέσιμα όλα, εδώ για να χρησιμοποιήσουμε κάποιο TABLE θα πρέπει πρώτα να το «καλέσουμε» με την με την χρήση της  ρουτίνας FINDTABLE του Object interface.

