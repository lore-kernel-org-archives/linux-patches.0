Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A22E611C
	for <patches@lists.linux.dev>; Wed, 11 Jun 2025 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749640545; cv=none; b=OmHKLPxjcpvNVRAAfnu8sdZClFc5tbZip0OWxOQ3P8tkGIudauv22uldtEFPK8V7PiP169a3uwP7dipg1wQ9FqGucX5FHjIuWwJF4OdljNbBI6Ry9rgXTR4x+pkCMSv7HsGRMfc3cqoQShsa4tcc9NbEl8WlFsIntahFQNHVljo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749640545; c=relaxed/simple;
	bh=Ny6adC2A9Zl3ef5XKbx1IHOwQSuklN2R6wh9jgWvj1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KO+kNVd3+oFQMImS57kIERW2YbB3Yyq+GVwuod5nA7npVqNhnwdzMFg1039CDYmMWtTBg0C1dIS+cO2ULEp3W9r+zf1qGJgH2+Hyv80ALtmOTx3pbxNuNU/m9145FonsENHs7t6dNiqalJQiSgoHQvcJWPSro22JelKdHFiNv6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXWOhvdP; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXWOhvdP"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-553644b8f56so6227475e87.1
        for <patches@lists.linux.dev>; Wed, 11 Jun 2025 04:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749640542; x=1750245342; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rs/HPsGwpc0dA/4wWlqPgOrji+1iMcQ1YoQx7yS8T7E=;
        b=RXWOhvdP5zsA0EpEjWN3xI2Q992akLSCDqW2TZjk016cmgEgBcPn8qPeXxkGCVRRym
         zIq4VnfJnR4bH1EADsv8i7AXUw7ATZ284wW2ZWSJc1IrLr1qiMtXHNykYAxsNX8iFQ/A
         K8WoXl7zEU+Xd7amiT/ZfvGaBBh7lrhUKp7AUWz+PPN29DD7KASIvOsLyVej02oyD4tv
         IIlv/uIb6aAQOceeJOwCq4rLaGR55l7tnl6pN7wt7/YNpIybljC1J94Gj0Ax/kbuUuRL
         PO0IOzqJI8hBj7HYB0vhBbPNZwquNMiW57H0ypH4pn0OtQQUAwTJfxug8temYaJiz7hl
         z/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749640542; x=1750245342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rs/HPsGwpc0dA/4wWlqPgOrji+1iMcQ1YoQx7yS8T7E=;
        b=nB7l3cL70jBdv/AZl9PW74AjGPzZQ9TABsc37mKo61M01sqWt8XXU5fEFgIa4QKTVV
         2GNuniJYtCzbackML/y3GdcIcfRUJZ9t2uw2MKHCeM4bP8I/OsteqGNjmjVz60Kte+1O
         GrGfeHt2CTd1d0khAcXm8jy9sOA+ccz5KPaWLKw8c3l+FZbVjG8WEmOYmcfW/gM2dpuD
         L7h7hiLr/QO6UNxPE5Z83dgwvD5XlOuleS2VHkhjJI0f7djbeaxWByIgHpYL34Y0QYOU
         zYvpASpYEG5KYuZJDAkjmnEQHC+9Py1T7ECnVT5e+LdWIA8WMt5Vgj9Ky9ErvBnW+R0z
         HNJA==
X-Forwarded-Encrypted: i=1; AJvYcCVF2qv8+V+RnRY6ysO1WARJgejk2hzM/rVHjj+dvuCSMWwekPt9/R3BIv6mRkhGMErbjRV2ewXc@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/GrgHiF63wypieWHDNpuCPcTWaaZU8moqwlfvVP3axAuqmr17
	QqLb6+VjQVMl4LRspXxXBX8C1byCqe7OM5jny+9w7PMoPBi8RczG2T+S
X-Gm-Gg: ASbGncuytciYZDDDw5UcQ5vzLushxQY5rTkp4vxIVngmUTqe1lQdxvZmogZQt7fLouO
	H2Z0Nkig2EvQhZex2dj5ibATwOMdRprJeqeU5JrJ686YBGmxCvherI7ncKdc2i/L4dPGhenNTxe
	vRuRs/x5T312DfmtcpAuVZTzVQS6ChAE0uz904AmYweUEhyltcXJjhUcwh839QeWmq92R2INmLv
	vQak195hHgzhfYHEj3YzV/wI1sajzvXiNdSAYX51gnc+2fN6yRvOKndLc7y4nXwSB8ZnBTJp3/y
	LKMrNytsu0rWcPuvnzsNSH+E1T1zTbBDtRsdoLU9iGhvSQshdJlBnQJUYFjjPa8XJcDsv1esawT
	AueTrn86+U4PP9UWkdtcL918=
