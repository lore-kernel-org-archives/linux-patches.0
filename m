Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3423B2A1
	for <patches@lists.linux.dev>; Wed, 15 May 2024 04:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715748387; cv=none; b=qpiQqvbnYF/9Z7xJT+X7Olnbkp8BEiUxlPnOL++NGV1Jh6VzUnpAN1kB0Lr630vviimCBdB/NWt8ZTva6FMqS715V8XL99RvRpP219wAResAcU8UO3h9HavQCMtfbKGjVZdhtidTFjZJWNdhX8CJCsVlBbOvSDQt+T3paEcnq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715748387; c=relaxed/simple;
	bh=iJ2O8f/PoiMWbkLO39zieFIrs3iybhip4LTxR4g5Uk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2MOuK28DjmnbefwgnMB4PWM9NaN7iIOdZU1nTj6bxUozqXgpNf+Y5k2zAWMqkei7NhDQUMJxWaPnhptQyhJIBzz7XuseF0Pq9WSiYHAHTEQisxyAWoi29Mcn0qCxmYlqGgbqcgNx1fJKuB0+XJcJW1wkqk/ugaLcDO1h9vMSEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEqYpQD6; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEqYpQD6"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ee954e0aa6so51184545ad.3
        for <patches@lists.linux.dev>; Tue, 14 May 2024 21:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715748386; x=1716353186; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VtxoGe1/eejPDg5Q4HDf5+EPwAkFuKKE1kZFYnwxgJA=;
        b=JEqYpQD6yVwG/JMiSnZEX9Hs9c/R9B0wq2dqzmARMSKHXLF3raeR6708kmCT3h49Wv
         GCcm7GA73dCSKt2YuccCMOz5sx8j4Xdm/c1/oukUDuep2L2sDobGXiXLSw/zUJ1QcrCC
         WbS0dePxLu8WyLIzz0nnPHKAP7PfPJVY9f7GTg4q6J4JQXPaUPSFy/8OIlt4bGYrwY7S
         kmUlLDIay0sS89ZOyMNlU8lE2rvXnhLB3EIXh6YNoqrYd3iE1jd8Uzv45KP4dV5HFp2J
         OjDRHgl1/Vlkp+8cv+ewIAqsZ5QiYQBxZbs2FJR0m9bidaF0Ejzz/oScCr1qeX18Am7M
         74fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715748386; x=1716353186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtxoGe1/eejPDg5Q4HDf5+EPwAkFuKKE1kZFYnwxgJA=;
        b=XfG0S/17O93PgWTIGi85R9xRpBb/FXUDWzLX5EvH47NPtFkDptJFLgiUpRuIHUi/VN
         RxsCrOI69BrscndpuuS264GTRD9soDaKk/QBBU0g4zIL0UrPWionfQnMbw1beDgz+hi8
         UVMa8je6keURbpVULYKdtRbxrmjQSYh2+hsI1YSznCybunscRker/666Y7RwG74FdGN0
         FMoSbYAifFqLlz30vma4SK/H5fy91Y75q/AM0NSA/+tT82Nl8y36BlUq+l3umnE9lD3X
         lYoaOHQZs8/SK4UJhvo/6K15qzsKE2Igz1CqM+hWWkrNvNuwKijmwEcc8hvCdy/BwdIt
         HUfw==
X-Gm-Message-State: AOJu0Yx6mKjH1q0sbwidQMJggBMeuFOVEKBIMwipVRN2yb6pXzyxOarE
	JNOb4oTcimq7du9+tiOAf8uuhDg45SR5DCdC9OoAEHSwkyMSm5GB
X-Google-Smtp-Source: AGHT+IH/XrTjM2PeRK+50jEYxUmUQv3h8fFp5IUdKc92GIpW+8kEgTsvHOgSiD+PFyw0gIrd/g4NFQ==
X-Received: by 2002:a17:903:2cf:b0:1e4:436e:801b with SMTP id d9443c01a7336-1ef441c113dmr187211615ad.67.1715748385636;
        Tue, 14 May 2024 21:46:25 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d4877sm107308485ad.24.2024.05.14.21.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 21:46:25 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E02F618109C16; Wed, 15 May 2024 11:46:22 +0700 (WIB)
Date: Wed, 15 May 2024 11:46:22 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/336] 6.8.10-rc1 review
Message-ID: <ZkQ-HpCHYxv9mq2_@archie.me>
References: <20240514101038.595152603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9cOENGfmL5IvcNVJ"
Content-Disposition: inline
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>


--9cOENGfmL5IvcNVJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 12:13:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 336 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9cOENGfmL5IvcNVJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZkQ+GgAKCRD2uYlJVVFO
oxkvAQCaEZP/0IxV0UUSD2YwRSFuTtlUslOem7aMf+/F7g9FLgEA+XQtjHx4Emzb
IzL9957c/X+XjIs2cThK7f/EoyVX0Qc=
=7K6X
-----END PGP SIGNATURE-----

--9cOENGfmL5IvcNVJ--
