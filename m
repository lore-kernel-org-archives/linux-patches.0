Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0992D7812;
	Sun,  1 Mar 2026 12:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366862; cv=none; b=MrK4Bq+0bADiTmBDEh7ziSg7D5XECiyBq15BVB0d+D6rKhUUqNi8coNEEw0SWJ6nYYA4a3pUNAERBqPrNla3dDwbskdUJpkp0nOU/WxPKi45cqsMGwLRJWt8szp8wfqbK3/YNRKzNOzgm1pzWDaVmwqNgStCvT1CDLB9Fi4+mKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366862; c=relaxed/simple;
	bh=GV4biyhRrEZz40rfc0wKy4KzsbBqa22OJai2tVPOucU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jg+zDmUFKUHn9X6gs0+9a9H7zQ9oIi0bx4Bg8jMURjgLH+mnecqpNxWGNP4XJmORvhtfYhQGZPjE7iL7QxJpAdK5grpyZhyDy0OKXISRwjFEiayJ91u3/iaNxY9iCKJbvaCR48Fu8Gp6HWkBaDS0cMlplWRdPKk09uU7A8s5Ido=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTmy9iVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTmy9iVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38559C116C6;
	Sun,  1 Mar 2026 12:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772366862;
	bh=GV4biyhRrEZz40rfc0wKy4KzsbBqa22OJai2tVPOucU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cTmy9iVfgYt9dNLnzNMr0BcwsoebEbPbUSvb/tZBODfb4kjqaH05souwrO6Edu6VY
	 ApiKjZgNr/z0ImqgeYalVrQTqpCs+RKbcLV4OMbngMWBjwuuvX+ii2mZO1UkTdGxYU
	 uK9t2mv/1DEUHBjdMnHaL2G+mWzfYb9dkvRfbdHPWNpulD/ani+lBwCjx8wZONqImm
	 RV4DT1z+3GCyMKp/CON1maqLDtCjF9RIsjXIQTHyKCn1lGPUSgpg7s34QD46fgQwvO
	 z58YtdqO9akAFGrN0MwkMBDOXlXns2QaLRt/4HKp9GLMNz8XftfmWDBueURco3W0UX
	 J4WJQ4k6FJZ7Q==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 172231AC58DB; Sun, 01 Mar 2026 12:07:39 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:07:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
Message-ID: <aaQsCrodKUyB2KJo@sirena.co.uk>
References: <20260228180659.1583364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8FXXPDZpuHVNkHsZ"
Content-Disposition: inline
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--8FXXPDZpuHVNkHsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 28, 2026 at 01:06:59PM -0500, Sasha Levin wrote:

> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--8FXXPDZpuHVNkHsZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkLAoACgkQJNaLcl1U
h9DIQQf/bxFIwZLwWrFUqFZwvPgCqayFbnvzaKFyzw4HsUTlqSHsS9kRTeUg9c4L
fupM84I5ndXWHPxbhxkWjFOwDYxGjsypXh/sEJF9i55nu35wNp8X6zQW1rEIOjDm
7EUWSmZalDVIGwnWRLs9VC2InL81jv5s2R1Gwns7z9ujTG1xeRNieAgtWefvoCAv
m8YgN7Bl4OLdApDFMjqjNH5ii6/1E4wthOKVfw8qsqtNJErreEB+gr5cmev9qKZy
YOSA4qEyZ0VE0svKvamMfzmmuNFkIslomol64Th6sjznv1jySjI2hOJh4cE4bG+R
wp3e0kVFBmHlHTwIZBypDI5GTtzhgg==
=ZWkM
-----END PGP SIGNATURE-----

--8FXXPDZpuHVNkHsZ--
