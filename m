Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E334340A5A
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448259; cv=none; b=hZZcBzoccoMF2SPMvMyxdP2eVMGBq7TeKtxTHcW7cioLbJN1TVeMIOVhnWijKrI+sRoudH9obstxV664DTdZayrnA5l8wF7ERegVXfXQB/H6wWHpUSDe8YSkuUpUEUOp8vkYz+WdxEKjfS6+RFC2NAFLKgbkPvsxXmS4W+QQG8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448259; c=relaxed/simple;
	bh=ysE9y8L5j651mPfz7etUcFwhGQ64pPVJAnhoqY88J/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDByUPMAU3G+L+Y9f8fiNtP+ZxlDkYh3a8Hkpn4AzwdhsNZpne4wj4X6VC7ApIDLB5g3TtpQqrbNdwL1rejPp4cK/qVordfKSgXfIqdG4MOSJsAkVuwiaZArkHgC4SEufwhn37wjMOrRKW7h2HeRBFe9Zs/GGOjhdcyzaYJLHNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=IL2T4Ga/; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="IL2T4Ga/"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id BE01022A47;
	Mon,  2 Mar 2026 11:44:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772448255;
	bh=51ucpPcaf8pfmzUtIw4wGGaAo73/GfKlyHEWg0DqVAw=; h=From:To:Subject;
	b=IL2T4Ga/bvIPDD5iE4ru8ANQteG3ifbamnMHKFnWVdA3/ri8q/QG7YOdEOi/jHrwn
	 mwMcNvc8a8+42huL8R6HqcU2yqmIOxn0MVD5dfTbUYMI01+YpbOTcMJBCsK74afUwD
	 l1j45n3fLne9RpgGJKFzubI2o4cnbSb05ATCfBnUn7mZRwnz/YAqzQ+vPO8/NFiLGq
	 OKrJFXYcvEt5vSjvAdLT26W2CmF9IfsL61AEsp3UnNuL1Q8FdciUWfmkRTqLrv5pOt
	 fuYfMinJyfqz/vfe4Eemt16U3OIj0Deej9oGTHXP5ai3nQDkETe41ek3+JjYBHbUUG
	 Dvh8OPtmFit+w==
Date: Mon, 2 Mar 2026 11:44:10 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
Message-ID: <20260302104410.GA43527@francesco-nb>
References: <20260228180659.1583364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>

On Sat, Feb 28, 2026 at 01:06:59PM -0500, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

