Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C838354FE
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D26351C006E; Wed, 11 Oct 2023 11:38:37 +0200 (CEST)
Date: Wed, 11 Oct 2023 11:38:37 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/226] 5.10.198-rc1 review
Message-ID: <ZSZtHYMzzzurSE3t@duo.ucw.cz>
References: <20231009130126.697995596@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFBb2XWQo6/4f6Tx"
Content-Disposition: inline
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>


--nFBb2XWQo6/4f6Tx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.198 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.

Now I'm confused. a8d8122 seems to be labeled as 5.10.198 (not rc),
and it was released early.

It is broken w.r.t. Renesas hw, as reported before.

Best reagrds,
										Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nFBb2XWQo6/4f6Tx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZSZtHQAKCRAw5/Bqldv6
8rB2AJ9x5YdUe7APJ+hlOXGFzdAtlUxpiQCfTtCyGrYRk/w4DwEyoq/MC62gdvI=
=pbne
-----END PGP SIGNATURE-----

--nFBb2XWQo6/4f6Tx--
