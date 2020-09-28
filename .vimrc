set nocompatible              " Vi와 호환 불가 설정, 필수
filetype off                  " 필수

" Vundle을 포함시키기 위해 runtime 경로를 설정하고 초기화
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" 기존 경로 대신 Vundle이 플러그인을 설치할 경로를 입력하십시오.
"call vundle#begin('~/some/path/here')

" Vundle이 스스로를 관리하도록 설정, 필수
Plugin 'VundleVim/Vundle.vim'
" 당신의 모든 플러그인은 다음 명령어 이전에 추가되어야 합니다
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'https://github.com/rakr/vim-one.git'
Plugin 'scrooloose/nerdtree'
Plugin 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plugin 'beikome/cosme.vim'
Plugin 'https://github.com/easymotion/vim-easymotion.git'

call vundle#end()            " 필수
filetype plugin indent on    " 필수

Plugin 'AutoComplPop'

set t_Co=256
color cosme
syntax on
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:EasyMotion_leader_key = '<Leader>'
set shiftwidth=4
set expandtab
"let g:airline_theme='one'
"colorscheme one
"set background=light

set cursorline
set smartindent

function! InsertTapWrapper()
   let col=col('.')-1
   if !col||getline('.')[col-1]!~'\k'
      return "\<TAB>"
   else
      if pumvisible()
         return "\<C-N>"
      else
         return "\<C-N>\<C-P"
      end
   endif
endfunction

inoremap <tab> <c-r>=InsertTapWrapper()<cr>

set pastetoggle=<F2>
set showmode

map <F3> :NERDTreeToggle<cr>
