Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F09B143723
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737575154; cv=none; b=mFUCK6lkPDyFW6mkJpCNpCgD/g04W2oIDlxaoECkbb+37U6kJwkg6c+2kEehBjKRsxfUuCe+ersxEOXtVYkJCtwdr5xZvzR2Rwv2Z+hcuwbMHKejzB0BwJih6QU4yKJXKTdOtK41V+5bS9Qlv6CRYB1FtAsk2cFN4o97UYpaCo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737575154; c=relaxed/simple;
	bh=ZTnXFWzRpEsh9p3bJxanO3I3YeldFUGJXpCKXzP5TmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a98O2baJQtbAbsHGAgBufYczHe65gYEv2RJ+JgzG1ubfE9ksgZAY8V6Ozo6GMyzgCku36ZBlT1wECXKsBj0FnoosBXtqNMS4MOHikxWoihWU5F2LnfrvnxpDJlpKMwOGvGNfy3iFiJGCVgSv4Ck1ImErmQMDgbBfhoxOksGjmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ewwDdBHV; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ewwDdBHV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1B77A10090383;
	Wed, 22 Jan 2025 20:45:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1737575143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkuPd9GUv8SlJEcUQ42HZ/1LC3FwuTsrn3mijrcBYM8=;
	b=ewwDdBHVltVw2wk4KGML1D/u/mXxNuGIotqwZTT/p/3wyu/7eDUfBNCGioOuMoRyiwPTO1
	05ixHDXlZlEhgEXR/gYcSpel3/hEFkxUN9tQM6lI4bxStJUKpPrDQBXBayB/me09TZ6U0x
	oZtPgaTmMDCIUG0eIB1dhCNJEu/3Ci6LGJDYsY4WjiOjAPJH6kvdCGGqpMVBhwjFyqUkG1
	Q6ODhPluR/91+tAPn7w2o3f/i1FrIo0L/CBuuWgMoRtJzKcspuAd8CVPBr9ToY/81X3K3p
	h1HKn7r0hYir49tcCQMWtfDGmDAoavvTIt2/6IZygDglUJj0MMvqGbRKFDVIFg==
Date: Wed, 22 Jan 2025 20:45:32 +0100
From: Pavel Machek <pavel@denx.de>
To: Ron Economos <re@w6rz.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
Message-ID: <Z5FK3Ev5KE25avDQ@duo.ucw.cz>
References: <20250122073830.779239943@linuxfoundation.org>
 <010553d5-4504-40d9-a358-8404f57ebe9a@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QS5ReBQbHdYnDOHm"
Content-Disposition: inline
In-Reply-To: <010553d5-4504-40d9-a358-8404f57ebe9a@w6rz.net>
X-Last-TLS-Session-Version: TLSv1.3


--QS5ReBQbHdYnDOHm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.15.177 release.
> > There are 127 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.=
177-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-5.15.y
> > and the diffstat can be found below.
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
> The build fails with:
>=20
> drivers/usb/core/port.c: In function 'usb_port_shutdown':
> drivers/usb/core/port.c:299:26: error: 'struct usb_device' has no member
> named 'port_is_suspended'
> =A0 299 |=A0=A0=A0=A0=A0=A0=A0=A0 if (udev && !udev->port_is_suspended) {
> =A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ^~
> make[3]: *** [scripts/Makefile.build:289: drivers/usb/core/port.o] Error 1
> make[2]: *** [scripts/Makefile.build:552: drivers/usb/core] Error 2
> make[1]: *** [scripts/Makefile.build:552: drivers/usb] Error 2
>=20
> Same issue as with 6.1.125-rc1 last week. Needs the fixup patch in 6.1.12=
6.

Yep, we see that too in CIP testing... on risc-v.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
635635910

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QS5ReBQbHdYnDOHm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ5FK3AAKCRAw5/Bqldv6
8oXCAJ4x7n03sX6zB5zLBhA9eBx66Tsl4ACeNV7D0xd9/XJBhihrP33gnYIIQvo=
=RAoj
-----END PGP SIGNATURE-----

--QS5ReBQbHdYnDOHm--
