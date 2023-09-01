Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2FAEBE
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 07:03:00 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68a3b66f350so1412548b3a.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 00:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693551779; x=1694156579; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8wr24to/gtJqJwr7CdrwRS9mfHBCNBSTGsrr1PkE30=;
        b=NBtvgHgRGCeJ6fQo0Zac+t7jjONAvnXTTkyYyQ3gfulw2F7Dc+55nKqlrAm8QDSotg
         69XJWLKYeKMFeQWy/3eOwxg4RjHCFBNP2Vkr2lAdj5l/L+ri+htcvwHGYt6tVRwVW3zQ
         ZFRHdRPHkzD7kursPQE7xOiX9dZin07ZbETkGf/d+oMMCcdJ0ubeorMkh+lkXoFdOAUV
         qD8QOFiseLYRueo+NPj32keMikBGSj4PJ8Ajw1kt5NJq5S6LBZIN3frRbYZ7i7uH2S1K
         kDzh7ZxJPpihDT4SA7lKI2CaHvQqWAMxOCSIjw1vtSGXDHyoRYM1ey95VNl9rCn6nSov
         7QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693551779; x=1694156579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8wr24to/gtJqJwr7CdrwRS9mfHBCNBSTGsrr1PkE30=;
        b=V1Y1SRRD7atV+mTd+0bbyiGK7KCBopqnAap1X14M4OBWQQw0Qo/++WHbCv0KQzDCBj
         PzLF1B9cAhFoOOgi/dThGfZNGbu2ZKuXE2/s1UihTniK3iJMgC3mDA3I+BIvGQteJ6md
         PQvaPAbf6DkwBavuZodgFvwHA6EIKnkylgLuQ54PSRx3kd5Bwy41VEHJ/0nqh7zRqP4H
         5OEVMHw0v5X9rNnwCIT+djv1HlQlX11LpxAv6DKG4X6AyvMvahbwCnzSNSFadayirM55
         TzY4HNAa4uC7a8hi5xTe0xdalpSexLY75+EOdu0eSXjZqcNlf511ATrLx128E8wsp+tM
         Jb5w==
X-Gm-Message-State: AOJu0YwPNFpZFKThbJtD6W4SCiXG6rCXFxoQdbpvl73SJPDap1A+yZhE
	vTDHW4wmQ4l5ZwOmBhodn6s=
X-Google-Smtp-Source: AGHT+IFH62BQFrdwj6BomF4htUKGs5yvT3G/DWOQ60wYI1H0qhLDmCweZYjyFwA9jl5MEse1SfZ63g==
X-Received: by 2002:a05:6a00:189e:b0:68a:61a9:7e43 with SMTP id x30-20020a056a00189e00b0068a61a97e43mr2047516pfh.29.1693551779208;
        Fri, 01 Sep 2023 00:02:59 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id c5-20020aa781c5000000b0068a3dd6c1dasm2378796pfn.142.2023.09.01.00.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 00:02:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C2EF18F03D47; Fri,  1 Sep 2023 14:02:50 +0700 (WIB)
Date: Fri, 1 Sep 2023 14:02:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Message-ID: <ZPGMmjfiMKt1jMAL@debian.me>
References: <20230831111127.667900990@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L55yot6n5WpZHRsh"
Content-Disposition: inline
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>


--L55yot6n5WpZHRsh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31, 2023 at 01:11:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--L55yot6n5WpZHRsh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPGMlAAKCRD2uYlJVVFO
o7nKAQDCT2WUu7n/CoP/jDSM6zFSNP5PklxV3TlWaCgqiYdftQD8CvqE67J686xO
TKeWBGHuncY0L57Qi+O1X8LR73IUUgw=
=7eRH
-----END PGP SIGNATURE-----

--L55yot6n5WpZHRsh--
