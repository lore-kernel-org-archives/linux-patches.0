Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4094213C661;
	Fri, 26 Jul 2024 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993949; cv=none; b=AIf84g1MXrz8Pg4TOFmUvJ+PW6Ahs8gUsLERym6zBCTZu2VE5GJAPkcJD/qIQYrkjhydYz2Nlp5NB471jnXcCtGaZ+N5r/CVmU+sWaiY7JTbKensJEAP5AJVBNvt3aNvDnxdH/diPwTTIsAXsle8AB8mZTE38/p95j1Cx5x2sjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993949; c=relaxed/simple;
	bh=L28HDqLuspdoX5XmE49vLAZY5+6UVZN4anSGw6I9yuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyx4IGL8HpWy5ho60N6OuJOvVLCvuYMPlZ9qw5nFsQY8pTtAKr87wVqtraZCdM7NntpdLvTw1Ue7aNubPGPAW76SadzcA1S7a8rMGct0pShuG7fxK68k2h4kg0UCIrF3IMaiErRQp/qKlk+7zzs1XgHuW424m+NVM8OFWTbj9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgglUKL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgglUKL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39E8C32782;
	Fri, 26 Jul 2024 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721993948;
	bh=L28HDqLuspdoX5XmE49vLAZY5+6UVZN4anSGw6I9yuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AgglUKL46Sb871WDW4NyoTmt26igipX0PNg3JjAy4tmeTvQoEDZTzI5zsQpI7nPTW
	 1gubEyB99Larr7smFIkZiS+XZCk6h612GbIiFx9UBHtYxhPL9QBxVV3i7TLliodvJS
	 k8SArUGluRJWdDIGTPPMU86yCSv8J/frFejKLORtMmCble/hdvuMiL/ibNLMtS07zh
	 f/myNKGqHL9XKoucX1YkTcWJVMICbOHsM0TYBJMOX8bum2/TnzqfpDAOFGTJPU3qMM
	 tGD4QSZWKpJgJGiTXEY3/adIj2tMzfcQE37cS4wLkMH3ZecLJp55N6ZJUWZs7iDy+I
	 umW/oEvTaaQTw==
Date: Fri, 26 Jul 2024 12:39:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
Message-ID: <e9f41f04-47cb-48e7-bc1a-b3de793930ca@sirena.org.uk>
References: <20240725142728.905379352@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GhImBUIWkY6FcqNz"
Content-Disposition: inline
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
X-Cookie: It is your destiny.


--GhImBUIWkY6FcqNz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2024 at 04:37:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--GhImBUIWkY6FcqNz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajitQACgkQJNaLcl1U
h9DExQf7BgAYWYxr+k9ol+qIWkwM+fSN+rkPdvq6X4UzAoevT1kBuvkhl3jLK5z5
7RdGFfOHctRlbHWjO13QHumx31ioEZuSDbbZoUWNjC4cNo9edQ3kic9BZDSVRNfh
AcbigLB6hQ2JpaNCjtb7mQ1cGKm9V5d+jWpCP5RJTU7thQ2cnhz7ySohHMXx/czq
mmFsrzXowP7+E5tm44QudlfkkKMHQ/04eGuE/oHvE1+KfV59JQK8WmUqjjyYYGuo
MyNAzGIafAYMu0J2sKZOji7xGf7iM1Ziawg30UYs/qxiB8yjHKbuCJBSTsu1pZyQ
AO0nP6xkCnOJI9e1OLRwc/mVU+zL+A==
=8Y0/
-----END PGP SIGNATURE-----

--GhImBUIWkY6FcqNz--
