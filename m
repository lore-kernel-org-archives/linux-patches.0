Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91891405EB
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 10:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1356D1C006A; Tue, 17 Oct 2023 12:03:12 +0200 (CEST)
Date: Tue, 17 Oct 2023 12:03:11 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
Message-ID: <ZS5b31zuOxXuAAlE@duo.ucw.cz>
References: <20231016084000.050926073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZuOvj95TIyZYdPCo"
Content-Disposition: inline
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>


--ZuOvj95TIyZYdPCo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

                                                                           =
            =20
CIP testing did not find any problems here:                                =
            =20
                                                                           =
            =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y       =20
                                                                           =
            =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
            =20
                                                                           =
            =20
Best regards,                                                              =
            =20
                                                                Pavel      =
            =20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZuOvj95TIyZYdPCo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZS5b3wAKCRAw5/Bqldv6
8t48AKCMl1eXo2hOctKzIOB5i4EHqs+f/QCfZIY266G9/gPn9kp4hQxQlekE2D8=
=wuuW
-----END PGP SIGNATURE-----

--ZuOvj95TIyZYdPCo--
