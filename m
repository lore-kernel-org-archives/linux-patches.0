Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC85C1922D5
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718357890; cv=none; b=MOiJq1Slk7AZHu7m6L87vxMbtisaPGVTkfjGBNcO1L1V37Pb9QKEPUiRvMEiQlL+PY2nU0ckj3q9RKi2Ta4PgwPveOuytVazK1E73f/m+/Fg9QT/HRm7LYEXG9M78LUjI+VH1/lqHpMezT4W8BYjhdg2wpLyYHkDRE/zvCcIlkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718357890; c=relaxed/simple;
	bh=yk3xVCXhUi85+dtex8ea9Edp2bKOvgEo76IknOTQV6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyzkYW69Rtu9iyiA8/akKtlAGVz55ScwK4VHW4EUQBHMIP6pQD3RgwrTFQCLmf1923zfA0zUZsnvjBMPjPSZPJ80IdIkJH8Swcrvx/WYLCw488PlcVGsd6zkfcmE5ErIV120VCEaXk0QwKyZVAPBCvn3GrUWlb6PLtxSLq3LNNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1F1C91C0082; Fri, 14 Jun 2024 11:38:07 +0200 (CEST)
Date: Fri, 14 Jun 2024 11:38:06 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
Message-ID: <ZmwPfqvcarQQ/cLx@duo.ucw.cz>
References: <20240613113227.389465891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ln8mXAV6eA/q0+pD"
Content-Disposition: inline
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>


--ln8mXAV6eA/q0+pD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ln8mXAV6eA/q0+pD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmwPfgAKCRAw5/Bqldv6
8gqSAJ4oRJOMNzHexwIwalZ8RDexZwxOswCcDNXeiKfRmeRIZA+U/2iP25TYza8=
=nCwR
-----END PGP SIGNATURE-----

--ln8mXAV6eA/q0+pD--
