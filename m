Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B73A55
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 06:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJLNMpLV"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-694ed84c981so3931726b3a.3
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 23:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696919016; x=1697523816; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QmKiVGXOMoFSb0jdRS7/I36LbjLoB/tR7BGYo9BXzVA=;
        b=gJLNMpLVYyXYrj4vY5a2xWie0Yrapxf/JWf0ALf/divZnJltWC0jSKjNyOq9xQfMdp
         asvzoXRK4yQuPc+PETabQO2AMbNkJisI+ZHreGPNEAH/fGJZqip5M+pBbv0BWP3gQ/hJ
         P0vg0pfvtZTGbu8OWy74arefot0eu2zdBROzx55l7AEsCT9mCwdyGxIc6DusQRgStJw0
         otttahVk5rtXqFa5HXJEkJSRdUvotRsbUp9TpEPKQP+tzBGFTAW3MOKQ0NC2l5bAD+MH
         GesmLCiXzfoSeX5+dL9PGBwNYYlTdWT/tBAnrvXNZb/l5Ws62CXgoGv8fspwfGdhABX+
         JvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919016; x=1697523816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmKiVGXOMoFSb0jdRS7/I36LbjLoB/tR7BGYo9BXzVA=;
        b=cINtLTfNgoLdNcIenklpZ67j2wD5Pw1Yd+HSl6Iuo+5fAuAYrLY7NuZx3qZX7twAcE
         f7h57E7zLh15zxHkaq9eiRjIvWqBtf/rxrfIWpsg35FwAOKSJ/xjkY5IIidXwrhx1eB5
         v2mW5tUyMqLm9H0n+cwxYGwI03E/x5NYK3QPPcN/mx7otTiDgaP3x3bGRRD1Qz8ZbZLG
         LSpaYlY6iUgXqu8ZgJ3z0vUcy0p4SAgG+TdseH4N//78xUcYRMQ0bW4d5rz4NQaaIqY+
         aJ26k3SX9N8J91Qkf0VXNcm+BQ8fv4jAuYDXES4OmoRI+Bydapwa7GIrOkxBxIxk8r0w
         BeQA==
X-Gm-Message-State: AOJu0YwdQe226jpXNgh6EZCevzIKEu2JBL/EWBI3Zx7rTUTcCVBI+OCa
	168X/vdoDBQwp4R4oz03hMU=
X-Google-Smtp-Source: AGHT+IECxhjXjrQAv2tcqtN64pPrEu0AY9j+48dsFtrXG8ACl2uQZd14H8qDoT/6c3Qfm2xGYEa6Ew==
X-Received: by 2002:a05:6a20:8f0e:b0:16b:f8ef:f31e with SMTP id b14-20020a056a208f0e00b0016bf8eff31emr10060052pzk.5.1696919015682;
        Mon, 09 Oct 2023 23:23:35 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id y4-20020aa78544000000b006878cc942f1sm7410333pfn.54.2023.10.09.23.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 23:23:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0AFFE84B9020; Tue, 10 Oct 2023 13:23:30 +0700 (WIB)
Date: Tue, 10 Oct 2023 13:23:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
Message-ID: <ZSTt4p9ezc4cvxNW@debian.me>
References: <20231009130124.021290599@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n50QiLsRPrBx+8ui"
Content-Disposition: inline
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>


--n50QiLsRPrBx+8ui
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09, 2023 at 02:59:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--n50QiLsRPrBx+8ui
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZSTt3gAKCRD2uYlJVVFO
oyj0AP4ggBKxdQt22d6oxanLTajhPHPJW+1RISWNnDHMNWqvJgEAyndXFQuvH2PI
1tVI4HuXNSvspscewOFdHo3u6aUsIQc=
=N3HI
-----END PGP SIGNATURE-----

--n50QiLsRPrBx+8ui--
