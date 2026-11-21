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

" Target: Identifier Characters
" Example: [h'] | [get!] | [find?] | [α₁]
" Note: Includes primes so keywords never match inside names
" Note: Unicode letters and subscripts are word characters by default
syn iskeyword @,48-57,_,',!,?,192-255

" Target: Generic Keywords
" Example: [match] n [with] | [if] c [then] a [else] b | [for] x [in] xs
syn keyword leanKeyword do else for if in match mut return then try catch
syn keyword leanKeyword finally unless with continue break
syn keyword leanKeyword termination_by decreasing_by

" Target: Term Keywords
" Example: [fun] x => x | [have] h : p := ... | [by] simp | [show] p [from] h
" Note: Link to Constant for distinct highlighting
syn keyword leanTerm by by? calc forall from fun have let show suffices this

" Target: Clause Keywords
" Example: structure Foo [extends] Bar [where] | simp [at] h | [deriving] Repr
syn keyword leanClause at where extends deriving using rec renaming hiding

" Target: Declaration Keywords
" Example: [def] foo | [theorem] bar | [structure] Point
" Note: Has nextgroup to highlight the declared name
" Note: Link to Constant for distinct highlighting
syn keyword leanDecl def theorem lemma abbrev instance example axiom
      \ opaque structure class inductive coinductive
      \ nextgroup=leanDeclName skipwhite skipempty

" Target: Declaration Modifiers
" Example: [private] def foo | [noncomputable] instance | [partial] def
syn keyword leanModifier private protected public noncomputable partial
syn keyword leanModifier unsafe nonrec meta local scoped

" Target: Module Commands
" Example: [import] Mathlib | [open] Nat in | [namespace] Foo
" Note: Link to Constant for distinct highlighting
syn keyword leanCommand prelude import export open namespace section end
syn keyword leanCommand universe variable mutual set_option omit include run_cmd

" Target: Metaprogramming Commands
" Example: [macro] "foo" : term => ... | [syntax] ... | [notation] ...
syn keyword leanCommand macro macro_rules syntax elab elab_rules notation
syn keyword leanCommand infix infixl infixr prefix postfix precedence
syn keyword leanCommand declare_syntax_cat

" Target: Hash Commands
" Example: [#check] foo | [#eval] 1 + 1 | [#print] axioms foo
syn match leanCommand /#[a-z_]\+\>/

" Target: Incomplete Proofs
" Example: := [sorry] | [admit] | [stop] | [#exit]
" Note: Defined after hash commands so [#exit] takes precedence
syn keyword leanSorry sorry admit stop
syn match leanSorry /#exit\>/

" Target: Sorts
" Example: (α : [Type]) | [Prop] | [Sort] u
syn keyword leanSort Type Sort Prop

" Target: Boolean Literals
" Example: [true] | [false] | [True] | [False]
syn keyword leanBoolean true false True False

" Target: Operators
" Example: [:=] [=>] [->] [<-] [∀] [∃] [λ] [↦] [·] [▸] [|>.]
" Note: Defined before comments so [--] and [/-] take precedence
syn match leanOperator /:=\|=>\|->\|<-\|<;>\|<|>\||>\.\?\|<|\|::\|\.\.\|\$/
syn match leanOperator /[∀∃λ→←↔↦×∘¬∧∨≠≤≥∈∉⊆∪∩∣•·▸⁻¹]/
syn match leanOperator /[-+*\/%^<>=&|:;]/

" Target: Delimiters
" Example: [(]x : α[)] | [⟨]a, b[⟩] | [#[]1, 2[]] | [⦃]x[⦄]
syn match leanDelim /#\[\|[()[\]⟨⟩⦃⦄]/

" Target: Todo Markers
" Example: -- [TODO]: fix this | -- [FIXME]: broken
syn keyword leanTodo contained TODO FIXME XXX BUG FIX NB NOTE

" Target: Line Comments
" Example: [-- comment]
syn region leanCommentLine start="--" end="$" contains=leanTodo,@Spell

" Target: Block Comments
" Example: [/- comment -/] | [/-- doc -/] | [/-! module doc -/]
" Pattern: Excludes /-- and /-! from regular block comments
" Note: Supports nesting via leanCommentBlockNest
syn region leanCommentBlock matchgroup=leanCommentBlock
      \ start="/-[-!]\@!" end="-/"
      \ contains=leanTodo,leanCommentBlockNest,@Spell

