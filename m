Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8D26A0BD;
	Fri,  9 May 2025 06:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746771549; cv=none; b=r3SxbiDqaryO8+a67hPwaUZySBVly5e/H1K/Z4fAVLTWX75tpPI2ucGMB8dNz39xPl4+Nkb9wMT5MkmV0nGrNKRsOPcV7+oT4YHVnwouhq3Pl8ydJC9N7yaCs7fPE1ULA34ym/oNjvBlWhExcEdJkrBwuOsTzUznWQ6cRg4Mu7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746771549; c=relaxed/simple;
	bh=NYM1/STB/SI2JzqgJlobo7dJE80eQHq/fsb0VCpU9RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMdKjxs0hrV8UbQco8ekY908wLQAYeSd9+DyEjFMlI6r4suQlWWrAEKI3Z5pxbEEXsECWsiUh7B3QVHW6x6xtPPQVj/clvyF/Z9eXX354QKcwD7IUTh88bfgfPlLUu9tMAz/IW4tvduBkw07E+4hW4M3tuzZVtiKJNt3SQg/BWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf35wBd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf35wBd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866D6C4CEE4;
	Fri,  9 May 2025 06:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746771548;
	bh=NYM1/STB/SI2JzqgJlobo7dJE80eQHq/fsb0VCpU9RQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jf35wBd1dAn1FMXBlyvwKAPBK+QlZtSeAYasNL4hs+ZTIqS/R/HHL0j0PaTmWWWNu
	 6dRsc2KRapfXpq4QgqRPbmyGs7mbtoVsZpafv3vab+Bi7iza8rbNMCU+51dCndLHrY
	 5+AxpKOIE8rzuy7X6E0VUbt44NpsltTf4Zo1QayA=
Date: Fri, 9 May 2025 08:19:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Palmer Dabbelt <palmer@rivosinc.com>,
	linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
Message-ID: <2025050917-dismay-scary-7261@gregkh>
References: <20250508112618.875786933@linuxfoundation.org>
 <CA+G9fYsKqxUExVW1rEhU8_5pYOuhkzXyeL9TmTyGVsV2-C-PFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsKqxUExVW1rEhU8_5pYOuhkzXyeL9TmTyGVsV2-C-PFQ@mail.gmail.com>

On Thu, May 08, 2025 at 06:16:12PM +0530, Naresh Kamboju wrote:
> On Thu, 8 May 2025 at 17:00, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.90 release.
> > There are 129 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 10 May 2025 11:25:47 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on riscv with allyesconfig and allmodconfig builds failed with
> clang-20 and gcc-13 toolchain on the stable-rc 6.6.90-rc1 and 6.6.90-rc2
> 
> * riscv, build
>   - clang-20-allmodconfig
>   - gcc-13-allmodconfig
>   - gcc-13-allyesconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: riscv uprobes.c unused variable 'start'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build error riscv
> arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> arch/riscv/kernel/probes/uprobes.c:170:23: error: unused variable
> 'start' [-Werror=unused-variable]
>   170 |         unsigned long start = (unsigned long)dst;
>       |                       ^~~~~
> cc1: all warnings being treated as errors

Oh that's wierd.  riscv defines flush_icache_range() as "empty" so then
this patch does nothing in these older kernels.  Ah, it's an inline
function in newer kernel trees as well so that the build warning isn't
there anymore.

As this change feels odd for 6.6 and older kernels, AND it's causing
build warnings, I'm just going to drop it and if the riscv maintainers
really want it applied to these trees, will take a working backport from
them.

thanks,

greg k-h
