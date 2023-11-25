Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E1517C3
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 11:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2C3471C0072; Sat, 25 Nov 2023 12:19:45 +0100 (CET)
Date: Sat, 25 Nov 2023 12:19:44 +0100
From: Pavel Machek <pavel@denx.de>
To: Nam Cao <namcao@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/372] 6.1.64-rc1 review
Message-ID: <ZWHYUP+i7G63YKwl@duo.ucw.cz>
References: <20231124172010.413667921@linuxfoundation.org>
 <20231124222543.qaM-plhi@linutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HE6FFvPMiZOVfFmC"
Content-Disposition: inline
In-Reply-To: <20231124222543.qaM-plhi@linutronix.de>


--HE6FFvPMiZOVfFmC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.1.64 release.
> > There are 372 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> I got the following build error with riscv64 defconfig:

We got build failure on riscv, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
084460710

Best regards,
										Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HE6FFvPMiZOVfFmC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZWHYUAAKCRAw5/Bqldv6
8tzBAKC3g1GNjymD4OWMrQZGQhk50RiBZgCfb4/N1KUceaBC6oNvkSNBxDm0Uew=
=KxxZ
-----END PGP SIGNATURE-----

--HE6FFvPMiZOVfFmC--
