Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB098BFA
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="jW7vp6N1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=NAJQ
	zgOcdNSX9MZb65UvbzZn3vNRAYofV4MzKCAyclE=; b=jW7vp6N1Pog84OHIKWZA
	5cSmL4ps2IoEIg51B7E3o+OvQpa6smNR/oE5aErVoTN2CQiSKNiCrD97J1dhag8X
	4CJWAUCVI4xjPXNjF1HTSXbcgzlNazSXUAug97ZIouyUJ+ayH3p8FTEAK+MCg8fV
	YIUEJ6Y2c6iz0YnLzu7a0C6BD97P32ly8Ya+NpIPWwxF7HpsNyDGMoiBzl+7l2P5
	lQGt68/EO+smGAVr3KgpRj3KOGnhFNPGskeHzwUqmvvTdrVV/4whamvk+SZEVNJQ
	aFUNp6utkTsYH2kRCMC97dJt83BEods71A7iT72AcoMaO6xrNIA+NTTGcMIDXPM3
	3g==
Received: (qmail 3055336 invoked from network); 10 Oct 2023 21:07:01 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 10 Oct 2023 21:07:01 +0200
X-UD-Smtp-Session: l3s3148p1@xaddaWEH2OIgAQnoAGlXAD2vdu1iMtuG
Date: Tue, 10 Oct 2023 21:07:01 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Pavel Machek <pavel@denx.de>
Cc: niklas.soderlund+renesas@ragnatech.se, yoshihiro.shimoda.uh@renesas.com,
	geert+renesas@glider.be, biju.das.jz@bp.renesas.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris.Paterson2@renesas.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10
 000/226] 5.10.198-rc1 review
Message-ID: <ZSWg1fv3gOyV5t+h@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Pavel Machek <pavel@denx.de>, niklas.soderlund+renesas@ragnatech.se,
	yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
	biju.das.jz@bp.renesas.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris.Paterson2@renesas.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20231009130126.697995596@linuxfoundation.org>
 <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz>
 <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/kp/j1jVUyZUkyH2"
Content-Disposition: inline
In-Reply-To: <ZSU+GHl1q7T/TBp5@duo.ucw.cz>


--/kp/j1jVUyZUkyH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

> And testing failed. So
>=20
> commit f5799b4e142884c2e7aa99f813113af4a3395ffb
> Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Date:   Tue Nov 10 15:20:57 2020 +0100
>=20
>     mmc: renesas_sdhi: populate SCC pointer at the proper place
>    =20
>     [ Upstream commit d14ac691bb6f6ebaa7eeec21ca04dd47300ff5b6 ]
>=20
> seems to be the buggy commit that breaks renesas boards in 5.10.

This patch was part of a series. Did the other two patches come with it?

b161d87dfd3d ("mmc: renesas_sdhi: probe into TMIO after SCC parameters have=
 been setup")
45bffc371fef ("mmc: renesas_sdhi: only reset SCC when its pointer is popula=
ted")

If not, I could imagine that could lead to a crash. No idea why only
with 5.10, though.

Happy hacking,

   Wolfram


--/kp/j1jVUyZUkyH2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmUloNUACgkQFA3kzBSg
KbalEw//W488KspqGDxtiGmkNKHxaz67vVIJ9W3yTETogIW67VdO7JV7yonILHvi
7RzXc4MPO4FeinxKmr+bhXwB5ePbdB+hwJ2SJCGPo40MFshhc8GgdZdBFw8J19Dp
cMhOGnbzBXw2RkleGDL92uryMT09zGM3QyVuIBlYppIxGxIiETSvsDEfpyD+88eg
Zof37R7hYkiN+/4cvsOxxuD2lHhhrG9hcwshTpl7YyVtUP0zRXAWoWw+8pJvkeC5
FlNXOWJUBwAm18ckIw5BxkBqx5rb1rvwfIsXOnrZEB7ZanZjC3hpRqD8hyRVaHFD
ciW6KOgzWWDcCLQft9PWMos/iYgB8cFzBjZ0LdQArpyVULMZQRDn+s8PoUVynLLn
EAZyJ6RRZCmEs6r/qGls6fdARBLfJkegfj9okxBsTgVrdckm2MkDCcryx2LUITva
LwtPFgeyRXv3Hw8Pqr+/piIENBnqfW4QtfrL5lq1IdeTDN/Lzacd4FoUirYd5GjS
FvCM+lgIFFzC1r3HgaNbHnT+th8pXklIClpYUFVUVIVMHZ5PYtNQymakvqcO3TV1
sO3cgwjwtE9ztfNrKO28VItnbF8uPYQevrRGKZfPUsKzohcFiYTZV9Mf/LHq72Jk
Dlf/yJFx3HBucsY4KZdLCTP6BWfteFAD/AKVx37V3sMZp8ECtnE=
=lHJO
-----END PGP SIGNATURE-----

--/kp/j1jVUyZUkyH2--
