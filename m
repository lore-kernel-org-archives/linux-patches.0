Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88701316193
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 09:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768554023; cv=none; b=Y+7Zn3QLay3r8wccDVBCm6A0WY0IKYMq8M/RhSK3myMyC8iO4rb5vuR4KdoJw9cYNnzzNwx+vS0y7Ul2RoHAh748mJWcoI4IpyXbix3HKGkWeEglt0DuBFmQWM2IKO2TCrJ2+XDKqL+LmobsHnAsS/fHYuuspCM4qFKjN2YUcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768554023; c=relaxed/simple;
	bh=A+E5AWDmmOM4IRBV0FHjijfa+4SMFzrmm7kov35h9Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLpdfgnsCxU+QZl5PE6S3TjjDrI/i9VulVtFbtgsUv56p+D/l9noNu1LVLhMSmsizyI39ILn1vwsXYQWw6jhUIZHIlcqmv65UXmadNc6JHCNsRA1ujPQMWSEWx2eIZ38iu9kGuVlEk77L+5Gbka2KESYVdf+KjdvEMIRE7497xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=vfhufKep; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="vfhufKep"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so15205335e9.1
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 01:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1768554019; x=1769158819; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yUMUTMwiWEJ7+ksilVolcJXR96N0AiCWE01lI6b1ngI=;
        b=vfhufKep7EHT+k6ouiBuwDADXnR0ZOjHWmfey/eq1zm29zuJ4O5vjPGJrmUh0gRLPD
         M3kBzjHCle9zIRzN0w9Clp17yNgmNWX9XWTUaXevEzWyDKoR4T4UhOsQtEQF1mhMd0nj
         AiPVbhwOEPBfNxVkzbwe+xmxFVkz84iMPED4UXiU/e5RLG4jHOW4SapdvhBrVl6JKG2x
         XFMDWOxN6j6JXTvfqTM45R06H9HNseqClYVlYwf5zVUt5u+gbfy2Hk1vS5I0KowyU4yt
         63PCmsFqLzYroGxebEPhiNq4qegfPqDqr3G2mNvwEkpyewJ4H91417VRXk0GfoB00lsn
         JGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768554019; x=1769158819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUMUTMwiWEJ7+ksilVolcJXR96N0AiCWE01lI6b1ngI=;
        b=Ybc0eZeTEDHiktFStQrJSwK+YKoFDrvjqb1FWiJ+uOkOaKplj5gvIxlHjx/FxJi+zY
         tbjo3MKvE110jvpgfhJeRbHP7pDKf3OnqJLOYp2Cl4brNWqu1MyHETCsDE6rKMpuQudh
         sy52xFxlllmeXcovoQdpyqNt2Tc4Muk994j/e6Q1hsNT/qa4FU3jfz5xf7dZ5PrMZu2v
         6bKUyqpKKI/HoGRJkccrsRw5TuTjpVdIDdq9VsxMgBFPp0Wz2lSC5/qH2u+mYBwDAhuz
         Cj6vA23BuJFa6Nh6Xjdlkp2q8ObGazRxg+11jaU1LVroDciOCH1tjr6SHzda5cIi39GX
         ZBaA==
X-Forwarded-Encrypted: i=1; AJvYcCVtiJI2MQJCLrOzesi0oxL3Kltn0LkN2e9HB+oMB4CEdupwYNwhcXLaqVTyKXTymWl26FE6GL26@lists.linux.dev
X-Gm-Message-State: AOJu0YwWKpt563rl+Re408QjPFhHhNliIgHVuOvOUESTda+I8+L/5e63
	nG2dA4BB6xgDvf37P0T4L7ou7HuPcGDga8bx5/559j3CwiEBTh2GdCBtsjfmiA0EsCo=
X-Gm-Gg: AY/fxX49HpBb0Ax48+IPbwHtzPsLZ9eaVY23m/CbXTivKXHJueeApzoGGSE4TXj90Ww
	RqrnJMeqCq9XkmfqzLGdwmgrQt/CAalsH5Dv32Wf0Wd7Xty4AEo6bMaOX3gQnMNbsDjoOFQ2KsC
	zDmeae27Rdz606z3iL7/ZRvf0c78Zhp26BkWueb/jnEHxH8/I5n6g49PIBOvyMPydLSzfWv4f4y
	yfpfGddiOULs/pWBFjpn/ma33PFP4ChTsAvYc5uHgmguKqoXDEzFyX0SWXS9APygP4lILCSivXw
	l/kumBQceGvEMByxzn8H8uBcGG3ERgQ4AaALql3tt8AXodjbS7M2Ye+kkHhlHAaW2t62o6rUwdF
	6Xp9N81IofvDzIPrnuMq26kBKz2nkKnsi9u+JdZ8qA5n6oSVjVG9a1dk7qyMwUKRU+LB5Xu0Y+V
	EhfPkY/5QBAIFlCxfkPcTth1C171Wm89vo8kXZy66UeJy8ClhdXZejfE1MElnehtShL61cbMMS/
	Ow=
