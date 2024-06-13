Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990351411C3;
	Thu, 13 Jun 2024 22:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718318126; cv=none; b=gdG6L4k8uyGnlBvYXHxTdAAvkmBI/4fH4LQ3UgOYHf+xPJ5Yz4y2Ox9GTDLaxpEQstBLT3BzBYjQ5XjhcOXx4czrKpW0Peg/+dpDjbd8r4j9o37RI+UYM8rDWiJFv+zXBLwrVqyPXtwmGJ3ZZTtdikbY+PkuxwU1E0rNsSeUg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718318126; c=relaxed/simple;
	bh=p+VwQhv5G5CYvaf+I9sazjD4wTWlRzKTz9+GDqPyq38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVCvSs7u/hYGEdUn59sWDzX6CuaKRooQZsNAO2RS1uh+gi0pWW+FPB2cFp5kgt/NAXN4RLaJND/YWmN/TORH9avAob2WivLHKoZPWL6eRVZlcXQKxip6AzxuI3L2Si4r47RLFRY3tgrHOFZzXtdULOe8MExXHAMuMyIYuoQuuIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZJFn8FF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZJFn8FF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1322C2BBFC;
	Thu, 13 Jun 2024 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718318126;
	bh=p+VwQhv5G5CYvaf+I9sazjD4wTWlRzKTz9+GDqPyq38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TZJFn8FFLtDllkEQfxJ9kmP6cm2LJADJXIuh4dWKR2L6D1gmcq535DcLm4ILeSoMK
	 j3T+KyxIUCa1o1IBySiyVxushNMc+7F3+72NyFG1bE0bKS3hNqDyKGFuoIzABi03he
	 nX5LMBLtIqjTb3td27LRsRQAs0KnDjwiRlvtU5X7lq+l8C7hY2MFbxJ2n51zvBRDiU
	 IGBWaxfQbmekfiZLftmONNSVRaKIKhcXjPoa9KcInwDj2rnEjxA0AThLm1ktqZuv8j
	 9YKIYpWy+EL54RiNB75HCp0BTx+5XXq0f/8N8LX0TvS6HGAwmYZuc+dljPLorULz3Q
	 utC1PoKU7hXhQ==
Date: Thu, 13 Jun 2024 15:35:23 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
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
Message-ID: <20240613223523.GB1849801@thelio-3990X>
References: <20240613113247.525431100@linuxfoundation.org>
 <CA+G9fYvnVJi1RFhO5f6ZH2mpagZ6jcEdoQAxnSBxWPHsEVQwYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvnVJi1RFhO5f6ZH2mpagZ6jcEdoQAxnSBxWPHsEVQwYg@mail.gmail.com>

On Thu, Jun 13, 2024 at 08:43:41PM +0530, Naresh Kamboju wrote:
> On Thu, 13 Jun 2024 at 17:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.219 release.
> > There are 317 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The following build errors are noticed on riscv with clang-18 toolchain
> but gcc-12 builds pass.
> 
> However, compared with older releases this is a build regression on
> stable-rc 5.10.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> riscv:
>  defconfig - gcc-12 - PASS
>  defconfig - clang-18 - FAILED
> 
> Build error:
> ------
> arch/riscv/kernel/stacktrace.c:75:52: error: incompatible pointer to
> integer conversion passing 'void *' to parameter of type 'unsigned
> long' [-Wint-conversion]
>    75 |                                 if
> (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
>       |
>                 ^~~
> include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
>    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>       |                                             ^
> arch/riscv/kernel/stacktrace.c:75:57: error: incompatible integer to
> pointer conversion passing 'unsigned long' to parameter of type 'void
> *' [-Wint-conversion]
>    75 |                                 if
> (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
>       |
>                      ^~
> include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
>    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>       |                                             ^
> 2 errors generated.
> make[3]: *** [scripts/Makefile.build:286:
> arch/riscv/kernel/stacktrace.o] Error 1

It looks like either commit 9dd97064e21f ("riscv: Make stack walk
callback consistent with generic code") should be applied with the
straight from upstream copy of commit 7ecdadf7f8c6 ("riscv: stacktrace:
Make walk_stackframe cross pt_regs frame") or the latter commit's 5.10
backport should be modified to match the linux-5.10.y order of the
arguments:

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index c38b20caad7c..010e4c881c8b 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -72,7 +72,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
 						   &frame->ra);
 			if (pc == (unsigned long)ret_from_exception) {
-				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
+				if (unlikely(!__kernel_text_address(pc) || !fn(pc, arg)))
 					break;
 
 				pc = ((struct pt_regs *)sp)->epc;

Cheers,
Nathan
