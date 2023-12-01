Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5B017D2;
	Fri,  1 Dec 2023 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaPocXJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70A3C433C9;
	Fri,  1 Dec 2023 23:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701471900;
	bh=8QM9HT8onEgqQAddB8/SA3iCORef5quAS35T+XsDQRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TaPocXJMVe5qtUJSPlh/Z3bfVfmippRoj18kOiQe5GTipg6nooHM35LWW5rZoxJ9f
	 neh3nMj12wovWs1Pc5X11kTcwaeNu8A6hKZZgKgK4pDa2rH1REtHMO15GDQDBAvy9R
	 wPCgBf+kLJAqpnZpgWqakzhTz58Cbe9AscZKZYsk=
Date: Sat, 2 Dec 2023 00:04:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Francis Laniel <flaniel@linux.microsoft.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
Message-ID: <2023120223-diagnosis-niece-3932@gregkh>
References: <20231130162133.035359406@linuxfoundation.org>
 <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>
 <2023120134-sabotage-handset-0b0d@gregkh>
 <4879383.31r3eYUQgx@pwmachine>
 <2023120155-mascot-scope-7bc6@gregkh>
 <4cf40ef6-058f-4472-88c9-3dc735175c85@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4cf40ef6-058f-4472-88c9-3dc735175c85@linaro.org>

On Fri, Dec 01, 2023 at 08:34:26AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 01/12/23 3:44 a. m., Greg Kroah-Hartman wrote:
> > Please take some time with a cross-compiler on the above listed
> > architectures and configurations to verify your changes do not break
> > anything again.
> 
> It failed in more architectures than we initially reported. FWIW, this error can be easily reproduced this way:
> 
>   tuxmake --runtime podman --target-arch arm     --toolchain gcc-8  --kconfig imx_v4_v5_defconfig

Fails for me:

$ ~/.local/bin/tuxmake  --runtime podman --target-arch arm     --toolchain gcc-8  --kconfig imx_v4_v5_defconfig 
Traceback (most recent call last):
  File "/home/gregkh/.local/bin/tuxmake", line 8, in <module>
    sys.exit(main())
             ^^^^^^
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/cli.py", line 170, in main
    build.run()
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/build.py", line 652, in run
    self.prepare()
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/build.py", line 318, in prepare
    self.runtime.prepare()
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/runtime.py", line 423, in prepare
    self.prepare_image()
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/runtime.py", line 443, in prepare_image
    do_pull()
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/utils.py", line 36, in retry_wrapper
    ret = func(*args, **kwargs)
          ^^^^^^^^^^^^^^^^^^^^^
  File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packages/tuxmake/runtime.py", line 441, in do_pull
    subprocess.check_call(pull)
  File "/usr/lib/python3.11/subprocess.py", line 408, in check_call
    retcode = call(*popenargs, **kwargs)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/subprocess.py", line 389, in call
    with Popen(*popenargs, **kwargs) as p:
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/subprocess.py", line 1026, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.11/subprocess.py", line 1950, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'podman'

Are you sure that's the right command line to use?  :)

thanks,

greg k-h
