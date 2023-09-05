Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5227E
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 04:11:20 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso8755575ad.3
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 21:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693887080; x=1694491880; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIlMAZ50va4APRXsLxxo9D6kHpaz1P92F5pndkHR9ZM=;
        b=H/DYB/ELX5ZFBSZ72LzoYlxMPTH0L4yt5otw3h07RT+MjWtR+MXP1BzT5ae/DAMhBK
         Fd5RvEeDUCsN68xAYeTiu6TAeiZeDFEbv2viz0etGuq3RuY9wd79HWEuG1i8txV0EgGQ
         isTFUhtBParlfTu6Wb2s5oJDta5B2pc8eicNz47sE/79EOWkGxJpsy8e2NCmYtkS7iXN
         JEiwzpCIivJofRHlTldXptKp+h9O8Jkw9dekIhQrUgKIJo2KZiTHphSU+feDZzg6QDLR
         czrEJ5Wh4LQOTi5KdgCAoQSUjx3LRDR3e9CcDTTQfXkLBx2Yiq0oQ44IB3T10egqgO2H
         UiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693887080; x=1694491880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIlMAZ50va4APRXsLxxo9D6kHpaz1P92F5pndkHR9ZM=;
        b=HaIqmTc+r0WKyzeYf99//frEjc2YWtRhMa6wrwYtK+bVGZoekjzE71hvoLf1gOSo1Z
         KZZNGm/IdPojRfyTKvyTSk4NgT8ZNQNvv1VbEus3U1LK6jmfDYaQgzIcyR2UQBFNw4Qk
         ZfX5dUSg4V7lb6ORDiu6IFUXA0C9wb+MYUoQdMyrwv/MuzQRywhGLT8Rm+PdUFlRoPUC
         +k7k5eKyZybR8gS8wRhz+NZXYkyurNPTjWG/ruh0WhI4pTYbKqsUVy8CBeXF2VpsCXyX
         ENgYg6acWxxPlP7Wo8tOaynebT3M5Y4mgIat6M8WFdeahnPaTOEyRkThDdVw/KI6LEmx
         ByJQ==
X-Gm-Message-State: AOJu0Yy04NpSF+TZmhUwySKHzhL/C+5cxl8eHxug5QNQzDpLjqoqXrEo
	cuNLEJiXmj6+z1C0b2kTsp0=
X-Google-Smtp-Source: AGHT+IF2fMTKi2lUisY9zZI1YMErIBX7PytITedg0+99Wi8JAxf48Fx0KSjjrLM/GIFEzsAxh/dgSQ==
X-Received: by 2002:a17:902:8f81:b0:1c0:d5c6:748f with SMTP id z1-20020a1709028f8100b001c0d5c6748fmr8126856plo.67.1693887079569;
        Mon, 04 Sep 2023 21:11:19 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090301d000b001b54d064a4bsm8216282plh.259.2023.09.04.21.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 21:11:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C150C80665D4; Tue,  5 Sep 2023 11:11:14 +0700 (WIB)
Date: Tue, 5 Sep 2023 11:11:14 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
Message-ID: <ZPaqYkvpv-SuNaWe@debian.me>
References: <20230904182946.999390199@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qgY7tslBl2Et3VY2"
Content-Disposition: inline
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>


--qgY7tslBl2Et3VY2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04, 2023 at 07:30:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--qgY7tslBl2Et3VY2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPaqXQAKCRD2uYlJVVFO
o2+dAPoCAaTGWb68AESIogYBgM5EaLF7IGs0GRhp/v0jMPvmIAD/coVd1CGNIAUN
ubXXxb+wa7BHTAhocvV/ZP3Ls6vxsgk=
=hCPn
-----END PGP SIGNATURE-----

--qgY7tslBl2Et3VY2--
