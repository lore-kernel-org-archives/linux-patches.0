Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833E813AE9
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 11:44:50 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B05001C0A94; Thu, 27 Jul 2023 13:35:22 +0200 (CEST)
Date: Thu, 27 Jul 2023 13:35:22 +0200
From: Pavel Machek <pavel@denx.de>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	rcu@vger.kernel.org
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Message-ID: <ZMJWet00+9yIl/9c@duo.ucw.cz>
References: <20230725104514.821564989@linuxfoundation.org>
 <20230727035846.GA3644016@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v37RfGbpMGXlYcwp"
Content-Disposition: inline
In-Reply-To: <20230727035846.GA3644016@google.com>


--v37RfGbpMGXlYcwp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.4.7 release.
> > There are 227 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.7=
-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-6.4.y
> > and the diffstat can be found below.
>=20
> I saw this when running rcutorture, this one happened in the TREE04
> configuration. This is likely due to the stuttering issues we are discuss=
ing
> in the other thread. Anyway I am just making a note here while I am
> continuing to look into it.

So is the stuttering new in 6.4.7?

> Other than that, all tests pass:
> Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>

=2E..or you still believe 6.4.7 is okay to release?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--v37RfGbpMGXlYcwp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZMJWegAKCRAw5/Bqldv6
8u8RAJ0aWW+qCQPiDjOB9diBiJQL+qWo9ACaAgyIcHs0X3Tgy7OLCSwhGHymGF0=
=WG+w
-----END PGP SIGNATURE-----

--v37RfGbpMGXlYcwp--
