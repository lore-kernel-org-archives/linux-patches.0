Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D03B7A8
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 06:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721800871; cv=none; b=VgpttiQd2u/AEk4ifg9IFWhMa87/d1MJTGZryY/KXjN3gFSh1M5Q633/cpNz87BwCoyl9p76WmzChO34niIQHo0IAk5ac5aiXnJ3hZhF7sBoxGuvmgKB4BV6zsA7bVo5c8hjSNQooX20iy6kIpM755dejBbXCNjZSVrMlJKDzLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721800871; c=relaxed/simple;
	bh=pVYRbbf669wNRKAoGCCyM5jD3NVuv+jVryjtv1tk/Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCJ6zp+bRUClTL/POnCuYSm6BK8ICndngo6ahhqGd5ZXsTOGiKvdna87xMExIu5njBR/IB8jyJ/nm8kTH/8kv0vBbFlBQT6j7wFZ6VS79z4kDiFxkl+JEtRaudkJOSyNar02BC6IAUWcUbLYDy59AamxGsAWPiKMXuAlNgNDdHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=ucw.cz; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id DCB731C0082; Wed, 24 Jul 2024 08:01:05 +0200 (CEST)
Date: Wed, 24 Jul 2024 08:01:05 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
Message-ID: <ZqCYodrxetiXGi3u@duo.ucw.cz>
References: <20240723180143.461739294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QiJ3GPm5U9mN+hWa"
Content-Disposition: inline
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>


--QiJ3GPm5U9mN+hWa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QiJ3GPm5U9mN+hWa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqCYoQAKCRAw5/Bqldv6
8tHPAJ9Ix3+qmfriVFNFTiqmoCed7sA++wCdEsg7c99UgMeNEnLiVEuMyChRdgE=
=bcAm
-----END PGP SIGNATURE-----

--QiJ3GPm5U9mN+hWa--
