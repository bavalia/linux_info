" Load .vimrc file
" :so .vimrc    or   :source .vimrc
" :so %

" Turn on line numbering. Turn it off with "set nonu" 
"set nu
set relativenumber 
set number  

" Set syntax on
syntax on

" Indent automatically depending on filetype
filetype indent on
" set autoindent
set smartindent

" tab width setting
set tabstop=2
set shiftwidth=2

" expand tab to spaces"
set expandtab


" Case insensitive search
set ic

" Highlight search
set hls

" Wrap text instead of being on one line
set lbr

" Set spell check / to remove spell check 'set nospell'
" set spell 

" Set curser navigation with mouse click 
set mouse=a


""" sugestion by sahil #plug plugin #begin
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Use Space-f for commenting
Plug 'scrooloose/nerdcommenter'
noremap <space>f :call NERDComment(0,"toggle")<CR>

" Plugin for colorschemes
Plug 'morhetz/gruvbox'
"
" " Better incremental search plugin
Plug 'haya14busa/incsearch.vim'

" Vim airline plugin
Plug 'vim-airline/vim-airline'
set laststatus=2
" Dont do white space detection
let g:airline#extensions#whitespace#enabled = 0

" File explorer ( Bring up using <F2>)
Plug 'scrooloose/nerdtree'
map <F10> :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right" " Open NerdTree on right side insted of left
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Color scheme
Plug 'tomasr/molokai'
let g:molokai_original = 1
"
Plug 'majutsushi/tagbar'
map <F9> :TagbarToggle<CR>
"learn tagging in directory for functions in a project
" Use ctags to generate ctags for any directory and load it to vim
" ctags -R .
" Ctrl+]  # to go to defination
" g Ctrl+] # open list of matching definations
" :set tags=./tags;

" Use tab to do completion
Plug 'ervandew/supertab'

Plug 'vectorstorm/vim-csyn'

" Session manager stores and restores default session automatically or prompts
" vim also has default functionality for sessions, write function for autoload
" xolox has support for nerdTree over default session manager
" commented due to functions for automating sessions working directory wise
"Plug 'xolox/vim-session'
"Plug 'xolox/vim-misc'


" install pluings and then set and uncomment this for c++ and python autocomplete
"
"   " Python Autocomplete - Use Ctrl-space to open suggestion list
"   Plugin 'davidhalter/jedi-vim'
"   let g:jedi#popup_on_dot = 0 " Dont show suggestions on dot
"   let g:jedi#show_call_signatures = 0 " Shows function prototype while typing
"   " Time (milli sec) after which function call signature is shown
"   let g:jedi#show_call_signatures_delay=2


"   " C++ autocomplete - Use Ctrl-x Ctrl u to open suggestion list
"   Plugin 'Rip-Rip/clang_complete'
"   " path to directory where library can be found
"   lef g:clang_library_path='/usr/lib/llvm-3.5/lib/libclang.so.1'
"   " Use Ctrl-x Ctrl u to do autocompletion
"   let g:clang_complete_auto=0     " Disable autocompletion when :: or -> or . is encountered
"   " autoslect the first entry in menu
"   let g:clang_auto_select=1
"   " Work side by side with omnicomlete
"   let g:clang_omnicppcomplete_compliance=0

"   " Extra Plugin to move text up and down
"   " Move text using Alt-j (down) or alt-k (up)
"   Plugin 'matze/vim-move'

call plug#end()

" Colorscheme set to molokai after plug loads the molokai scheme
set background=dark
colorscheme molokai

set mat=2               " 2/10 th of second to blink when matching brackets
set hlsearch            " Enable search highliting
set colorcolumn=80      " Show the 80 character limit
set backspace=indent,eol,start  " Makes backspace key more powerful.
set nofoldenable        " Dont fold code when vim starts

" To search for visual selection, use //
vnoremap // y/<C-R>"<CR>

" remap for incremental search plugin
map /  <Plug>(incsearch-forward)

 "Press esc 2 times to clear search highlight
" it will rehighlit when searching again
nnoremap <silent> <Esc><Esc> <Esc>:nohl<CR><Esc>

"""""""""""""""""""""""""""" Functions to do stuff """""""""""""""""""""""""""""

" Damian Conway's Die Blinkënmatchen: highlight matches
" adjuest time in brackets
nnoremap <silent> n n:call HLNext(0.05)<cr>
nnoremap <silent> N N:call HLNext(0.05)<cr>

function! HLNext (blinktime)
let target_pat = '\c\%#'.@/
    let ring = matchadd('ErrorMsg', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction


let g:ctrlp_open_func = { 'files': 'CustomOpenFunc' }
function! CustomOpenFunc(action, line)
        call call('ctrlp#acceptfile', [':t', a:line])
endfunction

""""""""""""""""" cscope """"""""""""""""""""""""""""""