X-Google-Smtp-Source: AGHT+IErqyHxgS61ZnGwEnYEo1TU+/To0abLwZsZtdHapcw6ayI/mTmD3hIw1qdzV+w9pTDB/J1EDQ==
X-Received: by 2002:a05:6512:1196:b0:553:2eff:8d74 with SMTP id 2adb3069b0e04-5539c18ef14mr793813e87.42.1749640541553;
        Wed, 11 Jun 2025 04:15:41 -0700 (PDT)
Received: from gmail.com (83-233-6-197.cust.bredband2.com. [83.233.6.197])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55367731785sm1912622e87.216.2025.06.11.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 04:15:40 -0700 (PDT)
Date: Wed, 11 Jun 2025 13:15:39 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org, patches@lists.linux.dev
Subject: Re: [PATCH drm-misc-fixes] drm/sitronix: st7571-i2c: Select
 VIDEOMODE_HELPERS
Message-ID: <aEllW20OnCDZhUhB@gmail.com>
References: <20250610-drm-st7571-i2c-select-videomode-helpers-v1-1-d30b50ff6e64@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HzZoh/TuFQilwAtH"
Content-Disposition: inline
In-Reply-To: <20250610-drm-st7571-i2c-select-videomode-helpers-v1-1-d30b50ff6e64@kernel.org>


--HzZoh/TuFQilwAtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 10, 2025 at 12:40:38PM -0700, Nathan Chancellor wrote:
> This driver requires of_get_display_timing() from
> CONFIG_VIDEOMODE_HELPERS but does not select it. If no other driver
> selects it, there will be a failure from the linker if the driver is
> built in or modpost if it is a module.
>=20
>   ERROR: modpost: "of_get_display_timing" [drivers/gpu/drm/sitronix/st757=
1-i2c.ko] undefined!
>=20
> Select CONFIG_VIDEOMODE_HELPERS to resolve the build failure.
>=20
> Fixes: 4b35f0f41ee2 ("drm/st7571-i2c: add support for Sitronix ST7571 LCD=
 controller")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/sitronix/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/sitronix/Kconfig b/drivers/gpu/drm/sitronix/=
Kconfig
> index c069d0d41775..741d1bb4b83f 100644
> --- a/drivers/gpu/drm/sitronix/Kconfig
> +++ b/drivers/gpu/drm/sitronix/Kconfig
> @@ -5,6 +5,7 @@ config DRM_ST7571_I2C
>  	select DRM_GEM_SHMEM_HELPER
>  	select DRM_KMS_HELPER
>  	select REGMAP_I2C
> +	select VIDEOMODE_HELPERS
>  	help
>  	  DRM driver for Sitronix ST7571 panels controlled over I2C.


Good catch, it looks like this driver is missing the dependency.

Reviewed-by: Marcus Folkesson <marcus.folkesson@gmail.com>

--HzZoh/TuFQilwAtH
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEBVGi6LZstU1kwSxliIBOb1ldUjIFAmhJZVUACgkQiIBOb1ld
UjLv5g//TNfcrIgOAm95L/YzLzv9QBbABNKU/BLE6UBZhW+r45/dPViDLqNhympx
6XK01B4Og1qopiqqKSR3RHMtytxS+2E2xQhz1A2XbjBd1VMcSmJ+Aim/Y/BDuaAX
k/fiZ+pCjj56Serl+TcQABC8KwjK5gj401XOIYStFUlcoUxhYBSQKckoq3wSaSZA
o5WJOGHl9+y7P8pzxcthKnoYnCTPqRhk+9nWEz66jRUu8lUrvWuEfCzeCwJjcqjF
o525Iv/k97wsqdI7HOlgrn6lcb5RWy+Kv7esO2P93GqOVcJab10PB2VbGXCSkn9X
P+c2+HwOgNR9FO2dhu6+O7axRieS6HB9CqE++AWYd0uQPPNBYVEvKE7kUHl/pZ44
rqlOmGZnZnPg4SzVn8OYTPSvyOltx9GzYe6pfnL4XS9tibvy9nX3tptiyuQssf3y
711LlIgQHFWP7voydfyhAyCktG3axa6NbUs0vTxthOYiJgYfFi+DvdmIRALmpaNC
nxlZZhIaOywBtU+Rd0TEiDQ+CiWO/TdGxLjPIVLsQgY45vy18Qxq+cmJL1ybl64d
5JqItawiSUvUE4Y/bl6YUZD8blZS4SsVPD60Ce1XSiN0JYpf9MSSLg5dM4Sqoz/y
Qoc/ckkgIN+TB+L6sM2dyhD5Mvsydl26Py0dHMpDzVj8rv45HvU=
=jzzG
-----END PGP SIGNATURE-----

--HzZoh/TuFQilwAtH--
