Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E3927701
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 19:47:50 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0C9DC1C0006; Mon, 18 Sep 2023 21:47:48 +0200 (CEST)
Date: Mon, 18 Sep 2023 21:47:47 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Sameer Pujar <spujar@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <ZQipY8MUrNSpOBOB@duo.ucw.cz>
References: <20230917191051.639202302@linuxfoundation.org>
 <dfe78c1a-8322-413b-f1b7-3a6a307a831c@nvidia.com>
 <2023091846-cabbage-imagines-3fde@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RsvENpkY97gWjqyL"
Content-Disposition: inline
In-Reply-To: <2023091846-cabbage-imagines-3fde@gregkh>


--RsvENpkY97gWjqyL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Sameer Pujar <spujar@nvidia.com>
> > >      arm64: tegra: Update AHUB clock parent and rate
> >=20
> >=20
> > Unfortunately, the above change is causing a regression in one of our a=
udio
> > tests and we are looking into why this is.
> >=20
> > Can we drop this from stable for now?
>=20
> Is it also a problem in Linus's tree?  Keeping bug-compatible is always
> good :)

Please update Documentation/process/stable-kernel-rules.rst
accordingly. People expect certain properties from stable tree, and of
the rules written there only "It or an equivalent fix must already
exist in Linus' tree (upstream)." is followed.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--RsvENpkY97gWjqyL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZQipYwAKCRAw5/Bqldv6
8ga/AJ4rIhtWw5HCsxMcbFWd/XpshfXZXQCfWx27itd90g0HydpGZLqxlqrRFJQ=
=JZbM
-----END PGP SIGNATURE-----

--RsvENpkY97gWjqyL--
