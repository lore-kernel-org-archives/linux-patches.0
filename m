Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404121E52D;
	Tue,  7 Jan 2025 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253346; cv=none; b=n5X2e7buhZ2lcwBBa+T77cN/XxB3D9/mlFP0m7Byd/hARAcVQCJRuiSTEmlSNRXXyc+iiMPGohzbt9BR6tbJXyFUYh9oMsSBLVRUVAYDym8PdrKxsfqFAp3i5UCvRHV90mUkHUmlp2uRWaIsGHTsr28mK7/lmzA+kyF8gkjPCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253346; c=relaxed/simple;
	bh=PFrxud6pqjq0jfLdwP4iQ7nVaW3Uxua7abvLolI1+fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcQqmDY0Hr40sFhvsxVxjeDPXGcfkybhzR5xsr5Vj5qbwkVusf32NNo03eH3oR5jsJuD3g6/NwRrE2E3LpgWzutCiLnlcjr4BK9k4ZbCXxNrdHAiP4QaqVR1QvQrMmRC4SiwixVb2kLmZNBb1ULEuglR3L5RjmDTcqD9DJgS2I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BotC6Wvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BotC6Wvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932AEC4CED6;
	Tue,  7 Jan 2025 12:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736253344;
	bh=PFrxud6pqjq0jfLdwP4iQ7nVaW3Uxua7abvLolI1+fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BotC6Wvf5X9Zp9KFbmiTOeTvkR/m1Udw2kHK3rcrrKtwJwDk6VOmegsoh2qpMaUR9
	 8gxcuaqzw+o2Q8P53Qp3qyINNlhUSzs60x6IBK6BvjtAOso3uwxbQByqSxx5oDD95J
	 WP38qRBZSkIBwqIkdwnQv7lWHCMoStTrQXXpdGwav94oWQwekAuzV8iGIL5bXjJqnp
	 xgosIEDGS8tStEW02xVLY+rNCLzhLwYxIdxl2YDz1x5QXM2JzbaMLuh1A4XrrdwDMI
	 /O851vhYz8ln8TzY9J6lK64FOJF4KkhJtzTiwdDKoQLkU6qs68A3beqX7MFwwPdE20
	 S1Fr17quRuEeA==
Date: Tue, 7 Jan 2025 12:35:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
Message-ID: <17c932d7-2690-4036-8a6b-0b8e4ec8ec80@sirena.org.uk>
References: <20250106151138.451846855@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ey9zYcrvB44Brh8T"
Content-Disposition: inline
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
X-Cookie: PIZZA!!


--ey9zYcrvB44Brh8T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:15:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ey9zYcrvB44Brh8T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd9H5kACgkQJNaLcl1U
h9CUcQf+L8TXkGwlGPrVzii32lvMdkLmV2JEDrZDqdYhpkQURtwHJnI2IAQWOo1a
h42MhWGCkeGx+xLrVHCk1ZRFsQUm5QXpHc9qPiB3/rMIXEKnbSgNnD9OOHG2GjAG
dFQC1cfzqnbSy+vXYfwX0u71DD9IYzYyXW+47dzc1aS9xty2laTS2AMZpl0j2K4V
g4VgBY6IHfxz0A4Yjkw9/iAZVPJ53T4t1JvINzWDqeVkK+8OSfjzDfmPwQIwDqu6
zCexFnmXheyBKAJgYCYqDSlm8xhgG7uscQTWLptwWBHfYAWR2ArWFSzaRA88zU0E
vY4EXSBpoEOBkRyNVzf9rBA0cL1Yhw==
=Rblw
-----END PGP SIGNATURE-----

--ey9zYcrvB44Brh8T--
