Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4974C89;
	Sat, 15 Jun 2024 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449221; cv=none; b=dxS6BmccZqmxCwBXX5eHGD1q9y7XarTOn1aiPsBV+I0mRNQxXFOwwHhPtAUu1+caaAfT+8MDNGvgwDfqOLt9kH8YU8AkgFWOIerwRb8LyrVdn4LX0iD1i2aY7WFuOoMDHLoyRQHyuSu9WyKaVd1d2JBxstQwKdWeL2muCTBgxa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449221; c=relaxed/simple;
	bh=3HB0saeYYAYpcpbConAzAngu+NHabLUV8Vxt1hPYagw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgEa4rYqqwyiHALrw1xUZs/t4ISBExdVNGMBMlxfaiLpvUgZVtlwx5y2rdmlvVqtefIoCTzNzYMyc0f+ds4AAw8D5Lcu0rRcec9dch5Ufo1zsursz8CaqSOcYahrt5DuRhvxRqHuZ3CAM6vBw9oRfgaXcnj2TM6ArOYNZzvuGU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP6NPZBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP6NPZBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA912C116B1;
	Sat, 15 Jun 2024 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449221;
	bh=3HB0saeYYAYpcpbConAzAngu+NHabLUV8Vxt1hPYagw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VP6NPZBNeZTg14E+XDA1TY7n6JlW6rjALKM3oAudvH3yUfwSvwaRFFG3ukjWK+Cf4
	 ZnsxRDA8vSZsG3ginB55C9+4WYmIEyUlvoFLKNv8QcvkLnFF3BGW0TuqvRd280UWHB
	 M5/7S/J88hexKmfBJ6jKCq4Mz7HI2f8ib7tYCqx8=
Date: Sat, 15 Jun 2024 13:00:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Guo Ren <guoren@linux.alibaba.com>, Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
Message-ID: <2024061545-cold-fancied-1bd0@gregkh>
References: <20240613113247.525431100@linuxfoundation.org>
 <CA+G9fYvnVJi1RFhO5f6ZH2mpagZ6jcEdoQAxnSBxWPHsEVQwYg@mail.gmail.com>
 <20240613223523.GB1849801@thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613223523.GB1849801@thelio-3990X>

On Thu, Jun 13, 2024 at 03:35:23PM -0700, Nathan Chancellor wrote:
> On Thu, Jun 13, 2024 at 08:43:41PM +0530, Naresh Kamboju wrote:
> > On Thu, 13 Jun 2024 at 17:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.219 release.
> > > There are 317 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > The following build errors are noticed on riscv with clang-18 toolchain
> > but gcc-12 builds pass.
> > 
> > However, compared with older releases this is a build regression on
> > stable-rc 5.10.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > riscv:
> >  defconfig - gcc-12 - PASS
> >  defconfig - clang-18 - FAILED
> > 
> > Build error:
> > ------
> > arch/riscv/kernel/stacktrace.c:75:52: error: incompatible pointer to
> > integer conversion passing 'void *' to parameter of type 'unsigned
> > long' [-Wint-conversion]
> >    75 |                                 if
> > (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
> >       |
> >                 ^~~
> > include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
> >    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
> >       |                                             ^
> > arch/riscv/kernel/stacktrace.c:75:57: error: incompatible integer to
> > pointer conversion passing 'unsigned long' to parameter of type 'void
> > *' [-Wint-conversion]
> >    75 |                                 if
> > (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
> >       |
> >                      ^~
> > include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
> >    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
> >       |                                             ^
> > 2 errors generated.
> > make[3]: *** [scripts/Makefile.build:286:
> > arch/riscv/kernel/stacktrace.o] Error 1
> 
> It looks like either commit 9dd97064e21f ("riscv: Make stack walk
> callback consistent with generic code") should be applied with the
> straight from upstream copy of commit 7ecdadf7f8c6 ("riscv: stacktrace:
> Make walk_stackframe cross pt_regs frame") or the latter commit's 5.10
> backport should be modified to match the linux-5.10.y order of the
> arguments:
> 
> diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
> index c38b20caad7c..010e4c881c8b 100644
> --- a/arch/riscv/kernel/stacktrace.c
> +++ b/arch/riscv/kernel/stacktrace.c
> @@ -72,7 +72,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
>  			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
>  						   &frame->ra);
>  			if (pc == (unsigned long)ret_from_exception) {
> -				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
> +				if (unlikely(!__kernel_text_address(pc) || !fn(pc, arg)))
>  					break;
>  
>  				pc = ((struct pt_regs *)sp)->epc;

I'll just drop these riscv patches from 5.10.y, as odds are, no one is
using that arch in that old tree anymore.  And if they are, they can
send working patches :)

thanks,

greg k-h
