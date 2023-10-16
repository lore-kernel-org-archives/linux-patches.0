Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526372770A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1qsVFv-0003Gk-Bs; Mon, 16 Oct 2023 23:36:07 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qsVFu-002Ahm-JP; Mon, 16 Oct 2023 23:36:06 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qsVFu-00HXpm-AB; Mon, 16 Oct 2023 23:36:06 +0200
Date: Mon, 16 Oct 2023 23:36:02 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 010/102] platform/x86: hp-wmi:: Mark driver struct
 with __refdata to prevent section mismatch warning
Message-ID: <20231016213602.b6l6g6iquil3ojes@pengutronix.de>
References: <20231016083953.689300946@linuxfoundation.org>
 <20231016083953.964212636@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bdldqitun2sd6lde"
Content-Disposition: inline
In-Reply-To: <20231016083953.964212636@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--bdldqitun2sd6lde
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 10:40:09AM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 5b44abbc39ca15df80d0da4756078c98c831090f ]
>=20
> As described in the added code comment, a reference to .exit.text is ok
> for drivers registered via module_platform_driver_probe(). Make this
> explicit to prevent a section mismatch warning:
>=20
> 	WARNING: modpost: drivers/platform/x86/hp/hp-wmi: section mismatch in re=
ference: hp_wmi_driver+0x8 (section: .data) -> hp_wmi_bios_remove (section:=
 .exit.text)
>=20
> Fixes: c165b80cfecc ("hp-wmi: fix handling of platform device")
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Link: https://lore.kernel.org/r/20231004111624.2667753-1-u.kleine-koenig@=
pengutronix.de
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

while backporting this patch shouldn't hurt, the warning triggers only
if you also backport commit f177cd0c15fc ("modpost: Don't let "driver"s
reference .exit.*"). As I assume you don't, there is no need to apply
this patch to 5.15.x (or other stable releases).

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bdldqitun2sd6lde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmUtrMEACgkQj4D7WH0S
/k55JggAoFbWotEc+q8qjCWRL295cfmyUDfFtr9My3EDyI7tkDX90UNwP43+KnUY
8OyphB0sHDvDKcWbkpj7N5aIWih/FANSDGkLmGbvZNV6tMj7pvMfrbHHN6rNl6e7
nBoZVokpMpda/GELH7fJnz5qM/IPY0I4PXdxzaG98U494Q32mzQaEXEnumZoFYlI
o39o/JQKxarpdJ40LX8O8sD1Abt2AYRpmLP+B5SGThqRR5NOgrCjzIJjHwpdtYF+
x+gidYnm2NZ//Xm81HT2Z+Seeuz6pDpTsDCBW+ROl902fhQmYIQMD2sLqb6j9Udj
4uE8psIAmZLxuvzyCKyy6KA1emLgsA==
=YN7/
-----END PGP SIGNATURE-----

--bdldqitun2sd6lde--
