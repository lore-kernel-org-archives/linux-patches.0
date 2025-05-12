Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD346A934;
	Mon, 12 May 2025 09:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747042283; cv=none; b=uOb78wzl3v//GpYD6O/EQ//zgsiiK2i06piQVBe75vX+6oN2MyR9gLjQCP2JWpca4m7GHOh5bC1MPFnt6iBSM40ngQjezwsO0HdT8mE8QMc+CkZx5KiDwOO69qi3UoPh8USPeK6AXNoEpWBK80kKusO0ZfRb00AntnWk+hfkGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747042283; c=relaxed/simple;
	bh=Pl5wI9ryAPdgORdBss+zWHr/rLzZLPqpkrMyNkyLOrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+E7fUlmvj9M/ipy0EaXJeQEDsEvMmugrBu8Azsj2UmSKhS6ICOj6sRBURV9GQVQxadehq+n0hN0uA0hZhVtxXwiNPYN620UMwwqglRwiT6uX1EEvU0fgqLEwwk4BjzGpcaFlMvJqYF2jPTH0T76xnFdXehP7CKotr0aGjziRx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqDkcM5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqDkcM5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A26C4CEE7;
	Mon, 12 May 2025 09:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747042283;
	bh=Pl5wI9ryAPdgORdBss+zWHr/rLzZLPqpkrMyNkyLOrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aqDkcM5kbzBSpqfa2DcUZcTC2CN2/IqVXcfwUnQ3zOru/LJ5p5i/z9LwkUsDTxXrI
	 Y7IsYEHkb7pMDcSwuybWOhiCoiDMnlTmFOnjZ0dBJJbseASIbRBKBZGSru1x4LldDz
	 kYZdcga4bRl1nnHM2Lz2mzYKK+Ii+7HDatDcArwc=
Date: Mon, 12 May 2025 11:31:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <2025051205-return-blame-ba79@gregkh>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
 <2025022221-revert-hubcap-f519@gregkh>
 <Z7mXDolRS+3nLAse@duo.ucw.cz>
 <2025022213-brewery-synergy-b4bf@gregkh>
 <aCG9kFjnZrMd4sy8@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCG9kFjnZrMd4sy8@duo.ucw.cz>

On Mon, May 12, 2025 at 11:21:20AM +0200, Pavel Machek wrote:
> On Sat 2025-02-22 10:39:23, Greg Kroah-Hartman wrote:
> > On Sat, Feb 22, 2025 at 10:21:18AM +0100, Pavel Machek wrote:
> > > On Sat 2025-02-22 07:28:10, Greg Kroah-Hartman wrote:
> > > > On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> > > > > 
> > > > > 
> > > > > On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.1.129 release.
> > > > > > There are 569 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > 
> > > > > And yet there was a v6.1.29 tag created already?
> > > > 
> > > > Sometimes I'm faster, which is usually the case for -rc2 and later, I go
> > > > off of the -rc1 date if the people that had problems with -rc1 have
> > > > reported that the newer -rc fixes their reported issues.
> > > 
> > > Well, quoting time down to second then doing something completely
> > > different is quite confusing. Please fix your scripts.
> > 
> > Patches gladly welcome :)
> 
> It is not okay to send misleading emails just because script generated
> them.

*plonk*
