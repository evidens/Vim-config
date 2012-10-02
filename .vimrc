" This file uses fold. Type zo -> open current fold; zR -> open all recursive
" Notes {
"
" F. Gabriel Gosselin custom vimrc <gabriel NOSPAM AT evidens DOT ca
" Inspired by
"   - http://spf13.com/post/perfect-vimrc-vim-config-file
"   - http://www.derekwyatt.org/vim/the-vimrc-file/my-vimrc-file/
"   - https://github.com/carlhuda/janus
"   - http://items.sjbach.com/319/configuring-vim-right
"   - http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" }

" Environment {
    " Startup {
          " When started as "evim", evim.vim will already have done these settings.
          if v:progname =~? "evim"
                finish
          endif

          " Use Vim settings, rather then Vi settings (much better!).
          " This must be first, because it changes other options as a side effect.
          set nocompatible

          " Set mapleader to , so it's consistent everywhere
          let mapleader = ","
    " }
    " Backups {
          " Place backups in a better place
          set backupdir=~/.vim_backups//
          set directory=~/.vim_backups//

          if has("vms")
                set nobackup    " do not keep a backup file, use versions instead
          else
                set backup        " keep a backup file
          endif
    " }
    " Bundle Support {

          fu! ConfigAddonManager()
                set runtimepath+=~/vim-addons/vim-addon-manager
                try
                    call vam#ActivateAddons([
                           \'snipMate', 'snipmate-snippets',
                           \ 'The_NERD_tree', 'The_NERD_Commenter',
                           \ 'PowerLine',
                           \ 'Solarized',
                           \ 'IndentAnything',
                           \ 'project.tar.gz',
                           \ 'FuzzyFinder', 'ack',
                           \ 'matchit.zip', 'AutoClose',
                           \ 'repeat', 'surround', 'taglist',
                           \ 'html5', 'vim-coffee-script',
                           \ 'twig',
                           \ 'ack',
                           \ 'Align294',
                           \ 'Javascript_Indentation',
                           \ 'Headlights',
                           \ 'Markdown'])
                catch /.*/
                    echoe v:exception
                endtry
          endf

          call ConfigAddonManager()
    " }
    " GUI Behaviour {
          " In many terminal emulators the mouse works just fine thus enable it.
          if has('mouse')
                set mouse=a
          endif

          " Set very sparse options on gvim
          set guioptions=ac
    "}

    " Set visual bell -- no beeping!
    set vb

    " Allow hidden buffers
    set hidden

    " This is the timeout used while waiting for user input on a multi-keyed macro
    " or while just sitting and waiting for another key to be pressed measured
    " in milliseconds.
    "
    " i.e. for the ",d" command, there is a "timeoutlen" wait period between the
    "        "," key and the "d" key.  If the "d" key isn't pressed before the
    "        timeout expires, one of two things happens: The "," command is executed
    "        if there is one (which there isn't) or the command aborts.
    set timeoutlen=500
" }

" Display {
    set ruler		 " Show the cursor position all the time
    set number     " Show line number"
    set cursorline " Highlight the current cursor line


    " When the page starts to scroll, keep the cursor 8 lines from
    " the top and 5 lines from the bottom
    set scrolloff=5

    " Command-line {
          " Make command line two-lines high
          set ch=2

          " Display current mode
          set showmode

          " Enable enhanced command-line completion. Presumes you have compiled with
          " +wildmenu. See :h 'wildmenu'
          set wildmenu
    " }

    " Status-line {
          " Set the status line the way I like it
          set stl=%f\ %y%m\ Line:\ %l/%L[%p%%]\ Col:\ %c\ [0x%B]

          " Always show the status line
          set laststatus=2
    " }


    " Syntax colouring {
          " Switch syntax highlighting on, when the terminal has colours
          if &t_Co > 2 || has("gui_running")
              syntax on
          endif

          " Syntax coloring lines that are too long just slows down the world
          set synmaxcol=2048

          syntax enable
          set background=dark
          colorscheme solarized
    "}

    " MacVim-specific options {
          if has('gui_macvim')
            " Fullscreen takes up entire screen
            set fuoptions=maxhorz,maxvert
            set colorcolumn=80

            " Allow meta (option) to be used in key bindings on map
            set macmeta
          endif
    " }

    " Don't update the display while executing macros
    set lazyredraw
" }

" Editing {
    " allow backspacing over everything in insert mode
    set backspace=indent,eol,start

    " How invisibles will be displayed
    set listchars=trail:·,tab:▸\ ,eol:¬

    " Set proper language
    set spelllang=en_gb
    set spell

    " Set default font
    set gfn=Monaco\ for\ Powerline:h14

    " Set consistent tab stops
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
    set expandtab
    " Makes indent align with shiftwidth
    set shiftround

    " Allow the cursor to go in to "invalid" places
    set virtualedit=all

    set history=100 " keep 50 lines of command line history
    set showcmd     " display incomplete commands

    " Search options {
          " Use more standard regex
          nnoremap / /\v
          vnoremap / /\v

          set incsearch  " do incremental searching
          set hlsearch   " Switch on highlighting the last used search pattern.

          set ignorecase " Ignore case unless...
          set smartcase  " ...a capital letter is specified

          set gdefault   " Use line global replace default

          nnoremap <leader><space> :noh<cr>  " Turn off highlighting once you're done searching
    " }

    " Don't use Ex mode, use Q for formatting
    map Q gq

    " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
    " so that you can undo CTRL-U after inserting a line break.
    inoremap <C-U> <C-G>u<C-U>


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

          autocmd FileType python set omnifunc=pythoncomplete#Complete
          autocmd FileType python setlocal sts=4 ts=4 sw=4 tw=79
          autocmd FileType python setlocal foldmethod=indent
          autocmd FileType python set foldlevel=99
          autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
          autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
          autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    else
          set autoindent  " always set autoindenting on
    endif " has("autocmd")

    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.
    " Only define it when not defined already.
    if !exists(":DiffOrig")
          command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                    \ | wincmd p | diffthis
    endif
