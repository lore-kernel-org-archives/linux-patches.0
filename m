Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A54A471
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 20:46:38 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 07D0A1C09D7; Tue,  8 Nov 2022 21:46:36 +0100 (CET)
Date: Tue, 8 Nov 2022 21:46:35 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sashal@kernel.org, Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <Y2rAK1mD2n8wIMm2@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <Y2pxr88XE+XP6uNc@duo.ucw.cz>
 <Y2q0A/sbF65Z8UBs@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kR4JlILZHBvWLzQ/"
Content-Disposition: inline
In-Reply-To: <Y2q0A/sbF65Z8UBs@kroah.com>


--kR4JlILZHBvWLzQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 5.10.154 release.
> > > There are 118 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > I'm getting build errors with the dtbs:
> >=20
> > Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax=
 error
> > 10169FATAL ERROR: Unable to parse input tree
> > 10170make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freesc=
ale/fsl-lx2160a-clearfog-cx.dtb] Error 1
> > 10171make[2]: *** Waiting for unfinished jobs....
> > 10172Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 s=
yntax error
> > 10173FATAL ERROR: Unable to parse input tree
> > 10174make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freesc=
ale/fsl-lx2160a-honeycomb.dtb] Error 1
> > 10175  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2.d=
tb
> > 10176  DTC     arch/arm64/boot/dts/allwinner/sun50i-h5-bananapi-m2-plus=
-v1.2.dtb
> > 10177  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2-e=
x.dtb
> > 10178Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 s=
yntax error
> > 10179FATAL ERROR: Unable to parse input tree
> > 10180make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freesc=
ale/fsl-lx2160a-qds.dtb] Error 1
> > 10181  DTC     arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
> > 10182
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/32=
91098692
>=20
> Odd.
>=20
> Sasha, any ideas what went wrong here, but not in the other
> branches?

I believe it is this commit:

 |4f9355148 c126a0 .: 5.10| arm64: dts: lx2160a: specify clock frequencies =
for the MDIO controllers

pavel@duo:~/cip/krc$ grep -ri QORIQ_CLK_PLL_DIV .
=2E/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:					    QORIQ_CLK_PLL_D=
IV(2)>;
=2E/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:					    QORIQ_CLK_PLL_D=
IV(2)>;
pavel@duo:~/cip/krc$=20

The macro QORIQ_CLK_PLL_DIV is not defined in 5.10, so it confuses
parser. I guess it should be dropped, or dependencies should be added.

We need this:

include/dt-bindings/clock/fsl,qoriq-clockgen.h:#define QORIQ_CLK_PLL_DIV(x)=
     ((x) - 1)

Which was added in commit 4cb15934ba05b49784d9d47778af308e7ea50b69 to
mainline. That's not only dependency.=20

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kR4JlILZHBvWLzQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2rAKwAKCRAw5/Bqldv6
8lCwAJ4iY5pw4oCr3KQV4Ui/dJJTjeZ59wCgkk/h8lWaC1qstBA0MMCZw+oOeIs=
=lX56
-----END PGP SIGNATURE-----

--kR4JlILZHBvWLzQ/--