if has("cscope")
    set csprg=/usr/local/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

""" sahil #plug plugin #end


""" default CompileAndExecute function settings #begin
let g:cv = 1
let g:lib = ''
function! CompileAndExecute()
  "exe 'w'  " if saving before compile is enabled
  let command = ''
  " filename: http://vim.wikia.com/wiki/Get_the_name_of_the_current_file 
  " external commands: http://learnvimscriptthehardway.stevelosh.com/chapters/52.html
  let fileDir = expand('%:p:h')
  let fileName = expand('%:t')
  let exeFile = expand('%:t:r')
  "let fileNamePath = expand('%')
  "let exeFilePath = expand('%:r')

  if (expand('%:e') == 'cpp') 
     "echo  'g++ --std=c++14 -O3 inputfile.cpp -o outputFile `pkg-config --cflags --libs opencv`'
    " include extra libraries you want to use
    let openCV = ""
    if exists("g:cv")
      if (g:cv==1)
        let openCV = " `pkg-config --cflags --libs opencv` "
      endif
    endif

    let lib = ''
    if exists("g:lib")
      echo "using extra libraries: " . g:lib
      let lib = g:lib 
    endif

    let libraries = openCV . ' ' . lib
    "
    " execute in current directory
    "let compile = "g++ --std=c++14 -O3 " . fileNamePath . " -o " . exeFilePath . libraries 
    "let run = "./" . expand(exeFilePath)
    "let command = "bash -c " . '"' . compile1 . " ; " . run1 . '"'

    " execute in file directory
    let compile1 = "g++ --std=c++14 -O3 " . fileName . " -o " . exeFile . " " . libraries 
    let run1 = "./" . expand(exeFile)
    let ifCompileRun = compile1 . " ; " . "if [ $? -eq 0 ]; then " . run1 . " ; " . "fi"
    "let ifCompileRun = compile1 . " ; " . "echo $?"
    "let command = "bash -c " . '"' . "cd " . fileDir . " ; " . compile1 . " ; " . run1 . '"'
    let command = "bash -c " . '"' . "cd " . fileDir . " ; " . ifCompileRun . '"'

  elseif (expand('%:e') == 'py')
    "!python % 
    let script1 = "python " . fileName
    let command = "bash -c " . '"' . "cd " . fileDir . " ; " . script1 . '"'

  elseif (expand('%:e') == 'sh')
    "!python % 
    let script1 = "bash " . fileName
    let command = "bash -c " . '"' . "cd " . fileDir . " ; " . script1 . '"'
  endif

  "echom system(command) " "system standard output is not visible "
  exe "!" . command
  echo "# compiled and executed"
endfunction

" key maps"
"map <F7> :!python % <CR>
map <F7> : call CompileAndExecute() <CR>

""" Compile and execute #end

"" Session management #begin
"" Automated directory wise save and load sessions

function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
" Load Session only if filename as argument is not provided to vim
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
endif
au VimLeave * :call MakeSession()

"" Session management #ends

" paste as it is without restructuring, paste: paste as it is, nopaste: auto indent while editing
set pastetoggle=<F8> 

" show tab options for command completions at bottom of screen
set wildmenu

" marking before search, to go to position before search use mark `s
nnoremap / ms/
nnoremap ? ms?

" gvim settings
set guioptions-=T  "remove toolbar


" ################ CtrlC CtrlV copy paste like msvim ################
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>       "+gP
map <S-Insert>      "+gP

cmap <C-V>      <C-R>+
cmap <S-Insert>     <C-R>+


"### C-A : copy all, C-S increase numbers
nnoremap <C-A> magg"+yG`a
nnoremap <C-S> 

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>     <C-V>
vmap <S-Insert>     <C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>       <C-V>

