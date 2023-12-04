Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0F92510C
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iRyuHWIz"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6ce46470647so615063b3a.1
        for <patches@lists.linux.dev>; Mon, 04 Dec 2023 06:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701701738; x=1702306538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECEVktnNpUXpGoY7MofBhZHrCIiW0FRv5VOwOFl73MQ=;
        b=iRyuHWIzg5W7PmX00P2vvRynl18wrzURiZYS0uo/XeA/peAaxyKPg+OS5eHVwf+AzC
         s9FaY1c1ZYapQO7NrP4tHFhf163491IUX5H9ke4XWZS43jk4ofO0nF6BAu7i6HpN4jgh
         OfGScIKI8HXGLNPdW8Lbyp5tgccJQhgEEDP4oSdJ0Jlh68fZAp6YEScTorUj+h82nOnA
         SUF9sHhwgzw8+mQqw4LuCFKBLDdQlOvzvgsyAgBwTCHVld/4/WoQTe/Al3La04QmQsw7
         EJlGl3s7vVWr2YluALXPHWwpA68bppGqfei14FMhibtb5KQKbT15zwAYLO97TRU2CwzK
         qt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701701738; x=1702306538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECEVktnNpUXpGoY7MofBhZHrCIiW0FRv5VOwOFl73MQ=;
        b=N7lGvIbUfjbvW/P89spAXNZTY+p+5jPY4i5yNBcdSoXpZtP9ewCqWHiHV7pI6wVzSt
         2tByHGefGTHBeKJNF4SWlK2Wxc/haLjHZ7GdY0FAIruu+Xy1llrWE1Q0QPTUwBxIwp23
         OXbox158Jb9hwZkNMJCD2OVWNZUUmA/Sl4LR8cCYlpW1ZuazbYJMIUQQ/aY6kpu1k4At
         CV/GbWx5VstYT4QOsD0Skqc5cB6s4cUPXI66IP8XybP5eC5KBxjmv633QhbY3juhB4bs
         KEXycyovnZreZwp57mOJqiL7RX1MyNlAmV5UASj+a0EeHzoIrlgmToCiR1EOJVkPrRI3
         Nlyg==
X-Gm-Message-State: AOJu0Yy90DY38jGf2TmRdpzcfchR/HDfW3g4/eZ9GlnPlsxhkqYJoIR3
	8Y21qEOC8yjvoak25ByIiGJXtydwexKYu8Xc/Ibq0g==
X-Google-Smtp-Source: AGHT+IE61hyEtN0sXTa9zACdyfMXQB5XPSbT1eqxKDZKJptlwkTbAzQaMLBoHLqfOCG77V6pdVueQ5n8yk1VPt4SbZE=
X-Received: by 2002:a05:6a00:2e21:b0:6cb:d24b:878d with SMTP id
 fc33-20020a056a002e2100b006cbd24b878dmr2212551pfb.2.1701701738519; Mon, 04
 Dec 2023 06:55:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231130162133.035359406@linuxfoundation.org> <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>
 <2023120134-sabotage-handset-0b0d@gregkh> <4879383.31r3eYUQgx@pwmachine>
 <2023120155-mascot-scope-7bc6@gregkh> <4cf40ef6-058f-4472-88c9-3dc735175c85@linaro.org>
 <2023120223-diagnosis-niece-3932@gregkh>
In-Reply-To: <2023120223-diagnosis-niece-3932@gregkh>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 4 Dec 2023 08:55:27 -0600
Message-ID: <CAEUSe78X7_bwDiHwxS1u0TNTyuqDifoa36yjh=BgcByPp1i86w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francis Laniel <flaniel@linux.microsoft.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Fri, 1 Dec 2023 at 17:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 01, 2023 at 08:34:26AM -0600, Daniel D=C3=ADaz wrote:
[...]
> > It failed in more architectures than we initially reported. FWIW, this =
error can be easily reproduced this way:
> >
> >   tuxmake --runtime podman --target-arch arm     --toolchain gcc-8  --k=
config imx_v4_v5_defconfig
>
> Fails for me:
>
> $ ~/.local/bin/tuxmake  --runtime podman --target-arch arm     --toolchai=
n gcc-8  --kconfig imx_v4_v5_defconfig
> Traceback (most recent call last):
>   File "/home/gregkh/.local/bin/tuxmake", line 8, in <module>
>     sys.exit(main())
>              ^^^^^^
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/cli.py", line 170, in main
>     build.run()
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/build.py", line 652, in run
>     self.prepare()
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/build.py", line 318, in prepare
>     self.runtime.prepare()
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/runtime.py", line 423, in prepare
>     self.prepare_image()
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/runtime.py", line 443, in prepare_image
>     do_pull()
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/utils.py", line 36, in retry_wrapper
>     ret =3D func(*args, **kwargs)
>           ^^^^^^^^^^^^^^^^^^^^^
>   File "/home/gregkh/.local/pipx/venvs/tuxmake/lib/python3.11/site-packag=
es/tuxmake/runtime.py", line 441, in do_pull
>     subprocess.check_call(pull)
>   File "/usr/lib/python3.11/subprocess.py", line 408, in check_call
>     retcode =3D call(*popenargs, **kwargs)
>               ^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.11/subprocess.py", line 389, in call
>     with Popen(*popenargs, **kwargs) as p:
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.11/subprocess.py", line 1026, in __init__
>     self._execute_child(args, executable, preexec_fn, close_fds,
>   File "/usr/lib/python3.11/subprocess.py", line 1950, in _execute_child
>     raise child_exception_type(errno_num, err_msg, err_filename)
> FileNotFoundError: [Errno 2] No such file or directory: 'podman'
>
> Are you sure that's the right command line to use?  :)

Yes, it just needs `podman' to be installed. The Tuxmake team will
change that cryptic message into something easier to parse.

FWIW, `--runtime docker` also works (if Docker is installed), and
`--runtime null` simply makes Tuxmake rely on the cross-compilers you
have installed.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
