Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97653101E6;
	Sun, 18 Aug 2024 08:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723971322; cv=none; b=djEvE2LAmNVOU6P8w69U1xCM+74X0/y7L8BZoq3OiQeOy5Ggr3S2Ds2q0r2v71DNYS5NGteKvviNTByRlhUNkOOoDqTao54b0uHCI/1tKWp5zvgc+QBCX70IZHPMtqoODDLFBYigSvaUzhegBg2ivy4hCdYDy7eLkxaQ60fSfPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723971322; c=relaxed/simple;
	bh=pPv6ETlZaKlCB45ZA2czhva+WhqswiAldgD9gR2ihEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjVdae44Sl8BQa6+QhZRCMxuNJRxFmaFmV66HnTqayJH6ip9PmWp6t/Em4MAVtFZaf67l/Xf5NhZzuBRgm+rbCYYLnTSCXYWw7JBy0sn0zke7SeOx7xFLdcsG6BdJOzzwvAQ/2xXp6dfmKVjK/e9EqU54yILIVJsFXBsf1rSyco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKaivLmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKaivLmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BBC32786;
	Sun, 18 Aug 2024 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723971322;
	bh=pPv6ETlZaKlCB45ZA2czhva+WhqswiAldgD9gR2ihEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jKaivLmhtt7olUKvu0DXw2JdZX2uEtAnj1anJV63lYbu8mdtqtirCu0wljsf8hNtl
	 IZtHc5HgGK7yJF7kw6Z6arpPY63oM42xljpWk710CO61/tV6QN/C50JQA8mni4b3Cc
	 RwkBZ/9UCsjZpkrkfG6FEOtnsF9bkw0w5swnJ2JU=
Date: Sun, 18 Aug 2024 10:55:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/345] 5.10.224-rc3 review
Message-ID: <2024081846-sequester-pull-4183@gregkh>
References: <20240817074737.217182940@linuxfoundation.org>
 <CADYN=9++QDcougZ_xJOLf8otPOrrFcwaJe_gL7ZYmmw6gDXWmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9++QDcougZ_xJOLf8otPOrrFcwaJe_gL7ZYmmw6gDXWmg@mail.gmail.com>

On Sat, Aug 17, 2024 at 05:39:48PM +0200, Anders Roxell wrote:
> On Sat, 17 Aug 2024 at 09:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.224 release.
> > There are 345 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon, 19 Aug 2024 07:46:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following S390 build failed on stable-rc 5.10.y with gcc-12 and clang due
> to following warnings and errors [1].
> 
> s390:
>   build:
>     * gcc-8-defconfig-fe40093d
>     * gcc-12-defconfig
>     * clang-18-defconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> The bisect points to 34a325f5a22f ("s390/pci: Do not mask MSI[-X]
> entries on teardown")
> as the problematic commit [ Upstream commit
> 2ca5e908d0f4cde61d9d3595e8314adca5d914a1 ].
> 
> Build log:
> --------
> /builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_setup_msi_irqs':
> /builds/linux/arch/s390/pci/pci_irq.c:298:9: error: implicit

Wow, s390 builds just don't work at all.  I'm going to go drop all s390
changes from 5.10 and 5.15 now, I doubt anyone for those arches is
really using those older kernels these days anyway.

thanks,

greg k-h
