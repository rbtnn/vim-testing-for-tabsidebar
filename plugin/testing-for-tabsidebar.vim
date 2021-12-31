
let g:loaded_testing_for_tabsidebar = 1

if !has('tabsidebar')
	finish
endif

function! s:main() abort
	let saved_showtabsidebar = &showtabsidebar
	let saved_tabsidebarcolumns = &tabsidebarcolumns
	let saved_showtabline = &showtabline
	let prop_id = 'prop_id'
	let high = 'Pmenu'
	try
		set showtabsidebar=2
		set tabsidebarcolumns=20
		set showtabline=0
		tabnew
		setlocal buftype=nofile
		call setbufline(bufnr(), 1, ['aaaaa', 'bbbbb', 'ccccc'])
		vsplit
		split
		split
		split
		split
		wincmd w

		call popup_clear()

		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   '+-- popup_create(line: 1, col: 1)',
			\ ], {
			\   'line': 1,
			\   'col': 1,
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   '+-- popup_create(pos: center)',
			\ ], {
			\   'pos': 'center',
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		call popup_atcursor('popup_atcursor()', {
			\   'highlight': high,
			\ })

		for w in filter(getwininfo(), {i,x -> x['tabnr'] == tabpagenr() })
			call popup_create([
				\   printf('* <- getwininfo(winrow: %d, wincol: %d)', w['winrow'], w['wincol']),
				\ ], {
				\   'line': w['winrow'],
				\   'col': w['wincol'],
				\   'zindex': 200,
				\   'highlight': high,
				\ })
		endfor

		let w = win_screenpos(2)
		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   printf('+-- win_screenpos(line: %d, col: %d)', w[0], w[1]),
			\ ], {
			\   'line': w[0],
			\   'col': w[1],
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		let w = screenpos(3, 1, 1)
		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, col: %d)', w['row'], w['col']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['col'],
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		let w = screenpos(4, 1, 1)
		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, endcol: %d)', w['row'], w['endcol']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['endcol'],
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		let w = screenpos(5, 1, 1)
		call popup_create([
			\   '*',
			\   '^',
			\   '|',
			\   printf('+-- screenpos(line: %d, curscol: %d)', w['row'], w['curscol']),
			\ ], {
			\   'line': w['row'],
			\   'col': w['curscol'],
			\   'zindex': 100,
			\   'highlight': high,
			\ })

		call prop_type_add(prop_id, {})
		call prop_add(1, 1, {
			\   'length': 1,
			\   'type': prop_id,
			\   'id': 1,
			\ })
		call popup_create([
			\ printf('* <- popup_create with prop(line: %d, col: %d)', -4, -1),
			\ ], {
			\   'line': -4,
			\   'col': -1,
			\   'textprop': prop_id,
			\   'textpropid': 1,
			\   'zindex': 100,
			\   'highlight': high,
			\ })

	finally
		redraw
		echo 'Is this Okey?'
		call getchar()
		tabclose
		call popup_clear()
		call prop_type_delete(prop_id, {})
		let &showtabsidebar = saved_showtabsidebar
		let &tabsidebarcolumns = saved_tabsidebarcolumns
		let &showtabline = saved_showtabline
	endtry
endfunction

command! -bar -nargs=0 TestingForTabsidebar :call s:main()

nnoremap <nowait><space>   :<C-u>TestingForTabsidebar<cr>

