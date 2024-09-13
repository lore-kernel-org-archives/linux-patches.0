Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CED1C2319;
	Fri, 13 Sep 2024 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726230455; cv=none; b=l2FzUwIYjFe4ahEZuL+QRyaApB0DOHh7nJSzKKCLiuLv3mqo4BHZsvUBjyIdK6FG92zq6L44Qu2PD4mKwEGz9LrTy+CbLM5OmPF+IM+opPI15kqm7M5wnblueK3PUlc4qKI+TQslz0AZ6/DwE8tYrvdk5lKXXPhqy1+693LKAJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726230455; c=relaxed/simple;
	bh=Xn7ahkD5Ei/452KsEUp8graRPSBFcovTP+7QMOXhAgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q09Io+2rxY9TDwOkHqxixM+4JYX72vntbBXQ6Hte2Yp14gBOEIpYbPGeKmX1WlOvonMWNa7uhA3+GPzcTQMRoh7cEJM4f1uYBiYy+xtdTPbDmchwkewJXU4a7QF6cVp+Wjc25YACd5y5Anhg7+SWnAPDhyeWiGOqdXJV+8/nblc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ou1wOFkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ou1wOFkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF01C4CEC0;
	Fri, 13 Sep 2024 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726230454;
	bh=Xn7ahkD5Ei/452KsEUp8graRPSBFcovTP+7QMOXhAgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ou1wOFkE6y1fntz+hYhajiflE8pyAvzS0XPDmz228CZ8slRjsUrzKpnc158hiWaWt
	 ZzYLSlM/9y5gGQxLnthhpQQR66Gw9vxYD2SGI7bXcx4qQ5fngJ88W/S9behEP+PF2V
	 2/MNBWbHpTcaYMnoVVRQmwmDWLhCi3wRudn15Jpk=
Date: Fri, 13 Sep 2024 14:27:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
Message-ID: <2024091329-clambake-lion-860a@gregkh>
References: <20240910094253.246228054@linuxfoundation.org>
 <CA+G9fYtxOA7Ee1omhLT-fMaaBPqNEZQYVHXovLtGgv9jbuxQLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtxOA7Ee1omhLT-fMaaBPqNEZQYVHXovLtGgv9jbuxQLA@mail.gmail.com>

On Wed, Sep 11, 2024 at 08:44:13PM +0530, Naresh Kamboju wrote:
> On Tue, 10 Sept 2024 at 16:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.322 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 Sep 2024 09:42:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.322-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build
> * kernel: 4.19.322-rc2
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: 00a71bfa9b89c96b41773efee1cca378cc1fa5e6
> * git describe: v4.19.321-96-g00a71bfa9b89
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.321-96-g00a71bfa9b89
> 
> ## Test Regressions (compared to v4.19.320-99-g0cc44dd838a6)
> 
> ## Metric Regressions (compared to v4.19.320-99-g0cc44dd838a6)
> 
> ## Test Fixes (compared to v4.19.320-99-g0cc44dd838a6)
> 
> ## Metric Fixes (compared to v4.19.320-99-g0cc44dd838a6)
> 
> ## Test result summary
> total: 116497, pass: 103587, fail: 542, skip: 12283, xfail: 85
> 
> ## Build Summary
> * arc: 20 total, 20 passed, 0 failed
> * arm: 204 total, 192 passed, 12 failed
> * arm64: 54 total, 44 passed, 10 failed
> * i386: 30 total, 24 passed, 6 failed
> * mips: 40 total, 40 passed, 0 failed
> * parisc: 6 total, 0 passed, 6 failed
> * powerpc: 48 total, 48 passed, 0 failed
> * s390: 12 total, 12 passed, 0 failed
> * sh: 20 total, 20 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x86_64: 46 total, 36 passed, 10 failed
> 
> ## Test suites summary
> * boot
> * kunit
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * rcutorture
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

Thanks for testing and letting me know,

greg k-h
