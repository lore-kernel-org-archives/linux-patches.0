Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE3420B4C
	for <patches@lists.linux.dev>; Wed, 10 May 2023 11:56:57 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D95A21C0E50; Wed, 10 May 2023 13:48:49 +0200 (CEST)
Date: Wed, 10 May 2023 13:48:49 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, seanga2@gmail.com,
	roger.pau@citrix.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
Message-ID: <ZFuEoWJL1TRmEuMM@duo.ucw.cz>
References: <20230509030653.039732630@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3feHP3ItjbT1YT6U"
Content-Disposition: inline
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>


--3feHP3ItjbT1YT6U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Sean Anderson <seanga2@gmail.com>
>     net: sunhme: Fix uninitialized return code

This one is wrong for stable. err is still initialzied to 0, which is
wrong thing to do. Mainline is ok, but fix does not work for 6.1.

> Roger Pau Monne <roger.pau@citrix.com>
>     ACPI: processor: Fix evaluating _PDC method when running as Xen dom0

If the condition can be handled (and code has "return false"), it
should use WARN, not BUG.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3feHP3ItjbT1YT6U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZFuEoQAKCRAw5/Bqldv6
8n5+AKC/SFzVGGUaufYOoWyVkK64FtNAxwCguyBJql+rxqKvkmQaoN67VBU3gNw=
=h8+c
-----END PGP SIGNATURE-----

--3feHP3ItjbT1YT6U--
