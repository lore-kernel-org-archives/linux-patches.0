Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0319F1EBFE2;
	Thu, 30 Jan 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259904; cv=none; b=SrKpUilTKqKO0wffbl1GDPfkmOZ062UrXZZTQLkub1NZsWYLZo2aplo18qM0AGJ0zgGGNgIZBXCCQX04uSIeOK8i2doz6xJcjnW5rLMcneeMm1xHe5s2O+tqap3jbrWNCOXBjeX1RKKpXQG5OnZKUn9Dlq/PdMTBu3M4UkNpaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259904; c=relaxed/simple;
	bh=W9b51sdGSgBtc1NmbsFrO6b3NmRf/LaedZRXt3Szszc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXZD7hyDEx750i/KEy/wpbmMFebWMy1I41WKnl6+NrqONizObXTmKq2UeRwFafjSI8BKTIvYi9icehJXZT0+2hGJM6HybEwchKlEYe7RrVZw0ZO4WIRpo+iN458lM/jJ+2sL0eMoxR4xdgwIkV3LjtpCZQFVDTIwsNBIrYCtNfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQTJWa/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQTJWa/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31555C4CEE0;
	Thu, 30 Jan 2025 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738259903;
	bh=W9b51sdGSgBtc1NmbsFrO6b3NmRf/LaedZRXt3Szszc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fQTJWa/vkhS2uOVXW54VOT3BLv/A+qqBAZxkrHLi22pSrMBfFRTrl1UD4MQl020l8
	 5lWg/C1QHBI9+AVh6EyvKYA1hjQ6qVqFsi6xYozNz2gaRoQwAgxOeou80AM7Ku+i58
	 jJzan/YI63o7LlVq4ddMpstk7pGMVhwueutyBwx/1HWkLwBLngCq4h2lGDIQrMTeBR
	 C9M8BAiMh3NuDsnkMh/K1y4mEiEBd7faqgtUhNnUZWcjEpY1OhCgarab8SPieodzFU
	 cusNz87zacKFUENd7CnHM8sYKjabddDa3lD/gNtXJf+RMpRHt7UC28eUrRmGrSJkpN
	 z/1F2CXOyz1+Q==
Date: Thu, 30 Jan 2025 17:58:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
Message-ID: <73fb2541-a04d-4327-8316-b21a4a212302@sirena.org.uk>
References: <20250130144136.126780286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Z5s04CIt25nF0sJo"
Content-Disposition: inline
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
X-Cookie: Password:


--Z5s04CIt25nF0sJo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 03:41:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Z5s04CIt25nF0sJo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmebvbgACgkQJNaLcl1U
h9DFNwf/Q7Zys4Oe6SFJ0nu22LasF1JivBrnRuR+9umuUFqhIPf2A8IA0LtAmf8W
GZ/xEHn3gk/o8o2UXNT4byMNbRcXPjF0gWxEr/xjcmkdfSaQI+pSgbcd9z0ZcUU2
fpKeMxolJYQcd9hHFOw2MQkxdn0X+/LJfLTP2bbkXz5UPD1ZB0JACkjhqF76TnBt
cn3BjM+PnqlmmYWLGyx10uPXPkyTG/lxbJKHZtMmz2IfD5loXHIKEy4GPKq+NcFk
IISTGoq9WwUI0sqpfdyWNNzETcPANatQzny/rhSvQwbIMLQ1/8842lPw6TIlu84E
I+rkXcoEqDoAIeLkbsagjaAOwyMfRg==
=+wVd
-----END PGP SIGNATURE-----

--Z5s04CIt25nF0sJo--
