" Set tabs
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" turn off folded colors
hi folded ctermfg=none ctermbg=none

" turn off auto-comment
setlocal fo-=t fo-=r fo-=q fo-=o

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" allow us to use <Space> in normal mode
:nnoremap <Space> i<Space><Esc>

" allow folding of Perl subs
"let perl_fold = 1

function GetPerlFold()
  if getline(v:lnum) =~ '^\s*sub\s'
    return ">1"
  elseif getline(v:lnum) =~ '\}\s*$'
    let my_perlnum = v:lnum
    let my_perlmax = line("$")
    while (1)
      let my_perlnum = my_perlnum + 1
      if my_perlnum > my_perlmax
        return "<1"
      endif
      let my_perldata = getline(my_perlnum)
      if my_perldata =~ '^\s*\(\#.*\)\?$'
        " do nothing
      elseif my_perldata =~ '^\s*sub\s'
        return "<1"
      else
        return "="
      endif
    endwhile
  else
    return "="
  endif
endfunction
setlocal foldexpr=GetPerlFold()
setlocal foldmethod=expr


" remove vim backup files

function RemoveVimBackup()
    w
    ! find . -name "*~" | xargs rm
endfunction


" do a uninst/reinst of Perl module

function PerlBuild()
    w
    ! make distclean
    ! perl Makefile.PL
    ! make
    ! make install
endfunction


" do just an install of Perl module

function MakeInstall()
    w
    ! make install
endfunction


" commit to git repo

function GitCommit()
    w
    ! git commit -a
endfunction

" push to git repo

function GitPush()
    w
    ! git push
endfunction

" commit and push to git repo

function GitCommitAndPush()
    w
    ! git commit -a && git push
endfunction

" commit to hg repo

function HgCommit()
    w
    ! hg commit
endfunction


" push to hg repo

function HgPush()
    w
    ! hg push
endfunction

" push and commit to hg repo

function HgCommitAndPush()
    w
    ! hg commit && hg push
endfunction


if has("vms")
  set nobackup        " do not keep a backup file, use versions instead
else
  set backup          " keep a backup file
endif
set history=50        " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch        " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" need to specify comments, as they were pissed on by sourcing other files

au FileType * setlocal comments=

" -------------------
" $work specific
" -------------------

" source ticket .vimrc

if filereadable(glob("~/.vimrc_ticket"))
    source ~/.vimrc_ticket
endif

"
" custom key mappings
"

" map ii to ESC

map! ii <Esc>

" execute file currently being edited

map ,run :!./%

" maps custom functions

map ,rvb :call RemoveVimBackup()<CR>
map ,rmi :call PerlBuild()<CR>
map ,mi :call MakeInstall()<CR>
map ,ci :call SvnCommit()<CR>
map ,hgc :call HgCommit()<CR>
map ,hgp :call HgPush()<CR>
map ,hci :call HgCommitAndPush()<CR>
map ,gc :call GitCommit()<CR>
map ,gp :call GitPush()<CR>
map ,gi :call GitCommitAndPush()<CR>