" }

" Mappings {

    " Toggle paste mode
    nmap <silent> ,p :set invpaste<CR>:set paste?<CR>

    " cd to the directory containing the file in the buffer
    nmap <silent> ,cd :lcd %:h<CR>
    nmap <silent> ,md :!mkdir -p %:p:h<CR>

    " Toggle show invisibles
    nmap <silent> ,s :set nolist!<CR>

    " Toggle relative lines
    nmap <silent> ,r :set relativenumber!<CR>
    " Complete tags
    imap <M-D-.> </<C-X><C-O>

    " CTags generate
    map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
    nnoremap <F8> :!/usr/local/bin/ctags -R --python-kinds=-i *.py<CR>

    " TagExplorer
    nnoremap <silent> ,t :TlistToggle<CR>

    " Use tab to toggle opening/closing parens
    "nnoremap <tab> %
    "vnoremap <tab> %

    " Clean trailing spaces in a file
    nmap <Leader>W :%s/\s\+$//<cr>:let @/=''<CR>

    " Toggle mac meta (allow special character typing OR meta binding)
    nmap <Leader>M :set macmeta!

    " Shortcut to set filetype to Django template (for new files)
    nmap <silent> ,dj :set filetype=htmldjango.html<CR>
    " Vimrc {
          " Let's make it easy to edit this file (mnemonic for the key sequence is
          " 'e'dit 'v'imrc)
          nmap <silent> <leader>ev :split $MYVIMRC<cr>

          " And to source this file as well (mnemonic for the key sequence is
          " 's'ource 'v'imrc)
          nmap <silent> <leader>sv :so $MYVIMRC<cr>
    " }
    " Window navigation {
          nmap <silent> ,h :wincmd h<CR>
          nmap <silent> ,j :wincmd j<CR>
          nmap <silent> ,k :wincmd k<CR>
          nmap <silent> ,l :wincmd l<CR>
    " }

    " Mappings inspired from http://learnvimscriptthehardway.stevelosh.com {
        " Move line up/down
        nnoremap - ddp
        nnoremap _ ddkP

        " Delete current line
        inoremap <c-d> <esc>ddi

        " Caplitalise current word
        inoremap <c-u> <esc>viwUea
        nnoremap <c-u> viw


    " }
" }

" Plugin-specific settings {
    " FuzzyFinder {
        function! NERDSafe(cmdname)
            if stridx(bufname("%"),"NERD_tree") >= 0
                :wincmd w
            endif
            exec a:cmdname
        endfunction
        noremap <leader>ff :call NERDSafe("FufFile")<CR>
        noremap <leader>fb :call NERDSafe("FufBuffer")<CR>
        nmap ,ft :FufTag<CR>
    " }
    " Project {
          let g:proj_window_width=40
    " }
    " NERDTree {
          let NERDTreeIgnore=['\.pyc$', '\~$']
          nmap ,n :NERDTreeToggle<CR>
          nmap ,b :NERDTreeFromBookmark
    " }
    " NERDCommenter {
          " Command-/ to toggle comments
          map <D-/> <plug>NERDCommenterToggle
          imap <D-/> <Esc><plug>NERDCommenterToggle i
    " }
    " TagList support {
          let Tlist_Use_Right_Window = 1
          nnoremap <F4> :TListToggle<CR>
    " }

    let g:Powerline_symbols = 'fancy'
    " }

" Language-specific settings {
    " Coffee Script {
        au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
        au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
    " }

" }

" Useful Janus functions {
    " Project Tree
    if exists("loaded_nerd_tree")
        autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
        autocmd FocusGained * call s:UpdateNERDTree()
        autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
    endif

    " Close all open buffers on entering a window if the only
    " buffer that's left is the NERDTree buffer
    function! s:CloseIfOnlyNerdTreeLeft()
        if exists("t:NERDTreeBufName")
          if bufwinnr(t:NERDTreeBufName) != -1
            if winnr("$") == 1
                q
            endif
          endif
        endif
    endfunction

    " If the parameter is a directory, cd into it
    function! s:CdIfDirectory(directory)
        let explicitDirectory = isdirectory(a:directory)
        let directory = explicitDirectory || empty(a:directory)

        if explicitDirectory
            exe "cd " . fnameescape(a:directory)
        endif

        " Allows reading from stdin
        " ex: git diff | mvim -R -
        if strlen(a:directory) == 0
            return
        endif

        if directory
            NERDTree
            wincmd p
            bd
        endif

        if explicitDirectory
            wincmd p
        endif
    endfunction

    " NERDTree utility function
    function! s:UpdateNERDTree(...)
        let stay = 0

        if(exists("a:1"))
            let stay = a:1
        end

        if exists("t:NERDTreeBufName")
            let nr = bufwinnr(t:NERDTreeBufName)
            if nr != -1
                exe nr . "wincmd w"
                exe substitute(mapcheck("R"), "<CR>", "", "")
                if !stay
                    wincmd p
                end
            endif
        endif

        if exists(":CommandTFlush") == 2
            CommandTFlush
        endif
    endfunction

" }

" Abbreviations {
    iabbrev ot to
    iabbrev teh the
" }

" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell sts=4 ts=4 sw=4:
