Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BAE23E358;
	Sat, 22 Aug 2026 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787404622; cv=none; b=ppKWLQiz6Ne2zeCbpu+3cih6VBVA/5WVnO4jDl2ofsFgVsYKdo2I5GpezpuRJo/k4xIA28d5FXuLN9rJZi1HTGdat+Ie0CNxLoWxHI0CnWE6I8EF4jtsnMEm0qFfaQpKfSJVJV1aczrRnFuVniBBW2rTqMkOHhQj3MIwMRXDuGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787404622; c=relaxed/simple;
	bh=BR1snPkwfkVnUInI2lrLvLYNLTq0C1xu8dEch5EeNoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZS1ABKuBNKx7SZyzMh1rsyOqbmKfDmQuABo5TY9UNk6LzSNCb0jzGkNt1GMMA+wT4jbsGxW3w2xX4sXPKYytjNYO/gNIkgsisAOMJwAgGI1aoPO0P4nEZQWaSxuGNuQbzPu4n/IkmtCVHA36im6DxhK/Sver+ZqTRTKupDKtYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJT88XFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJT88XFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D41B1F000E9;
	Sat, 22 Aug 2026 13:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787404620;
	bh=kNKVf9sRlqgsau86MH6/g1YjUq4xz4HaMGbi8JaDRcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BJT88XFcCbGAAalyyS0AgzO/6agys4UZjODr/fOnxRk1cAuOcBNVwgiBFYv25aTn4
	 rA9lZeQR3I3JSeELf8QjmF67oO2qax62jbI8F80lqXxcWRjy+HQBAYTXFikQO2mlZr
	 isLnX4RQeWmwsMXHbJtyYnt0k656iV4YoK/m6/oLqvQiSvGhzhisjSea+vXGvFn/cN
	 oI11iEUB8fYnwhuS4rUIX8cT0iWgLmFRpSq4ChGDkPo/9pZ6BdwBg7CnDHax0Sx7Lw
	 JYIMVMSLOw+Hyz4MH0lU3uyhuXmrKjrG+fR6P+SvuAS/dWbrKogpzAH12PVhk2KNLZ
	 8VEquw3+N1Ksw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id C42231AC527F; Sat, 22 Aug 2026 14:16:57 +0100 (BST)
Date: Sat, 22 Aug 2026 14:16:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Message-ID: <aomhSULPneYWNuwg@sirena.co.uk>
References: <20260820145253.200766705@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Hj2qyV8B7u0OII2d"
Content-Disposition: inline
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--Hj2qyV8B7u0OII2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:52:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Hj2qyV8B7u0OII2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJoUkACgkQJNaLcl1U
h9Dg8Qf/U6WQ0WHZ4SYOAUspO+jG2cuqxus4rH5CT/TX1N1NTRDMfjfbNAfKhvEe
BX7A3auuOvJPrctDtdLrw8q6iJFyJL44SYAmvaTC++9RE+xUw9TtwLkERBybr+kj
nDVpRfUP9br3vQw8tlgERnaPF+vQrW8W10rppJZqkGuEVSpK6I0v6I5h0ZzlLGnX
wSvrlwFvlJhMLipx0sZWJrEooSiE8tBME0gNP3rbXQxP2ex1P/EzMx5rL7ctogTo
ChQOAZhzqBvjqSOHge/s4Dgrva10ZXJ2LUKVO2xBtPip49U9dF2VP9K20Roym3ws
lgUuOy7+dUL2jVpRkilp7veh5XOlWg==
=pgua
-----END PGP SIGNATURE-----

--Hj2qyV8B7u0OII2d--
