Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D120C030;
	Wed, 25 Jun 2025 08:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750840788; cv=none; b=D+ObVnWf2eMypY26dzkEltNwn83NfUASJNvTZ2lLseggEJyMLZxqiKdONw7HdWtCN3fCar7OHbDfkz6Izi2L/4VE56NCbhjQouo5L16YUBdJ++NhTFDFXd0IwC6JH4tWSktFWJy2dqf4eJ40UaJCZzp5ku4U5m01IxYpAcwlbf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750840788; c=relaxed/simple;
	bh=AKWp94BkCy2jUpTR6LqOnbamDXJXn4LHkjksk4ahYig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DbIsPioRMz3a1YxGIzdksJV2OEb6dzChNy5sjyrzXNIQImbEm4vKwm/l4dpq8H0tcquHIM0hPvCSNEzL68mh7jRadmrzh9MvQo7FSANkXwSkF04NQI5HGehvGBXe6gEuLLs4J8NqYAXZIPAvfZyYVSVUnfXarUD+1hGC/X8fglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgRQlbSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgRQlbSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9168FC4CEEE;
	Wed, 25 Jun 2025 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750840788;
	bh=AKWp94BkCy2jUpTR6LqOnbamDXJXn4LHkjksk4ahYig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgRQlbSl8HNc9xfWseFFuRlOuppQhtGQc08g0qmC3RoDN20ebVDskEMvl6Rl8HIWG
	 ZjlDg0rOFj28TWFIT+enpCWuedXSIuSjVmODpni1OouyXwH8UASAdunn9j5F8/XEG2
	 DTjSUfydoqqtbfiwO3ek4+sbYUnSLyLfnNfiwrR4=
Date: Wed, 25 Jun 2025 09:39:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Russell King - ARM Linux <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, kees@kernel.org
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <2025062517-lucrative-justness-83fe@gregkh>
References: <20250623130632.993849527@linuxfoundation.org>
 <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
 <2025062439-tamer-diner-68e9@gregkh>
 <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>

On Wed, Jun 25, 2025 at 07:15:24AM +0530, Naresh Kamboju wrote:
> On Tue, 24 Jun 2025 at 15:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 24, 2025 at 02:12:05AM +0530, Naresh Kamboju wrote:
> > > On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.186 release.
> > > > There are 411 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Regressions on arm64 allyesconfig builds with gcc-12 and clang failed on
> > > the Linux stable-rc 5.15.186-rc1.
> > >
> > > Regressions found on arm64
> > > * arm64, build
> > >   - gcc-12-allyesconfig
> > >
> > > Regression Analysis:
> > >  - New regression? Yes
> > >  - Reproducibility? Yes
> > >
> > > Build regression: stable-rc 5.15.186-rc1 arm64
> > > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > > of field in 'struct' declared with 'designated_init' attribute
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ## Build errors
> > > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > > of field in 'struct' declared with 'designated_init' attribute
> > > [-Werror=designated-init]
> > >   702 |         {
> > >       |         ^
> > > drivers/scsi/qedf/qedf_main.c:702:9: note: (near initialization for
> > > 'qedf_cb_ops')
> > > cc1: all warnings being treated as errors
> >
> > I saw this locally, at times, it's random, not always showing up.  Turn
> > off the gcc randconfig build option and it goes away, which explains the
> > randomness I guess.
> >
> > If you can bisect this to a real change that causes it, please let me
> > know, I couldn't figure it out and so just gave up as I doubt anyone is
> > really using that gcc plugin for that kernel version.
> 
> You are right !
> The reported arm64 allyesconfig build failures are due to,
> 
>   randstruct: gcc-plugin: Remove bogus void member
>   [ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]

Thanks for the bisection, for some reason that wasn't working for me.
I've dropped this, and the other randstruct change from 5.15.y and older
kernels now.

greg k-h
