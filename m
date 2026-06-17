Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A73F58D1;
	Wed, 17 Jun 2026 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781706385; cv=none; b=UCijoIc9Np3DSRuihTEnan/VHRieUg9193die2k8K3u2YKzo8mU4bfb7hi0QUGBd4HfIXITVccldZBQzdu4oEGLdO8f9VX/3iZNod8YaDMgwlko8rViR68kRJPdau16wLMVg1mvJivnmYHVOFipgMJv4umf6cd+lclflxcEZaMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781706385; c=relaxed/simple;
	bh=piWZjWgpY6i97lZ7IrOOepD5NazW4NIySKzMMZOf3L0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+3zWEVa7NWQVUUitUBGy5RElZEG9Uq53p6aXNKz+AlBdTcS0abqxd6SJ2o2t9LIYHeXiuhrj2d3nVVj1wWZKYBqak1d8p4INnJt43s8XKIthSHn6OlIx69yxHyjJoyeYwGB+W4tVPB3Lx9SoQsEJcNXzG5vXNpxWht1pfI9sn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4ZGvepd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4ZGvepd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCE01F00A3A;
	Wed, 17 Jun 2026 14:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781706384;
	bh=cyfcgLixjIJ/ZNlakykDFftx+mwdMiYzFjxXOqLJVTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J4ZGvepdX7KfkIpO65JtGyM0MQn/jAJ/90zWXZr8lKJqcLA7aHu/6PrQLVLTKDx3E
	 X92s7E+EwnhOhAZuH1Omrscj/Ia4lqXFYB6AsmO0O6P84rK7MuejoeLheAPDBZ5pOl
	 OsZ3MdvdNedbSf7YH12mEaU+x+5f7sR+g9pSajP60drIMZInnaJ6BOnl92YK7V1EQw
	 nlqS4n35wEE32g4f8KUa8ufHdRw5ziUvNCathRn7UyK+kREOamQDh+yPI5lzLNzFCy
	 w2AgkKDaglTEb1LojrIcTp5mf7IyDPt9macYSHjBAd0R4SZQ3EHC8vY4Jb3PNyCNZD
	 tjdlpqV/bUKRg==
Date: Wed, 17 Jun 2026 15:26:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
Message-ID: <89b84c07-9e6a-410f-a279-321a8085d167@sirena.org.uk>
References: <20260616145125.307082728@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QoVnGzZQg5ZjXRwR"
Content-Disposition: inline
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--QoVnGzZQg5ZjXRwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 08:22:27PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QoVnGzZQg5ZjXRwR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyrokACgkQJNaLcl1U
h9Dwhgf/bDevMaXuBDwdT9jacbcZaEBGkn+FyQDM4e+a+SDqXPHk4gRkAxB8XBcI
qJUOgdzBkRzQh5VLPMS4ieUxnIK8ttopMqlolouemwphG3SsZ2RYLJtI4b3d4xw4
X8rHG1z5OJZl1D6t1QjvkH57x0OxnC0TTo9B5pSOC7SyjzjVCphCE4BAYQuzB6ru
l/Pi6JjCJ3ot7kZs06AoPaOGQbXARWo6XsN/l9/DjwdAEwGTbfRRQ6Bm/wL9Y9jY
Cj7Ca+2I5p4K0G4byKj27om/nes6EF/RtgUD0I0lkNLt/dK9CQYqnVO8R78wFex9
7PDoHISig0enmM1p9L772uWrspY13w==
=qvu4
-----END PGP SIGNATURE-----

--QoVnGzZQg5ZjXRwR--