X-Received: by 2002:a05:600c:4e43:b0:477:c71:1fc1 with SMTP id 5b1f17b1804b1-4801e3342eemr27983545e9.19.1768554018135;
        Fri, 16 Jan 2026 01:00:18 -0800 (PST)
Received: from localhost (p200300f65f20eb04b8d7be8ab7c139c4.dip0.t-ipconnect.de. [2003:f6:5f20:eb04:b8d7:be8a:b7c1:39c4])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47f428ac749sm88493015e9.5.2026.01.16.01.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 01:00:17 -0800 (PST)
Date: Fri, 16 Jan 2026 10:00:16 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Takashi Iwai <tiwai@suse.de>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 477/554] ASoC: stm: stm32_sai_sub: Convert to
 platform remove callback returning void
Message-ID: <3tzxbwj2j7jph4virzzizrd66qikkjofz34koc5s5hmrynhaek@dyx2xciugqep>
References: <20260115164246.225995385@linuxfoundation.org>
 <20260115164303.569810160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ki5nd46iygwjhyk6"
Content-Disposition: inline
In-Reply-To: <20260115164303.569810160@linuxfoundation.org>


--ki5nd46iygwjhyk6
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 5.15 477/554] ASoC: stm: stm32_sai_sub: Convert to
 platform remove callback returning void
MIME-Version: 1.0

Hello,

On Thu, Jan 15, 2026 at 05:49:03PM +0100, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit a3bd37e2e2bce4fb1757a940fa985d556662ba80 ]
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
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Link: https://lore.kernel.org/r/20230315150745.67084-139-u.kleine-koenig@=
pengutronix.de
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Stable-dep-of: 23261f0de094 ("ASoC: stm32: sai: fix OF node leak on probe=
")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

While this patch is trivial and there are many patches like that in both
mainline and already backported to stable without any known problems, it
is also not very hard to backport 23261f0de094 to 5.15.y without this
patch. The merge resolution relevant is just:

diff --cc sound/soc/stm/stm32_sai_sub.c
index 2a2fc2f0ebbd,c7930d8f9ded..000000000000
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@@ -1579,8 -1587,7 +1587,9 @@@ static int stm32_sai_sub_remove(struct=20
  	snd_dmaengine_pcm_unregister(&pdev->dev);
  	snd_soc_unregister_component(&pdev->dev);
  	pm_runtime_disable(&pdev->dev);
+ 	of_node_put(sai->np_sync_provider);
 +
 +	return 0;
  }
 =20
  #ifdef CONFIG_PM_SLEEP

I don't feel very strong here, but IMHO this is trivial enough to skip
backporting the conversion to .remove_new() and it would be the right
thing from a pedantic POV. OTOH I also don't want to reply to each such
backport, don't object getting patches into stable, don't know how
the stable maintainers feel here and don't want to impose additional
work on anyone if just picking up the conversion is considered ok and
easier with the established workflow.

Best regards
Uwe

--ki5nd46iygwjhyk6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmlp/h0ACgkQj4D7WH0S
/k4F4wf9HhPDgCWIxfWSQsW0GdhqOlgt54pNJ7KLakNiwJwc+GZ1t5/5j8hmU6QR
yevcgw+nEPswftHUM3Ev/MsP8Gk+AK1e4ry0bz9/x9E2OX1FqjeovJqJkTiVt4T3
oGzUUIYqWVCRPjs498k9Nwkxig026ds2qDbDpb0YUrmSc4wufkliICxG8lQaMWMj
xV4wwIrH5/POSvN2dIwB90CIbFWrfhJ9G3gJUhfz4eTzrXReB+Fe0hH57ngy7p/B
PNfIsPGF1Aynixe2fPSF3RX+oBBSq8WVB3XDxs68ij16m/vb1IZI1YHgZbddwAug
8GYhT5lXC5I6H5fNClfbyJ2tzfaQVw==
=Suk+
-----END PGP SIGNATURE-----

--ki5nd46iygwjhyk6--
