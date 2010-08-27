Set objFS = CreateObject("Scripting.FileSystemObject") 
Set objArgs = WScript.Arguments 
str1 = objArgs(0) 
s=Split(str1,"`") 
For i=LBound(s) To UBound(s) 
    WScript.Echo s(i) 
    ' WScript.Echo s(9) ' get the 10th element 
Next 