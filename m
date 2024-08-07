Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAC77119
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723052768; cv=none; b=l4v9wmzONiSdddvSUKJymVQzRNHi1Dka9bCbWL2u10QsuiApK5ma6ob9ZXZLOQ9ECBSvk3zfF8EGPgZkxXNs/84MRgAgCJ+hhfXOZnD9q9mABHbjPK/L8CKMGeUpY+4PycfFYsTrwl2+GdTJ8Tp6RMh+in0FWBilOySN/tJj75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723052768; c=relaxed/simple;
	bh=gF081KCfJ5B+lAgNuy87qr5XocQ6S3L9ZKRS3HBuzeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlcxQhgcgsShRLzBK7tMwcO/KxLKRX14dNekTOmChe+DPHM1eMAHTfdIMUY5aF0zpOw8u/jcuVJO64fE05ob0EOIzJnnITFLbpkYvZlbGKyZxbJoWauZI8z0peExqcfCZjdOVSdWADi4uBBtmctTOrm+IKwcSvKNLLAeqMXtg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 8AD631C0082; Wed,  7 Aug 2024 19:46:03 +0200 (CEST)
Date: Wed, 7 Aug 2024 19:46:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Message-ID: <ZrOy2l/ukmsvOVUF@duo.ucw.cz>
References: <20240807150020.790615758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="atc206epg6yZT1AI"
Content-Disposition: inline
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>


--atc206epg6yZT1AI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--atc206epg6yZT1AI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrOy2gAKCRAw5/Bqldv6
8uU8AJ0TieuE9Zgi/fKbxidFQE/jx/EVYACaAyt+L1zKdNy9ZQOdDbPEegiJaNg=
=kpy0
-----END PGP SIGNATURE-----

--atc206epg6yZT1AI--
