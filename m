Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2ED3D902F
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774342846; cv=none; b=nBiXdSLVjzY2PmzOp0NS4SGTGjOSqP9PDjYfGWV2curmac8PQK/Uc3CG8cm3pmrox39OH/r9AcwtTJhM/AVmjhSnL/UWSczXxzQwvvVNuWLhHyTjbwIa0sR52siCfMplDQJKeKqmp3DI72Rcv0oVpxxdPOh+W38V7wH9gR323f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774342846; c=relaxed/simple;
	bh=oiHs6N1rFWpnuanxIExkY/eJPmrlb90Gu0I+IgRsazw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRp2I+9jWZR6z5eLYpCyi/3TzSAb4bVIvqanAcrS7v1gQerKoPGuI+RWhv9UZkOasfT+ltksLSR8hC1axSA86+OB57Amjx0T+bqiTydc2Gg5eikqwL71K2UrWUfnUQC5ncluCZSOAPbXmUS+XToC62WnTKsh5qjeMqPtPvPvwis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=TZ8wxpvN; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="TZ8wxpvN"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 07C221FD12;
	Tue, 24 Mar 2026 10:00:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1774342843;
	bh=/5936k4IAzQn+uyLkyZDUAbYvFQESLgotW8LzVMakmk=; h=From:To:Subject;
	b=TZ8wxpvNOBS/8WwuVZN2dLXQ/sBiLzQLM7mMvkUA7mXGd+/ZMbOMquSEEOpgyJA2e
	 RFUhFQPLXeX5huLRzPL3K36rApvnXK9blStR9ACyyjVHEq3VOpN9gcnerAIfHwAOqi
	 d9r5wUCgTtGCfcuOFYKIcnuVZbxcU0j5J2kh8U48Zvrb5CiU4Q5w1TVVO2555P5zuC
	 PHS3UPHiwY7FTciE6CPl9yUrLMfzBeG+dRkP124udUAZvbX86pSMKdsOU0KsNnXnJB
	 kW/Yy8Ppk2Yg6GNvVPm/y8i4NxRYM05C5VczibQVhidmHRiIMRg0CekhvrZl/Exgbj
	 JxGfWLZ9VPuSw==
Date: Tue, 24 Mar 2026 10:00:39 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Message-ID: <20260324090039.GA18830@francesco-nb>
References: <20260323134526.647552166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:39:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

