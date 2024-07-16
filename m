Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB78208DA
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721160704; cv=none; b=UlVy7pW7Tn7YJyIvjO1c/if5eUMRX/IA4IBaFLteGyioP58Y+BTGfWJXzUkfD1viZSgM4GEregv3cOCm+vDor0djdcj/qsnI3OqXTUET6T+ErtLDhGG8bM2OBQ8/2a/hHfKlE9OaaI9RBrMCuCh7E47HPEpCbTCQZhkKR1lrKyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721160704; c=relaxed/simple;
	bh=8HSN7MlmJOklhIyTJDTjqmQnsv/lceoUg2a1fAPse+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTIgQR1PCOeYhLYyw8cam6NYRhRFgAEeHa4pCJ5on9VS61AlZ5/x0aUbJ9g82C92GSDnjfBNCz+7xqXy5wr2VDfgs330OJ+Bhnoq/pKBGt8OC3T47xMgnPRiQteO7qxFkeiKyWT8YtO+z3HL1qHHPSqo0QArxJWQRaXb32kJCec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 726D61C009C; Tue, 16 Jul 2024 22:11:41 +0200 (CEST)
Date: Tue, 16 Jul 2024 22:11:41 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
Message-ID: <ZpbT/cu3seKyKyqO@duo.ucw.cz>
References: <20240716152738.161055634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VlJuuHVad2cKKUt5"
Content-Disposition: inline
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>


--VlJuuHVad2cKKUt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
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

--VlJuuHVad2cKKUt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpbT/QAKCRAw5/Bqldv6
8pn7AJ46xrre4x+iqVC/e5ZbJFSRh63bDACgq7+398WiLxT1LBk/rsIkmAuw9gg=
=poJc
-----END PGP SIGNATURE-----

--VlJuuHVad2cKKUt5--
