Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F8C185E68
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723097471; cv=none; b=lrOJNbrArjAiBsNtids2yWh0IutDp1vHCqQO5lesoEhEY9g868l6FSJ2kxdv0V4axEoLU+GgH0YrbtHRgxgv6qxwJm84NyBQocs+dXY10afr0OI5ZTG4DMzYly3eKFPm8c0wDWdjW2rD5fptgrgNmDzDF0JP+0wEmP/yofwtaks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723097471; c=relaxed/simple;
	bh=XpiyGpASuB9p4qJtFJGNcBl87mmkpyvDcEh3HXDYk+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gI3PUwfJdAdNQ9Yfb342K/o1IDSxvJ97CGrn9ABJRSwrRcQWESwymgZsnQOk3gIz5loPJUeb6tk90BeMfWgIgysZlymWSuoWAtdNvE3UfDgmXSFLVuIxf1Pl8TDc+zIcaIvKAXLbnWZrd9QMklrdS6jXndb6hzxodbcmptPcDkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=b7nsoX1A; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="b7nsoX1A"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7aa4bf4d1eso78144766b.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 23:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1723097467; x=1723702267; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hMVSvloPi67e6nc4nTBS6kTKkfveRbd6X3Yp5Y8htg0=;
        b=b7nsoX1Azf2qtDScKQ1q/0KLcB5hww5xiGURMCxozsYaW+GS7bsSwtyadcTWkCwmhs
         ky7dSKTH+2kxboydO3kQ9yEetH9GAdkFCJ5sZhhJExv7J9b/wYK2Lx+v+JWGdDrKXEMi
         08U+6RKHmsoaIrVfYwUfVzAx0xgGRHLUAH/bsNdrPBDI+H39h2L/4yMrSbcZ7rF3EeLX
         OECMW/fLYuiiqhBdT9a7KKxU03eQ+KrNjptBHkCYu3f6cF0n/A0JjmPjL+WzZDgWmYWJ
         UWqzTjhQp7G7NYzQRjw+pnX2mgUzg6g+J67C1QDWvlVpHSgfmxnioq0eBSdNat1E4Qyo
         mYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723097467; x=1723702267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMVSvloPi67e6nc4nTBS6kTKkfveRbd6X3Yp5Y8htg0=;
        b=kxabjQralTvGXvoSP1UH8EMamWpx0EXF8qZOSTxFaWrfLe6mlI0FK7ka/1qThMESsf
         RwS28SiiOYNc8Y4DNOe5OpkWUhsXshDJSwNx9hJ2dP73fPrYRrJLLyf2kzt1Hz4QF3sz
         jkwVdBBtVd6ermVqsWJDFn59zs50J0n+EmI+omsUUhaeDOqsA55pkAFFRfNjAQo/qrbV
         TblHtco20EZjFIh1ASDfHpYfscP4/H9R9daoH7o1F+j4ZlGeCsa1SaBs7MZh8w6ESPSL
         Xm+Ku4Ijb6tjHpSotSzftGf11GPoOuR8kzvxd46zAVr5VGaq0Gq3kToFl7Q609pG1X9X
         zQBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUpTQ1zEKmqYGVWbVjw7XksaZGbX84baLCl1twiD8TxyHjac+53xNWR8b5rfSl9b0FEPe6bMR96+nW87jKiSjaalkwNwgGKg==
X-Gm-Message-State: AOJu0Yxx48A7JioRsOZH9MAbazzllLg5uBL7Xi15WjYxpEiiWKGpQlLy
	M6Hg/wLD6l5qaeV/djNhEQVH8N7VhrTKgoWndyi8VaHzNMu4MMJ2LTFYSmCNiJs=
X-Google-Smtp-Source: AGHT+IGz9VSBO4l/jHWUsfOwrk3jSQZxLMnd1cZyratztKlyg3GbC09/QsLWOC1/0PO3hfCOEG9kSQ==
X-Received: by 2002:a17:907:944c:b0:a7a:c083:8575 with SMTP id a640c23a62f3a-a80907c97e5mr48767366b.0.1723097466693;
        Wed, 07 Aug 2024 23:11:06 -0700 (PDT)
