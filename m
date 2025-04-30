Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738013FEE
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 06:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745996079; cv=none; b=Kza45bsnFBZ1FtJah8VReDmTk9ptFLa768gQD+iW6tz1v6EB8K3mure9g5RrV0rHYhZFNyp6nnh6W3YdLErgLTfqKKnPdahgggV2B1i8lcrZfuqveg+CKdWc7GxsWngLyFZ6F7Q5nPJHLlSC1NIvIYTEWXzCr0AQJSkBWS15QbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745996079; c=relaxed/simple;
	bh=bqp7jpwn3EqlQt7Hg5N9JaJDJWf+o57RoxeQ3hNESqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBpeUX7fk1V/Er7MxqqssrXG4vSPlDvPAhl38j1+jBO3BIqsy7LcyekB2RO0Br5mN61Hom+XJtANyoqykx1M7d5CwnZ+CPjX4NqhW6GtDG+WKK5VKRTggto+G3SC++id6FgnIcrUwfO27z1Lyso3VS5nwlV/KnOHN5aBA33uJ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=GnfCVPEj; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="GnfCVPEj"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso1120235566b.3
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 23:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1745996075; x=1746600875; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fE+2AKL9tQoV7VjNqMUMkalVxmAieNXXm1j2vCBLH8o=;
        b=GnfCVPEjQ35MQndt8EgPlxQbYM9GHTSUkmWr5FEQ63f6SJtSlQVvqMp4Vbmi8WGuTr
         bV06l5YDursXu4kX8SzLUCq/zl4TQaBtjv3dJoAVt1gX+/4jm7FNc6GIPmfHq3stDDdJ
         BStzlUUkJLaqLvUkBfLqhhl966tIDDJEAX8PsPWZG4FJLFBuTCw6c2cd2bmn2/DYolZj
         VTPR2b80/Q1yOix6jjMavxyT71jXUsFLFetZVn5qWh1Ud3VeoRh4sfRnsTfg7HIBGTjV
         1rwuAj1d6EeTcFD/0d2ozUmd7U6KBlFiLoiOTUzEhe7Td8gE6erGZXpokhaltqi2nHCm
         jjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745996075; x=1746600875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fE+2AKL9tQoV7VjNqMUMkalVxmAieNXXm1j2vCBLH8o=;
        b=HWfxexA7A75WLVUG/5xrFFOD4ZoCJXDcgEO9PXkptXEmwXLjdIJgAdOJxVpTUgesNk
         3egvbIPawz06TRsjSAbyGIyhingN5/ReLUujejJIJ7x720/aUgT9Z2qcr+O234HFVVme
         hx+JkvtAjGEd9aoZCfhSg3pzKG5xd7LS6X84FTeR6NG6WuNE6hEhSsXkSVFAGFt5neRQ
         XOo/IGkNNkhuf/Bixw5DrjadshLrvaU1C2pCKiSC8Z6HQtu9sewJIJDSynNdolO4EU9V
         dB/B8cYyok7Wt+l//jPVhULhkjIML4r1hQyZz7dFuCxzgxvyWJ8QNmUOjKggerUkGdmD
         xN6w==
X-Forwarded-Encrypted: i=1; AJvYcCVC+YQWDn++2/zjd2IA8PAYYA3p7awSAnZ9NTx9mIRKR8YqbmdNGSVGlAFkuqWCf76r28cn3Y2g@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0mGKjQ/fo5EQ30fG+ziOM+JvhIOBq7Y8JYjEAWHgLC7M6a4yI
	PPW3n945MXlo38dBN40SMZ5r1nbQE33V5BjGismxBHJWl222qsTJD5precBj/s8=
