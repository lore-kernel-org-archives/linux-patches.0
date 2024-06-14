Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3B318307A
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329481; cv=none; b=MLOgUOA6RFRA2cTQCqlwGonbliT31i2FtTj6N8aAWrRUw44KDgXk0LFU/noQCzKMTM1QzohmlUpLG0RdnfslzWIqvCV299F90QWHTXZplzOM1QYvnTiBLfP6bTmKvnvrHLQKT9FeenX2cEX8FHFiwSzGJQfjSEDSsqyBUUxtJSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329481; c=relaxed/simple;
	bh=fH40zqOTfVcgLYU0HRNRBYRHUfogY6LIleH0ta3aoJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezi1KXFscGBRP8ZsUKS+l4RdSUQgEwKTm3kgFgb69b0Pl3rSMeaLwUWqvrgAGlN2CWusXvo9bnckcMFFTJBuvYFT53h9Rd+MF3S0V3lXGi7RtptfmYtJQTgd/fRdabMVc6s1CU3URrsdThcML040fD0aiMEKaO8W5DTnsI0IL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4OiuBkc; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4OiuBkc"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f9c1902459so1028374a34.0
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 18:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718329479; x=1718934279; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ygO5V+oG+XeF4PldGgpxH0Gz5/YrIXpA9VZRkyom+l8=;
        b=L4OiuBkckm9NGZJvbVKv2rKTiqW8OIRyndnsK0ZwgA8CPv75iTnkuiuZDsbI81Iv6s
         R/+ziXn/wTTXRElipOLfc2N1gCqxnI1QBYJofOxLBsxYDSE59mjmtmNewy9Iv48ED2Gw
         zQM7rxAZuItS+3r2nLFwmsXUiJxOwsPFb+OGQm/ZSyjiHH1I7A38KDb93H3AnmOdbUA4
         BCIlsMNcF56mEAxfW9FjRPzvyGWsbDDpJukblJpAN8FgpALzRyNPYDdljSEDP5cXxB/s
         Xzgs4PqNqWidaj1HJ/1v0AtNFHHsWI3iigcP/oDrSKFjkQ02AJX7rLzI6FwCUU7F05zP
         u+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718329479; x=1718934279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygO5V+oG+XeF4PldGgpxH0Gz5/YrIXpA9VZRkyom+l8=;
        b=dmOFA/wXSbQaNaeO4bDbBk3nDzjkwzZ/YKhDs9zl7QDnO4lf2czPKzxcs18yk+VTTb
         vcRVEEMXi2rQRWqH5fqPAfTDeUwJPvttpF5sGPOlFy7+tIIrzU1dtMyj3bLV7tefk0s0
         nONGi+CSIwefIt+LXtiuG5K1YdKIfkJ6Lp9lPYIvpjjHbPLo8VDidg2P3g77far3ehC6
         mLLDqb/0UQ1qTVvF6J/4NDnz4ScFC/jT3pBySkdfi3zj7oOIrrNJo5i4t8OP7LWj19Zj
         RzIT0A7ewRbAClMeeVXTT5VC72Ro+k9ncorYeJWzHI1otuQ37955i2QNBTLIed64eygK
         ZnaA==
X-Gm-Message-State: AOJu0Yxzn6n/5/10szTp9NmYqY6N2ZhkZX1c4it0RE8LHm4L4xZ5+jc/
	9OcWH0w4INZoGwphpIhBg6o5jvEzMoraVx9eY8+wtyIxpoAFlNZg
X-Google-Smtp-Source: AGHT+IEZNY45DlLX5atGCT7NUZFz3BiwjbgcpArIED+Q9TZq29Fi//7Ul5VjM9LWMV5ado+PfzRDVw==
X-Received: by 2002:a05:6870:164b:b0:24e:8987:6f34 with SMTP id 586e51a60fabf-25842897a04mr1528609fac.3.1718329477885;
        Thu, 13 Jun 2024 18:44:37 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc925ffdsm1994881b3a.22.2024.06.13.18.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 18:44:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E37D218462DE1; Fri, 14 Jun 2024 08:44:34 +0700 (WIB)
Date: Fri, 14 Jun 2024 08:44:34 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
Message-ID: <ZmuggqznvQti5rq-@archie.me>
References: <20240613113227.389465891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fBpbOS8Qy13v8RwX"
Content-Disposition: inline
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>


--fBpbOS8Qy13v8RwX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 01:32:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--fBpbOS8Qy13v8RwX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZmugfgAKCRD2uYlJVVFO
owDMAP4oFLWEZ5eEs6Yl479fX2vWtXOpMgM6mr73knmW4lvM7AD/V/Ws/vvbov62
a6CqQOuybYHNYr6SQVXZPktuVwr76Q4=
=Th66
-----END PGP SIGNATURE-----

--fBpbOS8Qy13v8RwX--
