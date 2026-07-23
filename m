Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852E0233938;
	Thu, 23 Jul 2026 07:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792832; cv=none; b=oczsPlh7yggrlwUphrMoEuMxpaQfkyA45H5l9ehDnd98i63U89CrXAt2mZ6R+Bk4R+fg8j6kSuwNErqYlv8gk0vn5/4i9gKOO2adcOOJxs6XNu/j8a8OsX4qozgTc62Tc5ddxeB8JIkJyQGTW2HMfdyRXdqB1eZH0WYvuO69+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792832; c=relaxed/simple;
	bh=0IA2OnCJsPuAUZGkd4YUpj6amTdERCV8X5reU6js4CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYE/ncndsqGAMDfpM9WItn5Sv4AcLNNzLsjsOBt93i6O+5du5KW9oaQVGctPL196pFTzTdzakk6ADTArlIMshAyI/8cgoPGja/DIhl22WlIMD8daZUL8pNpFOkrhXTjSxM/rCrgPFOaC6tV4/2AtCWNZMF7LYrABL8a/KpL/o2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWyTd9uK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWyTd9uK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AB71F000E9;
	Thu, 23 Jul 2026 07:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784792831;
	bh=qm46VajDgXF0UrTgkkVQDvo0Se81NJWRnQU+deFt2R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bWyTd9uK3Vr2nUv5UMv4bSlVRnR7Cdmt2rUWFY+Kv07MSzjKEpFyESdyfpwmVAlhQ
	 1RrQB/cuDb54bs1Y2WWysIvRsL0vX76J4c0gXv4ECdA0mNJuBrzlJ+ApXHJrZSlFEy
	 kIYBhv3MrA4Jvzq8lB66PFRvSqnnQ6d0VrZYQ5o8=
Date: Thu, 23 Jul 2026 09:46:58 +0200
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
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <2026072333-creed-overbite-b2a9@gregkh>
References: <20260722143258.264584003@linuxfoundation.org>
 <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>

On Wed, Jul 22, 2026 at 07:25:26PM +0200, Frank Scheiner wrote:
> On 22.07.26 16:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.145 release.
> > There are 1226 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> > Anything received after that time might be too late.
> > 
> > [...]
> 
> Our autobuilds for ia64 fail for 6.6.145-rc2 (actually already for
> -rc1 but -rc2 was released before I could respond):
> 
> ```
> drivers/cpufreq/ia64-acpi-cpufreq.c:329:27: error: initialization of 'void (*)(struct cpufreq_policy *)' from incompatible pointer type 'int (*)(struct cpufreq_policy *)' [-Wincompatible-pointer-types]
>   329 |         .exit           = acpi_cpufreq_cpu_exit,
>       |                           ^~~~~~~~~~~~~~~~~~~~~
> drivers/cpufreq/ia64-acpi-cpufreq.c:329:27: note: (near initialization for 'acpi_cpufreq_driver.exit')
> ```
> 
> See [1].
> 
> [1]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/29932232437/job/88968683064#step:8:3100
> 
> This is due to the addition of an upstream change to 
> drivers/cpufreq/[...]` ([2]). As this change was introduced after 
> v6.6, it didn't change the ia64 specific driver that is still present
> for linux-6.6.y.
> 
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d
> 
> In our fork of Linux post v6.6 we carry a replay of b4b1ddc that makes
> the corresponding changes also for ia64. This is available on [3] (and
> also attached to this message) and fixes the build for me.
> 
> [3]: https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f962ddff46a901ff3468574b8.patch
> 
> Can this be included for linux-6.6.y, so it continues to build for
> ia64 as is?

Sure, I'll queue it up.  Does anyone still actually use ia64 anymore?  I
thought those systems were long dead.

thanks,

greg k-h
