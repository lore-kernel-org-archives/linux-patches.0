Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF050297
	for <patches@lists.linux.dev>; Tue, 28 May 2024 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716883302; cv=none; b=l6ZRNRJkuH85e6LoXNIt9xKnExJ95sYM5EucNQSr5DMLboemtV2qXCKdrWWC6bKnUNClKsl2rLJ2bEKIHUz5eryOJzXa/3i2XuRQ7wNfZvNFmcbVY9xpM5+k3jf0Gb0OISnwK1fRoDu6GQtSWfpe5w/C1iuOQz+Nvq+08UEZf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716883302; c=relaxed/simple;
	bh=4H9cFlulqedFws2ELO1wUMUgihOiv3ZYDtZ7xTuTPvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9aN/Rk27k7sFAwW5NfxFCvg9nZ2c+aikmuEw6mtpCziRh0GW245NHNC2LAtfJ0wmiHpwm0WJ0zfNUOy+D7C7QqVyh2gtM+zgmyS0hRmdUXXuDMj/HUUG6cGmmfofK8JjhLqayGDojFoQRtGYb7mbPPmydABI10ffu0nZQTO00c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4tCy1hd; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4tCy1hd"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-65894e58b8aso419502a12.0
        for <patches@lists.linux.dev>; Tue, 28 May 2024 01:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716883300; x=1717488100; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9A1HK7uMZTsEiYLsWkAO7fFC+9pdvWjOj3bR/6+kgQM=;
        b=K4tCy1hdQHHKYfkdTXhtBUzgvr3QoB2HI3NkgOO5FElu0xqgsPvl+C2nJuYIc7eiOg
         pLG9X99qApWkjIJUH0Lgr2eztUR2KDzyxqil5CjkOaH3Z30ET9qiFSZVsUUaZO/7jZAt
         ccMA6+UZOR1CkBzrgx+aSiO1UnnVPqgQwcg0EzjWJvWDuPkTU8xWFXttzm20m5l/1dBQ
         0Nue/mWDl2maOAcLR9lkGKBzAzZ3VC5/HyPAZzQL7YM8fFgvpXJKPeWKEWOIQ45qTcE8
         +TgIiLIRQ6XbwduR0uXZh8MOMvIjEbzwxPQXDg3uGNWu4E51r+pgf+XdAyb6sJNp9arA
         tOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716883300; x=1717488100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9A1HK7uMZTsEiYLsWkAO7fFC+9pdvWjOj3bR/6+kgQM=;
        b=tlycBpIdW3g8NotavVZBXjSzUXPZ4yIXe4xEurydK6xvPTr5zA0qJ+Kjiarnl2bH7c
         Ap67uHl7z+gcvlVTx+1LCMGlD3ZsFkyrbZw1pxoWs37oHUp90HEj48ghAHLhBq9wIxYa
         QrtmUZOr9MoU12qM11R4N6L30U5V59pNa1uuczzRQFZPMUOnK64RSm5q/WBnkYnMHTvR
         ydlRrW+W9nLRX/dF8fv2ESYt/8voz/v0a0B6x9GCMXX9wPiWcj8bLSfNnLEMJ2QuShSC
         xEakKXj3zCYEf8JTv5iocAFKGalrmblJAdGuDXGv2EcOP7ViJh6L9n/j+ptK9GWqrzM/
         iSwA==
X-Gm-Message-State: AOJu0YwAp2XmR9yicEuUsxbCdHe/YN0mNsdzELrD/FZBoEyzxqeUEpU1
	BKxrb/6dW55r8UEKa1rHJR39S/GWjCicQ0hSfKWJ1XqQCaEXEpLd
X-Google-Smtp-Source: AGHT+IEJ6aceDOomDqURkRUNgS+9piMb9beoRjZInDw1nHavLfkOAVtKIoDkY7FT9cEeOUBTgDxyvg==
X-Received: by 2002:a05:6a21:8188:b0:1ad:1c9d:f682 with SMTP id adf61e73a8af0-1b212e3aa44mr10271937637.35.1716883299638;
        Tue, 28 May 2024 01:01:39 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fc36d22fsm5939450b3a.86.2024.05.28.01.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 01:01:38 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 78DD018479822; Tue, 28 May 2024 15:01:28 +0700 (WIB)
Date: Tue, 28 May 2024 15:01:27 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
Message-ID: <ZlWPV3O9RM0-8HEs@archie.me>
References: <20240527185626.546110716@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nMrHX7joLy6h3Dw8"
Content-Disposition: inline
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>


--nMrHX7joLy6h3Dw8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2024 at 08:50:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--nMrHX7joLy6h3Dw8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZlWPSQAKCRD2uYlJVVFO
o2NpAQDxIa33gd6wIvlou7jNwGSyvHiyO867qMsfr8H0gZtovAEAsN3b+pJGFQTK
iPV8y8iqOYiIwHSvhaNjM7igI4SssQI=
=AK79
-----END PGP SIGNATURE-----

--nMrHX7joLy6h3Dw8--
