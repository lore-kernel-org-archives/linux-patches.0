Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325323A6
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 08:55:25 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4EED31C0E45; Thu, 16 Mar 2023 09:55:23 +0100 (CET)
Date: Thu, 16 Mar 2023 09:55:22 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/25] 4.19.278-rc2 review
Message-ID: <ZBLZekJGZkok4WQr@duo.ucw.cz>
References: <20230316083339.388760723@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaPevFxnPeiV/QAH"
Content-Disposition: inline
In-Reply-To: <20230316083339.388760723@linuxfoundation.org>


--jaPevFxnPeiV/QAH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2023-03-16 09:49:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.27=
8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

Still seems to miss "net: caif: Fix use-after-free in
cfusbl_device_notify()" and 2 others.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jaPevFxnPeiV/QAH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBLZegAKCRAw5/Bqldv6
8uTUAJwMy88pTTCQI4pWNMFs3ug9+wB85wCfan6q3+ySh9WN4iGptiw+SlUNUi8=
=McZL
-----END PGP SIGNATURE-----

--jaPevFxnPeiV/QAH--
