Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521929BDB4;
	Thu,  6 Nov 2025 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762457540; cv=none; b=VnSxEprS4FA4AtTjCMRhoqSe2zNs7N5LRY1DId6iT8Vf0HJFfp+wExyD3iYZm7m/DbVePM55TXEw53fC6wN5WwsmX+Lt6MCiNrN1g4oPzQNqc3hQf+kisJoTw5+jNySzOTsDgwcwz2z/oiF6b+ch9tAfDw1wx/mCM155CAM8XZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762457540; c=relaxed/simple;
	bh=Ni+Z5fTEF+YJcvFBiJo8VsFjNREBSsxC1Q0KaC1UIhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vB+X6trhKaGvS5Ykt9tqO6RVKDM0Zg3nYK97sVlFBlmwONeyWAQNTeD4iwiI0KNfgQ5JRIuDV6aTtN+napy1rhgempVmd87h1RenvtiERCLYEtxnTjOQN/uK58GJ+EL9nxaN1UTKMBNKfL6Hr40tYkkXbMdF5BsnVP2mVNQDzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhdO2rCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhdO2rCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D4C4CEF7;
	Thu,  6 Nov 2025 19:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762457539;
	bh=Ni+Z5fTEF+YJcvFBiJo8VsFjNREBSsxC1Q0KaC1UIhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uhdO2rCKwc+m0T3GRreLTpCoc5sP9T/rvc7JdYXyMVyq9t2UIeMfwKwuGrCedb4mB
	 IulL3ag5sFDPptex2EzW0EpD0C0vaHM4pFM9NJqPBFNscAzd1ENQpBWjb5Rtvk/aN5
	 oXL/G0M/75n99PNK2nMXN/TnxshE1hxmrxDGghvhJt7jFBkXcdeSRoE/3mnmMfgcyi
	 Wpmlp58KBHu2T1JC4KaisdmcrtrUpEFDYF0E1+w7LhE65Yr6GA4/4z+dwatO7Befqr
	 u3ljs477WayN0WliI2TP/lfQ1Po/+bUuYbJTv8CgKgBAC9e+Cm3pSzB+ULcD2lDAG9
	 EIXUKO2Dz1ljg==
Date: Thu, 6 Nov 2025 11:32:18 -0800
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Russell King - ARM Linux <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <202511061127.52ECA4AB40@keescook>
References: <20250623130632.993849527@linuxfoundation.org>
 <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
 <2025062439-tamer-diner-68e9@gregkh>
 <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>
 <2025062517-lucrative-justness-83fe@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025062517-lucrative-justness-83fe@gregkh>

On Wed, Jun 25, 2025 at 09:39:45AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jun 25, 2025 at 07:15:24AM +0530, Naresh Kamboju wrote:
> > On Tue, 24 Jun 2025 at 15:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jun 24, 2025 at 02:12:05AM +0530, Naresh Kamboju wrote:
> > > > On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.15.186 release.
> > > > > There are 411 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > Regressions on arm64 allyesconfig builds with gcc-12 and clang failed on
> > > > the Linux stable-rc 5.15.186-rc1.
> > > >
> > > > Regressions found on arm64
> > > > * arm64, build
> > > >   - gcc-12-allyesconfig
> > > >
> > > > Regression Analysis:
> > > >  - New regression? Yes
> > > >  - Reproducibility? Yes
> > > >
> > > > Build regression: stable-rc 5.15.186-rc1 arm64
> > > > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > > > of field in 'struct' declared with 'designated_init' attribute
> > > >
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > ## Build errors
> > > > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > > > of field in 'struct' declared with 'designated_init' attribute
> > > > [-Werror=designated-init]
> > > >   702 |         {
> > > >       |         ^
> > > > drivers/scsi/qedf/qedf_main.c:702:9: note: (near initialization for
> > > > 'qedf_cb_ops')
> > > > cc1: all warnings being treated as errors
> > >
> > > I saw this locally, at times, it's random, not always showing up.  Turn
> > > off the gcc randconfig build option and it goes away, which explains the
> > > randomness I guess.
> > >
> > > If you can bisect this to a real change that causes it, please let me
> > > know, I couldn't figure it out and so just gave up as I doubt anyone is
> > > really using that gcc plugin for that kernel version.
> > 
> > You are right !
> > The reported arm64 allyesconfig build failures are due to,
> > 
> >   randstruct: gcc-plugin: Remove bogus void member
> >   [ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]
> 
> Thanks for the bisection, for some reason that wasn't working for me.
> I've dropped this, and the other randstruct change from 5.15.y and older
> kernels now.

This thread got pointed out to me. You can put this back in if you want;
you just need the other associated fix (which had a bit of an obscure
Fixes tag):

d8720235d5b5 ("scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops")

-Kees

-- 
Kees Cook
