Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD7C3128B8;
	Thu, 18 Sep 2025 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758226534; cv=none; b=uES4gAapVT3UoI+vp5kAZ1RRYkUc152jX6g/ja+M0NnD2SKU1QoDTeqvNhQ0UL9wEes2+JqeYNO3vHT+Q+i2in7SB4GNLaeJk2xMs9eEUflUOXud9yyWW8Uien/t/r30ZCkT6S8gIWJqnGYOJcs5SIy1EISnJzcnF9oDQhHE8iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758226534; c=relaxed/simple;
	bh=HQTm4CMW9+YUNyC28ifG6Tb9djwUQbuPlwyEg/Xqx4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KND9nKLbpCCm+0Xxw+nZtBQyqztnkjlduqwOVQXLscf9z7w4P2kseN4uT+cHC5CpkM5IVx3h7OywhK7mI0Nrx4rOt4GdkP1J1MAK1oCPpflxwKNfiYUUayUvN8ljjO3rysYIC9W6cPzNRSvDvRwm87TBKciDZS8fXXGAAgWrwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxwccQKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxwccQKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEDEC4CEE7;
	Thu, 18 Sep 2025 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758226533;
	bh=HQTm4CMW9+YUNyC28ifG6Tb9djwUQbuPlwyEg/Xqx4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lxwccQKUkKLfcHvCvYAlv/KeXhHwELTRsIYFouON5TvIu8Fv3fbKWwjm0i4JJd4cz
	 y3ldXAx23PHn98MRchmSYsWdDttPtTVxnumr5hq/Lmj5VrSBkoaTrjZGRVoCbFXqns
	 dfbldo6p9xrCIqkW0msjtU1YFhRaOG1lJCXby+HGCgQCLC0SUCbadrnIsJUNPxj/46
	 O9tH6j3yF20q6naf6oKwlK3zqU8wtGP1puZWBFJCO18pleuoGXXq+y+8WzJP3VnHBy
	 tlLDp2bGxnlacFHW/5n0nRwi+nBqu1qpi64VioVSbirOfUWF8k8t1Vys4J6kiMT5Hm
	 w4Hxxv0KLfdLQ==
Date: Thu, 18 Sep 2025 21:15:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
Message-ID: <095a7365-8c06-4854-ba71-2a65865d2e3a@sirena.org.uk>
References: <20250917123329.576087662@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OW6HTeUJpEW4Xj5W"
Content-Disposition: inline
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
X-Cookie: Victory uber allies!


--OW6HTeUJpEW4Xj5W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2025 at 02:34:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--OW6HTeUJpEW4Xj5W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjMaF0ACgkQJNaLcl1U
h9D3UwgAg2Lzpw4vlid0Z4kZVDD9KnB/cWqzvQPiFI6gXsYvMNQcmw90/iMFXBFN
IRbH7hPgaX0KE6QejBQwonXOGXe47PUbpmCZrXGNMieuX77tU6ZpU7hPfLJy2Wn4
LbxqbOGh3106whyvPsfh1vEGH0stDaH0Fg2QcD+IqxPSPYW7z4d/QhHFA3KrTXPl
mlp5sNjP1FChccOXTyMOBwkpw6TYO+a1/FiH6Z3dQpswbK2oXq0125D9t5fyz81v
Zz42oO+S+0ktxztrVcf9DbKBlDWl7vdfywp8xjCqEUpDzMRxNyKwhdqqDjzYN0xg
7YNyuJsGXSAB39lpOfcdbAIif8OtZw==
=pJsT
-----END PGP SIGNATURE-----

--OW6HTeUJpEW4Xj5W--
