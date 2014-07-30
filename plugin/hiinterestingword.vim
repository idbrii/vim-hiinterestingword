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

" Clear highlights
nnoremap <silent> <leader>0 :call hiinterestingword#ByeInterestingWord()<cr>

" Engage Highlights
for i in range(1,6)
    for mapmode in ['n', 'v']
        exec mapmode .'noremap <silent> <leader>'. i .' :call hiinterestingword#HiInterestingWord('. i .', '. (mapmode == 'v').')<cr>'
    endfor
endfor

" vim:et:sw=4
