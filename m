Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3258BE1
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 15:14:44 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id CD6A61C09D8; Tue,  8 Nov 2022 16:14:42 +0100 (CET)
Date: Tue, 8 Nov 2022 16:14:42 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Message-ID: <Y2pyYsNkI8AtuB5+@duo.ucw.cz>
References: <20221108133326.715586431@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZiDR8E0XoFAGHITo"
Content-Disposition: inline
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>


--ZiDR8E0XoFAGHITo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.9.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZiDR8E0XoFAGHITo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2pyYgAKCRAw5/Bqldv6
8qw5AJ9D/Vj7JBB0liAQMYIuFnY7bDVSbwCfX6kRpXpnTsxI3GuNja5SdgNaYuY=
=Jesa
-----END PGP SIGNATURE-----

--ZiDR8E0XoFAGHITo--
