Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DE1E57E;
	Wed, 17 Jul 2024 06:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721196912; cv=none; b=H7bFQlADVoDNnMWHiNvevnvMM2+/7aFiLYsNLBSfV4lBmGo7EpaIgMnMLTS3LoP86uaCOqTBvEgzMSWZTRH55Pjm89WZAMmUt2K76tfSKOZ9BN4mmgglRsbqdpMITR/J19gpBrK68o6s86VXxQMWvlNSAx1tBo78Q3AwW4RXOGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721196912; c=relaxed/simple;
	bh=ZBhtMLdcoezBuG6oHqDon5iO2naEp1wK1o9CII1PmnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0SV6jV/xx9w16y/X0zJK9em9xhG6OySrjzF/rV27e5SijQQqFf6DPEsqEqN1mJlASfciE7sy+Ti89hJwfZipoS2R8opKRFgxC7p8iiD+0JBS7FXS3oZcoZKOzK1nuNPIPX6thtX1lFvu+boNDbDaaxmqr5v7IPFgWLsSuzOV6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FdJMI3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FdJMI3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B9AC4AF09;
	Wed, 17 Jul 2024 06:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721196911;
	bh=ZBhtMLdcoezBuG6oHqDon5iO2naEp1wK1o9CII1PmnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0FdJMI3dg7ljgzoaZMCKGN2WzhhYdNqFX1452++txg2ZvzjS1Lau/IGtuLor5s0E9
	 PzxFu5s82OgOT+BNNldAN4wwa9QfTYlrRkkLXy/8ZdDTQnA6qLbGEAe0X7uPC6HULQ
	 zsYU5hBruqtTkTnGIBDGJOkK76IJawut8U3I+Doo=
Date: Wed, 17 Jul 2024 08:15:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
Message-ID: <2024071743-anyhow-legroom-1d54@gregkh>
References: <20240716152752.524497140@linuxfoundation.org>
 <CA+G9fYvVaSX9Ot2vekBOkLjUqCx=SbQqW4vWhypCnGwwBmX4xg@mail.gmail.com>
 <c7beb899-91dc-4fcd-816e-fa7ba6f956e4@suswa.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7beb899-91dc-4fcd-816e-fa7ba6f956e4@suswa.mountain>

On Tue, Jul 16, 2024 at 03:45:33PM -0500, Dan Carpenter wrote:
> On Wed, Jul 17, 2024 at 01:49:12AM +0530, Naresh Kamboju wrote:
> > On Tue, 16 Jul 2024 at 21:37, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.163 release.
> > > There are 144 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The s390 builds failed on stable-rc 5.15.163-rc1 review due to following build
> > warnings / errors.
> > 
> > First time seen on stable-rc 5.15 branch.
> > 
> >   GOOD: ba1631e1a5cc ("Linux 5.15.162-rc1")
> >   BAD:  b9a293390e62 ("Linux 5.15.163-rc1")
> > 
> > * s390, build
> >   - clang-18-allnoconfig
> >   - clang-18-defconfig
> >   - clang-18-tinyconfig
> >   - clang-nightly-allnoconfig
> >   - clang-nightly-defconfig
> >   - clang-nightly-tinyconfig
> >   - gcc-12-allnoconfig
> >   - gcc-12-defconfig
> >   - gcc-12-tinyconfig
> >   - gcc-8-allnoconfig
> >   - gcc-8-defconfig-fe40093d
> >   - gcc-8-tinyconfig
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build regressions:
> > --------
> > arch/s390/include/asm/processor.h:253:11: error: expected ';' at end
> > of declaration
> >   253 |         psw_t psw __uninitialized;
> >       |                  ^
> >       |                  ;
> > 1 error generated.
> 
> Need to cherry-pick commit fd7eea27a3ae ("Compiler Attributes: Add __uninitialized macro")

Thanks, as this keeps coming back, I'll go add this commit now to all
branches and push out -rc2 releases in a few hours.

thanks,

greg k-h
