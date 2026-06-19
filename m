Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2034CFD3
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 11:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781867105; cv=none; b=BM+0X52GjC7n7UagduH6/bIyPq0DwREtl1fuVb7SSUBocaE4cmdDQIPGfDPw7tcKPflTDureX4xYp6gHkPnlF8ZCVnk8x3cEe6psbIIy4/fqwS7as0qMk/utdkjktAEVnJfQ+/X3Ms8FoBH8u56Qz3Rgwd2l0mB98b5vGJhS+YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781867105; c=relaxed/simple;
	bh=k5+Z1eZmsdEQJ1DB13tROBI95uweH+XXdHuAKMgVKdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSxL7Rl4bvVgZQyU34+az4jjm1eOAN0TqU+2gH+VHfltz7IL7dVmW1Pas7JMO1TjupCOX8Mtu9h/WEG5YaPL16vb80uj+uVZIGynoxRziGLnDLdQGiBSRBrHxR3m4gm+0BbvL7Kfn8yuNdmFFnPhKKEzFJNWSbC2NKoJ3DvUv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=d82jithN; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="d82jithN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1781867094; bh=c+zR18Ad7rkZNRJ2IvTAgj+X955Dqao85kkz2NnauVU=;
	h=From:Message-ID:From;
	b=d82jithNqyOQVFh8gcLRFnPJBeajHlWtg1TQd9CJh7kIugAv1571GZCpRGL0AqjgU
	 zhWwb0zlMlVpqGFFeaNUpcm0V/LgMixvi7Gt4xGL+YdQNK6h8GKw/AA+HgbgK3sYMR
	 83BBmI1XOkhOWngy5Jn0dEcSN/fZSTYxTpy9JZz0=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 6CFB9C0BEE;
	Fri, 19 Jun 2026 13:04:54 +0200 (CEST)
Date: Fri, 19 Jun 2026 13:04:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Message-ID: <ajUiVV085JDKcEdM@1wt.eu>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:26:36PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

FWIW now running on my laptop (t480s).

Tested-by: Willy Tarreau <w@1wt.eu>

Willy
