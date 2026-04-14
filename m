Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC7E30B53C;
	Tue, 14 Apr 2026 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776190732; cv=none; b=WumS0vCXtYMzQi1PnIvEJJ54+m88WNxyJgBUiOwA1kabvVhLZXILPWlzkwIR+AxtfuQJaAp76Sat75IkNXEXao/c+c8r7DCTLEAU10DKmU9uiHFqNDaIs8tgaL419xagYY/Qayb+ULqJ8OsPi10y+hMhIVW8uBpTc8I/FAtgUHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776190732; c=relaxed/simple;
	bh=f3aShvLQEsG7hvfbK0BKgrHsCJRBLx+359RcrZkZVzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJyfQlvV3/eIs/Oo4NVjoVNPNh2vToUMOM27gqO4oTOj5rrsjiaotzUwUtT7MaxlwnYx3odWGq+6oZ8EmCbbfSu2uiQ1ls4eloNgcqeLwunrOQDldM+ewxrLk5qmTdKrkiW1Twie+BFIUExukdruHuDkBO/ONCrSu8Um1FopS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8XZ5p4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8XZ5p4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2B8C19425;
	Tue, 14 Apr 2026 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190732;
	bh=f3aShvLQEsG7hvfbK0BKgrHsCJRBLx+359RcrZkZVzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y8XZ5p4aEgq3oqhIEe/6vEkIKfUCWrHNzeiqqd5VmcBJuVqTUzeGX1HKQfVGZxjFd
	 kuEWqwx7svs7ADoTfA+4l+3JaWarrV57lhJegHJW62s/FE/wigMkjJG4o9OikR4Zdu
	 7JPtnL1NFTUQYJpkwjjdND+Z6CszYB7oqq9AMJhQMiluBoXgPzcf62Stov4PkKgOhM
	 6ECuFCs8wV8+L4/2EG5FCUs5Lq9mVBr7ORGAx6WDCJ4ZfjdikMm1JCXgqAYG+TAnOO
	 8sLeN3wYHeh3xXFKt2mjvVlK0KZKhuWD1AIxG8u5QXdZabCIOqxGd9cQoOOzH1XKXy
	 Bnym9vYDaKx0A==
Date: Tue, 14 Apr 2026 19:18:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
Message-ID: <ac48eb94-8d07-483b-bc01-6fc3a2e96a64@sirena.org.uk>
References: <20260413155724.820472494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pF5yMaB9u4TNPnza"
Content-Disposition: inline
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
X-Cookie: Academicians care, that's who.


--pF5yMaB9u4TNPnza
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 13, 2026 at 06:00:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pF5yMaB9u4TNPnza
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnehQUACgkQJNaLcl1U
h9AGSQf/fIM5iCxafZEZmPW9wlb47uC73bRS3Xycpy71xBuPjV8xiq2Hqv8gIpR3
GqLewqJIOhFI5y9sS8u/Jr3Wqfjiwe8AV1/b6Hmha4jeb7t0nXX1p4Q6+j3hY0zQ
S/dElGRATwy5HhB8ERQUbt6lT2+Dk2vZSTZhFEqg0+Qp08N+55e6PZuT+Xit/Q1r
/dx3usXuBeayduIWYBV9id4aaRq+ctdzEuXtI1Zjv7d6kEcSOGwWZ8aG+yZD6z9Y
nwjANdJZN6JZm/chBLoyGbTNt189jZeEhG5Hz4v3/EZTQ6qMx8mo7AXfI48q0lHq
oaB38hjfstD0/gO/OXcGsk0Tuuk9UA==
=ByH7
-----END PGP SIGNATURE-----

--pF5yMaB9u4TNPnza--
