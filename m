Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692747B
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 21:35:40 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 03D5B1C09F6; Mon, 16 Jan 2023 22:35:38 +0100 (CET)
Date: Mon, 16 Jan 2023 22:35:37 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/521] 4.19.270-rc1 review
Message-ID: <Y8XDKdUQ2JMgCB3x@duo.ucw.cz>
References: <20230116154847.246743274@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vJclO4rIwnOYAZ+"
Content-Disposition: inline
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>


--0vJclO4rIwnOYAZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.270 release.
> There are 521 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0vJclO4rIwnOYAZ+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8XDKQAKCRAw5/Bqldv6
8o7+AKC+7b0Tr5vR8oQDn6aOTvm3FbC+HACcCSMFb6IUfn9vogJQSy9HzYyZ2vU=
=ZT6+
-----END PGP SIGNATURE-----

--0vJclO4rIwnOYAZ+--
