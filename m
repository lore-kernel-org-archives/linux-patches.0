Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16C11411EB
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598881; cv=none; b=rb4KOUjySdjkcQ32VE88K/ogEuxypScnFvAYcnvsXWqTbsxska+5mf/dkGf0vapGXFBaFCq0tBYE68EFZJLKE1i2N+AIWd+cjboMuJlK2YVtJpH6wszoGqtESTxvya8yToUtNRiqa71PxiuczAW3M94yClcdaIezgFIyfxf1tBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598881; c=relaxed/simple;
	bh=kyKwsty/Qc/DIuGgoFsG1EkKrgDw44AACle+vr3Ujho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oS8j+aQcreZ3QRQ13xVkA37KOL+cGwR0Cb93KaA8nSbYLT2ZtSh/oBcQPLh+A55jKg51frbNA3Q6mj5LIVKuLm/tklafzZb2GZ1sbaeLXwtRtPaL7/6IK52KoCumdfHHEXBgmsMCvC2v5zzinovSSWu3WMzizL9B5OepZSjaaTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=GCrGm0f6; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="GCrGm0f6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 519C3103972A6;
	Fri, 30 May 2025 11:54:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598877; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=b75V7TbpO6cq4OPMJHli7fTtI363KCx9AR7xKmqbqeg=;
	b=GCrGm0f6R5mvZu1qFBJsTW+csxqo0kKizBBads7Z9L3Q+AoUWHk3kpZQDjHfK1gKTSYpJA
	0V2mNQbwFqq0mNOYmjlwsVJeUkOgjXpXxz6K4zqlD3UhMX8c/F1RFme7bHs3AT4LRUDI/t
	30eWrKoE33QX+7TG17G0p336VKCXOVjdjuqHh31vdbZ5Sh+hYId27IjXPHi7B5yeagOJ8d
	Dzpo6H4BMWGuT7yg/xaPuxSg1m2gYsBHdI4y7/WRlUagUJsYm/kY0l/YL74baVgllSgYyq
	auJLm9xccExrXVn+iFKA+ga5FjWIn7aD9crjwrren/4TT1R4F0rr/rzvhXbcMg==
Date: Fri, 30 May 2025 11:54:33 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>, Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 283/626] soc: ti: k3-socinfo: Do not use syscon
 helper to build regmap
Message-ID: <aDmAWUXfRp84LEv4@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162456.532226727@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfUx4lG0jpqVExec"
Content-Disposition: inline
In-Reply-To: <20250527162456.532226727@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--MfUx4lG0jpqVExec
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2025-05-27 18:22:56, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let
me know.

Preparation for future development, does not fix a bug. Sasha
should not be picking these up.

BR,
                                                                        Pav=
el

> From: Andrew Davis <afd@ti.com>
>=20
> [ Upstream commit a5caf03188e44388e8c618dcbe5fffad1a249385 ]
>=20
> The syscon helper device_node_to_regmap() is used to fetch a regmap
> registered to a device node. It also currently creates this regmap
> if the node did not already have a regmap associated with it. This
> should only be used on "syscon" nodes. This driver is not such a
> device and instead uses device_node_to_regmap() on its own node as
> a hacky way to create a regmap for itself.
>=20
> This will not work going forward and so we should create our regmap
> the normal way by defining our regmap_config, fetching our memory
> resource, then using the normal regmap_init_mmio() function.
>=20
> Signed-off-by: Andrew Davis <afd@ti.com>
> Link: https://lore.kernel.org/r/20250123181726.597144-1-afd@ti.com
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/soc/ti/k3-socinfo.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
> index 4fb0f0a248288..704039eb3c078 100644
> --- a/drivers/soc/ti/k3-socinfo.c
> +++ b/drivers/soc/ti/k3-socinfo.c
> @@ -105,6 +105,12 @@ k3_chipinfo_variant_to_sr(unsigned int partno, unsig=
ned int variant,
>  	return -ENODEV;
>  }
> =20
> +static const struct regmap_config k3_chipinfo_regmap_cfg =3D {
> +	.reg_bits =3D 32,
> +	.val_bits =3D 32,
> +	.reg_stride =3D 4,
> +};
> +
>  static int k3_chipinfo_probe(struct platform_device *pdev)
>  {
>  	struct device_node *node =3D pdev->dev.of_node;
> @@ -112,13 +118,18 @@ static int k3_chipinfo_probe(struct platform_device=
 *pdev)
>  	struct device *dev =3D &pdev->dev;
>  	struct soc_device *soc_dev;
>  	struct regmap *regmap;
> +	void __iomem *base;
>  	u32 partno_id;
>  	u32 variant;
>  	u32 jtag_id;
>  	u32 mfg;
>  	int ret;
> =20
> -	regmap =3D device_node_to_regmap(node);
> +	base =3D devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	regmap =3D regmap_init_mmio(dev, base, &k3_chipinfo_regmap_cfg);
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);
> =20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--MfUx4lG0jpqVExec
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDmAWQAKCRAw5/Bqldv6
8jjXAKDDIvBPiNM8hZBbtWBo9Br7KDGrywCgt9ksGG+ZDCVfDlBOBcQd1TFbMVo=
=5ukk
-----END PGP SIGNATURE-----

--MfUx4lG0jpqVExec--
