/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();
    private boolean string_too_long = false;
    private int comment_depth = 0;

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
    case STRING:
	yybegin(YYINITIAL);
	return new Symbol(TokenConstants.ERROR, "EOF in string constant");
    case COMMENT:
	yybegin(YYINITIAL);
	return new Symbol(TokenConstants.ERROR, "EOF in comment");
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

%state STRING
%state COMMENT

DIGIT      = [0-9]
ALPHANUM   = [a-zA-Z0-9_]
NEWLINE    = \n
WHITESPACE = [\ \t\f\r]

IF         = [Ii][Ff]
FI         = [Ff][Ii]
THEN       = [Tt][Hh][Ee][Nn]
ELSE       = [Ee][Ll][Ss][Ee]
IN         = [Ii][Nn]
ISVOID     = [Ii][Ss][Vv][Oo][Ii][Dd]
LET        = [Ll][Ee][Tt]
LOOP       = [Ll][Oo][Oo][Pp]
POOL       = [Pp][Oo][Oo][Ll]
WHILE      = [Ww][Hh][Ii][Ll][Ee]
CASE       = [Cc][Aa][Ss][Ee]
ESAC       = [Ee][Ss][Aa][Cc]
OF         = [Oo][Ff]
CLASS      = [Cc][Ll][Aa][Ss][Ss]
INHERITS   = [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
NEW        = [Nn][Ee][Ww]
NOT        = [Nn][Oo][Tt]

OBJECTID = [a-z][a-zA-Z0-9_]*
TYPEID   = [A-Z][a-zA-Z0-9_]*

BOOLEAN  = t[Rr][Uu][Ee]|f[Aa][Ll][Ss][Ee]
%%

<YYINITIAL>{NEWLINE}     { curr_lineno++; }
<YYINITIAL>{WHITESPACE}+ { /* ignorar */ }

<YYINITIAL>{IF}        { return new Symbol(TokenConstants.IF); }
<YYINITIAL>{FI}        { return new Symbol(TokenConstants.FI); }
<YYINITIAL>{THEN}      { return new Symbol(TokenConstants.THEN); }
<YYINITIAL>{ELSE}      { return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>{IN}        { return new Symbol(TokenConstants.IN); }
<YYINITIAL>{ISVOID}    { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>{LET}       { return new Symbol(TokenConstants.LET); }
<YYINITIAL>{LOOP}      { return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>{POOL}      { return new Symbol(TokenConstants.POOL); }
<YYINITIAL>{WHILE}     { return new Symbol(TokenConstants.WHILE); }
<YYINITIAL>{CASE}      { return new Symbol(TokenConstants.CASE); }
<YYINITIAL>{ESAC}      { return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>{OF}        { return new Symbol(TokenConstants.OF); }
<YYINITIAL>{CLASS}     { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>{INHERITS}  { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>{NEW}       { return new Symbol(TokenConstants.NEW); }
<YYINITIAL>{NOT}       { return new Symbol(TokenConstants.NOT); }

<YYINITIAL>"*"        { return new Symbol(TokenConstants.MULT); }
<YYINITIAL>"/"        { return new Symbol(TokenConstants.DIV); }
<YYINITIAL>"+"        { return new Symbol(TokenConstants.PLUS); }
<YYINITIAL>"-"        { return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>"~"        { return new Symbol(TokenConstants.NEG); }
<YYINITIAL>"<"        { return new Symbol(TokenConstants.LT); }
<YYINITIAL>"<="       { return new Symbol(TokenConstants.LE); }
<YYINITIAL>"="        { return new Symbol(TokenConstants.EQ); }
<YYINITIAL>"<-"       { return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL>"=>"       { return new Symbol(TokenConstants.DARROW); }
<YYINITIAL>"("        { return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>")"        { return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>"{"        { return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL>"}"        { return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>";"        { return new Symbol(TokenConstants.SEMI); }
<YYINITIAL>":"        { return new Symbol(TokenConstants.COLON); }
<YYINITIAL>","        { return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>"."        { return new Symbol(TokenConstants.DOT); }
<YYINITIAL>"@"        { return new Symbol(TokenConstants.AT); }

<YYINITIAL>{OBJECTID}       { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL>{TYPEID}         { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>{DIGIT}+         { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext())); }
<YYINITIAL>{BOOLEAN}        { return new Symbol(TokenConstants.BOOL_CONST, yytext().charAt(0) == 't' ? Boolean.TRUE : Boolean.FALSE); }

<YYINITIAL>"--"[^\n]* { /* comentário de linha, ignorar */ }
<YYINITIAL>"(*"       { comment_depth = 1; yybegin(COMMENT); }
<YYINITIAL>"*)"       { return new Symbol(TokenConstants.ERROR, "Unmatched *)"); }

<COMMENT>"(*"         { comment_depth++; }
<COMMENT>"*)"         { if (--comment_depth == 0) yybegin(YYINITIAL); }
<COMMENT>{NEWLINE}     { curr_lineno++; }
<COMMENT>.            { /* ignorar */ }

<YYINITIAL>"\""       { string_buf.setLength(0); string_too_long = false; yybegin(STRING); }


<STRING>\"              { yybegin(YYINITIAL);
                         if (string_too_long) 
                           return new Symbol(TokenConstants.ERROR, "String constant too long");
                        return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(string_buf.toString())); }

<STRING>\n              { curr_lineno++; yybegin(YYINITIAL); return new Symbol(TokenConstants.ERROR, "Unterminated string constant"); }
<STRING>\\\n            { curr_lineno++; if (!string_too_long) string_buf.append('\n'); }
<STRING>\\n             { if (!string_too_long) string_buf.append('\n'); }
<STRING>\\t             { if (!string_too_long) string_buf.append('\t'); }
<STRING>\\b             { if (!string_too_long) string_buf.append('\b'); }
<STRING>\\f             { if (!string_too_long) string_buf.append('\f'); }
<STRING>\\\"            { if (!string_too_long) string_buf.append('"'); }
<STRING>\\\\            { if (!string_too_long) string_buf.append('\\'); }
<STRING>\\[^\n]         { if (!string_too_long) string_buf.append(yytext().charAt(1)); }
<STRING>\000            { return new Symbol(TokenConstants.ERROR, "String contains null character"); }
<STRING>[^\"\n\\\000]+  { if (string_buf.length() + yytext().length() > MAX_STR_CONST - 1) {
                              string_too_long = true;
                          } else if (!string_too_long) {
                              string_buf.append(yytext());
                          } }

.                       { return new Symbol(TokenConstants.ERROR, yytext()); }
