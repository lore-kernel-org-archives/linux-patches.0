Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974D1C27
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 12:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 375621C004E; Thu,  5 Oct 2023 14:27:41 +0200 (CEST)
Date: Thu, 5 Oct 2023 14:27:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	sakari.ailus@linux.intel.com, davthompson@nvidia.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Message-ID: <ZR6rvGqpwdSeOeHt@duo.ucw.cz>
References: <20231004175217.404851126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XViw4iWp1HiFdjEt"
Content-Disposition: inline
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>


--XViw4iWp1HiFdjEt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Here are some issues:

> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: via: Use correct dependency for camera sensor drivers
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: v4l: Use correct dependency for camera sensor drivers

These are is unsuitable for 6.1 as the VIDEO_CAMERA_SENSOR symbol does
not exist in 6.1. Please drop.

> David Thompson <davthompson@nvidia.com>
>     platform/mellanox: mlxbf-bootctl: add NET dependency into Kconfig

Unsuitable for stable, we don't have that problem in 5.10 or 6.1.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XViw4iWp1HiFdjEt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZR6rvAAKCRAw5/Bqldv6
8lvhAJ91rfDV5NSdjN/Qh8IDmX0ImzH9NQCcDtHVGtw2iWmeB4kUzud6QcqOHOM=
=xyQd
-----END PGP SIGNATURE-----

--XViw4iWp1HiFdjEt--
