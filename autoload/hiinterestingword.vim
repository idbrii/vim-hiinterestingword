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

function! hiinterestingword#ByeInterestingWord() " {{{
    " Clear all interesting words
    for n in range(1,6)
        let mid = s:base_match_id + n
        silent! call matchdelete(mid)
    endfor
endfunction

function! hiinterestingword#HiInterestingWord(n, is_visual) " {{{
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
    let pat = escape(@z, '\')
    if !a:is_visual
        let pat = '\<' . pat . '\>'
    endif
    let pat = '\V' . pat

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    let @z = old_z

    " Move back to our original location.
    call winrestview(view)

    if a:is_visual
        " Re-select and esc to restore cursor position. Esc is required to
        " clear visual selection (exec is required to use Esc).
        exec "normal! gv\<Esc>"
    endif
endfunction " }}}

" Default Highlights {{{

function! hiinterestingword#SetupHighlights()
    hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
    hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
    hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
    hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
    hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
    hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
endfunction

" We're ready to set these up as soon as this file is loaded (because someone
" tried to highlight a word).
call hiinterestingword#SetupHighlights()

" }}}
