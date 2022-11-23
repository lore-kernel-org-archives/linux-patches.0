Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C691FA3
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 11:47:23 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4F5401C09DB; Wed, 23 Nov 2022 12:47:21 +0100 (CET)
Date: Wed, 23 Nov 2022 12:47:20 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Message-ID: <Y34ISJA4/YGREd/4@duo.ucw.cz>
References: <20221123084546.742331901@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtFXNc2ONGWFLTj3"
Content-Disposition: inline
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>


--BtFXNc2ONGWFLTj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Nathan Huckleberry <nhuck@google.com>
>     drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

This is just a kCFI annotation, we don't really need them in stable.

> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     rtc: cmos: fix build on non-ACPI platforms

I believe maintainersaid we don't need this in stable. Should I google
for exact mail?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--BtFXNc2ONGWFLTj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY34ISAAKCRAw5/Bqldv6
8qLSAKCjwrr9fgSafQdFixlYfNeVyxeKkgCfUFkFsreiSW/nkw+OeOnX0IpD7j8=
=hiAh
-----END PGP SIGNATURE-----

--BtFXNc2ONGWFLTj3--
