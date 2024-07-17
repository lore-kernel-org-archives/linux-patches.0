Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0AA125DE;
	Wed, 17 Jul 2024 06:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721197321; cv=none; b=RiP7nZv3JGQUprp+dUOZXa7Rdwc/KAmolxqe+6keKdFvtzrc+885mKBH9eMFVR+tDdl9Rtfa+yMFaWOpIDePbMhMshasYsEwSl/+1ulSRW7QzB3g950T5V5d+kQ/7sIx5HCRn7+E/EEorHM6RytP1q491sZf7iXiguVtokltjJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721197321; c=relaxed/simple;
	bh=P5/fapqUwCJ/tjVBDrwJ4Sdt7sccWMQBrjnThCjs2uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUqc8cO6I5mkz+6TyLTY550JH9AJXSE42tvKzIkh9hkGgZuCPr+T2VcyZVftUY9YtIIBHNI1qIyImFVnTKwqEnZExQorXAzAfmJEj6fr7XC6AbWZcGpzDH9OK/kDSCaik92DsDZdz/bV+YQRrKRTh1yTwPx1eaXb0sp2aLxUjzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eA5G/gAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eA5G/gAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29D6C32782;
	Wed, 17 Jul 2024 06:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721197321;
	bh=P5/fapqUwCJ/tjVBDrwJ4Sdt7sccWMQBrjnThCjs2uQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eA5G/gAE43be5J+MNaHbWX2j3Br0FKcmQ+GxEgR0qNzvorMoF1Q+6XG4P9Bgzy/ko
	 N+3ili5wpYcGTRdpV1gZ9PviNdCFMKGa2NvOjbGTpip29wvZZjLxseTkgT1dBX6tyP
	 WHutdBx0PZWvJlY5lW2rvhE6DfKk1D/uAEsQTPpQ=
Date: Wed, 17 Jul 2024 08:21:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
Message-ID: <2024071751-operator-tipoff-9cb9@gregkh>
References: <20240716152738.161055634@linuxfoundation.org>
 <CA+G9fYuhFAiB_bnPpAC7sW96cyPHE3wGi+Q+=bNuXcmMzGnu=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuhFAiB_bnPpAC7sW96cyPHE3wGi+Q+=bNuXcmMzGnu=w@mail.gmail.com>

On Wed, Jul 17, 2024 at 02:30:54AM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jul 2024 at 21:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.318 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.318-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The 390 builds failed on 6.6, 6.1, 5.15, 5.10, 5.4 and 4.19
> 
> 
> * s390, build
>   - clang-18-allnoconfig
>   - clang-18-defconfig
>   - clang-18-tinyconfig
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
>   - gcc-12-allnoconfig
>   - gcc-12-defconfig
>   - gcc-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-tinyconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> -------
> arch/s390/include/asm/processor.h: In function '__load_psw_mask':
> arch/s390/include/asm/processor.h:292:19: error: expected '=', ',',
> ';', 'asm' or '__attribute__' before '__uninitialized'
>   292 |         psw_t psw __uninitialized;
>       |                   ^~~~~~~~~~~~~~~
> arch/s390/include/asm/processor.h:292:19: error: '__uninitialized'
> undeclared (first use in this function); did you mean
> 'uninitialized_var'?
>   292 |         psw_t psw __uninitialized;
>       |                   ^~~~~~~~~~~~~~~
>       |                   uninitialized_var
> arch/s390/include/asm/processor.h:292:19: note: each undeclared
> identifier is reported only once for each function it appears in
> arch/s390/include/asm/processor.h:293:9: warning: ISO C90 forbids
> mixed declarations and code [-Wdeclaration-after-statement]
>   293 |         unsigned long addr;
>       |         ^~~~~~~~
> arch/s390/include/asm/processor.h:295:9: error: 'psw' undeclared
> (first use in this function); did you mean 'psw_t'?
>   295 |         psw.mask = mask;
>       |         ^~~
>       |         psw_t
> 
> Steps to reproduce:
> ----------
> # tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
> --kconfig tinyconfig

Offending commit now dropped.

thanks,

greg k-h
