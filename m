Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5127B
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 21:30:25 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0ECD51C09F4; Mon, 16 Jan 2023 22:30:17 +0100 (CET)
Date: Mon, 16 Jan 2023 22:30:16 +0100
From: Pavel Machek <pavel@denx.de>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8XB6E5t/qcKnQb7@duo.ucw.cz>
References: <20230116154743.577276578@linuxfoundation.org>
 <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H5Vb37xdFkf30kEd"
Content-Disposition: inline
In-Reply-To: <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>


--H5Vb37xdFkf30kEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Mon, 16 Jan 2023 at 10:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.164 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.164-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Preliminarily,
>=20
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr'
> undeclared (first use in this function); did you mean 'idr'?
> |   427 |         if (!isr)
> |       |              ^~~
> |       |              idr
>=20
> It's currently failing for arm, arm64, (not i386) and x86, with GCC 8,
> 10, 11, 12; Clang 15 and nightly. We'll test the extended set of
> architectures and update momentarily.

CIP testing sees the same build problem:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/7=
48630506

  CC [M]  drivers/gpu/drm/msm/dp/dp_display.o
6758drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
6759drivers/gpu/drm/msm/dp/dp_aux.c:427:7: error: 'isr' undeclared (first u=
se in this function); did you mean 'idr'?
6760  427 |  if (!isr)
6761      |       ^~~
6762      |       idr
6763drivers/gpu/drm/msm/dp/dp_aux.c:427:7: note: each undeclared identifier=
 is reported only once for each function it appears in
6764make[4]: *** [scripts/Makefile.build:286: drivers/gpu/drm/msm/dp/dp_aux=
=2Eo] Error 1
6765make[4]: *** Waiting for unfinished jobs....
6766


Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H5Vb37xdFkf30kEd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8XB6AAKCRAw5/Bqldv6
8iloAJ9LoMMCTNXlZWHlhrtunrUHp/OADwCeMzhdXd643Eo2lnCkeaQK/W0yfyQ=
=NKME
-----END PGP SIGNATURE-----

--H5Vb37xdFkf30kEd--
