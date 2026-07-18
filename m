Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27343F0BA;
	Sat, 18 Jul 2026 12:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784378427; cv=none; b=HvxXTBLgyClj3q3TDO5Qb9ZXTzPz1IzaZmT/0CsZSiKW9SFJarLN/6PUm7rAYGrLEgJEtbPJWpin2+MKogXZqTaZEOp6js2yi0zd5fhFK1t80K2mI8clN+yXurEdkezTIJho/CvTLphYoFKQ5mh6ch2wfYHzqAFRPvseVw4KMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784378427; c=relaxed/simple;
	bh=VpS26vOWIC06pLMZFqWFCI6uY0oG87ADXfODEoafXbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGBVOmPUWRwn9B4xkAti3DyuLzi01XuI7tFHu+WEQFE6hyCXNNgxjefzO9zKQQla0nwEPLE5Uxi3wzIfJD3QhZ4VnQMglZt16I2YSkrcwg7dE05fOmK77fLJoRy/INnC5H3E08hoQgPZiC6FfFrHFADv69luuxn2g235jWcjUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpobY+V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpobY+V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F32C1F000E9;
	Sat, 18 Jul 2026 12:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784378425;
	bh=dWWVnONgZXVQU1lO4CFud7RX7kjavSmGP49NhOVJsng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KpobY+V+5iGp8aqgvEmfqBuNqvD8UEi56Z4AdJt1ucyFSZTSBoyN3lZG+tI7svzqp
	 k9yWNbq2l1F6R70RGrXUDfnFjbBQTo3C+nNVJDFeI31n6HDTPjh8kDNJxR8HvA9znw
	 y6IPE1Aqk2b6d1XITo3xzZ6NJ+b8iJIM+ppEu2vMa3RPxod2bhCmO6tTgNdJfEZVJ+
	 8rfOfvFmcLfmd7ctFdreogEx4nqy+WrNb1/vI5PuSWUm5SCqlZetqLGJynhMJZtozb
	 7r1BrEGVgHzRlolBK2hkx5AVofPL16Jg8446MTsBcHnw0rrVZ15rS+MXhhUbQYIQZZ
	 9KMpDfGwC5dOg==
Date: Sat, 18 Jul 2026 13:40:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/357] 6.12.96-rc2 review
Message-ID: <aaab2374-7025-46f5-9676-5863587edbb3@sirena.org.uk>
References: <20260717101823.379399592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xiFrj0uqfNJ+2Non"
Content-Disposition: inline
In-Reply-To: <20260717101823.379399592@linuxfoundation.org>
X-Cookie: Do not pick the flowers.


--xiFrj0uqfNJ+2Non
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 17, 2026 at 12:41:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--xiFrj0uqfNJ+2Non
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpbdDMACgkQJNaLcl1U
h9DEVwf9GJmL8CDFKdkYKIqF+w7OsrUOsXAOhDoqGo+t/44nsVzMhm8Vk1r+FM5P
EkkcgcklmQ1DmBKJVnqs76PF85IKCQcXZB7na8ognEYt5UZbGGUUGl8ZzCbTpwJI
IVVqte0nCfPjQVbIIlQw5JQzR8e4f86UzXi3lAPxCTcKT/KrhUuQ8vlvmuJdWMg7
ZH4TZguqCunHUbHg/jtf9yF/7LHiuZPpkuSjyMFHWKQZEX+I5YvagZTsRMA2dgmG
3hG6JJg4HmYQvdpjgfaSq664R9f6YXHA+6TcPYFQNZPv7HOrCWo+ash0ajr81GBw
hq/9QoTh43qPoFKeKA/O4gJS1i4M6Q==
=7KMy
-----END PGP SIGNATURE-----

--xiFrj0uqfNJ+2Non--
