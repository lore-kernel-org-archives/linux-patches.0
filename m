Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E1810E8;
	Thu,  1 Dec 2022 06:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC70AC433D6;
	Thu,  1 Dec 2022 06:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669877847;
	bh=BaMgJwUiCoBEvSeqAqOxE4cJJS5gWcuzwMHMoycHemA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HrvNrrwsCHIR+VOhcph/ADMxgw6TU79tSXgLD74kurH6jlxVx9XTYE9kWzZzxvyCZ
	 htajgwAl5PROnnZCCK2IqOJJmdsaayfbhRGszVeM6Qa5cGkVgx0lYZYSyq6Q1CkUy1
	 mFVUjUkgrixuPhl+6ib2u3DKY8vX9ZDy8+ZFnqcZ5AJhAhSnojcPZEIw4MFiUtMc9O
	 yuCK5wb0+/itgtxcNLTXbmgDozPRRHZCVCsr2NA0jpOIznu3GTwelwYPXrFi6QTkRI
	 2Kqf3Y3MRx7jQCwX/94ID8USoPCUEZaalc5fmjHoM9fE7HBp5DS7+x27lMLkpUrV+q
	 wF9lH8sFyP52g==
Date: Wed, 30 Nov 2022 23:57:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, bpf <bpf@vger.kernel.org>,
	llvm@lists.linux.dev
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4hQVCBYfwU0abvO@dev-arch.thelio-3990X>
References: <20221130180544.105550592@linuxfoundation.org>
 <CA+G9fYuJVxhKbeN9OGCr2_zyfa1k3j4DS1gAoTW0P89Eyz2FHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuJVxhKbeN9OGCr2_zyfa1k3j4DS1gAoTW0P89Eyz2FHg@mail.gmail.com>

On Thu, Dec 01, 2022 at 11:44:53AM +0530, Naresh Kamboju wrote:
> On Thu, 1 Dec 2022 at 00:13, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.0.11 release.
> > There are 289 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro's test farm.
> Regressions found on x86_64:
> 
>     - build-clang-15-allmodconfig-x86_64
>     - build-clang-nightly-allmodconfig-x86_64
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
>     bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
>     [ Upstream commit c86df29d11dfba27c0a1f5039cd6fe387fbf4239 ]
> 
> Causing the following build warnings / errors with clang-15 allmodconfig
> on x86_64,
> 
> Build error:
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu-
> 'HOSTCC=sccache clang' 'CC=sccache clang'
> kernel/bpf/dispatcher.c:126:33: error: pointer type mismatch ('void *'
> and 'unsigned int (*)(const void *, const struct bpf_insn *,
> bpf_func_t)' (aka 'unsigned int (*)(const void *, const struct
> bpf_insn *, unsigned int (*)(const void *, const struct bpf_insn
> *))')) [-Werror,-Wpointer-type-mismatch]
>         __BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
>                                    ~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/bpf.h:938:54: note: expanded from macro '__BPF_DISPATCHER_UPDATE'
>         __static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
>                                                             ^~~~
> 1 error generated.

Thanks for the report! This is fixed with upstream commit a679120edfcf
("bpf: Add explicit cast to 'void *' for __BPF_DISPATCHER_UPDATE()"),
which was marked as a fix for c86df29d11df.

Cheers,
Nathan
