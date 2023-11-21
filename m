Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625491F939
	for <patches@lists.linux.dev>; Tue, 21 Nov 2023 07:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r5Ksp-0008AB-GM; Tue, 21 Nov 2023 08:09:19 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r5Kso-00AWnv-MC; Tue, 21 Nov 2023 08:09:18 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r5Kso-004pby-Cy; Tue, 21 Nov 2023 08:09:18 +0100
Date: Tue, 21 Nov 2023 08:09:18 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: sre@kernel.org, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] power: reset: at91: Drop '__init' from
 at91_wakeup_status()
Message-ID: <20231121070918.xsjpdmfnrd563xok@pengutronix.de>
References: <20231120-fix-at91-modpost-warnings-v1-1-813671933863@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2f2ll4udxq7343yq"
Content-Disposition: inline
In-Reply-To: <20231120-fix-at91-modpost-warnings-v1-1-813671933863@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--2f2ll4udxq7343yq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 03:35:32PM -0700, Nathan Chancellor wrote:
> When building with clang, there are two section mismatch warnings:
>=20
>   WARNING: modpost: vmlinux: section mismatch in reference: at91_poweroff=
_probe+0x7c (section: .text) -> at91_wakeup_status (section: .init.text)
>   WARNING: modpost: vmlinux: section mismatch in reference: at91_shdwc_pr=
obe+0xcc (section: .text) -> at91_wakeup_status (section: .init.text)
>=20
> Drop '__init' from at91_wakeup_status() to clear up the mismatch.
>=20
> Fixes: dde74a5de817 ("power: reset: at91-sama5d2_shdwc: Stop using module=
_platform_driver_probe()")
> Fixes: 099806de68b7 ("power: reset: at91-poweroff: Stop using module_plat=
form_driver_probe()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks.

Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2f2ll4udxq7343yq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmVcV50ACgkQj4D7WH0S
/k6i7QgAjsgw7n9dc9ir6cJZCu+PqNKZsiedUBAktzbcC66zMgVG/8wj+eGdfh0O
uqVHPQTSkSB2j7I2RJ5GO7t5sZQcCPAvMCuEtQ1t3JjRtOjW7akVbQU1QGTgL5J9
gjce8YieAb32Ay0evFzY+1fRgShuKbzVWabFqvu1Q+s3K4A787yDapbNShsS7iCB
0P4qPRbakATfOb03UI43w8rPRlOy1Bn9bCtTWQp9VCmBUOchp+3PZxjDXbfHhxN1
IlckFADdhQGr8fMd5X9+JDRSUSqHNAX12pka+a8KUilNT/N32VrsTxqqeGU6PHuC
tP53uVK8Ah58s2KP+IEzNUkJLzCkWQ==
=EwAJ
-----END PGP SIGNATURE-----

--2f2ll4udxq7343yq--