syn region leanCommentBlockDoc matchgroup=leanCommentBlockDoc
      \ start="/-[-!]" end="-/"
      \ contains=leanTodo,leanCommentBlockNest,@Spell

syn region leanCommentBlockNest
      \ start="/-" end="-/"
      \ contained transparent contains=leanTodo,leanCommentBlockNest,@Spell

" Target: Escape Sequences
" Example: "hello[\n]world" | "[\x41]" | "[\u03B1]"
" Note: Error is defined first so valid escapes take precedence
syn match leanEscapeError /\\./                contained
syn match leanEscape      /\\[nrt\\'"]/        contained
syn match leanEscape      /\\x[0-9a-fA-F]\{2}/ contained
syn match leanEscape      /\\u[0-9a-fA-F]\{4}/ contained

" Target: String Interpolation
" Example: s!"x = [{x}]" | f!"[{a}] and [{b}]"
syn region leanInterpolation start="{" end="}" contained contains=TOP

" Target: String Literals
" Example: ["hello"] | [s!"x = {x}"] | [r#"raw"#]
syn region leanString start='"'         skip=/\\\\\|\\"/ end='"' contains=leanEscape,leanEscapeError,@Spell
syn region leanString start='\<[smf]!"' skip=/\\\\\|\\"/ end='"' contains=leanEscape,leanEscapeError,leanInterpolation
syn region leanString start='r\z(#*\)"' end='"\z1' contains=@Spell

" Target: Character Literals
" Example: ['a'] | ['\n']
" Pattern: Not preceded by an identifier, so primes like h' are skipped
syn match leanCharacter /\k\@<!'\%([^'\\]\|\\[nrt\\'"]\|\\x[0-9a-fA-F]\{2}\)'/

" Target: Name Literals
" Example: [`Nat.succ] | [``foo] | [`«my name»]
syn match leanName /``\?\%(\k\|«[^»]*»\)\%(\k\|\.\|«[^»]*»\)*/

" Target: Numeric Literals
" Example: [42] | [0xFF] | [0b1010] | [0o77]
syn match leanNumber /\<[0-9]\+\>/
syn match leanNumber /\<0[xX][0-9a-fA-F]\+\>/
syn match leanNumber /\<0[bB][01]\+\>/
syn match leanNumber /\<0[oO][0-7]\+\>/

" Target: Float Literals
" Example: [3.14] | [1.0e10] | [2e-3]
syn match leanFloat /\<[0-9]\+\.[0-9]\+\%([eE][+-]\?[0-9]\+\)\?\>/
syn match leanFloat /\<[0-9]\+[eE][+-]\?[0-9]\+\>/

" Target: Attributes
" Example: [@[simp]] theorem | [@[inline, reducible]] | [attribute [simp]] foo
syn region leanAttribute start='@\[' end='\]' keepend
      \ contains=leanString,leanNumber

syn keyword leanAttribute attribute nextgroup=leanAttributeArgs skipwhite
syn region leanAttributeArgs start='\[' end='\]' contained keepend
      \ contains=leanString,leanNumber

" Target: Declaration Name
" Example: def [foo] | theorem [Nat.add_comm] | def [«my name»]
syn match leanDeclName /\%(\k\|«[^»]*»\)\%(\k\|\.\|«[^»]*»\)*/ contained

hi def link leanKeyword            Keyword
hi def link leanTerm               Constant
hi def link leanClause             Label
hi def link leanDecl               Constant
hi def link leanDeclName           Function
hi def link leanModifier           PreProc
hi def link leanCommand            Constant
hi def link leanSorry              Error
hi def link leanSort               Type
hi def link leanBoolean            Boolean
hi def link leanOperator           Operator
hi def link leanDelim              Delimiter
hi def link leanTodo               Todo
hi def link leanCommentLine        Comment
hi def link leanCommentBlock       Comment
hi def link leanCommentBlockDoc    Comment
hi def link leanEscape             SpecialChar
hi def link leanEscapeError        Error
hi def link leanString             String
hi def link leanCharacter          Character
hi def link leanName               Identifier
hi def link leanNumber             Number
hi def link leanFloat              Number
hi def link leanAttribute          PreProc
hi def link leanAttributeArgs      PreProc

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "lean"
