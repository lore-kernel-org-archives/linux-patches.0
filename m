Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B517361
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 02:04:35 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id g3so14870329pja.2
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 19:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681351475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ajXeZFI8jDvtkOHsMQMABautHIWSEDNr2zJAikW9Y5I=;
        b=nGhWlGViKx7JsP8m+E64vXcsXVwRQXtDGsqbNUW/2A+5nilH7de59kUQkbvASq0w+H
         FuOeyrt+i8F/X4f5h8RX8WnzRPZWXm3SgeXe/Lo+n+rpkLCHZAyYyCkpWDEyYadufCc+
         snlxhl8RmsBXmKVF5hj92SoBTlRnZb0pRLdA6j1p0JPe8OY4RZb3ZZrXDB47gb0toyGI
         LJ7GuCWLKJmL5ggkw18LyE7PxBzb2siDBnShGIoJ6aHv/28wHRCzuR7351aazjCuuyFS
         eFbBTMVumbtAa3AurbrWXcbqj9BdBN0/LapM2EMYrRiKUpcEo//mRMAQFs6ztcWXeZ+h
         +pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681351475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajXeZFI8jDvtkOHsMQMABautHIWSEDNr2zJAikW9Y5I=;
        b=fIIin3+9vdyjKFgbb/z5BWKRgww3nahNDnPSWM9rzdJOHbbm9fw+SnCzLZ+l8dClCR
         vKD+9co5RRC68r9KqREbpsuLvTcER9YUN4McmbLKmEohDJCZWLVyf4rZFWeRrMnv6MxJ
         WxFwcJhDTTx9JGarvkfRTd64hVoixrcHMQwnKtqHK9CRRh2RNqiyoL7LC02198HV/bSm
         W9YQDQVFQjnAnHdjXEm2Hr50MWsCE02NhJp9DPpvo8DdYvak/Vp7oYoPT+7ZOMeAaVAm
         b7mwCl66x25+Uf9tx1N7LAEImBqzliLhN4YY9dqt0Wj942SNYiTKtLpzwe+63BQX6lB9
         o0Gw==
X-Gm-Message-State: AAQBX9ewezD2dfnUJCSz1+ldWKMZyukksnF3C3L5380d9MQJzr1yC35X
	5Kswpc4IEI/puKDIxbFpAv0=
X-Google-Smtp-Source: AKy350YG1Xw5IfPU4j8wcGusQdvHQ5APfvIMoCfGXApM6E1B3+zb9oh16odZhkilqeKNTJMcB63p4A==
X-Received: by 2002:a17:90b:3005:b0:247:ea8:1ac1 with SMTP id hg5-20020a17090b300500b002470ea81ac1mr199984pjb.11.1681351474926;
        Wed, 12 Apr 2023 19:04:34 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a858200b002448f08b177sm2102636pjn.22.2023.04.12.19.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:04:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 565B51068D3; Thu, 13 Apr 2023 09:04:27 +0700 (WIB)
Date: Thu, 13 Apr 2023 09:04:27 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Message-ID: <ZDdjKy+gIuXRB7IY@debian.me>
References: <20230412082823.045155996@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6wlRiPRhQb7nvgTG"
Content-Disposition: inline
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>


--6wlRiPRhQb7nvgTG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:33:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--6wlRiPRhQb7nvgTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDdjKgAKCRD2uYlJVVFO
o/XOAQD6VtxrfW07Yh/9GLGU4xmpF5WJ673N3oT0/7F2PSy1bAD/RA9KaDOaYBOJ
a5VSzD0+ecaol5Vi283zC9ejO6G32gY=
=Y6eA
-----END PGP SIGNATURE-----

--6wlRiPRhQb7nvgTG--
