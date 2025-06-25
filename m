Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E8AF50F;
	Wed, 25 Jun 2025 08:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750841550; cv=none; b=corsEPEgeLnnhmYBRqRkT9w9EBytJKaLCN3IlZDyVZwStC6BoF6Kou5+YmB95/FktmHBDDSL8sndP4QlE1xpf0+nmLKXnH1cHAWunJ14XrG3/mp1Xe2yrxff4c4BpecIDesCCEaTqs+kR2jIpk0/1b8+5NAa/mBDwE1mA+axMx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750841550; c=relaxed/simple;
	bh=NEjOO6MyFXxkn7NerpncmY9/qLiFsH/Y4Jb/xiTGkOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYX6pCxbZ6tQ1Xoc5Azlo6QUeCeosdmWqE+ZV5WSl3qglZUBZloBk241s5xntsW/54OXQ7Th1quQgNe9q50U1JIHU/x8iANJWVz7H1WHuNUC+EO/IUuDv8/xYJIJieV2lcdEQCJRtVqTrnLs7y3lnn9bWdLXkwQxV/yt0Tc7DrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+ZBmcW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+ZBmcW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F853C4CEF1;
	Wed, 25 Jun 2025 08:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750841549;
	bh=NEjOO6MyFXxkn7NerpncmY9/qLiFsH/Y4Jb/xiTGkOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+ZBmcW72ckUTCHtrRqXpKmpnjw7iEoZCAZOrCPKTA2vJ7UfB69HatqPmcGy+u9ip
	 On1xNK9o/S8Yd29DDbgfG6XHgHxaonAzEqr5rEMfusAl4OoQY6IGSJ+4QX7OyZfct2
	 ZUSnPvbl2T2EphXFKuij6jOVnIkCdxLX3ih/tSAI=
Date: Wed, 25 Jun 2025 09:52:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	kvmarm@lists.cs.columbia.edu, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Andy Gross <agross@kernel.org>
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
Message-ID: <2025062508-vertical-rewrite-4bce@gregkh>
References: <20250623130611.896514667@linuxfoundation.org>
 <CA+G9fYvpJjhNDS1Knh0YLeZSXawx-F4LPM-0fMrPiVkyE=yjFw@mail.gmail.com>
 <2025062425-waggle-jaybird-ef83@gregkh>
 <CA+G9fYvNTO2kObFG9RcOOAkGrRa7rgTw+5P3gmbfzuodVj6owQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvNTO2kObFG9RcOOAkGrRa7rgTw+5P3gmbfzuodVj6owQ@mail.gmail.com>

On Wed, Jun 25, 2025 at 10:03:22AM +0530, Naresh Kamboju wrote:
> On Tue, 24 Jun 2025 at 15:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 24, 2025 at 12:46:15AM +0530, Naresh Kamboju wrote:
> > > On Mon, 23 Jun 2025 at 18:40, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.4.295 release.
> > > > There are 222 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Regressions on arm defconfig builds with gcc-12 and clang failed on
> > > the Linux stable-rc 5.4.295-rc1.
> > >
> > > Regressions found on arm
> > > * arm, build
> > >   - clang-20-axm55xx_defconfig
> > >   - clang-20-defconfig
> > >   - clang-20-lkftconfig
> > >   - clang-20-lkftconfig-no-kselftest-frag
> > >   - clang-nightly-axm55xx_defconfig
> > >   - clang-nightly-defconfig
> > >   - clang-nightly-lkftconfig
> > >   - gcc-12-axm55xx_defconfig
> > >   - gcc-12-defconfig
> > >   - gcc-12-lkftconfig
> > >   - gcc-12-lkftconfig-debug
> > >   - gcc-12-lkftconfig-kasan
> > >   - gcc-12-lkftconfig-kunit
> > >   - gcc-12-lkftconfig-libgpiod
> > >   - gcc-12-lkftconfig-no-kselftest-frag
> > >   - gcc-12-lkftconfig-perf
> > >   - gcc-12-lkftconfig-rcutorture
> > >   - gcc-8-axm55xx_defconfig
> > >   - gcc-8-defconfig
> > >
> > > Regression Analysis:
> > >  - New regression? Yes
> > >  - Reproducibility? Yes
> > >
> > > Build regression: stable-rc 5.4.295-rc1 arm kvm init.S Error selected
> > > processor does not support `eret' in ARM mode
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > >
> > > ## Build errors
> > > arch/arm/kvm/init.S: Assembler messages:
> > > arch/arm/kvm/init.S:109: Error: selected processor does not support
> > > `eret' in ARM mode
> > > arch/arm/kvm/init.S:116: Error: Banked registers are not available
> > > with this architecture. -- `msr ELR_hyp,r1'
> > > arch/arm/kvm/init.S:145: Error: selected processor does not support
> > > `eret' in ARM mode
> > > arch/arm/kvm/init.S:149: Error: selected processor does not support
> > > `eret' in ARM mode
> > > make[2]: *** [scripts/Makefile.build:345: arch/arm/kvm/init.o] Error 1
> > >
> > > and
> > > /tmp/cc0RDxs9.s: Assembler messages:
> > > /tmp/cc0RDxs9.s:45: Error: selected processor does not support `smc
> > > #0' in ARM mode
> > > /tmp/cc0RDxs9.s:94: Error: selected processor does not support `smc
> > > #0' in ARM mode
> > > /tmp/cc0RDxs9.s:160: Error: selected processor does not support `smc
> > > #0' in ARM mode
> > > /tmp/cc0RDxs9.s:296: Error: selected processor does not support `smc
> > > #0' in ARM mode
> > > make[3]: *** [/builds/linux/scripts/Makefile.build:262:
> > > drivers/firmware/qcom_scm-32.o] Error 1
> >
> > That's odd, both clang and gcc don't like this?  Any chance you can do
> > 'git bisect' to track down the offending commit?
> 
> The git bisection pointing to,
> 
>   kbuild: Update assembler calls to use proper flags and language target
>   commit d5c8d6e0fa61401a729e9eb6a9c7077b2d3aebb0 upstream.

Thanks for that,  I'll go drop all of the kbuild patches that Nathan
submitted here and push out a -rc2

greg k-h
