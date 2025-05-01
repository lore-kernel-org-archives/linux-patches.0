Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C8942A9D;
	Thu,  1 May 2025 07:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746086087; cv=none; b=RA9yLueO0Sgvvwt+R8lkJnkLptcsk0+CABGfE1US0GOjvLX7dKNG0lcEx8VboHMAAx/LTyx1pebYvNrXgcgj7QwHriIOrJzdVxZhULjwCW7urOoiLMkvKhiQ8jj8jm9C4ISavj/sm7c+uj7N9tTDbx5qq3IYdY+T1Ag6oHLreyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746086087; c=relaxed/simple;
	bh=YyH+QYDcrWxqy8Mqc87sknZc5CF77OuB52Z/q0LBfZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqD3dw3G26aK1MUNgxRGg13kvyFzHNA2tRwYvJcJe1HcZWbkf0cLITJT4tTaEoOXCn4DQ98+YG/rTYvEW6/g0iun+Jlq/4vfXOtguMWkH1jJoTZDo9Qell+NlqtehRIYK5DFZLUvhvEpHKvIspEIa3b59eZjJswOjlSVHm7UHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaSR0h+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaSR0h+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61819C4CEE3;
	Thu,  1 May 2025 07:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746086087;
	bh=YyH+QYDcrWxqy8Mqc87sknZc5CF77OuB52Z/q0LBfZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qaSR0h+6EPI5lYAOYZqyroZijdhZbZ7cB6N7Wdz7wSqwO+ZutuigdnyHe3eNP+J7k
	 EIegr7aGqSZeei64Dhan6I5OWN5NJdf8uBOIZP7MfMASq6+5lK0UPi7D76e0xxb2h3
	 Y4KUZPFih/SBn7ZgDeXcVVYOIHPip25MFmFytIgc=
Date: Thu, 1 May 2025 09:54:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
Message-ID: <2025050148-expand-definite-8401@gregkh>
References: <20250429161059.396852607@linuxfoundation.org>
 <CA+G9fYs2AK7jGyJ-kR884-CJA3RRLLWD8r1L5fKLYn68TSQ1ow@mail.gmail.com>
 <44f876a3-7229-4320-8715-e49a122aa2ea@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44f876a3-7229-4320-8715-e49a122aa2ea@w6rz.net>

On Wed, Apr 30, 2025 at 05:27:31PM -0700, Ron Economos wrote:
> On 4/30/25 10:59, Naresh Kamboju wrote:
> > On Tue, 29 Apr 2025 at 23:41, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 6.6.89 release.
> > > There are 204 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Following two build regressions found one on riscv and s390.
> > 
> > 1)
> > Regressions on riscv build with allyesconfig and allmodconfig with toolchains
> > gcc-13 and clang-20 failed on stable-rc 6.6.89-rc1.
> > 
> > * riscv, build
> >    - clang-20-allmodconfig
> >    - gcc-13-allmodconfig
> >    - gcc-13-allyesconfig
> > 
> > Regression Analysis:
> >   - New regression? Yes
> >   - Reproducibility? Yes
> > 
> > Build regression: riscv uprobes.c error unused variable 'start'
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ## Build error riscv
> > arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> > arch/riscv/kernel/probes/uprobes.c:170:23: error: unused variable
> > 'start' [-Werror=unused-variable]
> >    170 |         unsigned long start = (unsigned long)dst;
> >        |                       ^~~~~
> > cc1: all warnings being treated as errors
> 
> This warning is caused by not having the fixup patch "riscv: Replace
> function-like macro by static inline function" upstream commit
> 121f34341d396b666d8a90b24768b40e08ca0d61 in 6.6.89-rc1, 6.1.136-rc1 and
> 5.15.181-rc1. Looks like it didn't apply cleanly to those versions.
> 
> The fixup patch was included in 6.14.5-rc1 and 6.12.26-rc1.

Thanks, I'll go drop this from 5.15.y, 6.1.y, and 6.6.y for now and wait
for some fixes to be resent.

greg k-h
