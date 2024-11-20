Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF7153BED;
	Wed, 20 Nov 2024 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732121061; cv=none; b=Ra5vad82QWRl8yEOdLqpBjrZN4bY50QZhcUZY527FdS8rFtOC///VYRvPuIVJ/6x7TwQdLn397eyaltN/4oP+E4oxYU2jHlkK8nVxfF1Veuqdb16l/fblfXo3VvJfb6cSrgf7GlH86YWtlzWoo+2a//IBEI8KM6MriWLhfPJZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732121061; c=relaxed/simple;
	bh=PLm1O8VD+F91NL9h/2SyCyeSBRV19QokfhIk2HQe1BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVluuRMdk6BudQQ3Fbd6Lko2RcG+w4WNLayf4uULu22172LFubK2Pe7JkWkqSMifIhPZUoMMf9RgjdR1Q5ejeh0MVtQ4eJsY6d57lYbqs6n9HUyx6zdtmyx6HPSJYj4PQocWnEkPnx3fNueOU5dLM07B/zXhTyeWdNXzMKmR35g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWHZ2dwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWHZ2dwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FD5C4CECD;
	Wed, 20 Nov 2024 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732121061;
	bh=PLm1O8VD+F91NL9h/2SyCyeSBRV19QokfhIk2HQe1BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lWHZ2dwZaNen8AD0m4seX+fOydRqtHGt8QZyiaPxPeK0eVC1eQvNq26DkFMDR9InO
	 8G5qbEt2XhxC3ODxHTSEtpXBJ7ZwJ0/0NC02FzZBi4p0hoULKeuHz9/SribuMcp2og
	 i5pM56Lg5g1bSzmsh+jv7uEz/Ffwql0651tP3KF2aYcVYmgCoc3GZvGEwK1QkDd24j
	 8NaFswUwsqzHYicHnckOGQ5UW3VpYUz40ZX/u6DAwo48nHv4B98OnKw/lPjYdopT5r
	 SkA3wALSRhmwHtAzBoJxo2oh5eANFuJCu8maeLRgQdkztJ19/EwAIXsQU7p6IZv6Du
	 JOPu+wmeSsC4g==
Date: Wed, 20 Nov 2024 16:44:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
Message-ID: <36610120-dfb4-4b4f-ae19-c944e7eca550@sirena.org.uk>
References: <20241120125629.623666563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1Et3L2Rk7paorokE"
Content-Disposition: inline
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
X-Cookie: Place stamp here.


--1Et3L2Rk7paorokE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2024 at 01:56:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.63 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1Et3L2Rk7paorokE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc+Ed4ACgkQJNaLcl1U
h9AzTgf/TNB2uElU3nt/5zbg0XwNucoEIcEg69ceB9VVgCbZl7QA+DBmlN2rH22A
Js+dw1/i2WGZMzIvjxwY9JnoOsi0RE/ZBNHUVL+iorGDpZbj/uexfyJz9+qKaSSx
8+37q1V1643kW46REyPeETEj0dhLZPPM+BPpeXJIPhT9/22GmL5P5eHWf6xJuh4o
U2V+ugAUs8XWuD6Pd1XD52CBPfMGhP7mc1tvArTgdUPMFx300//UbsqA/japxsUy
Aa9MDv1HeLijAccY0s4dvx3HNWmoATVVJwSzac+zkvrGWc4VFeUs2/cEyrfuIkLv
7578+aeG48iXXFSzGBMfJQPnQrlBkA==
=+DW3
-----END PGP SIGNATURE-----

--1Et3L2Rk7paorokE--
