Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057BB1D2BA
	for <patches@lists.linux.dev>; Tue, 23 May 2023 15:47:53 +0000 (UTC)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q1UEi-0007VH-D5; Tue, 23 May 2023 17:47:44 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 44DEE1CA89A;
	Tue, 23 May 2023 15:47:42 +0000 (UTC)
Date: Tue, 23 May 2023 17:47:41 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Liu Ying <victor.liu@nxp.com>, Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>, Sasha Levin <sashal@kernel.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH 6.3 169/694] arm64: dts: imx8mp: Drop simple-bus from
 fsl,imx8mp-media-blk-ctrl
Message-ID: <20230523-justly-situated-317e792f4c1b-mkl@pengutronix.de>
References: <20230508094432.603705160@linuxfoundation.org>
 <20230508094437.900924742@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rvqcuzyif67d4p2g"
Content-Disposition: inline
In-Reply-To: <20230508094437.900924742@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--rvqcuzyif67d4p2g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

can you please revert this patch, without the corresponding driver patch
[1] it breaks probing of the device, as no one populates the sub-nodes.

[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind drivers=
 to them")

Marc

On 08.05.2023 11:40:04, Greg Kroah-Hartman wrote:
> From: Marek Vasut <marex@denx.de>
>=20
> [ Upstream commit 5a51e1f2b083423f75145c512ee284862ab33854 ]
>=20
> This block should not be compatible with simple-bus and misuse it that wa=
y.
> Instead, the driver should scan its subnodes and bind drivers to them.
>=20
> Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reviewed-by: Liu Ying <victor.liu@nxp.com>
> Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Fixes: 94e6197dadc9 ("arm64: dts: imx8mp: Add LCDIF2 & LDB nodes")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/=
dts/freescale/imx8mp.dtsi
> index a237275ee0179..3f9d67341484b 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
> @@ -1151,7 +1151,7 @@
> =20
>  			media_blk_ctrl: blk-ctrl@32ec0000 {
>  				compatible =3D "fsl,imx8mp-media-blk-ctrl",
> -					     "simple-bus", "syscon";
> +					     "syscon";
>  				reg =3D <0x32ec0000 0x10000>;
>  				#address-cells =3D <1>;
>  				#size-cells =3D <1>;
> --=20
> 2.39.2
>=20
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--rvqcuzyif67d4p2g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRs4BsACgkQvlAcSiqK
BOglTgf+IKAL5Fr49pQGJh+ch4z8J4K+/ARzRZ5mnIC57MnZZC/QNhmzRMG0XQGW
t4fOVzv1t7ae2lmGe5X2y9mhTBw/XSlUtA0O98HOuzInXJfXWDeqrXoYt+WYe5a0
smVrwLwYzTqFem1lE0u0wgNe8IDJhLiVk644Wqj36knuuIWNGoLM8ONQfhkFINU9
s1lvDOvXPhQsJSvTOT1Xb46gXf7uJ7OywQhSrxqWwDEigJiFZyBUyX+zeqhzmjDz
RFTY8rVRmfqrmknGarTLse1fxYtaF7g8eQjMOTLSTq5aTvTarV/HCqQJM6n0btWH
dim0ug9AHcI84+GJ3mwHkQXnTKkbAw==
=WdZo
-----END PGP SIGNATURE-----

--rvqcuzyif67d4p2g--
