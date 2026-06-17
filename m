Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C122C3266
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704232; cv=none; b=L3WJTw2zXAC7uMj0v2ErdjaU6yXLSWP4cQF/pmGcuVGMD763oxkkGEcZlaIK4CJ/ge7xfUTbXnHLqSxbTE//WpiRr6iwBHjqxNk0mDDG7wBaT2tBZthlgev9XA77p+xEz+Ng4geMNBsFzFXe2I9DzxeTL30Sj80j3c7HtMd82ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704232; c=relaxed/simple;
	bh=xf6HD/dAGrTTvMOyVzcKPb1dlsLseLiFKrOXzL1TPJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOSch9MBwqWTsKt3JzsmjX6Sc7vtlq0FfenMKoiyWjBr1ZpcXjtUJrAcZAtiRhgZHUBwWX41lsf5z/QvpRMe9ioVutmCRu9+6YQiHR0+OLZmvnTFV4N7Je51yBNeUur98/7joarFe1TrMU20IMTKsp055tBeqcxBMu7q+8IdBEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Ugd/2WNE; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Ugd/2WNE"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id BACA51F927;
	Wed, 17 Jun 2026 15:50:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1781704229;
	bh=KHgroYrNSC9f3XvwT9WujdONGIZE/FhUTUmDSdmJons=; h=From:To:Subject;
	b=Ugd/2WNEiIawU6iL02XOM3yMqVn7RzukqbQP2I+UCSa63EipCBT75CWSxLSu9mIiD
	 mjNbZ0lZ3Y+132jn8GDszcwIAj0bwFuElhkdQTLgs11VlAnbDbQ/r6uhsxRPaOqIrL
	 EJFUF3XzRjpPDtKc3dDCoABYRStkjc2/27cDxBfTFoZLfgI9lS3RWSH9VWcAt1U/0E
	 fmZz5zqerWG1bek8u7H9AGUOp8y+DWChQm11DqK4G/WYALn/KTaoRISnXCIgR1XpS7
	 NARHAguvmkPsz0f8fcAoBii05pIcZIbdiYnkfcJp6KUBJwZHaqj8lj8ygQpDanGZVU
	 bCskyre6eEwTA==
Date: Wed, 17 Jun 2026 15:50:25 +0200
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
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
Message-ID: <20260617135025.GA99510@francesco-nb>
References: <20260616145117.796205997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:23:47PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

