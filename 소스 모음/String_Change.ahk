; UrlEncode
UrlEncode(Str, Enc = "UTF-8")
{
    StrPutVar(Str, Var, Enc)
    f := A_FormatInteger
    SetFormat, IntegerFast, H
    Loop
    {
        Code := NumGet(Var, A_Index - 1, "UChar")
        If (!Code)
            Break
        If (Code = 0x21
            || Code = 0x27 || Code = 0x28
            || Code = 0x29 || Code = 0x2A
            || Code = 0x2D || Code = 0x2E
            || Code >= 0x30 && Code <= 0x39 ; 0-9
            || Code >= 0x41 && Code <= 0x5A ; A-Z
            || Code = 0x5F || Code = 0x7E
            || Code >= 0x61 && Code <= 0x7A) ; a-z
            Encoded .= Chr(Code)
        Else
            Encoded .= "%" . SubStr(Code + 0x100, 4)
    }
    SetFormat, IntegerFast, %f%
    Return, Encoded
}
 
 
; UriDecode
UriDecode(Str, Enc = "UTF-8")
{
    Loop
    {
        If (!RegExMatch(Str, "i)(?:%[0-9a-f]{2})+", Code))
            Break
        VarSetCapacity(Var, StrLen(Code) / 3, 0)
        StringTrimLeft, Code, Code, 1
        Loop, Parse, Code, `%
            NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
        StringReplace, Str, Str, `%%Code%, % StrGet(&Var, Enc), All
    }
    Return, Str
}
 
 
StrPutVar(Str, ByRef Var, Enc = "")
{
    Size := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
    VarSetCapacity(Var, Size, 0)
    Return, StrPut(Str, &Var, Enc)
}