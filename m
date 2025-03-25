Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA2199934;
	Tue, 25 Mar 2025 23:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742945868; cv=none; b=dU1UVSeKX66loYw0ooYmugscjUr4DEksw1pdct/NIkb8QBLxKiC+roHxNfT+0ihvhSkV84XCGmYn1zMjtOddOHCoaBD67/l9/Z2AVeBjbk/am1d7bVwbOs7m/Bqb9MzRj/IJ0Po2rP0p+wwrMw45a6rKkkoowE2TUaOd/6+vXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742945868; c=relaxed/simple;
	bh=00/ArSjIQEZNs37g+f5KqAlg1L1Kwu+QoXBNEaLDdA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPwl9k7PyfhwX/oEIwaZ0hbKxOtzDI2UgftYJ9kDH7qqZ1+YOj8J1ENaeaiXU7/on9PY8suGAPgKRkAHduj1+80RAsKQOPGF2cIOTRfJgNtr8n42pjC7kK9L6pCwmwrazuQN1FrISGk7QpeOQS8hEJUBzuln0PPyssrhMYuIOLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkeblEwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkeblEwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659C2C4CEE4;
	Tue, 25 Mar 2025 23:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742945867;
	bh=00/ArSjIQEZNs37g+f5KqAlg1L1Kwu+QoXBNEaLDdA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkeblEwJcGEu19kTCnrKzhnz2M7cJmU/cnC2SBixBbgwn2LyZYpsatZ1pNX5vD+cw
	 J7JRWmMtT0hWyoi5qRo2EgPRpSdUeSRMIn2pupgr/nRYN1L8LSbFWfwOgrWu3Ov43G
	 frGd/KqrFVbdYF4iqOyajnHG4JMSe54RtoOZ56z4=
Date: Tue, 25 Mar 2025 19:36:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dragan Simic <dsimic@manjaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
Message-ID: <2025032556-faceplate-stingy-fe31@gregkh>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
 <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a823454af9915fe3acfcb66fd84dc826@manjaro.org>

On Tue, Mar 25, 2025 at 05:07:16PM +0100, Dragan Simic wrote:
> Hello Naresh,
> 
> On 2025-03-25 16:07, Naresh Kamboju wrote:
> > On Tue, 25 Mar 2025 at 18:05, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 6.6.85 release.
> > > There are 77 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc1.gz
> > > or in the git tree and branch at:

> > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-6.6.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 
> > Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
> > stable-rc 6.6.85-rc1
> > 
> > First seen on the v6.6.83-245-gc1fb5424adea
> >  Good: v6.6.84
> >  Bad: 6.6.85-rc1
> > 
> > * arm64, build
> >   - gcc-13-defconfig
> > 
> > Regression Analysis:
> >  - New regression? yes
> >  - Reproducibility? Yes
> > 
> > 
> > Build regression: arm64 dtb rockchip non-existent node or label
> > "vcca_0v9"
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ## Build log
> > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> > (phandle_references):
> > /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> > 
> >   also defined at
> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> > 
> > ## Source
> > * Kernel version: 6.6.85-rc1
> > * Git tree:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > * Git sha: c1fb5424adea53e3a4d8b2018c5e974f7772af29
> > * Git describe: v6.6.83-245-gc1fb5424adea
> > * Project details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/
> > 
> > ## Build
> > * Build log:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/log
> > * Build history:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27763720/suite/build/test/gcc-13-defconfig/history/
> > * Build details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/
> > * Build link:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/
> > * Kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/config
> > 
> > ## Steps to reproduce
> >  - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
> > --kconfig defconfig
> 
> This is caused by another patch from the original series failing
> to apply due to some bulk regulator renaming.  I'll send backported
> version of that patch soon, which should make everything fine.
> 

What commit id needs to be backported?  Or did you submit the fix
already and I just missed it?

thanks,

greg k-h
