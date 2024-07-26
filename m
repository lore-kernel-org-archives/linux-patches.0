Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1B45009
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721981610; cv=none; b=fwMXwvcznAP2dJM04rjsncNYxcFx5dE/H/e1yvILNf62n2LYaLc8QhbHFeTRcAJVb7LUsXVCMmA6DS5lXewJ9cPv4Qg3FCJT5IzUovZ10vSqAFnjHnm+jK4+fAiNeAzUVgjl/3l+cuLzP0PbyanldMXLIyeNqR3n7nLnHADIc0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721981610; c=relaxed/simple;
	bh=ZIeWNIcdzR5tife5OoqVMvtBoBntZ1kqoMZbtr6igYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLxl5wyBSMshkG1/d32m3FKbrd3qtFQnqn5RhWIBpwcSzqMGLoh68Az0VNBd/Bo5135GQv1zgfSTKv9YKrYuoSmGMctnwWjyywVYYcyS0aSDF8VFtgrQODtnWxwA1SCJd4iyj3kF1wNqey80/fhrYPo1Hu/BxeKOVxpQkayP9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E46091C009A; Fri, 26 Jul 2024 10:13:26 +0200 (CEST)
Date: Fri, 26 Jul 2024 10:13:26 +0200
From: Pavel Machek <pavel@denx.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Ian Ray <ian.ray@gehealthcare.com>
Subject: Re: [PATCH 4.19 00/33] 4.19.319-rc1 review
Message-ID: <ZqNapnqOdmdvYXRH@duo.ucw.cz>
References: <20240725142728.511303502@linuxfoundation.org>
 <CA+G9fYtZKAiw3abrvxmBovfYbJK7XcpV0aqH8Lg9wPc=i5ULHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LoU38mD8T5yU85ew"
Content-Disposition: inline
In-Reply-To: <CA+G9fYtZKAiw3abrvxmBovfYbJK7XcpV0aqH8Lg9wPc=i5ULHA@mail.gmail.com>


--LoU38mD8T5yU85ew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Thu, 25 Jul 2024 at 20:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.319 release.
> > There are 33 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.319-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> The following build errors were noticed while building arm and arm64 conf=
igs
> with toolchains gcc-12 and clang-18 on stable-rc linux-4.19.y also on
> linux-5.4.y.
>=20
> First seen on today builds 25-July-2024.
>=20
>   GOOD: 8b5720263ede ("Linux 4.19.318-rc3")
>   BAD:  f01ba944fe1d ("Linux 4.19.319-rc1")
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> Regressions found on arm:
>   - gcc-12-lkftconfig
>   - clang-18-defconfig
>   - gcc-8-defconfig
>=20
> Regressions found on arm64:
>   - gcc-12-lkftconfig
>   - clang-18-defconfig
>   - gcc-12-defconfig
>   - gcc-8-defconfig
>=20
>  Build errors:
> -------
> drivers/gpio/gpio-pca953x.c: In function 'pca953x_irq_bus_sync_unlock':
> drivers/gpio/gpio-pca953x.c:492:17: error: implicit declaration of
> function 'guard' [-Werror=3Dimplicit-function-declaration]
>   492 |                 guard(mutex)(&chip->i2c_lock);
>       |                 ^~~~~
> drivers/gpio/gpio-pca953x.c:492:23: error: 'mutex' undeclared (first
> use in this function)
>   492 |                 guard(mutex)(&chip->i2c_lock);
>       |                       ^~~~~

Yep, we see this one, too.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--LoU38mD8T5yU85ew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqNapgAKCRAw5/Bqldv6
8hReAJ9dnTQwS46F9fQHR2Af2EmF5StAiACdEHvR1J/NlPSRYt5j5k7rUET1g1c=
=y4aO
-----END PGP SIGNATURE-----

--LoU38mD8T5yU85ew--
