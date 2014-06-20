// vim: set ts=2 sw=2:
module CIL-SYNTAX
  /* 
   * A file is a list of global declarations and definitions. 
   */
  syntax File ::= Globals

  syntax Global ::= Decl
                  | FunDef
                  | TuPragma
  syntax Globals ::= List{Global, ""}

  syntax Decl ::= VarDecl | InitVarDecl | AggDecl | TypedefDecl

  /* 
   * Global declarations.
   */
  syntax AggDecl ::= "struct" CId "{" VarDecls "}" ";"
                   | "union" CId "{" VarDecls "}" ";"
                   | "enum" CId "{" EnumInits "}" ";"
                   | "struct" CId ";" // forward decls
                   | "union" CId ";"
                   | "enum" CId ";"

  syntax EnumInit ::= CId "=" Constant
  syntax EnumInits ::= List{EnumInit, ","}

  syntax TypedefDecl ::= "typedef" DeclSpecs Declarator ";"

  syntax FunDef ::= DeclSpecs Declarator FunBody [klabel(FunDef)] 

  syntax FunBody ::= "{" VarDecls Block "}"   [avoid]
                   | Block

  // TODO(AndreiS): macro does not work correctly; it can narrow the left-hand side of rule, instead of rewriting it
  rule S:DeclSpecs F:Declarator B:Block => S F { .VarDecls B } [macro]

  syntax TuPragma ::= "#" "pragma" "KCIL_TU" String

  /*
   * Basic types.
   */
  syntax Type ::= ParamDecl // TODO(chathhorn)
  syntax Void ::= "void"
  syntax NvType ::= BasicType
  syntax BasicType ::= "char"
                     | IntType 
                     | FloatingType
                     | "_Complex" // TODO
                     | "__builtin_va_list"
  syntax IntType ::= SignedIntType
                   | UnsignedIntType
  syntax SignedIntType ::= "signed" "char"
                         | "short"
                         | "int"
                         | "long"
                         | "long" "long" 
  syntax UnsignedIntType ::= "_Bool"
                           | "unsigned" "char"
                           | "unsigned" "short"
                           | "unsigned" "int"
                           | "unsigned" "long"
                           | "unsigned" "long" "long"
  syntax FloatingType ::= "float"
                        | "double"
                        | "long" "double"

  /*
   * Expressions.
   */
  syntax Exp ::= 
      Constant
    | Var
    | "(" Exp ")" [bracket]
    | Exp "." Field
    | Exp "->" Field
    | Exp "[" Exp "]" // used to collied with DirectAbsDecl and DirectDecl
    > "-" Exp [strict]
    | "+" Exp [strict]
    | "!" Exp
    | "~" Exp [strict]
    | "*" Exp [strict] // used to collide with Pointer
    | "&" Exp [strict]
    | sizeof(TypeOrExp) [prefer]
    > "(" Type ")" Exp [strict, prefer]
    > left:
      Exp "*" Exp [strict]
    | Exp "/" Exp [strict]
    | Exp "%" Exp [strict]
    > left:
      Exp "+" Exp [strict]
    | Exp "-" Exp [strict]
    > left:
      Exp "<<" Exp [strict]
    | Exp ">>" Exp [strict]
    > left:
      Exp "<" Exp [strict]
    | Exp "<=" Exp [strict]
    | Exp ">" Exp [strict]
    | Exp ">=" Exp [strict]
    > left:
      Exp "==" Exp [strict]
    | Exp "!=" Exp [strict]
    > left: Exp "&" Exp [strict]
    > left: Exp "^" Exp [strict]
    > left: Exp "|" Exp [strict]

  rule E:Exp -> F:Field => (*E).F [macro]

  syntax Exps ::= List{Exp,","}   [strict]

  syntax TypeOrExp ::= Type | Exp
  syntax Var ::= CId
  syntax Field ::= CId

  /*
   * Literals.
   */
  syntax Constant ::= Int
                 | DecimalConstant
                 | OctalConstant
                 | HexConstant
                 | String
                 | DecimalFloatConstant
                 | NoDotDecimalFloatConstant
                 | HexFloatConstant
                 | NoDotHexFloatConstant
  // TODO(chathhorn): Something fishy re asterisks in Token.
                 | "'*'"
                 | "'"CharConstant"'"
                 | CharConstantPrefix "'"CharConstant"'"

  // TODO(chathhorn): char constant prefix. Especially L, which appears in the
  // torture tests.
  rule _:CharConstantPrefix ' C:CharConstant ' => ' C ' [macro]
  
  syntax DecimalConstant ::= 
    Token{[1-9][0-9]*[Uu]?[Ll]?[Ll]?[Uu]?} [onlyLabel]
  syntax OctalConstant ::= 
    Token{[0][0-7]*[Uu]?[Ll]?[Ll]?[Uu]?} [onlyLabel]
  syntax HexConstant ::= 
    Token{[0][xX][0-9a-fA-F]*[Uu]?[Ll]?[Ll]?[Uu]?} [onlyLabel]

  // Either the dot or the exponent part (preceded by e or p) is required for
  // float constants.
  syntax DecimalFloatConstant ::=
    Token{[0-9]*[\.][0-9]*[eE]?[\+\-]?[0-9]*[FfLl]?} [onlyLabel]
  syntax NoDotDecimalFloatConstant ::=
    Token{[0-9]+[eE][\+\-]?[0-9]+[FfLl]?} [onlyLabel]
  syntax HexFloatConstant ::=
    Token{[0][xX][0-9a-fA-F]*[\.][0-9a-fA-F]*[pP]?[\+\-]?[0-9]*[FfLl]?} 
    [onlyLabel]
  syntax NoDotHexFloatConstant ::=
    Token{[0][xX][0-9a-fA-F]+[pP][\+\-]?[0-9]+[FfLl]?} [onlyLabel]

  syntax Constants ::= List{Constant, ","}

  syntax CharConstantPrefix ::= Token{[LuU]} [onlyLabel]

  syntax Char ::= 
    Token{[a-zA-Z0-9\~\!\@\#\$\%\^\&\(\)\-\_\+\=\:\;\?\/\|\`\{\}\[\]\<\>]} 
    [onlyLabel]
  syntax CharConstant ::= Char | EscapeString
  syntax EscapeString ::= "\\'" | "\\\\" | "\\a" | "\\b" | "\\f" 
                        | "\\n" | "\\r" | "\\t" | "\\v" 
                        | OctalStringEscape | HexStringEscape
  // TODO(chathhorn): Also \" but I can't get it to work.

  syntax HexStringEscape ::=
    Token{[\\][x][0-9a-fA-F]*} [onlyLabel]
  syntax OctalStringEscape ::=
    Token{[\\][0-7][0-7]?[0-7]?} [onlyLabel]

  // TODO(chathhorn): hex and octal escape codes in strings?

  /*
   * Statements.
   */
  syntax Stmt ::= Instr 
                | "return" "(" Exp ")" ";"                    [strict]
                | "return" ";"
                | "goto" Label ";"
                | "break" ";"
                | "continue" ";"
                | "if" "(" Exp ")" Stmt "else" Stmt   [avoid]
                | "if" "(" Exp ")" Stmt
                | "switch" "(" Exp ")" Block
                | "while" "(" Exp ")" Stmt
                | Block
                | Label ":" Stmt
                | ";"

  rule if (E:Exp) S:Stmt => if (E) S else ;   [macro]

  syntax Stmts ::= List{Stmt, ""}
  syntax Instr ::= Exp "=" Exp ";"       [strict(2)]
                 | Exp "=" FunCall ";"   [strict(2), prefer]
                 | FunCall ";"            [strict] // used to collide with Stmt

  // TODO(AndreiS): are these part of CIL?
  syntax Instr ::= Exp "++" ";"
                 | Exp "--" ";"
                 | Exp "+=" Exp ";"
                 | Exp "-=" Exp ";"
                 | Exp "*=" Exp ";"
                 | Exp "/=" Exp ";"
                 | Exp "%=" Exp ";"
                 | Exp "&=" Exp ";"
                 | Exp "|=" Exp ";"
                 | Exp "^=" Exp ";"

  // TODO(chathhorn): Doesn't quite make sense if X has a pointer type...
  // rule X:Exp ++ ; => X = X + (typeof(X)) 1 ; [macro]
  // rule X:Exp -- ; => X = X - (typeof(X)) 1 ; [macro]
  rule X:Exp ++ ; => X = X + 1 ; [macro]
  rule X:Exp += E:Exp ; => X = X + E ; [macro]
  rule X:Exp -= E:Exp ; => X = X - E ; [macro]
  rule X:Exp *= E:Exp ; => X = X * E ; [macro]
  rule X:Exp /= E:Exp ; => X = X / E ; [macro]
  rule X:Exp %= E:Exp ; => X = X % E ; [macro]
  rule X:Exp &= E:Exp ; => X = X & E ; [macro]
  rule X:Exp |= E:Exp ; => X = X | E ; [macro]
  rule X:Exp ^= E:Exp ; => X = X ^ E ; [macro]

  syntax FunCall ::= Exp "(" Exps ")"   [klabel('call), strict(2)]
  syntax Block ::= "{" Stmts "}" // used to collide with Initializer
  syntax Label ::= CId
                 | "case" Exp
                 | "default"

  /*
   * Lexical tokens.
   */
  /* C identifiers */
  /* regular expression for tokens representing C identifiers */
  syntax CId ::= Token{[\$A-Za-z\_][\$A-Za-z\_0-9]*}    [onlyLabel]
               | Token{"main"}
  syntax CIds ::= List{CId, ","}


  /*
   * Declarations (variables, functions, and typedefs).
   */

  // declaration
  //     declaration-specifiers init-declarator-list? ;
  //     static_assert-declaration
  syntax VarDecl ::=
      DeclSpecs Declarator ";" 
    // Bitfields; really only allowed in structs/unions.
    | DeclSpecs Declarator ":" Constant ";"

  // Elide bitfields for now.
  rule DS:DeclSpecs D:Declarator : _:Constant ; => DS D ; [macro]

  syntax VarDecls ::= List{VarDecl, ""}
  
  syntax InitVarDecl ::= 
      DeclSpecs Declarator "=" Initializer ";"

  // declaration-specifiers
  //     storage-class-specifier declaration-specifiers?
  //     type-specifier          declaration-specifiers?
  //     type-qualifier          declaration-specifiers?
  //     function-specifier      declaration-specifiers?
  //     alignment-specifier     declaration-specifiers?
  syntax DeclSpecs ::=
      StorageClassSpec TypeSpec [klabel(DeclSpecsClassSpec)]
    | StorageClassSpec TypeSpec TypeQual [prefer,klabel(DeclSpecsClassSpecQual)] 
    | StorageClassSpec TypeQual TypeSpec [klabel(DeclSpecsClassQualSpec)]
    | StorageClassSpec TypeQual TypeSpec TypeQual [prefer]
    | TypeSpec
    | TypeSpec TypeQual [prefer,klabel(DeclSpecsSpecQual)]
    | TypeQual TypeSpec [klabel(DeclSpecsQualSpec)]
    | TypeQual TypeSpec TypeQual [prefer,klabel(DeclSpecsQualSpecQual)]
  rule SC:StorageClassSpec _:TypeQual TS:TypeSpec => SC TS [macro]
  rule SC:StorageClassSpec TS:TypeSpec _:TypeQual => SC TS [macro]
  rule SC:StorageClassSpec _:TypeQual TS:TypeSpec _:TypeQual => SC TS [macro]
  rule _:TypeQual TS:TypeSpec => TS [macro]
  rule TS:TypeSpec _:TypeQual => TS [macro]
  rule _:TypeQual TS:TypeSpec _:TypeQual => TS [macro]

  rule register T:TypeSpec => T [macro]

  // storage-class-specifier
  //     [ ... ]
  syntax StorageClassSpec ::=
      "extern"
    | "static"
    | "_Thread_local"
    | "auto"
    | "register"

  // atomic-type-specifier
  //     _Atomic ( type-name )

  // type-specifier
  //     [ ... ]
  //     atomic-type-sepcifier
  //     struct-or-union-specifier
  //     enum-specifier
  //     typedef-name
  syntax TypeSpec ::=
      Void
    | "_Atomic" "(" Type ")"
    | "..."
    | BasicType
    | AggTypeSpec
    | CId

  // struct-or-union-specifier
  //     struct-or-union identifier? { struct-declaration-list }
  //     struct-or-union identifier
  syntax AggTypeSpec ::=
      "struct" CId 
    | "union" CId 
    | "enum" CId 
  
  // function-specifier
  //     inline
  //     _Noreturn

  // alignment-specifier
  //     _Alignas ( type-name )
  //     _Alignas ( constant-expression )

  // type-qualifier
  //     const
  //     restrict
  //     volatile
  //     _Atomic
  syntax TypeQual ::=
      "const"
    | "restrict"
    | "volatile"
    | "_Atomic"
    // Function specifiers.
    |  "inline"
    | "_Noreturn"
    // Alignment specifier.
    | "_Alignas" "(" TypeOrExp ")"
    // CIL versions.
    | "__restrict"
    | "__inline"

  // declarator
  //     pointer? direct-declarator
  syntax Declarator ::=
      DirectDecl 
    | Pointer DirectDecl [klabel(DeclaratorPointerDirectDecl)]

  // direct-declarator
  //     identifier
  //     ( declarator )
  //     direct-declarator [ type-qualifier-list? assignment-expression?]
  //     direct-declarator [ static type-qualifier-list? assignment-expression ]
  //     direct-declarator [ type-qualifier-list static assignment-expression ]
  //     direct-declarator [ type-qualifier-list? * ]
  //     direct-declarator ( parameter-type-list )
  //     direct-declarator ( identifier-list? )
  syntax DirectDecl ::=
      CId
    | "(" Declarator ")" [klabel(ParensDirectDecl)]
    | DirectDecl "(" ")" [prefer,klabel(FunVoidDirectDecl)]
    | DirectDecl "[" "]" [prefer,klabel(ArrayDirectDecl)]
    | DirectDecl "(" Params ")" [klabel(FunDirectDecl)]
    | DirectDecl "[" Constant "]" [klabel(ArrayConstDirectDecl)]
  
  // TODO(chathhorn): type qualifiers.
  // pointer
  //      * type-qualifier-list?
  //      * type-qualifier-list? pointer
  syntax Pointer ::=
      "*"
    | "*" TypeQual [klabel(StarTypeQualPointer)]
    | "*" Pointer  [klabel(StarPointerPointer)]
    | "*" TypeQual Pointer
  rule * _:TypeQual => * [macro]
  rule * _:TypeQual P:Pointer => * P [macro]

  // NOTE that we've made "..." a TypeSpec instead of using this production, so
  // our parser will allow that "..." to appear anywhere a regular type could
  // appear.
  // parameter-type-list
  //     parameter-list
  //     parameter-list , ...
  // syntax ParameterTypeList ::=
  //     Params
  //   | Params "," "..."

  // parameter-list
  //     parameter-declaration
  //     parameter-list , parameter-declaration
  syntax Params ::=
      List{ParamDecl, ","}
  
  // parameter-declaration
  //     declaration-specifiers declarator
  //     declaration-specifiers abstract-declarator?
  syntax ParamDecl ::=
      DeclSpecs
    | DeclSpecs Declarator [klabel(ParamDeclDeclSpecsDeclarator)]
    | DeclSpecs AbsDecl [prefer,klabel(ParamDeclDeclSpecsAbsDecl)]

  // Abstract declarators are declarators without identifiers, optionally used
  // in function parameter list declarations.

  // abstract-declarator
  //     pointer
  //     pointer? direct-abstract-declarator
  syntax AbsDecl ::=
      Pointer
    | DirectAbsDecl
    | Pointer DirectAbsDecl [klabel(AbsDeclPointerDirectAbsDecl)]
  
  // direct-abstract-declarator
  //     ( abstract-declarator )
  //     direct-abstract-declarator? [ type-qualifier-list? assignment-expression? ]
  //     direct-abstract-declarator? [ static type-qualifier-list? assignment-expression ]
  //     direct-abstract-declarator? [ type-qualifier-list static assignment-expression ]
  //     direct-abstract-declarator? [ * ]
  //     direct-abstract-declarator? ( parameter-type-list? )
  syntax DirectAbsDecl ::=
      "(" ")" [prefer]
    | "[" "]" [prefer]
    | "(" AbsDecl ")" [avoid]
    | "(" Params ")" [klabel(ParensDirectAbsDecl)]
    | "[" Constant "]"
    | DirectAbsDecl "(" ")" [prefer,klabel(FunVoidDirectAbsDecl)]
    | DirectAbsDecl "[" "]" [prefer,label(ArrayDirectAbsDecl)]
    | DirectAbsDecl "(" Params ")" [klabel(FunDirectAbsDecl)]
    | DirectAbsDecl "[" Constant "]" [klabel(ArrayConstDirectAbsDecl)]
  
  // initializer
  //     assignment-expression
  //     { initializer-list }
  //     { initializer-list , }
  // In CIL these should just be constants or constants with a cast.
  syntax Initializer ::= Exp | "{" Initializers "}" [klabel(InitGroup)]
  syntax Initializers ::= List{Initializer, ","}

  // TODO(AndreiS): remove hask for getting the result
  syntax KItem ::= "###result-value" "(" K ")"

  // TODO(AndrieS): handle this
  syntax CId ::= "sum" | "s" | "n" | "tmp"
  syntax DecimalFloatConstant ::= "0U"
endmodule

