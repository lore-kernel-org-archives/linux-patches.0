Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E84810A03
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ikeue01p"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cfa5840db3so10547635ad.2
        for <patches@lists.linux.dev>; Sat, 25 Nov 2023 04:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700915655; x=1701520455; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=07knrX4pVFE0iOcmmvEQbY06HxioBNIgSOZlMbJ9JQM=;
        b=ikeue01pSKL0n8fyJbfh4qW3iO3QtmXMg51eclrgzOVGsI1xk3Oh5Rbmdd9hkTuQtb
         xZr8k7tfNd7txzNwdfTXzeBaiq/Ro9YAQBSsRO7aJBaaGuCCXpjoIdILyqgmff7BILT2
         HEBhER/0EpoCu7Q+U1gFFZRHWHO5t4JspSYAHA4S5ZELhytQIvphyEUycyrhAIILpuqa
         QERgdR4ZNzddQVIuH5IkPzG92Yk1cyfmDP2oPI13Q2eiKdoun1K+xvKOvb2tFieGk7CE
         /fzgD7N4LgoKonc+eZEl8zqy+8rG+qeSdw8J3auqPF3tVCV9WEJqiC6fd9iHlq1KWdg1
         illA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700915655; x=1701520455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07knrX4pVFE0iOcmmvEQbY06HxioBNIgSOZlMbJ9JQM=;
        b=LoJaKBaNKYQt0JbdfYDloGQexTUk+1IL52IlExr5SNyNLwB6LO1Zkip4N8LYTtIxJq
         VllHaTa24uDJxkKUejm3yhncqWI87K1fIwNBPnzr+YtwyL3R9C3m3Vo60bzlYomJQAcp
         J01LWgFNYbuNQyVLM09SRFuGbYIupXna+44DdKoaT4W4ti6rqdhkHrE5C9Zl5bWDq16I
         LuxM7REZifDki16ZivOgMN1SGCB80V8g0PcCNRJz6fffASqRlFMfX9R3saS8tdCyb2k2
         cVyv0yDpiIYPfy534Y+HcNj8xqWemJ0XMUWPeBHtr9B7ywRNf31pfWpJRdcUqBGkKZOA
         EOKQ==
X-Gm-Message-State: AOJu0YyYSR9vrwwFck5Zd1myyJ8Hyzmc71/lZ6TDGrBUdo//HZFDSTUd
	+hJwjDsZZfGo5SHxLTXrK4E=
X-Google-Smtp-Source: AGHT+IFSYXWSODIoCE4XcmiZvqVb1mjna/JEsLe922nb/2SDAE+e19R3bI850BIxAfSpI9cV9TV4QQ==
X-Received: by 2002:a17:902:e887:b0:1cf:689e:5811 with SMTP id w7-20020a170902e88700b001cf689e5811mr7873263plg.18.1700915655399;
        Sat, 25 Nov 2023 04:34:15 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id h19-20020a170902f7d300b001ca4cc783b6sm4826080plw.36.2023.11.25.04.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 04:34:13 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id CDD1410205C47; Sat, 25 Nov 2023 19:34:10 +0700 (WIB)
Date: Sat, 25 Nov 2023 19:34:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 000/530] 6.6.3-rc1 review
Message-ID: <ZWHpwvYUQ3l1Dwv1@archie.me>
References: <20231124172028.107505484@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3UlSeso7lPb9eNYa"
Content-Disposition: inline
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>


--3UlSeso7lPb9eNYa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 24, 2023 at 05:42:46PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3UlSeso7lPb9eNYa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZWHpvgAKCRD2uYlJVVFO
o3BGAP9E4lmr3Mn5TH36iNQYs/endw9utiAxgj75ukuKNytFUAD/WROePuv9jQO2
zSPxguvXD3tmTRHDpSpdX1kSpOAgJAU=
=z1ZP
-----END PGP SIGNATURE-----

--3UlSeso7lPb9eNYa--
