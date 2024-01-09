Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472A8F40
	for <patches@lists.linux.dev>; Tue,  9 Jan 2024 07:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0/A9p9B"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-28d7870574bso999513a91.3
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 23:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704783824; x=1705388624; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xs3tOsO7zy1R5Dpwf1Worw1jnEX4JWvf4b/DnGpavKs=;
        b=Y0/A9p9BI4Q05ZNSqCn3qP5Nk/o2NIHx634YN7kJxyz3a4Ocy82pCwMiWhH9ixMK37
         mENvIuNjRutosjZ56JiliksC4/i7mwcnacv9Ay9NN+xphtSrwrq3O+zeL8Yb/CCym+aK
         lKmF7HsQrbgO42PQLerO+/te8QgWR3r65zqEBEXvSyOSW7aOAxe57ZoJl/AC/lfMwZoF
         c6JK+fVNRazL1EXXIwb1RZI8BpHx/LRcUcJ8gSUdfP66Ecw4ss+sOoOmoOvW3psUiAJ6
         ekaORxLwM7V4ZIUB1IUIoWWTIecxpIkZpnZqXHyb2p71eXgFsPcRY/UjMP1nG4I0Qzpg
         QpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704783824; x=1705388624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xs3tOsO7zy1R5Dpwf1Worw1jnEX4JWvf4b/DnGpavKs=;
        b=pkCReBB3RGT+Cc8LeJP5kiYmmSmW7CT7399TFp2liKgnH2eRg5FWQp5BJjS3PxVSwC
         Lj3Vd43YGmpkXKpyZzGtljVRk+Kb59ZZUpNp4O/xET/Ofr6ZXgxIMXFLVEPRMNm6MjBE
         glwnKuqTRrw29uJ/FZXQS3xt+i/bx6QFowb9phRRQ+dCB2hmXErKMpN7fVxsiR/4J+v0
         keEMprNaJ4fbFtQszR0OkZ5W6nSLhCDNuu+W97Zm9wDvx0jlUXXi65dpkYPx95DqT7fB
         u2LlwyOJlFSa3OjzfEHsM+EVQCWb3RJLikE0GyMTbhJsea6Kfv8aDsAoK4K+3bzUnfg1
         L4fw==
X-Gm-Message-State: AOJu0Yz+U4UJ47dzB3PGUtQOA6C1NUqU2L2N+xtml1KzC8Nb3QwPDsnE
	wSyHHW8u9Zs60T/yWYriNck=
X-Google-Smtp-Source: AGHT+IHlKJ76g+fmxlFbm6sHZQfVBU5b579SBwlHShnFDtKCXWmJQCvm2U+ap2npA6+m4wrCrourKg==
X-Received: by 2002:a17:90b:1b47:b0:28b:e09f:58c4 with SMTP id nv7-20020a17090b1b4700b0028be09f58c4mr1764267pjb.67.1704783823464;
        Mon, 08 Jan 2024 23:03:43 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090a2ac200b0028bc1df95c7sm1254646pjg.4.2024.01.08.23.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 23:03:42 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 32439184790E7; Tue,  9 Jan 2024 14:03:40 +0700 (WIB)
Date: Tue, 9 Jan 2024 14:03:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
Message-ID: <ZZzvzNcUQCfDJyWJ@archie.me>
References: <20240108150602.976232871@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Znhe3Gzkdkhr9ETQ"
Content-Disposition: inline
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>


--Znhe3Gzkdkhr9ETQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2024 at 04:07:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Znhe3Gzkdkhr9ETQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZZzvxwAKCRD2uYlJVVFO
o8CKAP0WyKQZoY68dpZxDcQ82JWlTdXk1ikzn2Yo5vh3ecRn3QD+PJqd+Aj8h9VM
u203dzRkEqfonJ7VtvY8hqTTDwRyiw8=
=3kED
-----END PGP SIGNATURE-----

--Znhe3Gzkdkhr9ETQ--
