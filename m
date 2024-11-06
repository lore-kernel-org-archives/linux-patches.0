Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C25A1DF995
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914393; cv=none; b=jUEC6fz0LmgDmf/Y5MNe5WUC6sThloyAvKN1vWr0p/nEzhX9t5r9FmdeZ1At4i9miEiTOywM5IGTSSa7jke2cECO9+AbpLqMPoCozwM2LqybRBAz8cH50syIe57XBNwaBhUDC8FaIJBLgKUKUbys69FBJ8UwcE875u2qPitny7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914393; c=relaxed/simple;
	bh=ydyhpAVLDcyskkiqgsbfEtKnDrTEwMD6GrknhaHy9Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExISe7DABnOX5maIm7WS/uHqiyWg/5YuHuydjvkx6iu1RyHomB4xnx6D/kvcjIasc7AQQNMdR2B2xJokvXoF5zEvrNYkNuk/3PpPcYstwxbOxiK0NK/HV2kEFulDpjs6L8LzlW8f2nLw8TPdxhmVY8sAtdiZ8foirbchyyUSNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0BCD71C00A8; Wed,  6 Nov 2024 18:27:40 +0100 (CET)
Date: Wed, 6 Nov 2024 18:27:39 +0100
From: Pavel Machek <pavel@denx.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hagar@microsoft.com, broonie@kernel.org,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4.19 000/350] 4.19.323-rc1 review
Message-ID: <ZyunCxYg0pYUhl2F@duo.ucw.cz>
References: <20241106120320.865793091@linuxfoundation.org>
 <CA+G9fYu-X4w24M9NgwWU4=vOsMxq8CzmCGo+BC-=t9e-R0NwnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pJRKqg6bCQhm53P0"
Content-Disposition: inline
In-Reply-To: <CA+G9fYu-X4w24M9NgwWU4=vOsMxq8CzmCGo+BC-=t9e-R0NwnQ@mail.gmail.com>


--pJRKqg6bCQhm53P0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Wed, 6 Nov 2024 at 12:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.323 release.
> > There are 350 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.323-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> The arm builds failed with gcc-8, gcc-12 on the Linux stable-rc
> linux-4.19.y and linux-5.4.y.
>=20
> First seen on Linux v4.19.322-351-ge024cd330026
>   Good: v4.19.321-96-g00a71bfa9b89
>   Bad:  v4.19.322-351-ge024cd330026

We see same failure.

drivers/pinctrl/mvebu/pinctrl-dove.c: In function 'dove_pinctrl_probe':
3778
drivers/pinctrl/mvebu/pinctrl-dove.c:791:9: error: implicit declaration of =
function 'devm_platform_get_and_ioremap_resource'; did you mean 'devm_platf=
orm_ioremap_resource'? [-Werror=3Dimplicit-function-declaration]
3779
  base =3D devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
3780
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3781
         devm_platform_ioremap_resource
3782
drivers/pinctrl/mvebu/pinctrl-dove.c:791:7: warning: assignment to 'void *'=
 from 'int' makes pointer from integer without a cast [-Wint-conversion]
3783
  base =3D devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
3784
       ^

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
529999662

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pJRKqg6bCQhm53P0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyunCwAKCRAw5/Bqldv6
8lPGAJ9oMNWV03OHZaARiHp2lZHDi0qgAQCeICvyy50v6eFhf5qYmsRHSy5a/mA=
=P71y
-----END PGP SIGNATURE-----

--pJRKqg6bCQhm53P0--
