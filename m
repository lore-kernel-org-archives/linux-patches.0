Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7351220698;
	Wed, 30 Apr 2025 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746053257; cv=none; b=D+nc/y+8ykE28lwL1IM19xP+oDRZV3kIRS6ff9Ka3uwUwZx492wYihg7TbkEPCHhCLtf9DvM1MOye+wmeCjEWU1Yi8sW5dpWAwGkDvHd4T2rZNeMXXzj2Vh2/UvaMjM3KZiChS0xd+Ez2cyGlR+njDibcluSehz6243ACmopEog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746053257; c=relaxed/simple;
	bh=icaZOJHTHfP1SiqsHfsKKGPz1yEdpgDbbrixjwzNtNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3rfmIt+tPqOyd32AjG6zlQC74vM0SEwzMsJpG94HLsndxM9+crK6aksE+y2i+Moicfvg3k9Op+MpoIGkCZVTYnWYJXQqXg4YYiJDGALOYQpGVu88FzjBru7BIt5awGgGNitnYs5Ch+5l3E7W62ZEub55q2lohXJmYoH8AK8ND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OaUo9ndv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OaUo9ndv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17F3C4CEE7;
	Wed, 30 Apr 2025 22:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746053257;
	bh=icaZOJHTHfP1SiqsHfsKKGPz1yEdpgDbbrixjwzNtNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OaUo9ndvNZFybhw9PEoD0SqKI+I6AaFtRN9RO8592qfO1b34d0uRWQgFG/0Axdh9R
	 IgQWi0Fr1nTzaAE2roJtxhF80tTUxO+9UOrFzpqtgf6JqEE9+feEx3qM2eYsfgUivU
	 2FA+mmYia5rsxlfQlu46/6HAqbfe+Ffuq4a81ZH1ppXKuNzGXLJNay4IhTSpjqKoFt
	 vTqE4jnpq8TEozTWEL3S639eH5x0it5gP0WORAUWE9TSctnVUrFQmlQ5L1IffGpeww
	 fWcjBMeEtrCzNaPXXa8K8Dyp+GoaXEeUBem+H1NS7PnQSaNynxiwH4P2epdlaOqtHZ
	 3Fr+D3/rNnYQg==
Date: Thu, 1 May 2025 07:47:33 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
Message-ID: <aBKohcHRp1MXl0nz@finisterre.sirena.org.uk>
References: <20250429161115.008747050@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8EWfW/Iv6Evktkie"
Content-Disposition: inline
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
X-Cookie: Well begun is half done.


--8EWfW/Iv6Evktkie
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2025 at 06:39:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--8EWfW/Iv6Evktkie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgSqIQACgkQJNaLcl1U
h9CwBAf/TOdaJfX7vwTsTNT0BbYNyH8Xr63G4hGkOtnau/TxOP/4LicRf4C+30Q7
84hN2Mx84HBMQZFg+X2sZLpoN4/j8EyiLDmskn8eANe0FmSKMzXbq7lTKBY3HElJ
ayo85KV4iomrOVUWWFsB0A9QE4KI2pZZBOicIce7SzM5dYSYo3tg5yWS+5BUYgay
zj++o0EeXhUDmoYWsFSxT6ZFHWSqv3IaxwFGXgs0dXAMkt8ZoUeVONa/bh6oeBOv
Dy3lKgl1sx0XcFU0F+eFqtFOrRdYuL+aTp4FsEYmKz0qbw59Dde8jokMDR27DJ41
kc/eB4ace7DaVGL8xt2WhcZNsaNE/Q==
=cqjq
-----END PGP SIGNATURE-----

--8EWfW/Iv6Evktkie--
