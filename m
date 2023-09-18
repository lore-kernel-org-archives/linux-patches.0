Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2D46A5
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 07:00:19 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6bf298ef1f5so2774680a34.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 00:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695020418; x=1695625218; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGpnaX3U1wfpEzDRwXZ6otPXK5e+cQlH+xiQluuxq6M=;
        b=na8cqO1gKwP3O7W9YEQPAmfWmNxrGbIC4VuulE8AIvlLbgGw/+qiG37y1g1C9dED2k
         CH9rLY8ND+a3Zm+UWygNPeEKhi2i+rdSC4Rq37PWczjm7n0i1ydzQJIkv722F+G6IE1y
         MWCJ0SUHPKN1VFYOQb9m/5iIHiZxZpCQV0bmvNAzDrDXLda8znxE/O8fay0ZXL5VlZUn
         V/mEAA8ismg/N7Q9mYmbDBKZr1yQ6MYjwdTA/TDxGNUj4Myv+utX2jn5dYigyKnTSYWW
         FlrEgfrhEi/5RVP7xmp1db5VSoBcb2mii3GzBUKy4OKTWCi6ZV2mPtxWbmEnI83c9yCQ
         pNwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695020418; x=1695625218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGpnaX3U1wfpEzDRwXZ6otPXK5e+cQlH+xiQluuxq6M=;
        b=ih1zPUzYtrtEw09XT8aqGzGnYFRVcyU7+88iRU8VG858596rNFoK+cvk2wYegYas/Q
         1EgYY89yoXxlhEa8QFyq9jcFfxQ3Im/gEe78ujIUetSH/RyyQkJM8CuGdWa5koobDCGL
         S91ptBz2XZxlryEHJ4DPfTXPi+UypasCJturELTmpWmyoAZYhMft14U6xYCotfvCv6ct
         8GAfCFOCyaoIdvjmgl3v+I4SNFpmXWm6xnQHFsOPcZS2r3wKz7EBI63FtCNAQYYYRz40
         t+DrqtYura9uDI3BJmBNkkXZj2O9XvXPx9u/y2l/u1qW0fBDJn9Ea1aBql0Qf/ypNWWF
         zzXA==
X-Gm-Message-State: AOJu0Yy0xWDeYSZcAGTMwT1OeYW2vtO5NtDbiiRYncYRllTaO8G9Z4zJ
	BRm6HeWuQuaqkIlobFqrAMQ=
X-Google-Smtp-Source: AGHT+IFSSQ/r23fvP6vvpjDiNkt/wADBnfh277py/7ZTNYoQw+rQ2lOXF1Z59G9xq9gCCaRvEb1CRw==
X-Received: by 2002:a05:6358:c29:b0:134:c859:d32a with SMTP id f41-20020a0563580c2900b00134c859d32amr8800859rwj.25.1695020418206;
        Mon, 18 Sep 2023 00:00:18 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id t20-20020a63b254000000b0057401997c22sm6222917pgo.11.2023.09.18.00.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 00:00:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id B2BEE8061F05; Mon, 18 Sep 2023 14:00:10 +0700 (WIB)
Date: Mon, 18 Sep 2023 14:00:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <ZQf1euO2Q49ELToH@debian.me>
References: <20230917191051.639202302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aFKtJh1eZuQwoNSP"
Content-Disposition: inline
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>


--aFKtJh1eZuQwoNSP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 17, 2023 at 09:10:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--aFKtJh1eZuQwoNSP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQf1ZQAKCRD2uYlJVVFO
o1PxAQCC3AuelFUwY6XoHM59dI9K5dK7w62l22V07hzSDgCkTgD+Izmeb9aVU5BY
8ybU9QBhB5rEdKR0b3gzXtu4pyAT1Q4=
=Xerm
-----END PGP SIGNATURE-----

--aFKtJh1eZuQwoNSP--
