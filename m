Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED16A21
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749F5C4339E
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674458912;
	bh=tDZSyDGWUdOFrSfldiEN29lT3lN2KENZc5nb4MvHF78=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IsP0wjxDEnFHvne1OyWxEIrR+cVRvkUSvZAuvBG8Y5Lmf1q12/B3Yuyvtu3Hmv8G7
	 fZ9mRPHO7EjkX+faagLXYDpQENaQNOPKLEObyPSWVKHL/GA++/Iinh967Ae9l13reA
	 fQtMljmoylteB+aIC8v4oeuegX4gffeyea/7w/f0tgEAQIN4+zYhQNAPLUVZCWBCVd
	 E+83tMYuk7ZlzxR428SXUTG2znRE9vT98AlcRqnleOSiWxW/mJy2C5kKLDxhozm7fj
	 VZQokaquQNmMu4P+oFRNiwXVG5Qha9pYullUApeVyDfBSbsxpxRo7yqizZutKeyVZb
	 RJbbaaIP9gUNw==
Received: by mail-lf1-f42.google.com with SMTP id g13so16824180lfv.7
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 23:28:32 -0800 (PST)
X-Gm-Message-State: AFqh2konCI32ExYT29oa3vDLFKZGjHFDXr8mpZJ9Us2M1/1c6OL53BXM
	oVaIi3o9HccJH3IS0Yyp5l0/tAYz/HkUZtK/nuQ=
X-Google-Smtp-Source: AMrXdXuwSrrvsm09tpsZA2C2PMEHa2dTiiOyrGKO8XhtVl4LMbWCyJAWnz611NXzHAoNEMS28NhTboUYuypfamEuWXA=
X-Received: by 2002:a05:6512:118a:b0:4cc:9d69:4703 with SMTP id
 g10-20020a056512118a00b004cc9d694703mr2418365lfr.110.1674458910440; Sun, 22
 Jan 2023 23:28:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150232.736358800@linuxfoundation.org> <CA+G9fYsEvpCj_vSFLxkKA6tzdNOhimqZYF+WCLKYAiNLtrMvsA@mail.gmail.com>
 <Y842R2KIhUL9XMUi@kroah.com>
In-Reply-To: <Y842R2KIhUL9XMUi@kroah.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 23 Jan 2023 08:28:18 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
Message-ID: <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2023 at 08:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 23, 2023 at 12:39:55PM +0530, Naresh Kamboju wrote:
> > On Sun, 22 Jan 2023 at 20:46, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.90 release.
> > > There are 117 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.15.90-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build regressions found on sh:
> >    - build/gcc-8-dreamcast_defconfig
> >    - build/gcc-8-microdev_defconfig
> >
> >
> > Build error logs:
> >
> > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > defined in discarded section `.exit.text' of crypto/algboss.o
> > `.exit.text' referenced in section `__bug_table' of
> > drivers/char/hw_random/core.o: defined in discarded section
> > `.exit.text' of drivers/char/hw_random/core.o
> > make[1]: *** [/builds/linux/Makefile:1218: vmlinux] Error 1
> >
> > Bisection points to this commit,
> >     arch: fix broken BuildID for arm64 and riscv
> >     commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> >
> > Ref:
> > upstream discussion thread,
> > https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
>
> Argh, what a mess.  Ok, let me rip out that commit (and the "fixes up
> that commit") series from the trees and push out a -rc2 in a few hours
> after I wake up.  I was worried about that one, and I should have
> trusted my first instinct...
>

The patch in question has

    Fixes: 994b7ac1697b ("arm64: remove special treatment for the link
order of head.o")
    Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link
order of head.o")

both of which were introduced in the current v6.2 cycle.

Neither of those are marked for stable, are obviously non-stable
material, and were not queued up themselves.

So how did we end up queuing these in the first place?
