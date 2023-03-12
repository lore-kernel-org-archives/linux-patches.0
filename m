Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3058C5C8B
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 19:45:33 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 82C0D1C0AAC; Sun, 12 Mar 2023 20:45:24 +0100 (CET)
Date: Sun, 12 Mar 2023 20:45:23 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Message-ID: <ZA4r03fWsS3KOQ5O@duo.ucw.cz>
References: <20230311091908.975813595@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qe/Jjd6815Vh63SM"
Content-Disposition: inline
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>


--qe/Jjd6815Vh63SM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

(We tested Linux 5.10.173 (e5f315b55f8e) and 6.1, 4.19 and 4.14 seem
ok, too).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qe/Jjd6815Vh63SM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZA4r0wAKCRAw5/Bqldv6
8iTNAKC7+b+W5w6QYC+TEzNeGZ1QJ0t0DACbB7Q3h2YJWvSVKeRTXupGsyjAl6A=
=5/u7
-----END PGP SIGNATURE-----

--qe/Jjd6815Vh63SM--
