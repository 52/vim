" © 2026 Max Karou. All Rights Reserved.
" Licensed under Apache Version 2.0, or MIT License, at your discretion.
"
" Author: Max Karou <maxkarou@protonmail.com>
" Source: https://github.com/52/vim
"
" Apache License: http://www.apache.org/licenses/LICENSE-2.0
" MIT License: http://opensource.org/licenses/MIT

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Target: Generic Keywords
" Example: [let] x = 1 | [if] cond {} | [match] v {} | [struct] Foo {}
syn keyword rustKeyword as box break const continue crate else enum
syn keyword rustKeyword for if impl in let loop macro match mod move
syn keyword rustKeyword pub ref return static struct super trait
syn keyword rustKeyword type union use where while yield dyn

" Target: Function Keyword
" Example: [fn] main() {}
" Note: Has nextgroup to highlight function name
syn keyword rustFn fn nextgroup=rustFuncName skipwhite skipempty

" Target: Special Keywords
" Example: [async] [fn] foo() {} | [unsafe] {} | [extern] "C" {}
" Note: Link to Constant for distinct highlighting
syn keyword rustAsync  async
syn keyword rustAwait  await
syn keyword rustUnsafe unsafe
syn keyword rustExtern extern

" Target: Self References
" Example: [self].field | [Self]::new()
syn keyword rustSelf     self
syn keyword rustSelfType Self

" Target: Storage Modifier
" Example: let [mut] x = 1
syn keyword rustStorage mut

" Target: Boolean Literals
" Example: let b = [true]
syn keyword rustBoolean true false

" Target: Built-in Types
" Example: x: [i32] | s: &[str] | c: [char]
syn keyword rustBuiltinType isize usize char bool str
syn keyword rustBuiltinType u8 u16 u32 u64 u128
syn keyword rustBuiltinType i8 i16 i32 i64 i128
syn keyword rustBuiltinType f32 f64

" Target: Reserved Keywords
" Example: [abstract] | [virtual]
" Note: Highlighted as Error since these are reserved but not usable
syn keyword rustReserved abstract become do final override priv typeof unsized virtual

" Target: Todo Markers
" Example: // [TODO]: fix this | // [FIXME]: broken
syn keyword rustTodo contained TODO FIXME XXX NB NOTE SAFETY

" Target: Line Comments
" Example: [// comment] | [/// doc] | [//! inner doc]
syn region rustCommentLine    start="//"     end="$" contains=rustTodo,@Spell
syn region rustCommentLineDoc start="//[/!]" end="$" contains=rustTodo,@Spell

" Target: Block Comments
" Example: [/* comment */] | [/** outer doc */] | [/*! inner doc */]
" Pattern: Excludes /*! and /** from regular block comments
" Note: Supports nesting via rustCommentBlockNest
syn region rustCommentBlock matchgroup=rustCommentBlock
      \ start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/"
      \ contains=rustTodo,rustCommentBlockNest,@Spell

syn region rustCommentBlockDoc matchgroup=rustCommentBlockDoc
      \ start="/\*\%(!\|\*[*/]\@!\)" end="\*/"
      \ contains=rustTodo,rustCommentBlockDocNest,@Spell

syn region rustCommentBlockNest matchgroup=rustCommentBlock
      \ start="/\*" end="\*/"
      \ contained transparent contains=rustTodo,rustCommentBlockNest,@Spell

syn region rustCommentBlockDocNest matchgroup=rustCommentBlockDoc
      \ start="/\*" end="\*/"
      \ contained transparent contains=rustTodo,rustCommentBlockDocNest,@Spell

