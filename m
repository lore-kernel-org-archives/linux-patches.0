Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA3979C5
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 19:02:45 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id F3A4B1C09DB; Mon, 21 Nov 2022 20:02:36 +0100 (CET)
Date: Mon, 21 Nov 2022 20:02:36 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
Message-ID: <Y3vLTFCZzsl5/bkr@duo.ucw.cz>
References: <20221121124150.886779344@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmoRar13e3jH32gZ"
Content-Disposition: inline
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>


--cmoRar13e3jH32gZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
                      =20
                                                                           =
                      =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y                =20
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
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cmoRar13e3jH32gZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3vLTAAKCRAw5/Bqldv6
8jEeAJ4yLekh7lTJW3IJZCSX00FIofF0RgCfVggNVsadTCCJQfGYMFNW/k3URr8=
=nvlH
-----END PGP SIGNATURE-----

--cmoRar13e3jH32gZ--
