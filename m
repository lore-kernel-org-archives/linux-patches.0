Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E642EB34
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 19:34:11 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id ECB241C09F4; Thu,  5 Jan 2023 20:34:08 +0100 (CET)
Date: Thu, 5 Jan 2023 20:34:08 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7cmMKUr//oYKWXb@duo.ucw.cz>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DAyEOyzRmfg8uvlt"
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>


--DAyEOyzRmfg8uvlt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Thank you.

Is it known at this point if 6.1 will became next longterm release? It
is not listed as such on https://www.kernel.org/category/releases.html
=2E We might want to do some extra testing if it is.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DAyEOyzRmfg8uvlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY7cmMAAKCRAw5/Bqldv6
8pqJAJ4/YfINv5Euqccv0dO35v2LvEq/tQCdEWqYh718akCnEq2hGbjbdK9w/nU=
=Sj9A
-----END PGP SIGNATURE-----

--DAyEOyzRmfg8uvlt--