X-Gm-Gg: ASbGncuvApDQRr72XR9NVPQ8A/Qqdifc7ddi60HpYSMkA8E6D/W+HKUPqtrTvScm7rp
	NDuQE5vCipA5dYxD/vTlAreyMvDGQxKU6MXID/ASXrnlzHk5AQs1ufXS66of3Ni9P27HcLQQoTe
	SvskTzUrI7g5/KPQmdQp0feZuCgGgvgpk8bwG6C8OrbHtoBfixOcBo3wmey8gsyi+uZYTHngM01
	dro8JNovnKPhcC4+t9RuBvf62AEoSIdUeFGgPjtmZLvmoR6O2HJA+SDP/sSejMOezmXe3tNP9Xq
	PoPTfJt4AmEoap74vHCM4dIiOM+dSSsUBVGol1M/Nwxz2w==
X-Google-Smtp-Source: AGHT+IFuATXiv271EdWmYw3hf0HHyn6r6/sAcb9NULJjNpiWFngbtTkbATJSDqdNp41ZVNC+ryt9yg==
X-Received: by 2002:a17:906:a403:b0:ace:dd20:2c25 with SMTP id a640c23a62f3a-acedd202dc4mr144344866b.51.1745996074539;
        Tue, 29 Apr 2025 23:54:34 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:36f3:9aff:fec2:7e46])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-acec57bece2sm245833666b.10.2025.04.29.23.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 23:54:33 -0700 (PDT)
Date: Wed, 30 Apr 2025 08:54:30 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 020/204] ASoC: qcom: lpass: Make
 asoc_qcom_lpass_cpu_platform_remove() return void
Message-ID: <npexot3y75j2lyvv2w33k6clvla24hpxls32giyyzh7swoyngs@p2qwspziwcwt>
References: <20250429161059.396852607@linuxfoundation.org>
 <20250429161100.253501778@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kw7fdhv2zjl6wosn"
Content-Disposition: inline
In-Reply-To: <20250429161100.253501778@linuxfoundation.org>


--kw7fdhv2zjl6wosn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.6 020/204] ASoC: qcom: lpass: Make
 asoc_qcom_lpass_cpu_platform_remove() return void
MIME-Version: 1.0

Hello,

On Tue, Apr 29, 2025 at 06:41:48PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit d0cc676c426d1958989fac2a0d45179fb9992f0a ]
>=20
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code.  However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> asoc_qcom_lpass_cpu_platform_remove() returned zero unconditionally.
> Make it return void instead and convert all users to struct
> platform_device::remove_new().
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Link: https://lore.kernel.org/r/20231013221945.1489203-15-u.kleine-koenig=
@pengutronix.de
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Stable-dep-of: a93dad6f4e6a ("ASoC: q6apm-dai: make use of q6apm_get_hw_p=
ointer")

I didn't try to actually apply the patches without this, but I guess the
upside of this commit is only to prevent a trivial merge conflict in
sound/soc/qcom/lpass.h.

Not sure this is justification enough to backport this patch to stable.
(Totally fine if you think it is, just sharing my thoughts.)

Best regards
Uwe

--kw7fdhv2zjl6wosn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmgRySQACgkQj4D7WH0S
/k7LGwf6A317hago4KeiT0nTg4vmoKu5jfSr5YRv4TjS+bG+krudBhh8wGc0Bu4s
u4iDONTH1whtlN+Cl1+2YED8g69DdO0Yg04WwPJ+ArhYm9qKKAqKaOhyQDYGlZNH
BueuC1oxVgkLsDKzaD+L7nr7ERrxkkwz9AO1rRBwRnZlSgPq0GO/39LIvnnA7kK+
Y+tagJJMFJEGRhx99ehH6YDxJJBnDVIZO2ZezCX3vnoI5d4Fxd/L5WRIJUeJHtgN
XBZ4fccuEJFJR9S4UKUdMgp524bTno697UO9d9KEVOyn0380/tgUsZtWx2ZnYSlY
GMsWRVavBVeVBzp2i8xDAg0HrcU2PA==
=hS1B
-----END PGP SIGNATURE-----

--kw7fdhv2zjl6wosn--
