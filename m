Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A304C1A4B56
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722517221; cv=none; b=eR3tg2+3j12vi3tsQRtYSth0sBQ7LDrdePM4dmFhXpBeLgDd74t5jaskJwU72SJvNaOFdUMTz5kZey2QYaEHmYdyQrpX9x6WApnGOfX0RvXjAvArmb4fzDEWKE9UWClLDys47rJfppBsg+gjoisJO9zBhFEjcrlaao93fT4PvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722517221; c=relaxed/simple;
	bh=kOzKLb8Be8mSq/zYvwMasuEkLwPYZu/V680ihchVzj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7j3heIZZq8DjvEqkEuOoKmFItZLn3IVtRdrH/ushzQq/0jAi0s2S2FVyV7EsxP5Js7qdG7zzDQ0ZRhC6cIrmP92tihTLy4A9AS0eHBo4FL/bM0cF+kqlSAqvIrvOiC+qxM5Wi1Sawxv/wPP1SBiOuLN7D9tG8isnBs391QULBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 5F11F1C008E; Thu,  1 Aug 2024 15:00:12 +0200 (CEST)
Date: Thu, 1 Aug 2024 15:00:11 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
Message-ID: <ZquG2xoGJ//tHLvA@duo.ucw.cz>
References: <20240731100057.990016666@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bo/1npVvdSUvBvJ7"
Content-Disposition: inline
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>


--bo/1npVvdSUvBvJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bo/1npVvdSUvBvJ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZquG2wAKCRAw5/Bqldv6
8mw1AKCgDTQxE53LHwZuAmaEm9WlF+F24QCcC2u5LG81Wl4icxZNzKCK0zgBMqQ=
=Ifl8
-----END PGP SIGNATURE-----

--bo/1npVvdSUvBvJ7--
