Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C5B27933E;
	Thu, 15 May 2025 05:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747287501; cv=none; b=syv+lLPFg09UG/Dd31PTGhRVnfxkP09HZMMvQrA8fwzGiGlXrAho0GWBmAURXIQtBJ+cdM4jwT/8inDZZ3vCK9LepDBreGdyl0r+oV7thFTCz/Q3eDXMQgQEpI1DEnHE/fNxScQ0QZ+Q/Yp00HK2K9li89to6AI6bsjImMfxIMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747287501; c=relaxed/simple;
	bh=MukgDO8NLFBFcYDgTR/tRT+VNDY5mR2Lko15zxNjcaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehSPhVAfbh4p5VXY/3CRxI0lCgvi1VHv1JmtKmPa7cN0DvHhoA1DOUKyJgH12knn07RTRY9nUg33vO1Lqj08IWuFImd0unH7wikhvA1Df/4nFVwmDHOWGCP/FjLKRJ+dEoeFy3UjLSFpGHehOB+rV6jDOjm/iGnp6Uu+ptHhMXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwMb2AqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwMb2AqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BA4C4CEE7;
	Thu, 15 May 2025 05:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747287500;
	bh=MukgDO8NLFBFcYDgTR/tRT+VNDY5mR2Lko15zxNjcaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DwMb2AqIjxB45MjAqEzIkcjTaKgUSyj1J/lJ7w8KDxuoLJVawkrW5Io17oGIjGiTc
	 Q7cMlvCBFIs9TsJ8GxJte+ejE1jSlDCXS61ht/0Q35f84vGJ9pS63e3H/leudL/V8S
	 XsGQHr0/1xDK9zn+i09W3LuM9hKcvmXc0tf4Q368=
Date: Thu, 15 May 2025 07:36:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <2025051547-reset-wrangle-39f0@gregkh>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <54e21b79-a7bd-4e35-ae0f-268daeda5557@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e21b79-a7bd-4e35-ae0f-268daeda5557@roeck-us.net>

On Wed, May 14, 2025 at 01:47:15PM -0700, Guenter Roeck wrote:
> On 5/14/25 13:05, Greg Kroah-Hartman wrote:
> > On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> > > Hi Greg,
> > > On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.6.91 release.
> > > > There are 113 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > > > Anything received after that time might be too late.
> > > 
> > > ld: vmlinux.o: in function `patch_retpoline':
> > > alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > 
> > > We see this build error in 6.6.91-rc2 tag.
> > 
> > What is odd about your .config?  Have a link to it?  I can't duplicate
> > it here on my builds.
> > 
> 
> Start with allnoconfig and add configuration flags until CONFIG_MITIGATION_ITS
> is enabled while CONFIG_MODULES is still disabled. Adding
> 
> CONFIG_64BIT=y
> CONFIG_CPU_MITIGATIONS=y
> CONFIG_RETHUNK=y
> 
> followed by "make olddefconfig" should do.

Thanks for that.  Luckily I don't think that CONFIG_MODULES is a common
config :)

Let's see if we can figure out a fix for this now...

greg k-h
