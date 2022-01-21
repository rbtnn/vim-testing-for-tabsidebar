
let g:loaded_testing_for_tabsidebar = 1

if !has('tabsidebar')
	finish
endif

function! s:show_popupwins() abort
	let saved_showtabsidebar = &showtabsidebar
	let saved_tabsidebarcolumns = &tabsidebarcolumns
	let saved_showtabline = &showtabline
	let prop_id = 'prop_id'
	let high = 'TestingForTabSideBarPopupwin'
	highlight TestingForTabSideBarPopupwin guibg=#7777ff guifg=#000000
	try
		set showtabsidebar=2
		set tabsidebarcolumns=20
		set showtabline=0
		tabnew
		setlocal buftype=nofile
		call setbufline(bufnr(), 1, repeat([repeat('.', &columns)], &lines))
		vsplit
		split
		split
		split
		split
		wincmd w

		call popup_clear()

		for line in [1, &lines]
			for col in [1, &columns - &tabsidebarcolumns]
				call popup_create([
					\   '@',
					\ ], {
					\   'line': line,
					\   'col': col,
					\   'highlight': high,
					\ })
			endfor
		endfor

		call popup_create([
			\   '@',
			\   '^',
			\   '|',
			\   '+-- popup_create(line: 1, col: 1)',
			\ ], {
			\   'line': 1,
			\   'col': 1,
			\   'highlight': high,
			\   'mask': [[2, 33, 1, 3]],
			\ })

		call popup_create([
			\   'popup_create(pos: center)',
			\ ], {
			\   'pos': 'center',
			\   'padding': [3, 3, 3, 3],
			\   'highlight': high,
			\ })

		call popup_atcursor('popup_atcursor()', {
			\   'highlight': high,
			\ })

		for w in filter(getwininfo(), {i,x -> x['tabnr'] == tabpagenr() })
			call popup_create([
				\   printf('@ <- getwininfo(winrow: %d, wincol: %d)', w['winrow'], w['wincol']),
				\ ], {
				\   'line': w['winrow'],
				\   'col': w['wincol'],
				\   'highlight': high,
				\ })
		endfor

		let w = win_screenpos(2)
		call popup_create([
			\   '@',
			\   '^',
			\   '|',
			\   printf('+-- win_screenpos(line: %d, col: %d)', w[0], w[1]),
			\ ], {
			\   'line': w[0],
			\   'col': w[1],
			\   'highlight': high,
			\   'mask': [[2, 35, 1, 3]],
			\ })

		let w = screenpos(3, 1, 1)
		call popup_create([
			\   '@',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, col: %d)', w['row'], w['col']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['col'],
			\   'highlight': high,
			\   'mask': [[2, 31, 1, 3]],
			\ })

		let w = screenpos(4, 1, 1)
		call popup_create([
			\   '@',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, endcol: %d)', w['row'], w['endcol']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['endcol'],
			\   'highlight': high,
			\   'mask': [[2, 34, 1, 3]],
			\ })

		let w = screenpos(5, 1, 1)
		call popup_create([
			\   '@',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, curscol: %d)', w['row'], w['curscol']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['curscol'],
			\   'highlight': high,
			\   'mask': [[2, 35, 1, 3]],
			\ })

		call prop_type_add(prop_id, {})
		call prop_add(1, 1, {
			\   'length': 1,
			\   'type': prop_id,
			\   'id': 1,
			\ })
		call popup_create([
			\ printf('@ <- popup_create with prop(line: %d, col: %d)', -4, -1),
			\ ], {
			\   'line': -4,
			\   'col': -1,
			\   'textprop': prop_id,
			\   'textpropid': 1,
			\   'highlight': high,
			\ })

	finally
		redraw
		echo 'Is this okey?'
		call getchar()
		tabclose
		call popup_clear()
		call prop_type_delete(prop_id, {})
		let &showtabsidebar = saved_showtabsidebar
		let &tabsidebarcolumns = saved_tabsidebarcolumns
		let &showtabline = saved_showtabline
	endtry
endfunction

function! s:term_in_popupwin() abort
	let bnr = term_start(&shell, {
		\   'hidden': 1,
		\   'term_finish': 'close',
		\ })
	call popup_create(bnr, {
		\   'minwidth': &columns / 2,
		\   'maxwidth': &columns / 2,
		\   'minheight': &lines / 3,
		\   'maxheight': &lines / 3,
		\   'border': [],
		\   'padding': [],
		\   'title': ' ' .. &shell .. ' ',
		\   'borderhighlight': ['Normal', 'Normal', 'Normal', 'Normal'],
		\   'borderchars': (&ambiwidth == 'single' && &encoding == 'utf-8')
		\     ? [nr2char(0x2500), nr2char(0x2502), nr2char(0x2500), nr2char(0x2502),
		\        nr2char(0x250c), nr2char(0x2510), nr2char(0x2518), nr2char(0x2514)]
		\     : [],
		\ })
endfunction

command! -bar -nargs=0 TestingForTabsidebarShowPopupwins  :call s:show_popupwins()
command! -bar -nargs=0 TestingForTabsidebarTermInPopupwin :call s:term_in_popupwin()

