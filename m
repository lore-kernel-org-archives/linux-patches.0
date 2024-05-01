Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CBD1607B4
	for <patches@lists.linux.dev>; Wed,  1 May 2024 19:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714592687; cv=none; b=InqNsXa+aP797c1hjBjkEPbHYU7Lr1jbsIZHt+2Kk4ChbD0g+fwmEoydHar28gZSNJd1Qp3Huzv2ZPfpJWy0V9IK1tWH+5RNvDMdj9VZ3gUO09nJkcUVcGLwqG1a1wua8zRPx8bsH7otcN/qqFHj8la1A5ZBfNaWikTl6ZzgeII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714592687; c=relaxed/simple;
	bh=7ZqJcDyiOsRiEB3FhDTYF6bnCr4vWyXNFPsh+n7U7f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qG8UFRItWAja+a9wc1dMZgqubXK/Ajdda2ypSjEusNRmscbhC8HNrK80BlS10RWdUKR3VCGOJvJuV5jzqtam2k212wx1tGUDkxZudyjEeVzFdZW/84d9FUDOUK/SPz9bv1CrYcCrmR2M25DURIjRhrxV9ApzHslpp6Ppfx4ogGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EEC061C0084; Wed,  1 May 2024 21:44:42 +0200 (CEST)
Date: Wed, 1 May 2024 21:44:42 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/77] 4.19.313-rc1 review
Message-ID: <ZjKbqmr/k6Lx8ZTN@duo.ucw.cz>
References: <20240430103041.111219002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sO83tbIVf3RyxDk3"
Content-Disposition: inline
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>


--sO83tbIVf3RyxDk3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.313 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--sO83tbIVf3RyxDk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZjKbqgAKCRAw5/Bqldv6
8mtkAJ9uAKxTFMvJzC9RdxiA5f9BLnu7LwCguABtmeOKebnr7hI+9JKMVdRhfRQ=
=QwsE
-----END PGP SIGNATURE-----

--sO83tbIVf3RyxDk3--
