Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216327E
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 03:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiDxpL+v"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3af608eb367so360679b6e.2
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 20:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696477308; x=1697082108; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sk95zFTEUxg4VjqgqYYBz24a5vuW35vcpYZ4u3hihIA=;
        b=TiDxpL+vUAPFMByJfIRMYe7fW+Zbg9PkRfcuUPwLvusBB+1JtyuJXumO7nzaoH6DV9
         5hvOWCLmGAKSDD5uV++pFw6ndIzldOy2kwWCoq2QK5TlLaKox9zc4TYNb+HawBbmT4JP
         rC1WSJfKVLlo2YWSIAEHtJQ43ANbHAOsX2m5S0BB1ocZw69vX+qIiVD0BmdA3i/e2P1c
         9wrKflo3dRoFU5gBh3k+B3E0zeeIl8H+iWzda6Y8Z+hnQlhYLaGb5HZNdHrYyou7De7r
         l832JXwdkxEI04eSA2kIpoG1sDF7rP/D6cv8fZOI5yeJQHjRaCF5ggwZyMmPgImADCBF
         FabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696477308; x=1697082108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sk95zFTEUxg4VjqgqYYBz24a5vuW35vcpYZ4u3hihIA=;
        b=GgM+CRVy591jXk5LWrN3Xr/T1bOQ5SZae45aekZUiohNNziP+u5p64dzw/SO6j/ZO2
         xXcFDymtPFFJ1MXKGWdS9Rc1oX0zqsTPzA7nmJMYGB4yGL+GPguBn1bsa8rduJmZqkzR
         MMGJ6PVAaZeeYvQYsVBXLU5aL92I+KjBknpUnoXzVdHQ6SEhSMwnPQD9/lNIB9PY52CU
         SLZCzzWaEOAbIjg+ooNGiO/HoAO3OdguaRXzzwp6gvnoTYjFercO1VJM3NZFl2VTm2bY
         guYMmoNwEBzoQl27vI3vVSzd15zxrXfTbGXvsQ1o3Hn0gmzNAPebzrsbfXVMJucm+OvT
         h+1g==
X-Gm-Message-State: AOJu0YwU7Q46E8HY/VnTMtlH4sMawPdlExLTu3aEeRtx7sWJrgmbNuyj
	60E06mG3lLGO1KHDM/QXXMg=
X-Google-Smtp-Source: AGHT+IGVDo7JufNBKQ83S5yooQvJh8P01DU3SZTzTijKLEVf7t3x+8HdemVgB7X0KbSn4SsCM+FIsw==
X-Received: by 2002:a05:6808:2382:b0:3ad:f866:39bd with SMTP id bp2-20020a056808238200b003adf86639bdmr4665141oib.27.1696477308089;
        Wed, 04 Oct 2023 20:41:48 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id a9-20020a63bd09000000b005891f3af36asm316522pgf.87.2023.10.04.20.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 20:41:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 81C2C80FCC18; Thu,  5 Oct 2023 10:41:41 +0700 (WIB)
Date: Thu, 5 Oct 2023 10:41:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Message-ID: <ZR4wdCFV9lT3XFKV@debian.me>
References: <20231004175217.404851126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2A/QDMh1jEjOPF+0"
Content-Disposition: inline
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>


--2A/QDMh1jEjOPF+0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 07:52:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--2A/QDMh1jEjOPF+0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZR4wbwAKCRD2uYlJVVFO
o25wAP486peTivssGitHaDW69OLp2joiFPR3ZIZ3MEPDmy3pYwD/bmNcEDqkqMEA
Gvfhbed2QiGCwwYAW3Aa9d6SzE/LHwE=
=/usy
-----END PGP SIGNATURE-----

--2A/QDMh1jEjOPF+0--
