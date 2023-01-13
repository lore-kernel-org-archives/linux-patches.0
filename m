Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506787EC
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 09:33:03 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D17141C0AB2; Fri, 13 Jan 2023 10:33:00 +0100 (CET)
Date: Fri, 13 Jan 2023 10:32:59 +0100
From: Pavel Machek <pavel@denx.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y8ElS+jivE5FWvku@amd.ucw.cz>
References: <20230110180017.145591678@linuxfoundation.org>
 <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XYCzQcN7upoMrEuL"
Content-Disposition: inline
In-Reply-To: <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>


--XYCzQcN7upoMrEuL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 Raspberry Pi 4 Model B.
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> While running LTP controllers cgroup_fj_stress_blkio test cases
> the Insufficient stack space to handle exception! occurred and
> followed by kernel panic on arm64 Raspberry Pi 4 Model B with
> clang-15 built kernel Image.
>=20
> The full boot and test log attached to this email and build and
> Kconfig links provided in the bottom of this email.

Full log is 11MB. That's rather... big for an email. Please post such
stuff as a link or at least compress them...

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XYCzQcN7upoMrEuL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8ElSwAKCRAw5/Bqldv6
8nsQAJ9lZgYFZdyj9N+xPb683pLscM0lqgCcDrW+2w/2k3wcoopdIFYzgsvsejA=
=ON0+
-----END PGP SIGNATURE-----

--XYCzQcN7upoMrEuL--
