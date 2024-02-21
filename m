Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16122F0C
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708498734; cv=none; b=QKa2arJMH/7uh9UcVTlcccmavlU+9IJF6t3tYEdUU/1pXmj1kdlciNzOSd5Yd7Q81Zq3IgQSQK4G3q2b6h66UV030KDWTxbCM7Gf6W1mv8bFmsNNCLWgA8NDLHFLamtR5vvATGEBCLglZedfNDFQGK9YVHLsEAtpLvI4bIOCNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708498734; c=relaxed/simple;
	bh=esYaMcSp0zrdIXaMpGrKr2iJnH9k7dzBw0jMQRzQ+i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuoUf9tbuz5ZOfotFtxpxJCJxf6bVwq5n7BWlI/DmzoV3XGJ8MHNBFQXLvDrMBiGklZPbrQPAttBhUIogTBIgOa2T3WrBtU4b1y3Zak0A44IHhRldF//QDXanRy3WGa4wWufaPEtrJPPhdtEqb/5STSVZNolFIbetolzeq/ae8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBw1EKKe; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBw1EKKe"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d95d67ff45so1937595ad.2
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 22:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708498733; x=1709103533; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LrTzttb3S5N87z0vQ+akgGn/f9AZy21TXyym/YWd6l4=;
        b=KBw1EKKer/rufrbFOWAghf6nPuptCLXgxTxj9kgcIx/TC59/2h91q3esJHhasIJ2FY
         XfeGecRxwm7e9IAGrjulDqC7YtWy1eD00ttq60S/mnxkTSHJkvO7c2DYGIcGPXtq59y/
         4dxhO/WWHipgNG2vzJbfoUWY32Y6dOPxq5OWIeSoZb8XJXFQ2fFz+Dg4jCa0EU9qRgiY
         gDPZRpLwS+bQffkul80I7juizb9/80KAldhDEji4yQSFpfMbfPnTH5V77q25OU0l5Fi1
         n5Ej/sGK+veB1BmlQdd9pzYJFiJ0MrCeEuC9ZgZZ3fzXXzJ93gBfzQZg4+0lXw3rncbE
         Z2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708498733; x=1709103533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrTzttb3S5N87z0vQ+akgGn/f9AZy21TXyym/YWd6l4=;
        b=XiDBsrgAMZQ0y19bXIfVW2Yca5B//7ENjG45XDAAj4k7IzLhBDfSf8uIJAMGkfQndV
         JVdLRD1vjdvdMlhKfEGvrM9GILRTkHzRbA5E9dqDnaplRoy7IFrfuZ90rVsukLVu7Nyp
         8PQoJiQ0OmRUiN12Q5ZgX5Vz43Y8PZH8pzeRwDJQlyxY6oEGNf6uOHaOKBMZD7xwk6JZ
         TCsM15IJ+1r2zFmDKOs9oN4oasO7nPHlI4Zb4jD9SzzS+8PyOO6fsIlkyF7PvuD/Mpr8
         2Kg06j8t5RJ7Wn8QHz0/k0+yfv+1ZJFc2zOsxYj6KrQhPCs3SFBkskOSS7oyB5Px5TiQ
         a9Wg==
X-Gm-Message-State: AOJu0YyPkHgWpBj6pXHs/WEmAvI/XpSZoWO2d76IkP064jTZEPVyHYhy
	Ek/6wCtCR5f+qcbj0DPN+7RoiVhVDTUyW7M5H3nJfbGmmsnSmMlV
X-Google-Smtp-Source: AGHT+IHkL0orzm61AWV2LyAwg/yFw2+V5wvEMjWMHHT03HgbgkpZEPjN9GNQNW9YUUHxFa+rAFwlww==
X-Received: by 2002:a17:903:22c5:b0:1db:ccd1:41f7 with SMTP id y5-20020a17090322c500b001dbccd141f7mr12761795plg.56.1708498732840;
        Tue, 20 Feb 2024 22:58:52 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902eec400b001da2951a788sm7324035plb.304.2024.02.20.22.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 22:58:52 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id B44F91848BD3F; Wed, 21 Feb 2024 13:58:46 +0700 (WIB)
Date: Wed, 21 Feb 2024 13:58:46 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/309] 6.7.6-rc1 review
Message-ID: <ZdWfJqvTeaAsM437@archie.me>
References: <20240220205633.096363225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uK4LsNMgGQp4a8h4"
Content-Disposition: inline
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>


--uK4LsNMgGQp4a8h4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 09:52:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--uK4LsNMgGQp4a8h4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZdWfIAAKCRD2uYlJVVFO
o50YAQD0j9xM0KbrlQWp9tg4pXWjbhDEfZ/ktJ4Ny4cU/pJc7QD9GQzQiKYphDJH
CseSofHsHBQR9bMwv53u50uBgg01IQ4=
=R86Y
-----END PGP SIGNATURE-----

--uK4LsNMgGQp4a8h4--
