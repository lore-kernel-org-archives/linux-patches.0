Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A74214812;
	Tue, 14 Apr 2026 19:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776195361; cv=none; b=i6xAE+gKQV/f6y5fyLoiRZ1A0ALuS7jf9ejHgF+ARYhHuUP2Vmagpj9xWGA/0SJieVWhb52mQmzxag8U/ZyQGr+LY8v/8qlI1Dem/CtuNThuzgFH/RXd5xcHxKNLtcGsfKTw69ArTBDHjS1B22CjU1cWIdRww73KF4L5vcUiCG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776195361; c=relaxed/simple;
	bh=/DEajXtpJCB3hOLSeweENEo1/sf1r0lzizWCu1QCoqQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ghiHGOGoslWWq4Nlp5liu2IPeyUqfgwbWilqxULfbbRJGK5MgxakA1f+geTWI0WT8zKXlaNKd6LCmq4yAqgKuiab/bp1Im6IfkFfbtnmqNNyk9PBW1VaWyvYoQRpKkmkz3VE1g+jGk29rF7gGngTAvDjmYSKhKdQDZt0cjPPPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCjYE-004t9a-2I;
	Tue, 14 Apr 2026 19:35:57 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCjYC-000000038s3-1fmc;
	Tue, 14 Apr 2026 21:35:56 +0200
Message-ID: <7c68cd425998a64761b95585f84d3a09b929a372.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 012/491] bus: omap-ocp2scp: Convert to platform
 remove callback returning void
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	 <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Date: Tue, 14 Apr 2026 21:35:51 +0200
In-Reply-To: <20260413155819.511284969@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155819.511284969@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cXEFg2QdTvJwlQI/StV6"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-cXEFg2QdTvJwlQI/StV6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:54 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 854f89a5b56354ba4135e0e1f0e57ab2caee59ee ]
>=20
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().

But platform_driver::remove_new doesn't exist in 5.10 so this breaks the
build.

Ben.

> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Link: https://lore.kernel.org/r/20231109202830.4124591-3-u.kleine-koenig@=
pengutronix.de
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Stable-dep-of: 5eb63e9bb65d ("bus: omap-ocp2scp: fix OF populate on drive=
r rebind")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/bus/omap-ocp2scp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
> index e02d0656242b8..7d7479ba0a759 100644
> --- a/drivers/bus/omap-ocp2scp.c
> +++ b/drivers/bus/omap-ocp2scp.c
> @@ -84,12 +84,10 @@ static int omap_ocp2scp_probe(struct platform_device =
*pdev)
>  	return ret;
>  }
> =20
> -static int omap_ocp2scp_remove(struct platform_device *pdev)
> +static void omap_ocp2scp_remove(struct platform_device *pdev)
>  {
>  	pm_runtime_disable(&pdev->dev);
>  	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
> -
> -	return 0;
>  }
> =20
>  #ifdef CONFIG_OF
> @@ -103,7 +101,7 @@ MODULE_DEVICE_TABLE(of, omap_ocp2scp_id_table);
> =20
>  static struct platform_driver omap_ocp2scp_driver =3D {
>  	.probe		=3D omap_ocp2scp_probe,
> -	.remove		=3D omap_ocp2scp_remove,
> +	.remove_new	=3D omap_ocp2scp_remove,
>  	.driver		=3D {
>  		.name	=3D "omap-ocp2scp",
>  		.of_match_table =3D of_match_ptr(omap_ocp2scp_id_table),

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-cXEFg2QdTvJwlQI/StV6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnelxcACgkQ57/I7JWG
EQmw0xAArSYPJ+O8BofzOrtVIlgZ5dSagMP8N97Q1CwZscF9vaVgADaRk3QrHA9Z
h62IhxfJjftvuRX1fu809xk7WyOC9FqyESOM8532vHlQ0XsfuJqBbiaef0EaGevv
Xpd+wvvwRHRKaRngVuWj3RUCQ8uKAXY52R8Z7fsMHvuRa54JDmpYSYhbpFn50AN3
eiLzMuY9FoUvjCe4xG3nbOj0gd94xu+XcFwYw7OD48Oy9DSmdUqIKWrJfEdocw4K
9H9S1mpli+hUQ4ud7HRUGbhbYNAmzTY5dDjf4oU7k305t3c8wEd4SQZpvzBx0WRt
NQepVvoew+U568UVJ4woGVtX1UvUvwj9ayKvXZsqwFqZ+3j1YMWyGflPjXG2GukO
9GzwnZQRduARIEM1vQQAbnxSHD6gO5TukAf7uAwZ4EJq3chDjX/q6ZASNE/M635A
XRuRcFqFRi3Z37DuD9fX2tvoiFyZAWQIMm2DAL1pSt1qfWeqvo5abn59Vk5CBE3v
G1B1LimCT7ELZSD7ZAtDEpPFnsyhQazDwBzoVDiYIlKvods6jPT78wudBvbSgWXo
r6EjuTsed5hq79nz4wspcl1ugcqPNtULj4qsZhJzr698m8NJqGACLNWKmPkhfBgY
KN8WSiiO4JkKH9t+P4FyChGY2GA28PtdouaY1jnwvKg53TTGojI=
=FsSj
-----END PGP SIGNATURE-----

--=-cXEFg2QdTvJwlQI/StV6--
