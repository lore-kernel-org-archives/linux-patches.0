Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7519BB1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 18:07:58 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id DE9BD1C0E58; Mon, 12 Jun 2023 20:07:49 +0200 (CEST)
Date: Mon, 12 Jun 2023 20:07:49 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Message-ID: <ZIde9VarEXi/BkzI@duo.ucw.cz>
References: <20230612101710.279705932@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pCCofi7Od6o0plFx"
Content-Disposition: inline
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>


--pCCofi7Od6o0plFx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I notice that origin/queue/6.1 was not updated. Is that an oversight?
It was quite useful to see what is coming.

Thanks and best regards,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pCCofi7Od6o0plFx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZIde9QAKCRAw5/Bqldv6
8mZXAJ9qj5Om9RWhQ4c5ZH5R5FAUZ36JJwCfZ2phh0LhrKGlSN0tlqn5Q+00Rhw=
=t2Dt
-----END PGP SIGNATURE-----

--pCCofi7Od6o0plFx--
