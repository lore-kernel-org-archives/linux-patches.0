Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2407C
	for <patches@lists.linux.dev>; Mon, 29 May 2023 08:38:52 +0000 (UTC)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q3YOd-0006QX-FL; Mon, 29 May 2023 10:38:31 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 375001CD69E;
	Mon, 29 May 2023 07:21:24 +0000 (UTC)
Date: Mon, 29 May 2023 09:21:23 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Marek Vasut <marex@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Liu Ying <victor.liu@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 127/127] Revert "arm64: dts: imx8mp: Drop simple-bus
 from fsl,imx8mp-media-blk-ctrl"
Message-ID: <20230529-opium-platform-776d927f2a0c-mkl@pengutronix.de>
References: <20230528190836.161231414@linuxfoundation.org>
 <20230528190840.351644456@linuxfoundation.org>
 <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="farkmu5gmuszzu3f"
Content-Disposition: inline
In-Reply-To: <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--farkmu5gmuszzu3f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.05.2023 01:48:05, Marek Vasut wrote:
> On 5/28/23 21:11, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > This reverts commit bd2573ee0f91c0e6d2bee8599110453e2909060e which is
> > commit 5a51e1f2b083423f75145c512ee284862ab33854 upstream.
> >=20
> > Marc writes:
> > 	can you please revert this patch, without the corresponding driver pat=
ch
> > 	[1] it breaks probing of the device, as no one populates the sub-nodes.
> >=20
> > 	[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind
> > 	drivers to them")
>=20
> Would it make more sense to pick the missing blk-ctrl patch instead ?

For me, that's fine, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--farkmu5gmuszzu3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmR0UnAACgkQvlAcSiqK
BOgivgf/V1PMU3Z8NK9iBRd8SxzDpJU650CrGs10uasM9AK1iVk8rMhaOQgYv1+a
vpsZEmY293ClljjRP0NjIQWeJVLYI7aszURhnP/jDddCVU9A7xdQqd+xABL2M+SH
F6HqAeYdHRg+yKnkVNXFegEzyd+vf5pdtT5CfhAyfa0UfJGAlZyf/HeKLC8ySndD
rMtsKceeRmyyFz0xbLc3uoXAInGrdaeEmcpiRBUiLI1gEZkmRqY5Dbu5TXW6EU7B
38eyuDcqNixH8eUlPqpiPN+JuGD7cuspbQLzJ8ufrOaXvm1py/h52z5g/Vh/fb/E
PKum+kEmwnFwnhMXCmBN5fgQqv60Fw==
=6oh+
-----END PGP SIGNATURE-----

--farkmu5gmuszzu3f--
