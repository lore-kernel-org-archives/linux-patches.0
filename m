Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD461422D4
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 04:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713931587; cv=none; b=jamm5VNVpnPiPbdB6F30bk13vERzmcgaRQv+iq95N/qEBedMeIO+XKaFAtmKeH5cBS3ljBUgjE0yuri0Ym44bPtkwF2RORnbcjbAOP+pRH8SXqkVF1I04JFlhfMqCb+Mkz8IjnljKmhsFjTTjBtClunPwYh4NROnh2bxC7BAKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713931587; c=relaxed/simple;
	bh=f1Dv5zv6/MeC05k9gFS4Dtb4TNI1V2WafkMkhzGBORU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h39cNmJ2LUJb//m7i650391JTLP4BrOH3Aw5MZuCYWYInpckq9U+1cteLA5/Um7HE61lRmIbrB3aO8PeZatPFNsraBPsJq1NrwJB82Chn5uzoaZEZt6a09fjE9ADT7R2x0MOlWNWPgpKs89TjUrY6nGb7LSg8EsivjaJpd9PRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0uSy3OM; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0uSy3OM"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e5b6e8f662so51177925ad.0
        for <patches@lists.linux.dev>; Tue, 23 Apr 2024 21:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713931585; x=1714536385; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/O6yWeew57XxnKc/kCg+J/zVlCaUNwIlMUpnlR1Sd4=;
        b=Y0uSy3OMto0PXCcjLTt+N5qZOkS65LCh0FDFL0tJaLrJEAGbFHgk4xadNvfIQ0AtbB
         ZLWGTstQFGrWq1enq7+fjgGbC1EjhgVtwxff6rLID6295Oe2xr/0qSQEAeQp6GK+TGtb
         9bQ6OKSAu3oUr2Osx+mWmjEaozF3s8asDdHT/vuO9FvlrqlueOIORadUnKrVZpAcF0FC
         xVmzSZvL83XXhcYWjV0tjXC0TBgxC5SOD1YvMC7iPuMPNEXZSshSuSZaY4wfYb5rB8Sc
         F061rhqs+CnPfV7fG8D/8oHAbt8HO+IQJvP+7PxlrlOX7bqE/Zw8f/nRWrX9dhKt1cRQ
         ro1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713931585; x=1714536385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/O6yWeew57XxnKc/kCg+J/zVlCaUNwIlMUpnlR1Sd4=;
        b=KfQWzm3kqRL+WvHnLp1ypN61e7TD32NZXS794zptCo6TZxr6hGnbiUZDn9mt5GlFUG
         OiiS1Czk4lyrKsIYiVzanO6ZUIXSvNQeqvn1vTP7lKqvTmr5ejhYW79ZARofM6xEhAzw
         8GsIFwZUMBveBQ712hFQi/OBDoIf0q7fnHNUDWvSp+qqRc6hvMvYeLyWOENxhI6FADc1
         usQfjfLfFt3zTMpoAUf5aBNk15dlQu2oW77R2LoBcLV2uqw0Qbli3b/W+z7Wtmg79L3H
         q6gB5pAZw3ibU3YStzGjFcZubHEGXngCyvOqYCulYlvkQg62n5SwHFSCwy3N7oph+Hbl
         Lu7g==
X-Gm-Message-State: AOJu0Ywvr4CnJ/Xa3l0cjCzfVzNIlMJ4qc/5uj8QmDrMqYJQH2Zkyeqk
	FRCayCM99HyS+F8hnyomQtq1HI3zBUoNTvo5GzeIdPx+QQSCk+LU
X-Google-Smtp-Source: AGHT+IHtBD+jhtIDvgZAHS2pfecScdht7j9Q0KeyrXlemvT0eMOOuJ+KhlcDzUOxFyuoNdDvoRRjpw==
X-Received: by 2002:a17:902:c40f:b0:1e5:5ccd:30e1 with SMTP id k15-20020a170902c40f00b001e55ccd30e1mr1274214plk.65.1713931585179;
        Tue, 23 Apr 2024 21:06:25 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id ki14-20020a170903068e00b001e434923462sm10876342plb.50.2024.04.23.21.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 21:06:24 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id EF44F18462BD3; Wed, 24 Apr 2024 11:06:21 +0700 (WIB)
Date: Wed, 24 Apr 2024 11:06:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/158] 6.8.8-rc1 review
Message-ID: <ZiiFPdhkEOcw9j6L@archie.me>
References: <20240423213855.824778126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kMDSqLl10Vx85l4k"
Content-Disposition: inline
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>


--kMDSqLl10Vx85l4k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 02:37:02PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.8 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kMDSqLl10Vx85l4k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZiiFOQAKCRD2uYlJVVFO
o9hmAP9A+ekpvYbmpT+rVVsRulkomktuJw0Js1RqLr5qxc6MRQEAjPuOsaPLop0p
JnLG2tN2FAMS0dBZpY72nwhdw6fwmA0=
=n4ej
-----END PGP SIGNATURE-----

--kMDSqLl10Vx85l4k--