" Target: Escape Sequences
" Example: "hello[\n]world" | "\[x1F]" | "\[u{1F600}]"
syn match rustEscape      /\\[nrt0\\'"]/        contained
syn match rustEscape      /\\x[0-9a-fA-F]\{2}/  contained
syn match rustEscape      /\\u{[0-9a-fA-F]\+}/  contained
syn match rustEscapeError /\\./                 contained

" Target: String Literals
" Example: ["hello"] | [b"bytes"] | [r#"raw"#] | [br#"raw bytes"#]
syn region rustString start='"'          skip=/\\\\\|\\"/ end='"' contains=rustEscape,rustEscapeError,@Spell
syn region rustString start='b"'         skip=/\\\\\|\\"/ end='"' contains=rustEscape,rustEscapeError
syn region rustString start='r\z(#*\)"'  end='"\z1' contains=@Spell
syn region rustString start='br\z(#*\)"' end='"\z1'

" Target: Lifetimes
" Example: &['a] str | ['static]
syn match rustLifetime /'[a-z_][a-z0-9_]*/
syn match rustLifetime /'static/

" Target: Character Literals
" Example: ['a'] | ['\n'] | ['\x1F'] | [b'x']
syn match rustCharacter /'\%([^'\\]\|\\[nrt0\\'"]\|\\x[0-9a-fA-F]\{2}\|\\u{[0-9a-fA-F]\+}\)'/
syn match rustCharacter /b'\%([^'\\]\|\\[nrt0\\'"]\|\\x[0-9a-fA-F]\{2}\)'/

" Target: Numeric Literals
" Example: [42] | [1_000] | [0xFF] | [0o77] | [0b1010] | [42i32]
syn match rustNumber /\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\?\>/
syn match rustNumber /\<0x[0-9a-fA-F_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\?\>/
syn match rustNumber /\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\?\>/
syn match rustNumber /\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\?\>/

" Target: Float Literals
" Example: [3.14] | [1.0e10] | [2.5f32]
syn match rustFloat /\<[0-9][0-9_]*\.[0-9][0-9_]*\%([eE][+-]\?[0-9_]\+\)\?\%(f32\|f64\)\?\>/
syn match rustFloat /\<[0-9][0-9_]*[eE][+-]\?[0-9_]\+\%(f32\|f64\)\?\>/
syn match rustFloat /\<[0-9][0-9_]*\%(f32\|f64\)\>/

" Target: Operators
" Example: [+] [-] [->] [=>] [::] [..] [&&] [||]
syn match rustOperator /[-+%^!&|*<>=]=\?/
syn match rustOperator /&&\|||\|<<\|>>/
syn match rustOperator /[-=]>/
syn match rustOperator /\.\.\.\|\.\.\|::/
syn match rustOperator /?/

" Target: Macro Invocations
" Example: [println!]("hi") | [vec!][1, 2] | [MyMacro!]()
syn match rustMacro /\<[a-z_][a-z0-9_]*!/
syn match rustMacro /\<[A-Z][a-zA-Z0-9_]*!/

" Target: Macro Definition Tokens
" Example: ([$x]:expr) | [$($y:tt),*]
syn match rustMacroVariable /\$[a-z_][a-z0-9_]*/
syn match rustMacroRepeat   /\$(/

" Target: Attributes
" Example: [#[derive(Debug)]] | [#![allow(unused)]]
" Note: Contains rustType to highlight derived traits
syn region rustAttribute start='#!\?\[' end='\]' keepend
      \ contains=rustString,rustAttributeParens,rustType

syn region rustAttributeParens start='(' end=')'
      \ contained transparent
      \ contains=rustString,rustAttributeParens,rustType

" Target: Function Definition Name
" Example: fn [my_function]() {}
syn match rustFuncName /\<[a-zA-Z_][a-zA-Z0-9_]*\>/ contained

" Target: Function Calls
" Example: [foo]() | [bar]::<T>()
syn match rustFuncCall /\<[a-z_][a-z0-9_]*\ze\s*(/
syn match rustFuncCall /\<[a-z_][a-z0-9_]*\ze\s*::\s*</

" Target: Types (PascalCase)
" Example: [MyStruct] | [Vec]<T> | [T]
syn match rustType /\<[A-Z][a-zA-Z0-9]*\>/

" Target: Constants (SCREAMING_SNAKE_CASE)
" Example: [MY_CONST] | [MAX_SIZE] | [FOO]
" Strategy: Define after rustType; patterns require underscore or 2+ uppercase
syn match rustConstant /\<[A-Z][A-Z0-9]*_[A-Z0-9_]*\>/
syn match rustConstant /\<[A-Z][A-Z0-9]\+\>/

" Target: Enum Variants (Contextual)
" Example: Option::[Some] | Result::[Ok]
" Strategy: Only match after uppercase identifier (Type::) to avoid module confusion
syn match rustEnumVariant /\([A-Z][a-zA-Z0-9]*::\s*\)\@<=[A-Z][a-zA-Z0-9]*\>/

" Target: Associated Constants (Contextual)
" Example: Self::[MAX] | i32::[MIN]
syn match rustConstant /\([A-Z][a-zA-Z0-9]*::\s*\)\@<=[A-Z][A-Z0-9]*_[A-Z0-9_]*\>/
syn match rustConstant /\([A-Z][a-zA-Z0-9]*::\s*\)\@<=[A-Z][A-Z0-9]\+\>/

" Target: Associated Methods (Contextual)
" Example: Vec::[new]() | String::[from]()
syn match rustFuncCall /\([A-Z][a-zA-Z0-9]*::\s*\)\@<=[a-z_][a-z0-9_]*\ze\s*(/

hi def link rustKeyword         Keyword
hi def link rustFn              Constant
hi def link rustAsync           Constant
hi def link rustAwait           Constant
hi def link rustUnsafe          Constant
hi def link rustExtern          Constant
hi def link rustSelf            Type 
hi def link rustSelfType        Type
hi def link rustStorage         StorageClass
hi def link rustBoolean         Boolean
hi def link rustBuiltinType     Type
hi def link rustReserved        Error
hi def link rustTodo            Todo
hi def link rustCommentLine     Comment
hi def link rustCommentLineDoc  SpecialComment
hi def link rustCommentBlock    Comment
hi def link rustCommentBlockDoc SpecialComment
hi def link rustEscape          SpecialChar
hi def link rustEscapeError     Error
hi def link rustString          String
hi def link rustCharacter       Character
hi def link rustNumber          Number
hi def link rustFloat           Float
hi def link rustOperator        Operator
hi def link rustMacro           Macro
hi def link rustMacroVariable   Define
hi def link rustMacroRepeat     Special
hi def link rustLifetime        Special
hi def link rustAttribute       PreProc
hi def link rustFuncName        Function
hi def link rustFuncCall        Function
hi def link rustType            Type
hi def link rustConstant        Constant
hi def link rustEnumVariant     Constant

" Target: Rustdoc Code Blocks
" Example: /// ```rust ... ```
" Note: Embeds full Rust syntax inside doc comment fenced code blocks
if !exists("b:current_syntax_embed")
  let b:current_syntax_embed = 1
  syntax include @RustCodeInComment <sfile>:p:h/rust.vim
  unlet b:current_syntax_embed

  let s:rust_annotations = 'rust\|should_panic\|no_run\|ignore\|allow_fail\|'
        \ . 'compile_fail\|edition201[58]\|edition2021'

  exe 'syn region rustDocCodeBlock matchgroup=rustCommentLineDoc '
        \ . 'start="^\z(\s*///\s*```\)\%(' . s:rust_annotations . '\)\?\s*$" '
        \ . 'end="^\z1$" '
        \ . 'contains=@RustCodeInComment,rustDocCodeBlockLeader keepend'

  exe 'syn region rustDocCodeBlock matchgroup=rustCommentLineDoc '
        \ . 'start="^\z(\s*//!\s*```\)\%(' . s:rust_annotations . '\)\?\s*$" '
        \ . 'end="^\z1$" '
        \ . 'contains=@RustCodeInComment,rustDocCodeBlockLeader keepend'

  syn match rustDocCodeBlockLeader /^\s*\/\/[\/!]/ contained
  hi def link rustDocCodeBlockLeader rustCommentLineDoc
endif

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "rust"
