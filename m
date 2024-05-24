Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C32D638
	for <patches@lists.linux.dev>; Fri, 24 May 2024 04:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716526085; cv=none; b=Y62uXuobwB+R/pt/p8IsSLTzuejW0oWS84ZNKwyNjNOl5JYiC+Q2LWdTr6f7S2kffwl1MUAnk9VYlpBDsC7IXt8IHacvjDSDqMH1kT4Cz5+JkSNtjBKPfkWV9uNnm1+mHgxUII9HidWxj2YF4ZBeu+XLHI+cL53CkJuVlbVQ0iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716526085; c=relaxed/simple;
	bh=JHlAFuVHHupjqfSPzb0L0lQNXH+CrBtA7lb766b1aOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nH2uq5QuVBSYW0nMuEBetbQFHGhJ8LCGBtZIGP0S9w40BWnJRUqjuoA39SbYFhfOa1CxHcfP2ibBRbw+MNLPjubCnAPOSC7k423rCJS05/CBzpKy7a9dQBqkJ+HeuvR5GmItP8KwWuHi24UPOFxGy7UMXFGod+6M5sfupgpnBa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i1gjYWrA; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i1gjYWrA"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2be94c9e230so668204a91.1
        for <patches@lists.linux.dev>; Thu, 23 May 2024 21:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716526083; x=1717130883; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bpI8w7HA5s7CGzkYjIe1gFefxklkIAHGAMzGmPuhWSQ=;
        b=i1gjYWrAuJ20WDvrSwf6+XBNhHYfpwuurQB4zTL18D6NI7Yai0po2+S05yzrCTiFCU
         bPU44b9Ygwjm+DlUroPjUyXskmZzJTQN2Wj38xo9elnr8HnB+V+f1CpfDh459wg1svOq
         TmfD/gsx7wi3cZGa8WnbQ4ZUPrwfee+Fma5sG0nWkygY1PX2Tl+D0S80jzl4jS17kSmg
         PpHy8ifOJjEeklfioor4mwUg5XlrfztsdcqPX6rCPpSbUNdzdJC57m4RJ9L0t4R1x8AQ
         /BmE8kXBW3NxOGPqpNG6KSynPHJtWQNEhvKKAIMpIiwHrM8IhdV0br2NfyPiAFi4QDfV
         vQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716526083; x=1717130883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpI8w7HA5s7CGzkYjIe1gFefxklkIAHGAMzGmPuhWSQ=;
        b=kzlSpFRKrnvuD7lP+tr6UxKCdTdlIofwYN8YjQEPDI2VlhtxoQ2Hyaj8QEpVLtrOr8
         z5vVsCJ/DqdBX3ybxFPohrG//1vppru8kmYs8aJPuhyAKnuNFlhci+EeqAXcSDWEzJ98
         kwosIxC1mbX5pu/0mRPD59ikXegvPvKUlwA05/pGSEgywffGtdtIrd5M8geofQ6KoWQI
         oR/J0tludSJkGhzfrfnpWmpf0x4gWCKcSyZ0SFWRUYAF9m5psZ8NPrwnuH65rCdgIGqH
         cN2cF2PUACp3Rvlbdp31NL67MQ3yEThDm3se3aFgg+Rwf6nKUmCWkP4tT11aN1645wZW
         Li6g==
X-Gm-Message-State: AOJu0YyNsaJB9DcZEbRjteY2R9PGUtL1ydbL51womh8Zi9Q46dEnw5XV
	QJuBihfAMSiJaS2JCAAxi1rL6KGbniB7/kfFG4oCkx8lDBXRs3onigTiIw==
X-Google-Smtp-Source: AGHT+IGSwipV0BTxyla45eLqcSZPIaUZuqB8z2DVVK3gxMIMe1PpJFyLm6brKsGJgAyHLJKH8QyjLw==
X-Received: by 2002:a17:90a:db90:b0:2b4:32ae:9932 with SMTP id 98e67ed59e1d1-2bf5e14a08bmr1125838a91.17.1716526082509;
        Thu, 23 May 2024 21:48:02 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f9b38fasm485622a91.47.2024.05.23.21.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 21:48:01 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 9781E184799CC; Fri, 24 May 2024 11:47:58 +0700 (WIB)
Date: Fri, 24 May 2024 11:47:58 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
Message-ID: <ZlAb_rGP6sGS5K9H@archie.me>
References: <20240523130330.386580714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gp24Hajt84rvAMGj"
Content-Disposition: inline
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>


--gp24Hajt84rvAMGj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 03:12:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--gp24Hajt84rvAMGj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZlAb+AAKCRD2uYlJVVFO
o8v5AP0R37rL5TXxn2u6/rZn9N1nSDzdsutZTdwXbGHHt3S2ywEAn9DYrApyjahe
+b8kkaOoPdrFTHaSVM8vJR756o8aCQ8=
=q8Md
-----END PGP SIGNATURE-----

--gp24Hajt84rvAMGj--
