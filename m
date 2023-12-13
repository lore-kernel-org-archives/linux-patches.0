Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5723919BA3
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 07:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 16E561C0071; Wed, 13 Dec 2023 08:52:27 +0100 (CET)
Date: Wed, 13 Dec 2023 08:52:25 +0100
From: Pavel Machek <pavel@denx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dianders@chromium.org, grundler@chromium.org, davem@davemloft.net,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: RTL8152_INACCESSIBLE was Re: [PATCH 6.1 000/194] 6.1.68-rc1
 review
Message-ID: <ZXliuTqyO_IjlIz7@amd.ucw.cz>
References: <20231211182036.606660304@linuxfoundation.org>
 <ZXi9wyS7vjGyUWU8@duo.ucw.cz>
 <a6af01bf-7785-4531-8514-8e5eb09e207e@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xxmwakYu/j4Nqz2"
Content-Disposition: inline
In-Reply-To: <a6af01bf-7785-4531-8514-8e5eb09e207e@roeck-us.net>


--3xxmwakYu/j4Nqz2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 6.1.68 release.
> > > There are 194 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> >=20
> > > Douglas Anderson <dianders@chromium.org>
> > >      r8152: Add RTL8152_INACCESSIBLE to r8153_aldps_en()
> > >=20
> > > Douglas Anderson <dianders@chromium.org>
> > >      r8152: Add RTL8152_INACCESSIBLE to r8153_pre_firmware_1()
> > >=20
> > > Douglas Anderson <dianders@chromium.org>
> > >      r8152: Add RTL8152_INACCESSIBLE to r8156b_wait_loading_flash()
> > >=20
> > > Douglas Anderson <dianders@chromium.org>
> > >      r8152: Add RTL8152_INACCESSIBLE checks to more loops
> > >=20
> > > Douglas Anderson <dianders@chromium.org>
> > >      r8152: Rename RTL8152_UNPLUG to RTL8152_INACCESSIBLE
> >=20
> > Central patch that actually fixes something is:
> >=20
> > commit d9962b0d42029bcb40fe3c38bce06d1870fa4df4
> > Author: Douglas Anderson <dianders@chromium.org>
> > Date:   Fri Oct 20 14:06:59 2023 -0700
> >=20
> >      r8152: Block future register access if register access fails
> >=20
> > ...but we don't have that in 6.1. So we should not need the rest,
> > either.
> >=20
>=20
> Also, the missing patch is fixed subsequently by another patch, so it can=
 not
> be added on its own.

For the record I'm trying to advocate "drop all patches listed as they
don't fix the bug", not "add more", as this does not meet stable
criteria.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3xxmwakYu/j4Nqz2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZXliuQAKCRAw5/Bqldv6
8ptyAKCIbKNVJODY4G/czTtiQuc0PLcH/wCeJ76TeC9JOZ9MVPpDBkm90ermodc=
=cOtU
-----END PGP SIGNATURE-----

--3xxmwakYu/j4Nqz2--
