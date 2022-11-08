Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02818BE1
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 15:11:52 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 33C3D1C09D7; Tue,  8 Nov 2022 16:11:44 +0100 (CET)
Date: Tue, 8 Nov 2022 16:11:43 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <Y2pxr88XE+XP6uNc@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HDV0VpNZKIS7ugZV"
Content-Disposition: inline
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>


--HDV0VpNZKIS7ugZV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm getting build errors with the dtbs:

Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax err=
or
10169FATAL ERROR: Unable to parse input tree
10170make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/=
fsl-lx2160a-clearfog-cx.dtb] Error 1
10171make[2]: *** Waiting for unfinished jobs....
10172Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 synta=
x error
10173FATAL ERROR: Unable to parse input tree
10174make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/=
fsl-lx2160a-honeycomb.dtb] Error 1
10175  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2.dtb
10176  DTC     arch/arm64/boot/dts/allwinner/sun50i-h5-bananapi-m2-plus-v1.=
2.dtb
10177  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2-ex.dtb
10178Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 synta=
x error
10179FATAL ERROR: Unable to parse input tree
10180make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/=
fsl-lx2160a-qds.dtb] Error 1
10181  DTC     arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
10182

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/329109=
8692

Best regards,
								Pavel    =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HDV0VpNZKIS7ugZV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2pxrwAKCRAw5/Bqldv6
8uIGAJ9AGiwflptIBGTm1laGcTwjrHSPPACfcZLD3tLBunJTr0pPiA7hjEEuH9E=
=jaD1
-----END PGP SIGNATURE-----

--HDV0VpNZKIS7ugZV--
