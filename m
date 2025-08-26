Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F81494D9;
	Tue, 26 Aug 2025 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219518; cv=none; b=sdcUYvMsacUntCsg/HPisJPYsLC4BP6agyr9cQI1Te4bBTb5rn9N47vVPeL++VAVJSG2tTfo9tgspi+ZDKe+CZdo/QSIOPD6nB82D9YT4aoC1Btyd59AuyxiaqzPclIZY90C9ylWPDs5hKRxz8oO2LRB6CkPkPKFztUcV8rbG9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219518; c=relaxed/simple;
	bh=g45d8EkSLfoneJnQw99PP1Rvrm1Zwnfx3ZjSKUMKZEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEL9GYDlJTC3w4oKkBOwgTg2vZac6jJnhC/0RhipL+A/R6GYdpkDvHXiJx8gmCrg7uP0IAbbeGXed+Q8Zd+9cG/L3egYj8Fufk9hYo14Q7hebANpEiF+MZB3EBKRr3xbKghzelmuKV4y/oURd/nJcLSLkaiOD/78WgxK2f0ayU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPihBAUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPihBAUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3198C4CEF1;
	Tue, 26 Aug 2025 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219518;
	bh=g45d8EkSLfoneJnQw99PP1Rvrm1Zwnfx3ZjSKUMKZEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZPihBAUn5iuIH7v+H5Aqv3qif4s16POJwJAyJWE619kiHLzVFiAbiXSqeY6fqcHMD
	 M2mG92KFqkIhoMrp22WOe+QqucjZU4aecHppCKg/T9rBqKgHy4krDkaE2zJXzign4N
	 EPQCJ2EZm+9fPL9SaoKphmD8L7I5saMMFlcJg82Q=
Date: Tue, 26 Aug 2025 14:50:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
Message-ID: <2025082620-humorous-stinky-bf0e@gregkh>
References: <20250826110952.942403671@linuxfoundation.org>
 <aK2rwEQ5hdOQSlLq@auntie>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK2rwEQ5hdOQSlLq@auntie>

On Tue, Aug 26, 2025 at 12:42:40PM +0000, Brett A C Sheffield wrote:
> Hi Greg,
> 
> On 2025-08-26 13:02, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.103 release.
> > There are 587 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> > Anything received after that time might be too late.
> 
> Quick query - should we be backporting a known regression, even if it is in
> mainline presently, or do we wait until the fix is applied to mainline and
> *then* backport both patches?
> 
> 9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")
> 
> introduces a regression which breaks IPv4 broadcast, which stops WOL working
> (breaking my CI system), among other things:
> 
> https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net
> 
> This regression has *already* been backported to:
> 
> - 6.16.3
> - 6.12.43
> 
> so I guess we wait for a fix for these.
> 
> However, it is not yet present in the other stable kernels.  The new stable
> release candidates today would spread the breakage to:
> 
> - 6.6.y
> - 6.1.y
> - 5.15.y
> - 5.10.y
> 
> Do we revert this patch in today's RCs for now, or keep it for full
> compatibility with mainline bugliness?

Is the fix in linux-next yet?  If it's there, I can queue it up
everywhere, which might be best.

thanks,

greg k-h
