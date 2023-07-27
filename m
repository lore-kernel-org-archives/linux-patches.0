Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44B156C8
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 11:42:27 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 556281C0A99; Thu, 27 Jul 2023 13:42:25 +0200 (CEST)
Date: Thu, 27 Jul 2023 13:42:24 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, arnd@arndb.de, masahiroy@kernel.org
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
Message-ID: <ZMJYIAXHGCh/8zLv@duo.ucw.cz>
References: <20230725104507.756981058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M1hNpiC3mFJoKO2Q"
Content-Disposition: inline
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>


--M1hNpiC3mFJoKO2Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

These should be dropped:

> Arnd Bergmann <arnd@arndb.de>
>     kallsyms: add kallsyms_seqs_of_names to list of special symbols

6.1.X does not have that symbol, we should not have this patch.

> Masahiro Yamada <masahiroy@kernel.org>
>     scripts/kallsyms: update the usage in the comment block

This one is wrong. We don't have that option in 6.1.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--M1hNpiC3mFJoKO2Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZMJYIAAKCRAw5/Bqldv6
8qHLAJ9xjKqg4nZtBW1hUAht46k5PhX1iACgrX0xYHaOBZFzPh8LtK20i8hQcx8=
=eYJ/
-----END PGP SIGNATURE-----

--M1hNpiC3mFJoKO2Q--
