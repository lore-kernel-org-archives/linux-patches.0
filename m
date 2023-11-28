Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81F01E496
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 20:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 80D091C006B; Tue, 28 Nov 2023 21:43:03 +0100 (CET)
Date: Tue, 28 Nov 2023 21:43:03 +0100
From: Pavel Machek <pavel@denx.de>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Pavel Machek <pavel@denx.de>, youwan Wang <wangyouwan@126.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, maz@kernel.org,
	andy.shevchenko@gmail.com, brgl@bgdev.pl, jani.nikula@intel.com,
	rf@opensource.cirrus.com, ilpo.jarvinen@linux.intel.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Message-ID: <ZWZQ15oIkDFov+n7@duo.ucw.cz>
References: <20231126154335.643804657@linuxfoundation.org>
 <ZWUJWhOkbHlwC2YB@duo.ucw.cz>
 <ZWWPJtXZ12WuTtd1@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS7wfy4WKlL7Ln9v"
Content-Disposition: inline
In-Reply-To: <ZWWPJtXZ12WuTtd1@codewreck.org>


--VS7wfy4WKlL7Ln9v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Jani Nikula <jani.nikula@intel.com>
> > >     drm/msm/dp: skip validity check for DP CTS EDID checksum
> >=20
> > This is preparation for future cleanup, do we need it?
>=20
> (For cleanup patches I'd say if it makes future backports easier it
> doesn't hurt to take them)

Well, stable-kernel-rules says we only take fixes for "serious"
bugs. Reality is different, but I'd really like reality and
documentation to match.

Thanks for reviewing the other comments!

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VS7wfy4WKlL7Ln9v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZWZQ1wAKCRAw5/Bqldv6
8vDkAJ0YtcBKZpfIl/OkLQ4JpkKB2vYXQQCfeRvSQHwmxHpgPN4qeij32BUzCQo=
=0csM
-----END PGP SIGNATURE-----

--VS7wfy4WKlL7Ln9v--
