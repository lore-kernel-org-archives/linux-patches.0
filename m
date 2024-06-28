Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A251B94F
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 19:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602792; cv=none; b=I4JTOI/wSQu6Rf80J1uswBzL1ClDuGtL++i1VWhl9p2wWy4zit/JlRFrpyc5nlGtR8tW3FHr3nKlrp/Y5f3f/a0Vr2LmuEFWLxRmx8UyEXX6So+wY0No+gHPnVKS+861rWuWgYQ5UZ7dVJcCygKJD7lC9stgJ11KLEee2JkgNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602792; c=relaxed/simple;
	bh=eqO7Ki95NF/BQYKdUKvbuFsOVwpI1DEUVyudC1vvO4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMVlnHlVIImox7YXv44qFink+AoP8KjrhcglhCqMn/cntF83FjxQ4MbW9AwQbCh5O/NlWagtvZeAkWHmSYaC6XJpiyJlcfKIUD7zcui0h1tfwbaJyU859zT0ArGbfFfAGcej7k6Sl8Pdl5VFiRR88sHQpv4wx5v0Ly94pMWEDs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=ucw.cz; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AA2E11C0098; Fri, 28 Jun 2024 21:26:29 +0200 (CEST)
Date: Fri, 28 Jun 2024 21:26:15 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
Message-ID: <Zn7mPrqkeztjS30d@duo.ucw.cz>
References: <20240625085525.931079317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XR9LtlHv+hRnaETr"
Content-Disposition: inline
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>


--XR9LtlHv+hRnaETr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XR9LtlHv+hRnaETr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZn8OVwAKCRAw5/Bqldv6
8lcyAKCXlB7kNp2gH8Qz4A1lFKvDnLSW8wCfS+OEU3BLDs6TJgvzoy25imcGqXg=
=bGHm
-----END PGP SIGNATURE-----

--XR9LtlHv+hRnaETr--
