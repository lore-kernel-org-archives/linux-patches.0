Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB245247
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 300571C0070; Mon,  6 Nov 2023 22:56:12 +0100 (CET)
Date: Mon, 6 Nov 2023 22:56:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 4.19 00/61] 4.19.298-rc1 review
Message-ID: <ZUlg+zd26I6F1oWD@duo.ucw.cz>
References: <20231106130259.573843228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qq+6ykEKXxcqiiOA"
Content-Disposition: inline
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>


--qq+6ykEKXxcqiiOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.298 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

There's something wrong here.

|d17debc75 a5feba o: 4.14| r8152: Increase USB control msg timeout to 5000m=
s as per spec
|78fca56b7 d2a0fc o: 4.14| tcp: fix wrong RTO timeout when received SACK re=
neging
|8152892c6 adc8df .: 4.14| gtp: uapi: fix GTPA_MAX

These three patches are in 4.14-stable, but not in 4.19-stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qq+6ykEKXxcqiiOA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZUlg+wAKCRAw5/Bqldv6
8lcjAJ9LpOT4RCd0AbLeFyEnFcw7Py5dtgCfQjqVvmOobfn/u86XhOiM5g5Dx0Y=
=zm+s
-----END PGP SIGNATURE-----

--qq+6ykEKXxcqiiOA--
