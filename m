Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336004C6EFA;
	Fri, 21 Aug 2026 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322043; cv=none; b=VQbId9ONkh4CDGA4EqyvwH0Ur97OrQNDHGsM9M3Qd/uJxbG1++PYx7CfSDOh/5KqQ5ZbE0YXQhyHsLZMaIcBJZQ1LJggRLMGv+MXr/vCBcYR5BHskQFWoKwnr464+UFrlKZPe1Fx4+WYeGYV7IbQAzpcRdg8WEUuDZyrFBzrmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322043; c=relaxed/simple;
	bh=0U3/f5b00kw7nXIkU0Hv6D7WvLN+mktvkX3z94mdOhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSZ4cVUDU56BQ8VxI3tiJ3SeMMBeSxH5hrSB/5vqIGOyBbM/RPJHHfozRvasZxRcE880JrHSUK7f4L8Ww/41CsDt6GzFNTJnwF8+SdxLhv8EwOlp5HhH9YGpbAUUd3Tvy2JF7WLE/drWxZXHZoHxJHsMBtozP1gltQYJQXkEV6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq7qh/Ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq7qh/Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B231F000E9;
	Fri, 21 Aug 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787322040;
	bh=qCpXDdlxaC1gGXEpRtu6HUDEEXqnvY7+5iVWElsVzsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wq7qh/IgP8d8Q5Vx+iU0QvjJ+SRUv7rWrdVuxEErd4IlqKYRkMYoMjUgJ51TzlzIz
	 Sw8Y+gBN2rOWTCDk/ziMAA6xh0OMASH/IQvx4to64F6fBcSJE7OV6mOnbUseoVTf2y
	 slYZS6reZ9bLofxUSxhEqNKpx3zCPjq4qy4Se0dg=
Date: Fri, 21 Aug 2026 16:20:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Pavel Machek <pavel@nabladev.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Message-ID: <2026082127-pacific-eatery-3ad3@gregkh>
References: <20260820145253.200766705@linuxfoundation.org>
 <aodHg8XQDxFP8VDp@duo.ucw.cz>
 <ac05ec20-03ef-4fc3-9821-c79ffadb3172@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac05ec20-03ef-4fc3-9821-c79ffadb3172@nvidia.com>

On Fri, Aug 21, 2026 at 12:36:22AM +0100, Jon Hunter wrote:
> 
> 
> On 20/08/2026 19:29, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 6.1.184 release.
> > > There are 303 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > We see failure here, too:
> > 
> > drivers/mmc/host/atmel-mci.c: In function 'atmci_remove':
> > 4522
> > 15:52:00
> > drivers/mmc/host/atmel-mci.c:2631:31: error: 'struct atmel_mci' has no member named 'bh_work'
> > 4523
> > 15:52:00
> >   2631 |         cancel_work_sync(&host->bh_work);
> > 4524
> > 15:52:00
> >        |                               ^~
> > 4525
> > 15:52:00
> > make[4]: *** [scripts/Makefile.build:250: drivers/mmc/host/atmel-mci.o] Error 1
> > 4526
> > 15:52:00
> > make[4]: *** Waiting for unfinished jobs....
> > 
> > ..looks same as 5.15 problem.
> > 
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776654125
> 
> I am seeing the same failure as well for v5.10, v5.15 and v6.1 FWIW.

Now fixed for all of these, AND for 6.6, thanks.

greg k-h
