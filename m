Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FF26A0BF;
	Wed, 28 May 2025 08:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748422357; cv=none; b=dCxE6zCVX7RUwYy/tAiWORiamv94eIpn8WLTTdTEPA+g6+6NEZdS7vw9GkkN9wuMdwhoBcmsIC4zYxhd65+zWaqJCNhaiOPE0rdALkvc7X8eNUbATGCWWzJuWqda8yOgKfSmCcFISO/616ScCVrMKIOKgoXuLk+Dv/tGpsdVg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748422357; c=relaxed/simple;
	bh=BmYME872G2HKJBR/wdLI4h4RnelU/w385HSGJ/Nngpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmM7beHYHsy1Tegwa2TM0ePuiERwfEBHqxaETkjEz1NiihG/48MIsOaDPYwVueW+Gu2Y/9nHzxevbKynd/jEQFg+LUiFEQprwCM6UUJ4oXX0TRZImXIZwggaQbUVOFrNAg13bwSoCAUsGRDuvjZwB2pvrRVYjoscvmO9D/E9ZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+IJMmF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+IJMmF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B18C4CEED;
	Wed, 28 May 2025 08:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748422356;
	bh=BmYME872G2HKJBR/wdLI4h4RnelU/w385HSGJ/Nngpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V+IJMmF7A9LPOcBmCxMUAACufm6xiV1ZyHyycFYXdgE0lWfb5gG6zjebdjGlk8wSG
	 YzcJTlmtH7nWSId+lwsWhxNY3pMgO7X6/Qlfn+R2zocZOLyc05Rooj67UP9n8oyq3e
	 195jqT4JP5wo63S+2nq0DOj6NiIO48+Bu7kRr3y0=
Date: Wed, 28 May 2025 10:50:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-s390@vger.kernel.org,
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Message-ID: <2025052824-turret-crank-48ee@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <CA+G9fYsvuqySTdV0Yqi3i-cyBh6j4Rw2_ze46RSUPrz0sbA2Xg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsvuqySTdV0Yqi3i-cyBh6j4Rw2_ze46RSUPrz0sbA2Xg@mail.gmail.com>

On Wed, May 28, 2025 at 12:40:10AM +0530, Naresh Kamboju wrote:
> On Tue, 27 May 2025 at 22:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.14.9 release.
> > There are 783 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on S390 defconfig builds failing with gcc-13, gcc-8 and
> clang-20 and clang-nightly tool chains on 6.14.9-rc1.
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducible? Yes
> 
> Build regression: S390 defconfig crash_dump.c use of undeclared
> identifier 'NN_PRSTATUS'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 
> Build log:
> ---------
> arch/s390/kernel/crash_dump.c:312:8: error: use of undeclared
> identifier 'NN_PRFPREG'
>   312 |         ptr = nt_init(ptr, PRFPREG, nt_fpregset);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:274:56: note: expanded from macro 'nt_init'
>   274 |         nt_init_name(buf, NT_ ## type, &(desc), sizeof(desc),
> NN_ ## type)
>       |
> ^~~~~~~~~~~
> <scratch space>:85:1: note: expanded from here
>    85 | NN_PRFPREG
>       | ^~~~~~~~~~
> arch/s390/kernel/crash_dump.c:313:8: error: use of undeclared
> identifier 'NN_S390_TIMER'
>   313 |         ptr = nt_init(ptr, S390_TIMER, sa->timer);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:274:56: note: expanded from macro 'nt_init'
>   274 |         nt_init_name(buf, NT_ ## type, &(desc), sizeof(desc),
> NN_ ## type)
>       |
> ^~~~~~~~~~~
> <scratch space>:87:1: note: expanded from here
>    87 | NN_S390_TIMER
>       | ^~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:314:8: error: use of undeclared
> identifier 'NN_S390_TODCMP'
>   314 |         ptr = nt_init(ptr, S390_TODCMP, sa->todcmp);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:274:56: note: expanded from macro 'nt_init'
>   274 |         nt_init_name(buf, NT_ ## type, &(desc), sizeof(desc),
> NN_ ## type)
>       |
> ^~~~~~~~~~~
> <scratch space>:89:1: note: expanded from here
>    89 | NN_S390_TODCMP
>       | ^~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:315:8: error: use of undeclared
> identifier 'NN_S390_TODPREG'
>   315 |         ptr = nt_init(ptr, S390_TODPREG, sa->todpreg);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:274:56: note: expanded from macro 'nt_init'
>   274 |         nt_init_name(buf, NT_ ## type, &(desc), sizeof(desc),
> NN_ ## type)
>       |
> ^~~~~~~~~~~
> <scratch space>:91:1: note: expanded from here
>    91 | NN_S390_TODPREG
>       | ^~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:316:8: error: use of undeclared
> identifier 'NN_S390_CTRS'
>   316 |         ptr = nt_init(ptr, S390_CTRS, sa->ctrs);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/crash_dump.c:274:56: note: expanded from macro 'nt_init'
>   274 |         nt_init_name(buf, NT_ ## type, &(desc), sizeof(desc),
> NN_ ## type)
>       |
> ^~~~~~~~~~~
> 
> ## Source
> * kernel version: 6.14.9-rc1
> * git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git sha: 10804dbee7fa8cfb895bbffcc7be97d8221748b6
> * git describe: v6.14.8-784-g10804dbee7fa
> * project details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.8-784-g10804dbee7fa/
> * architecture: S390
> * toolchain: gcc-8, gcc-13, clang-20, clang-nightly
> * config : defconfig
> * Build config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2xgl51jcJfVGQZw8dKSuEJNFtd4/config
> * Build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2xgl51jcJfVGQZw8dKSuEJNFtd4/
> 
> ## Boot log
> * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.8-784-g10804dbee7fa/testrun/28574235/suite/build/test/gcc-13-defconfig/log
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.8-784-g10804dbee7fa/testrun/28574235/suite/build/test/gcc-13-defconfig/details/
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.8-784-g10804dbee7fa/testrun/28574235/suite/build/test/gcc-13-defconfig/history/
> 
> ## Steps to reproduce
>  - tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
> --kconfig defconfig

Thanks, offending patch is now removed.

greg k-h
