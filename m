Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775383A7D73;
	Mon,  8 Jun 2026 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780914780; cv=none; b=dDzuD3pEFqqP9Yy/E2ZgkNd9DT4XYrlXFUcjdj6oWhsck+dZTLMEPUIzoB8QAWgAYUKPXGFgmV6mwVdwMNB9CnQjcvv1uryMLMEhIYPp1io3qrNZrnkN1B0qbgV2Kux26dEQG0v3Ewu1x9zB7mPAXMXjG6DIFLSjekr8zapK+ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780914780; c=relaxed/simple;
	bh=ucsg0y+vPwq8t29TzyjveuC8ZlV9NyOnmMvknbjahTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unGnrxaJ0YqT5zDpNOvrWsdfeDrs3w8VqCJnp9E9pd+bERau4FHTAXfW/fnriuZd8dRu+MWU+VrpM2CHUuTiytnlCDrtUWCgtEAV6GdVzTtDGVQhN88p7OT5Pk4/UkZtwkYybezd8qdKVxOMDTK5VqTUVa8IUJSgreid6o82sks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGtuydwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGtuydwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944981F00893;
	Mon,  8 Jun 2026 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780914779;
	bh=VrgTX6maMXqQRQypmSw+j2+O4a8NeO8G77HvRI4t32Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DGtuydwvDZAb+N5ZktMkc3Xhzt+vVuaNGoVeYSDc+WzEvES33AHrUixW5MsfzSYbt
	 guhA1OfI5cBsvaUJbAqvvS46T63vjThPjX2VfjWKRtnPxfBdKYKkf70396kEc5pSXA
	 xtVNuF/Yf7JWop+FBx8yzxHfhfgsG9BT1qROEwQCyHOU+plIQIrgzXjq2wZIttiv8t
	 tdlrkHA5Czw3Wr1VEdZoVxUDtZoKgAiHnsqDxjGu/kTqBWZZpI40cfyUlONCmHfw7y
	 nnjy19VwdA7uptTtcKFfeqA+dRn5m3PKpVk6PC7A2LJFaZLi/l+cZ7HFXfwNrh8TKS
	 Zvh5c3ApvEi8w==
Date: Mon, 8 Jun 2026 11:32:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
Message-ID: <a6279a93-5d07-4f82-8049-9309de8fee0d@sirena.org.uk>
References: <20260607095727.647295505@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dM0toQ9JXTHWE8gW"
Content-Disposition: inline
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
X-Cookie: We've upped our standards, so up yours!


--dM0toQ9JXTHWE8gW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 07, 2026 at 11:56:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dM0toQ9JXTHWE8gW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmommlQACgkQJNaLcl1U
h9DHigf9FzMOyfAsTo7ZvRwSI56WikxRKJv0gqpYs9lJ49bUu0Ql0ZBhJDfF3zBi
Ngn9izGW4jqXQGXvNPxDh2uzmHzjxT3NCjgWJRh1TZI5v7hjhVMpN6uMVzlDlSIW
3/LX4d0/5tiVKDOPmklTDTGPtydx9D3QyRdJZbzdvSJTOXw8HSCdgH5MN8jXSqls
6Lwenj+zY65FNjQDn32NWCpL2jT/BKsxkkhJlYmhxhzBSViqBREWA+Dsbd2EV7e6
912AiU6jCoF9hhmv6b9tABnRf4mhzbZt/nV3L7nKAR7Q/QKk1AoYqER9BGYNI9jD
8qbpskT9akSQehNZ3ONiXNzaFxsv4A==
=Ft6G
-----END PGP SIGNATURE-----

--dM0toQ9JXTHWE8gW--
