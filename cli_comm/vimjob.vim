    " Create a channel log so we can see what happens.
	call ch_logfile('logfile', 'w')

	" Function handling a line of text that has been typed.
	func TextEntered(text)
	  " Send the text to a shell with Enter appended.
	  call ch_sendraw(g:shell_job, a:text .. "\n")
	endfunc

	" Function handling output from the shell: Add it above the prompt.
	func GotOutput(channel, msg)
	  call append(line("$") - 1, "- " .. a:msg)
	endfunc

	" Function handling the shell exits: close the window.
	func JobExit(job, status)
	  quit!
	endfunc

	" Start a shell in the background.
	let shell_job = job_start(["/bin/sh"], #{
		\ out_cb: function('GotOutput'),
		\ err_cb: function('GotOutput'),
		\ exit_cb: function('JobExit'),
		\ })

	new
	set buftype=prompt
	let buf = bufnr('')
	call prompt_setcallback(buf, function("TextEntered"))
	eval prompt_setprompt(buf, "shell command: ")

	" start accepting shell commands
	startinsert
<
The same in |Vim9| script: >

	vim9script

	# Create a channel log so we can see what happens.
	ch_logfile('logfile', 'w')

	var shell_job: job

	# Function handling a line of text that has been typed.
	def TextEntered(text: string)
	  # Send the text to a shell with Enter appended.
	  ch_sendraw(shell_job, text .. "\n")
	enddef

	# Function handling output from the shell: Add it above the prompt.
	def GotOutput(channel: channel, msg: string)
	  append(line("$") - 1, "- " .. msg)
	enddef

	# Function handling the shell exits: close the window.
	def JobExit(job: job, status: number)
	  quit!
	enddef

	# Start a shell in the background.
	shell_job = job_start(["/bin/sh"], {
				 out_cb: GotOutput,
				 err_cb: GotOutput,
				 exit_cb: JobExit,
				 })

	new
	set buftype=prompt
	var buf = bufnr('')
	prompt_setcallback(buf, TextEntered)
	prompt_setprompt(buf, "shell command: ")

	# start accepting shell commands
	startinsert

