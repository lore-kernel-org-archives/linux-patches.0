Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B6487AE
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721981731; cv=none; b=n+/tWVhpdiem9nJDzOASaTKupFvCO3vZOe9Rpj7EEKV9lyDvRbdYZr3xoy3I0MI1By0Sm5BzZuAAgPD5KL8SvHKB6/s0f7n5/cbuli/yMjeRyc7KusFAuZQ21xqiaH69+Ch8oeJlWiBIBJSkZWA58QY6odwI9/hiVpV3rj7YMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721981731; c=relaxed/simple;
	bh=vpcvxNYgJelihQ1vsEnYcvgA9wSZcn2Etrgjh4jzpUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRuQQ9Z8DBM3wfteUBnnxaP585LoeWcoNERZB237FbCnaWdGRtT4I/P1mRI7jolE7wIBJ/EgJFebuBuyhxWDcEHced6p598n3A/MFvGvt87IVQStolq4tbkCx12GoNHSFfmCB0DpFRurnD0layPUX1mLrxdWR4lBTrFf25K2Csg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2DE9D1C009A; Fri, 26 Jul 2024 10:15:28 +0200 (CEST)
Date: Fri, 26 Jul 2024 10:15:27 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
Message-ID: <ZqNbHyu+9P8s4F30@duo.ucw.cz>
References: <20240725142738.422724252@linuxfoundation.org>
 <CA+G9fYvCyg1hXaci_j-RB4YgATb458ZqRjJSye4qub9zYrmL_A@mail.gmail.com>
 <2024072645-delighted-barbecue-154f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rU9CAJE2jXtz4tGD"
Content-Disposition: inline
In-Reply-To: <2024072645-delighted-barbecue-154f@gregkh>


--rU9CAJE2jXtz4tGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2024-07-26 08:33:00, Greg Kroah-Hartman wrote:
> On Thu, Jul 25, 2024 at 10:18:49PM +0530, Naresh Kamboju wrote:
> > On Thu, 25 Jul 2024 at 20:22, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.164 release.
> > > There are 87 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.15.164-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >=20
> > The following build errors noticed while building arm configs with tool=
chains
> > gcc-12 and clang-18 on stable-rc linux-5.15.y
> >=20
> > First seen on today builds 25-July-2024.
> >=20
> >   GOOD: b84034c8f228 ("Linux 5.15.163-rc2")
> >   BAD:  1d0703aa8114 ("Linux 5.15.164-rc1")
> >=20
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >=20
> > Build log:
> > -------
> > from drivers/net/wireless/ralink/rt2x00/rt2800lib.c:25:
> > drivers/net/wireless/ralink/rt2x00/rt2800lib.c: In function
> > 'rt2800_txpower_to_dev':
> > include/linux/build_bug.h:78:41: error: static assertion failed:
> > "clamp() low limit (char)(-7) greater than high limit (char)(15)"
> >    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, ms=
g)
> >       |                                         ^~~~~~~~~~~~~~
> > include/linux/build_bug.h:77:34: note: in expansion of macro '__static_=
assert'
> >    77 | #define static_assert(expr, ...) __static_assert(expr,
> > ##__VA_ARGS__, #expr)
> >       |                                  ^~~~~~~~~~~~~~~
> > include/linux/minmax.h:66:17: note: in expansion of macro 'static_asser=
t'
> >    66 |
> > static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)),
> >  \
> >       |                 ^~~~~~~~~~~~~
> > include/linux/minmax.h:76:17: note: in expansion of macro '__clamp_once'
> >    76 |                 __clamp_once(val, lo, hi, __UNIQUE_ID(__val),
> >          \
> >       |                 ^~~~~~~~~~~~
> > include/linux/minmax.h:180:36: note: in expansion of macro '__careful_c=
lamp'
> >   180 | #define clamp_t(type, val, lo, hi)
> > __careful_clamp((type)(val), (type)(lo), (type)(hi))
> >       |                                    ^~~~~~~~~~~~~~~
> > drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3993:24: note: in
> > expansion of macro 'clamp_t'
> >  3993 |                 return clamp_t(char, txpower, MIN_A_TXPOWER,
> > MAX_A_TXPOWER);
> >       |                        ^~~~~~~
> >=20
>=20
> Thanks, I've added a commit that should resolve this now.  I'll push out
> a -rc2 in a bit.

We see this one, too. -rc2's hit the test farm, we should have results
in hour or so.

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rU9CAJE2jXtz4tGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqNbHwAKCRAw5/Bqldv6
8qHXAJ0ZLfUS/Dq1JynMWQsEAH6QLdr23gCgjsBMAkK5IWHz+mtMvV50SqDsVkA=
=9VD/
-----END PGP SIGNATURE-----

--rU9CAJE2jXtz4tGD--
