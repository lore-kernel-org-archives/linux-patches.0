Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0895E1411EB
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598791; cv=none; b=NGp920EGFqY5EkS9HhuhjAIN1vlQRessKXRJwUW8hWhEnbL2sPnBFvvUf9Gyvm0nA3lsqQ8ICbGV6AVWeqUjJ9TML4NC2UBcWmhZ4o2p+rdnmSJWQlddRy0m5UbwVU+zZFJU4MjDbNIH3bX1cDHJWc4fu97kgTA4KUQXVryhCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598791; c=relaxed/simple;
	bh=XWSCG1Lem2rlfhbeXhqdnEDiLfhd9MMrHkkizrKIvEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhaRNv+KfqCi32SUDkuHn+T09nkcDzCA6xDDz8+cARMOt/Jd3gHO1Fcca7DAYxAzBjoDPZvnkWbCfKIa9+kSa7iLUSAC9lNsmCZIyE2ZNMP2f5zawLGkGj1BKE6EqY/lGpoZjdapCGjpzIy4kMg5oj44tDfHJJnc2RN54QEaoQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=deSQnpyS; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="deSQnpyS"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0D1931039728C;
	Fri, 30 May 2025 11:53:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598787; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Doivqs/o+B/MmCb9RU2D6eYgKANpaOxhbgC5TC/RLro=;
	b=deSQnpySfQjMNxppSiqpMD4Znhp5C0cg330rRHg7c33Xv71Wjy4ppUwVsODPvRpn+vqYso
	pb5sRaAV/InZuyDSG0wCgvEfeZ7pRjqQ094rF5Watcyn8MjqmbYJAsM1wpuHU+t5BgdAPu
	uyjjGtuGEQ+IZcaTKFmganb4cWSFkHfmEJfBQjibYhXOyovUPsRuMuj/FOHLUpapNHCIE8
	UnJTOjppVBfWBuLp5FffvxkBgf0kfz/wuEZxbv/Xfros3SpgsCwqMQi8i6qUmQ6L2HMIxF
	5VeDJhkUJR3c4ZF4geRaD8hNb/BkcpDZ65aKq/NnD0Q2RBgDafg5UA6l0yyGjQ==
Date: Fri, 30 May 2025 11:53:03 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 223/626] media: c8sectpfe: Call of_node_put(i2c_bus)
 only once in c8sectpfe_probe()
Message-ID: <aDl//53kGu2imznS@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162454.075919102@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rTUUCX6aSPreDSc9"
Content-Disposition: inline
In-Reply-To: <20250527162454.075919102@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--rTUUCX6aSPreDSc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

Cleanup, does not fix a bug. Sasha should not be picking these up.

BR,
									Pavel

> ------------------
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
>=20
> [ Upstream commit b773530a34df0687020520015057075f8b7b4ac4 ]
>=20
> An of_node_put(i2c_bus) call was immediately used after a pointer check
> for an of_find_i2c_adapter_by_node() call in this function implementation.
> Thus call such a function only once instead directly before the check.
>=20
> This issue was transformed by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c b/d=
rivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
> index 67d3d6e50d2e2..ed3a107965cc9 100644
> --- a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
> +++ b/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
> @@ -797,13 +797,12 @@ static int c8sectpfe_probe(struct platform_device *=
pdev)
>  		}
>  		tsin->i2c_adapter =3D
>  			of_find_i2c_adapter_by_node(i2c_bus);
> +		of_node_put(i2c_bus);
>  		if (!tsin->i2c_adapter) {
>  			dev_err(&pdev->dev, "No i2c adapter found\n");
> -			of_node_put(i2c_bus);
>  			ret =3D -ENODEV;
>  			goto err_node_put;
>  		}
> -		of_node_put(i2c_bus);
> =20
>  		/* Acquire reset GPIO and activate it */
>  		tsin->rst_gpio =3D devm_fwnode_gpiod_get(dev,

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rTUUCX6aSPreDSc9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDl//wAKCRAw5/Bqldv6
8tS3AJ0Q75F/2rmP5Z4JMl9gSB3po36UbwCbBsvkr/9rG36YUaVbIax4y0Z/MKk=
=PSM8
-----END PGP SIGNATURE-----

--rTUUCX6aSPreDSc9--
