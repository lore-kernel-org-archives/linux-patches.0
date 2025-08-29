Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0293375B1;
	Fri, 29 Aug 2025 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756487308; cv=none; b=W1t4iQZ3bM+Cs117JMSNHc9kYojjBtZdnwcx9uX9gga1624bdKnp7h+KKImZCphCP5NDj6ObDXzmKqwBri5tFgwQQ2c/6uFWyEFkzynIE514z2cV8l4z6AVPmVL6eSrkbDQh2nAP+MBtSYN6IaVYi1cC1j1bP31E8vpOQaDxrgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756487308; c=relaxed/simple;
	bh=SIIL7tfbe1Qypqdr/Gnur9FsUbBj729FigkstAdP5m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCuM5xER1B61JY+En9ooTH4kDioRIrtS7yCPxTJnJMqAh89feVp8JdpIfEQQ0abWUdW3OYf9ovrhvn6ecjRiWRNzUoSgjH0NuGYYmjR/7W0RYAecvwQH8rX7GPRAtfaWmBQ4IM8WXC7KjaexWK4C4OdVBlo+681aiSXZxpCHK60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Fri, 29 Aug 2025 17:08:03 +0000
From: Brett Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
Message-ID: <aLHecwEL3r7lrw2e@auntie>
References: <20250826110952.942403671@linuxfoundation.org>
 <aK2rwEQ5hdOQSlLq@auntie>
 <2025082620-humorous-stinky-bf0e@gregkh>
 <aK3Lj1OouiUqskLh@karahi.gladserv.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK3Lj1OouiUqskLh@karahi.gladserv.com>

On 2025-08-26 16:58, Brett Sheffield wrote:
> On 2025-08-26 14:50, Greg Kroah-Hartman wrote:
> > On Tue, Aug 26, 2025 at 12:42:40PM +0000, Brett A C Sheffield wrote:
> > > Hi Greg,
> > > 
> > > On 2025-08-26 13:02, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.6.103 release.
> > > > There are 587 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> > > > Anything received after that time might be too late.
> > > 
> > > Quick query - should we be backporting a known regression, even if it is in
> > > mainline presently, or do we wait until the fix is applied to mainline and
> > > *then* backport both patches?
> > > 
> > > 9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")
> > > 
> > > introduces a regression which breaks IPv4 broadcast, which stops WOL working
> > > (breaking my CI system), among other things:
> > > 
> > > https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net
> > > 
> > > This regression has *already* been backported to:
> > > 
> > > - 6.16.3
> > > - 6.12.43
> > > 
> > > so I guess we wait for a fix for these.
> > > 
> > > However, it is not yet present in the other stable kernels.  The new stable
> > > release candidates today would spread the breakage to:
> > > 
> > > - 6.6.y
> > > - 6.1.y
> > > - 5.15.y
> > > - 5.10.y
> > > 
> > > Do we revert this patch in today's RCs for now, or keep it for full
> > > compatibility with mainline bugliness?
> > 
> > Is the fix in linux-next yet?  If it's there, I can queue it up
> > everywhere, which might be best.
> 
> Not yet, but I'll let you know as soon as it is.  I'd suggest dropping
> 9e30ecf23b1b from 6.6.y 6.1.y 5.15.y 5.10.y and 5.4.y until the fix is
> available.

Hi Greg,

The fix has hit Linus' tree now with commit:

5189446ba995 ("net: ipv4: fix regression in local-broadcast routes")

This needs to be applied to all stable trees.

Cheers,

Brett
