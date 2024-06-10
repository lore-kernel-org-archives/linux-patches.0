Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE95A38
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717982894; cv=none; b=Xttcl94bDLIx5U5BkR987XkJPHBTrAJaTAT/u2kL02vz3Tzlbq0bF2FwDU5d5yiCaFhQPvxPvVPDAQOb7ASwrq2m2po3x7mRtRx2otUz8qW96wljjf6H6ywi3CdJaA4csRKviooRohm9io9L7/yEsz5UX/tklIwQPB/WSZg2ZSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717982894; c=relaxed/simple;
	bh=jDFwegCSWuUb75W10N3HVQWRCXQBrTGSItHT892scmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lgjnw3HNjO8hhNBJmxNF6b9MrypUC0DTjQQwM7E+PKx8n5lYU8Gmz0ZQpsAWVWQnvP02ZESt41h9n8ieFy76mhYz90eIb0jBY/wkjvlSMJyUSYqKL1KUs//i97sLq7YOkKxx+k6G+Y/FOOGttNpqL3+2h8s6JeJABimhM+CReG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fM+iC8uv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fM+iC8uv"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f717b3f2d8so1597235ad.1
        for <patches@lists.linux.dev>; Sun, 09 Jun 2024 18:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717982893; x=1718587693; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ogGDeikgVtP2/JojZOHyH+g7X1ICvG0a8hd8lBtiypU=;
        b=fM+iC8uvmgrgUOfhyOFQAOv0aAim55drqBQiEH2ZFcThN6OYdLZLWsxXt6H9pSaZqr
         RYJg8cYxgawM6hbhIyPNghunuC9N5DcG7XKlzTbxRNpHTwVX3bzbbTxbLd4m0sMFSeYA
         ypv/Qeio5n/ig3khNR7oXBsPW2km+r0aqe5wD42Z5l0+RBUM/qieFczRNheyp+mDzoRy
         OpVaiWsSkhxo9w5kt+YEBLZDr7q0qvy06KINDUObAW4NWZDWlcOvxNBHkoqOX6UrrYir
         rn/RPqeWXkPqJWhRcxylkFr6qUUN2AWSH1xGD42OnjHzKbGhSq8or721NQuwWhiOKg4Y
         sCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717982893; x=1718587693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogGDeikgVtP2/JojZOHyH+g7X1ICvG0a8hd8lBtiypU=;
        b=fzN81emzW4FK3yB8stbAf8nfsE2X0rRtZ2ZLkq+HimuN9E1q3JYfoPcecu894HBfF1
         R5fl2dGjtlEQApUF3uXCps9uqeZoyHxkHYY+4QQeaT5b5GDJc4+CBtg+JOpUGbJ1VwkY
         OXFvAh762mDBwtF+A+ZO5C+AuwT2nlqzJBuEpgVUQ4qecxDyMgWEvXVuaGD7jrk6T7SB
         raGUAIpR0YN+ycBWQmB/+aB0FmeDK4f4YfXHgReWmCYCCBiLrOh8QGrypCHrO5O9PfTy
         NDP+PdYTze1VH6FGVjndeQPhiqLsGQDSJXb8D8qooTBRukddQwE064wakCgF1EJCJl1G
         BwjA==
X-Gm-Message-State: AOJu0YwLqmOd4vm17/XRJZIUCNz9gRIO56TUU6hEH2HxxgRcb+RLZuL4
	xhBjYamSZgDpQ/FBWyCFaTtxYRoMEDrxGclDIEsN6QbWUe++CCMN
X-Google-Smtp-Source: AGHT+IFJo7eHVjaNg2drL50B9+RvvT9/t/rU7YReGKAasPj++KS22No3SWU21pQ0mLV8XqqTCBaCqw==
X-Received: by 2002:a17:902:ccc9:b0:1f4:8a31:5a4c with SMTP id d9443c01a7336-1f6d019ef8amr117255655ad.24.1717982892523;
        Sun, 09 Jun 2024 18:28:12 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd81c9c2sm71291645ad.308.2024.06.09.18.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jun 2024 18:28:11 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 30EC41846908D; Mon, 10 Jun 2024 08:28:08 +0700 (WIB)
Date: Mon, 10 Jun 2024 08:28:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/368] 6.9.4-rc2 review
Message-ID: <ZmZWp2YnzYmjkAsi@archie.me>
References: <20240609113803.338372290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W41JxYyyql6NqAfX"
Content-Disposition: inline
In-Reply-To: <20240609113803.338372290@linuxfoundation.org>


--W41JxYyyql6NqAfX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 09, 2024 at 01:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--W41JxYyyql6NqAfX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZmZWowAKCRD2uYlJVVFO
o2lGAP0dGu+7nBNV09SeIbB9xdX9a/utxgv5ORMtcJHB0JXHZQD+KI/VDJTKPMbg
1slqhmM7JjCzxCKLUSgL/r7C3WSmNwk=
=D0Gy
-----END PGP SIGNATURE-----

--W41JxYyyql6NqAfX--
