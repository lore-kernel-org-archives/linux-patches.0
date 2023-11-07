Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F22D05E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E74521C0070; Tue,  7 Nov 2023 12:34:10 +0100 (CET)
Date: Tue, 7 Nov 2023 12:34:10 +0100
From: Pavel Machek <pavel@denx.de>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Message-ID: <ZUogsgkcirXS7Yum@duo.ucw.cz>
References: <20231106130304.678610325@linuxfoundation.org>
 <ZUlfmlaNzofvgt2w@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9MBxmJllqxdc6y9g"
Content-Disposition: inline
In-Reply-To: <ZUlfmlaNzofvgt2w@duo.ucw.cz>


--9MBxmJllqxdc6y9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.200 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> There's something wrong here.
>=20
> 251e8b0a0 1aee91 o: 4.14| nfsd: lock_rename() needs both directories to l=
ive on the same fs
>=20
> Is present in 4.14-stable but not 5.10-stable.

|22de5d11e 41bae5 o: 4.14| ASoC: simple-card: fixup asoc_simple_probe() err=
or handling

This one is in 4.19 and 4.14-stable, but not in 5.10.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9MBxmJllqxdc6y9g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZUogsgAKCRAw5/Bqldv6
8pLiAKCr6vY0w/ea5AOYNL0cd64Lbge0OwCeMgCMPo6MOPGrprCCiqULM+KNEB8=
=3Egx
-----END PGP SIGNATURE-----

--9MBxmJllqxdc6y9g--
