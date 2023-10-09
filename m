Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653753C681
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 19:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpw8O-0006RJ-Q3; Mon, 09 Oct 2023 21:41:44 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpw8N-000UN9-PG; Mon, 09 Oct 2023 21:41:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpw8N-00CWyw-Fo; Mon, 09 Oct 2023 21:41:43 +0200
Date: Mon, 9 Oct 2023 21:41:43 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 066/219] pwm: atmel-tcb: Convert to platform remove
 callback returning void
Message-ID: <20231009194143.v3lcsl7v7z4jfxi5@pengutronix.de>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191043.380915891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n6eo26xjuwni3ike"
Content-Disposition: inline
In-Reply-To: <20230917191043.380915891@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--n6eo26xjuwni3ike
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sun, Sep 17, 2023 at 09:13:13PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 9609284a76978daf53a54e05cff36873a75e4d13 ]
>=20
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> Stable-dep-of: c11622324c02 ("pwm: atmel-tcb: Fix resource freeing in err=
or path and remove")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is similar to the other backport I wondered about[1]. IMHO dropping
this patch an resolving the (simple) resolving conflict is the more
sensible approach here. (But keeping this patch doesn't hurt either.)

The other dependency of c11622324c02 ("pwm: atmel-tcb: Fix resource
freeing in error path and remove") is not that trivial to back out, so
I'd keep it (=3D "pwm: atmel-tcb: Harmonize resource allocation order").

Best regards
Uwe

[1] https://lore.kernel.org/stable/20231009154949.33tpn4fsbacllhme@pengutro=
nix.de

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--n6eo26xjuwni3ike
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmUkV3YACgkQj4D7WH0S
/k7ccQf/frj8CWFZm3ABSck/fb7YinXROKbKtJ11mlBPiWYRvAg9crRPaYLMOdh3
EiJBkFh6YhfmBHH5BnMQQjFJ1+v5wHx5dxd3d4YPfYqJvu8Au2Kzk6NV2icxZDc0
3BWsUIw4qu56rIBCzxeFBV6qjYvnKdGszrRqU6NVFD61AbKifMUQfG1h9FHQPBQ+
owhAsySAc0ho44rWgNmVxUrtlWrHmtNFpl5y6c0+m+gy1yTsgPeW5rgUV/yCHPa0
NCG5FgmfP6r+5hshFzjs5M8B0lR2pccVYYgVtLWoRtLcaAFboBq4ySfrbr4CS9VY
vvJo4iiDQBZzn+JHcCZc/O4DA5+W/A==
=UbQu
-----END PGP SIGNATURE-----

--n6eo26xjuwni3ike--
