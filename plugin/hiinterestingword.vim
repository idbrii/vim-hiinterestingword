" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.  Use
" <leader>0 to clear the highlights.

" Source:
" https://bitbucket.org/sjl/dotfiles/src/e6f6389e598f33a32e75069d7b3cfafb597a4d82/vim/vimrc#cl-2291

let s:base_match_id = 86750

function! ByeInterestingWord() " {{{
    " Clear all interesting words
    for n in range(1,6)
        let mid = s:base_match_id + n
        silent! call matchdelete(mid)
    endfor
endfunction

function! HiInterestingWord(n, is_visual) " {{{
    " Save our location.
    let view = winsaveview()

    let old_z = @z

    if a:is_visual
        " Yank the last selection into the z register.
        normal! gv"zy
    else
        " Yank the current word into the z register.
        normal! "zyiw
    endif

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = s:base_match_id + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    call winrestview(view)

    let @z = old_z
endfunction " }}}

" Mappings {{{

" Clear highlights
nnoremap <silent> <leader>0 :call ByeInterestingWord()<cr>

" Engage Highlights
for i in range(1,6)
    for mapmode in ['n', 'v']
        exec mapmode .'noremap <silent> <leader>'. i .' :call HiInterestingWord('. i .', '. (mapmode == 'v').')<cr>'
    endfor
endfor

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}
