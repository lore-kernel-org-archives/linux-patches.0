Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584742367D9;
	Mon,  3 Aug 2026 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785744862; cv=none; b=eJ9wKvMJKEBDpH05kUjpEbRBo8d+cFKKWamUHZ1TxMY79ehiT+X/ymkA4i8sSLKruesY/RHTmfQdXxl4JopChskwovwFRtp8QMbdzDQmvSmpaLxz+qhFBthm5gnP1S1YFO0gZp7z34x52GL4B4QuJlxu7eTVGqDjGlV3cFEdTRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785744862; c=relaxed/simple;
	bh=64ffo3ymfUhgib+QwSdQ/h2LsDdvEueyPFBtu7EDTCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KulXRMAls9ZNiMsQaNBLnxOUkfERUkxW9usZ/6Gf253iCpHaMt5QbCm8HtBh6D/TL2tlcQUWnA1WUksyeQuMNeYmq0MDS7AYNiZIyP7AJxijbZFBSLSxyUw2nBT8PywbMYlxVzbiu9q4ixOz2iT+ug/GuzYL8gP/QbZiriMa0Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mc3W6ght; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mc3W6ght"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B7C1F00A3A;
	Mon,  3 Aug 2026 08:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785744860;
	bh=BThx6k7l458g7y10I4r2TZ4Pu3PNoveV6FgfRsfClf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mc3W6ght2Xwc5O6Ao4y2A9vYAQYeukEtXUXb22EKmTrw51FnKM9t0l0j489CRKMiy
	 SU9laEzOugH9NtiUX8JKM4wuY/hTzWou5bPrRYgS6q/bzgWrP4QymzBHiFKkJW26gY
	 ZBLN/u4wTbmmTNm47bI7D7dowO76OX09C9CVwJVY=
Date: Mon, 3 Aug 2026 10:14:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, cc@epic-linux.org
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Message-ID: <2026080313-stony-spree-9b45@gregkh>
References: <20260730141423.392222816@linuxfoundation.org>
 <e2abbb8e-e222-49d5-bc58-6b5328490ac6@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2abbb8e-e222-49d5-bc58-6b5328490ac6@web.de>

On Fri, Jul 31, 2026 at 07:37:59PM +0200, Frank Scheiner wrote:
> On 30.07.26 16:08, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.148 release.
> > There are 484 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.148-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> I didn't notice earlier, but we now seem to have a mirrored version of
> the build problem described for 6.6.145-rc2 ([1]) earlier:
> 
> from: https://github.com/linux-ia64/linux-stable-rc/actions/runs/30608172560/job/91087240301#step:8:3099
> ```
> drivers/cpufreq/ia64-acpi-cpufreq.c:327:27: error: initialization of 'int (*)(struct cpufreq_policy *)' from incompatible pointer type 'void (*)(struct cpufreq_policy *)' [-Wincompatible-pointer-types]
>   327 |         .exit           = acpi_cpufreq_cpu_exit,
>       |                           ^~~~~~~~~~~~~~~~~~~~~
> drivers/cpufreq/ia64-acpi-cpufreq.c:327:27: note: (near initialization for 'acpi_cpufreq_driver.exit')
> make[6]: *** [scripts/Makefile.build:243: drivers/cpufreq/ia64-acpi-cpufreq.o] Error 1
> make[5]: *** [scripts/Makefile.build:480: drivers/cpufreq] Error 2
> make[5]: *** Waiting for unfinished jobs....
> ```
> 
> [1]: https://lore.kernel.org/stable/88255dcb-acac-4a74-a086-b686aaf15eca@web.de/
> 
> Looking into the released 6.6.145 ([2]) the patch "cpufreq: Make
> cpufreq_driver->exit() return void" ([3]) that created the original
> problem for the ia64 buld in 6.6.145-rc1 and -rc2 was gone in the
> released 6.6.145.
> 
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=01f5e56c58488ddef1a0a7bc2102bab9cf0031f9
> 
> [3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d
> 
> Hence the patch which replays that change also for ia64 needs to go now,
> too.
> 
> Short of an upstream commit for this patch, I can only point you to the
> patch in:
> 
> * linux-stable-rc:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.6.y&id=bb51b626b5a8ef349b11876572540f19ad4d5030
> 
> * stable:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.6.y&id=bb51b626b5a8ef349b11876572540f19ad4d5030
> 
> * stable-queue:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=8b7e20cd309ee12f5916f0fa96569fcd0484551f
> 
> ..., you decide what you prefer. HTH.

Ugh.  This is what happens when we are trying to deal with stable stuff
that is not upstream, we almost always get it wrong.

Can you send me a revert patch for this, so we can fix your build?  ANd
going forward, I think we're just going to have to stick to the "it has
to be usptream" stuff, and if you wish to keep this arch alive outside
of upstream, the api/build/whatever fallout will have to be on you, as
we just can't handle it here, sorry.

thanks,

greg k-h
