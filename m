Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBC117C9
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 02:04:20 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-63b73203e0aso3668986b3a.1
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956260; x=1684548260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zdT5mleDLeq0ZPRxrhxbPyAgxYivgHjWjRIUkuvyouQ=;
        b=NYb+HEH/B4I3YJB/R0nUbVpY5JuWHjVGGikvy4lMljQ0Vp4o6ZD4tep/cxFZ7bQXbK
         7MPS+CMpVd3wNd3HJ1s5G01yFxgEJHbiPoz8v8nMEjBQ9OZlm4VW+8fT7kWJL7zx4PEm
         eMDGEQ949lvb5WD4+EUyH5TOlF8G4XUQS1lawZY4yWlBDjyUaG7PUO8edykgrXHCz0VB
         FrqfWmyqrwyBMoYTU7beZdKiSYArQFEASTW2w8gcJJAeU2clSCpvja+yXu+ncQb9u0m3
         RAHwwZ9VG9FkZY9ekrkm9btyPS5j4LV3jVFcCIaFm3SZQ+IZbUpXpiOEH6wPI5q4wuhr
         9Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956260; x=1684548260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdT5mleDLeq0ZPRxrhxbPyAgxYivgHjWjRIUkuvyouQ=;
        b=PWMHdRoA40BOF7xd7hAyxcT6vmXKppqJzTlxZRasFtutW7CeGFJb2E1KrLRvpu+T5c
         mLzVXTdZp9j4VHJt9nbm91WGTkoftf4H1b49zMYcRUAgptrDCQGwPcCwlcHsPw8b+hCH
         5v7ECgNGoshA5gZbhuEdqCXTZIESPgadSnoLZnscsVIinV7x6GjNJvc5CbzUQOg4NfHW
         YK7Z04p0Uuez1gEkO8xgRiM4voTiRKZNa8ems9DlbXW18j1W4RrYvdo+7s1huakuKqPo
         yiUXADXC/rH17svRd/DPbLs7Ubn1l6o/uSPfTtaMF4h6ZfM/gQTXgOe76CqzSuHx2aeQ
         0jZA==
X-Gm-Message-State: AAQBX9f9icBUFg6LnBQKLLMax5gf3He04zifKyw3ShULi/Z91yViqUMJ
	IXK2jwzsma6ub187fFOIF6s=
X-Google-Smtp-Source: AKy350aq3aOeOGvu/GOH4k02123owFbWfWKPfYp31iKKfKhvq0JMcObFOyHWJTZ8MszR65QFdJvaPQ==
X-Received: by 2002:a17:902:c40f:b0:1a6:6edc:c884 with SMTP id k15-20020a170902c40f00b001a66edcc884mr5781597plk.16.1681956259923;
        Wed, 19 Apr 2023 19:04:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id jj21-20020a170903049500b001a69e002c7esm102312plb.178.2023.04.19.19.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:04:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 30D101068A9; Thu, 20 Apr 2023 09:04:13 +0700 (WIB)
Date: Thu, 20 Apr 2023 09:04:13 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/87] 5.15.108-rc3 review
Message-ID: <ZECdneXReDmEBNzI@debian.me>
References: <20230419093700.102927265@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UKBJ1PY6MeZaw2yI"
Content-Disposition: inline
In-Reply-To: <20230419093700.102927265@linuxfoundation.org>


--UKBJ1PY6MeZaw2yI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 11:40:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UKBJ1PY6MeZaw2yI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZECdnAAKCRD2uYlJVVFO
o5tnAP0eFqKZOpGnOKB9KJdGm4jYst2JXduaWa+622gU4aGMjgD/Vp+GS0SFpI7d
walqISenpBJtHqcAtL1K60AIL4KCowI=
=tO8f
-----END PGP SIGNATURE-----

--UKBJ1PY6MeZaw2yI--
