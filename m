Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33114A8F;
	Wed, 17 Jul 2024 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721197342; cv=none; b=XMhaVejsqZspdYYsy2LMW+6vxcoP1UCIn38NnwHB7xv3itoqYgCow/EsL8PRA6sp3vtL2+1tCLiGh48oLueZ5qZPbsYZ0TeIWBKUyD+179PxBH50hyGTSXke2Sfnyl+qzpdoAN2exl/UJLG8W0uiPkAxMflYtFUoIXV62LyzBh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721197342; c=relaxed/simple;
	bh=LrtpofMdg46etwUfnOkLE+oGC9jAUvtRo8pAMdRwnoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsupu/5QtPzS+LL+Xp4YZdCHBk79KtX6BZ2wNdIwZU5zusLbe703VZSp94fFntyin9vw07FU339dNeDpXcALdQ0u8qcNUGxI5qeK0y779QXxzdGOVX3W90Ap9Q/ZRxc5Ws0xOHUqnOQLmrJf7reB21Hnbj5IA86cpt/tnaPSfaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ4PGI0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ4PGI0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5B9C32782;
	Wed, 17 Jul 2024 06:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721197342;
	bh=LrtpofMdg46etwUfnOkLE+oGC9jAUvtRo8pAMdRwnoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NQ4PGI0m6sYSBq8CWWlSmVX/Fy6eBdsV4I26pc+OGqxQiUbKFwpgyYemVePu3RQQY
	 Bu8lMRCvf9K6KBry7QvZZOzjoEFXvkckZqb4wGX4ZtuSjs6mqmxdxXacTTbpkPIADI
	 fbWWZSV4owwoyIuLCk7EZH30eAN2ms9lq03HVe9c=
Date: Wed, 17 Jul 2024 08:22:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.280-rc1 review
Message-ID: <2024071713-reshuffle-glazing-f7af@gregkh>
References: <20240716152740.626160410@linuxfoundation.org>
 <CA+G9fYtJwjRPsomCFehVXyw27S1f9Uq6H1ZvH573ekakj7Mdng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtJwjRPsomCFehVXyw27S1f9Uq6H1ZvH573ekakj7Mdng@mail.gmail.com>

On Wed, Jul 17, 2024 at 02:27:26AM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jul 2024 at 21:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.280 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The 390 builds failed on stable-rc 5.10.222-rc1 review; it has been
> reported on 6.6, 6.1, 5.15, 5.10 and now on 5.4.
> 
> Started from this round of stable rc on 5.4.280-rc1.
> 
>   Good:eee0f6627f74 ("Linux 5.4.279-rc2")
>   BAD: 51945679d212 ("Linux 5.4.280-rc1")
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
> 
> arch/s390/include/asm/processor.h: In function '__load_psw_mask':
> arch/s390/include/asm/processor.h:259:19: error: expected '=', ',',
> ';', 'asm' or '__attribute__' before '__uninitialized'
>   259 |         psw_t psw __uninitialized;
>       |                   ^~~~~~~~~~~~~~~
> arch/s390/include/asm/processor.h:259:19: error: '__uninitialized'
> undeclared (first use in this function); did you mean
> 'uninitialized_var'?
>   259 |         psw_t psw __uninitialized;
>       |                   ^~~~~~~~~~~~~~~
>       |                   uninitialized_var
> arch/s390/include/asm/processor.h:259:19: note: each undeclared
> identifier is reported only once for each function it appears in
> arch/s390/include/asm/processor.h:260:9: warning: ISO C90 forbids
> mixed declarations and code [-Wdeclaration-after-statement]
>   260 |         unsigned long addr;
>       |         ^~~~~~~~
> arch/s390/include/asm/processor.h:262:9: error: 'psw' undeclared
> (first use in this function); did you mean 'psw_t'?
>   262 |         psw.mask = mask;
>       |         ^~~
>       |         psw_t
> 
> 
> metadata:
> -----
>   config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrMGFV9tK3IYnSE2ntEa22g0J/config
>   download_url:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrMGFV9tK3IYnSE2ntEa22g0J/
>   git_describe: v5.4.279-79-g51945679d212
>   git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git_sha: 51945679d212aae61a418eff41370c13da94f94d
>   git_short_log: 51945679d212 ("Linux 5.4.280-rc1")
>   arch: s390
>   toolchain: gcc-12 and clang
> 
> Steps to reproduce:
> ----------
> # tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
> --kconfig tinyconfig

Should now be fixed, thanks.

greg k-h