Received: from localhost (p50915eb1.dip0.t-ipconnect.de. [80.145.94.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9d43065sm705042766b.98.2024.08.07.23.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 23:11:06 -0700 (PDT)
Date: Thu, 8 Aug 2024 08:11:04 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Daniel Lezcano <daniel.lezcano@linaro.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 011/121] thermal: bcm2835: Convert to platform remove
 callback returning void
Message-ID: <fqozvio6zhj3vow2h6zayfmtbi3c5ups6vkihymzabhk6cfuf3@gu4b4j7cyltj>
References: <20240807150019.412911622@linuxfoundation.org>
 <20240807150019.742020612@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7lw3mfobaywl5gkm"
Content-Disposition: inline
In-Reply-To: <20240807150019.742020612@linuxfoundation.org>


--7lw3mfobaywl5gkm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On Wed, Aug 07, 2024 at 04:59:03PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit f29ecd3748a28d0b52512afc81b3c13fd4a00c9b ]
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
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Stable-dep-of: e90c369cc2ff ("thermal/drivers/broadcom: Fix race between =
removal and clock disable")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/thermal/broadcom/bcm2835_thermal.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal=
/broadcom/bcm2835_thermal.c
> index 3acc9288b3105..5c1cebe075801 100644
> --- a/drivers/thermal/broadcom/bcm2835_thermal.c
> +++ b/drivers/thermal/broadcom/bcm2835_thermal.c
> @@ -282,19 +282,17 @@ static int bcm2835_thermal_probe(struct platform_de=
vice *pdev)
>  	return err;
>  }
> =20
> -static int bcm2835_thermal_remove(struct platform_device *pdev)
> +static void bcm2835_thermal_remove(struct platform_device *pdev)
>  {
>  	struct bcm2835_thermal_data *data =3D platform_get_drvdata(pdev);
> =20
>  	debugfs_remove_recursive(data->debugfsdir);
>  	clk_disable_unprepare(data->clk);
> -
> -	return 0;
>  }
> =20
>  static struct platform_driver bcm2835_thermal_driver =3D {
>  	.probe =3D bcm2835_thermal_probe,
> -	.remove =3D bcm2835_thermal_remove,
> +	.remove_new =3D bcm2835_thermal_remove,
>  	.driver =3D {
>  		.name =3D "bcm2835_thermal",
>  		.of_match_table =3D bcm2835_thermal_of_match_table,

While I'm confident this patch not to break anything (there are so many
of this type in mainline now and none regressed), it should be also easy
to port the follow up patches onto 6.6.x without this change.

No strong opinion and maybe being able to cleanly cherry pick later
changes is important enough to keep this conversion? Otherwise I'd tend
to drop this patch.

Best regards
Uwe


--7lw3mfobaywl5gkm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAma0YXUACgkQj4D7WH0S
/k6keAf/RZ69SP8bf6iDGb02MY6e2zUchD5jb2McKvIlulYCHlWcRXJUOAK9I7Pg
fStCTd27skWhvPZL2uMiMqFeHV/4QoZdg2exCYRYxS/WKE9zxNUWuT2FhUXyZPOe
+FBKWs/G8FfmX8J/SqiTld7Z+j8xNm3kGzferQDVvHlPQLzGAH9nxUxgNBZbraXp
ec37DlXflaR2zEsNnkaiIOJUI7csrmm4g1efaLTTgdsbG9AG6lrQeXNkWmUWCjof
oviLiYawX6ru96ixGznJUCl6XHyTsENYCeqge9aTJhZC5njvV4Ub50idzT7h9LG0
DI+uTwShFWI4U929ynF7l814UIj0RA==
=CYnj
-----END PGP SIGNATURE-----

--7lw3mfobaywl5gkm--
