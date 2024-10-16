Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD8318FC61;
	Wed, 16 Oct 2024 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729064136; cv=none; b=EB6uP7ey86Q+puQJVNsAQmYMtAe8Q7G7qBsdwPO6YIAOX9GgR2K2iSP6RPraZF36didJc7yHdUDwy7JAri7ixPCOYOOayMYceANGFNEJdDZIipTQrEzbKQVj8b7FGZj8T3aiWPRKc0OC6CE0bC97rAt+X4XUTWUqY1HsxZ4jqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729064136; c=relaxed/simple;
	bh=Xvs+lMtm2asCzvKJhf6aSQBopJmLdUz+khhBY26Z3m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgScmB0G0NMosuaoB84v6tbIevL7ZH8T8zl78bW3PO0XsMgdaAeOLirkLRE36hd9MTU/82QnMH1n6X+VQReGDvvuC+u6jsfixV5UfPGxZd8qY0aXZahONZ3SjCLX/dKiRhy87kecF9WtkR006NdR8RZ8tqlvnm7ZOmAKT6ukMMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbdiUbuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbdiUbuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FB6C4CEC5;
	Wed, 16 Oct 2024 07:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729064136;
	bh=Xvs+lMtm2asCzvKJhf6aSQBopJmLdUz+khhBY26Z3m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sbdiUbuDpqmKqyuvYbLHIkvhphRrEYtQzrkD2vO53pmSGQtE/3fljDvj13IE8jdLA
	 sOq5IgnO4B8fqHdCzHEksUFUon43dIujQNBqMJkxL5DMilGJlfA0g+/YGA5I05mPwv
	 8OVhCF625yMDyaTqPWkSjfHK40yB9w+bDdMpb+GQ=
Date: Wed, 16 Oct 2024 09:35:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
Message-ID: <2024101620-quaintly-afraid-4d9e@gregkh>
References: <20241015112440.309539031@linuxfoundation.org>
 <43399648-ea75-4717-b155-73541deacaba@gmail.com>
 <2024101515-timothy-overdrawn-b3f7@gregkh>
 <7df2134c-a2fa-4cb8-8d57-e06fb7f62bca@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7df2134c-a2fa-4cb8-8d57-e06fb7f62bca@gmail.com>

On Tue, Oct 15, 2024 at 10:25:44AM -0700, Florian Fainelli wrote:
> On 10/15/24 10:17, Greg Kroah-Hartman wrote:
> > On Tue, Oct 15, 2024 at 10:09:15AM -0700, Florian Fainelli wrote:
> > > On 10/15/24 04:19, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.168 release.
> > > > There are 691 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > perf fails to build with:
> > > 
> > >    CC /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o
> > > util/evsel.c: In function 'evsel__set_count':
> > > util/evsel.c:1505:14: error: 'struct perf_counts_values' has no member named
> > > 'lost'
> > >   1505 |         count->lost   = lost;
> > >        |              ^~
> > > make[6]: *** [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o]
> > > Error 1
> > > 
> > > seems like we need to backport upstream
> > > 89e3106fa25fb1b626a7123dba870159d453e785 ("libperf: Handle read format in
> > > perf_evsel__read()") to add the 'lost' member.
> > 
> > Is this new?  I can't build perf on any older kernels, but others might
> > have better luck...
> 
> Yes this is a new build failure, caused by "perf tools: Support reading
> PERF_FORMAT_LOST" AFAICT.

Thanks, I've dropped the offending commits now.

greg k-h
