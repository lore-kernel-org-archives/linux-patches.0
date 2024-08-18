Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED262564;
	Sun, 18 Aug 2024 05:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723957616; cv=none; b=kNdWiD4a94t2BzbhGrjCBCvA6XvCaEn+rXuXVTiuBE6SiaTNuJwrgLphqD7acf9MxY+YhBMmj88A6m7pTNzOYDZPzzZrjXmTPBekoVWySCjKqiW91WFyVRoWP3UAXR9Hu9dMHQV7FVqq1ekQ63mZP11i4QVcREGFuWID26D4mKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723957616; c=relaxed/simple;
	bh=72McZUZhNStCneFEyQbXrsHsYSndEZl6KasQ8BWZ5Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTkkx4a+CmcKBp6mWwhE7yekhUCxgdRbZtZF6xxVhJHd7m0cg16an2NMrZyHExQlFj2C/QlCwvl7fwk0ekagdVejSCCts1+kTajTX2u2nIoNtA6wdH65xcHUc+jj/CCcn7b786wYRnLsGMyIvAsBz48gDAgMPrjO1U7iLwA7txc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgzRnza8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgzRnza8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4335C32786;
	Sun, 18 Aug 2024 05:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723957615;
	bh=72McZUZhNStCneFEyQbXrsHsYSndEZl6KasQ8BWZ5Ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rgzRnza8fwKA4uZn8PLAZ0k5QlM4glaGKIpv57JDex31+OWUnkal5cRXGkZPqNlrS
	 gLXlz77vHGyKwzCqS1X0pq+bTFcMUlu3OIc0m1TEtMXRVe1dz+os6IvVcVPTCbGBjz
	 PR+xNUsQb184dvrDZn5Zcd1DX8YJo+9mQN5mMcxo=
Date: Sun, 18 Aug 2024 07:06:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: krisman@collabora.com, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: Adding sample code in -stable? was Re: [PATCH 5.10 000/345]
 5.10.224-rc3 review
Message-ID: <2024081838-pyramid-radiance-ef32@gregkh>
References: <20240817074737.217182940@linuxfoundation.org>
 <ZsEMJzot9kAjXW/d@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsEMJzot9kAjXW/d@duo.ucw.cz>

On Sat, Aug 17, 2024 at 10:46:31PM +0200, Pavel Machek wrote:
> On Sat 2024-08-17 09:51:14, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.224 release.
> > There are 345 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > Linus Torvalds <torvalds@linux-foundation.org>
> >     Add gitignore file for samples/fanotify/ subdirectory
> > 
> > Gabriel Krisman Bertazi <krisman@collabora.com>
> >     samples: Make fs-monitor depend on libc and headers
> > 
> > Gabriel Krisman Bertazi <krisman@collabora.com>
> >     samples: Add fs error monitoring example
> 
> I don't know why this was queued for stable, but I don't believe it
> should be there. This adds sample code, does not fix a bug.

It was asked for, please see the archives.
