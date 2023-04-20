Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D6A17C9
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 02:03:17 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1a66b9bd893so5865525ad.1
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956197; x=1684548197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=daoW9QA06zZMAl1RTvG2SlKgRJ+qcs4DTZlqIRplbzw=;
        b=cTiX6WHisRzCQEUNVND5mOIlKKG2n1T0iw4EZ+GdMSU5ag5+KgfD3sCs+xMvT6AJHN
         f5niSNhAZieO42mfSe3rVSDGYhIqVR2ZUCMMpRI12a+O7lVtCCmTGzDD5zOOuYJ4iqW4
         IG4eED8BPN303/nn/2caRpwtXPldp1G1c/D+rMR5nlrGVGLJtlM9aosi/31KwjQUiLHt
         aXivzHe3TTyUJ+GJVUHTcmyr8yVE2FV8+xlTUMKzqBFiRHzkYiGu5JkzmJhlfkZAWn7M
         kadB2Tfu8DqKgELgzP0xXtb4jdVbNMkWt3ZrWTzMXEAYRYWWnvGcl2PBWtx/ke1Tud2h
         lxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956197; x=1684548197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daoW9QA06zZMAl1RTvG2SlKgRJ+qcs4DTZlqIRplbzw=;
        b=WOUkUGKxce1odYm389VdsdSP/G09he3CJri0Jew8kDROiSr+0cNGlk/A1kEIP29nQl
         ZxntVueljL5rqUl8nRsEyr0BwJMUehy3RGsq1KppwQ16LnpR3G81GVmNH9KHghlFE+JK
         A6isjVNnTQy9Si6Fsmjmt8PpF6TWJrn1qQaDBSDLoXg+dLZwoQlJWqJn3CGZ9lYeAMlu
         oOJN3ahV7Txn8QVPiCEV48MCjjIybErCLbITWht8ye8VktAA9Fwcz0J1yoRHp+TXYPhY
         TsiI7SLT17+ttPAVnjGdM63dWfuroOI7iEdAoGBnXTCL2YD3NTb3CaQ7TEEIY862GY6p
         MIgA==
X-Gm-Message-State: AAQBX9dvklP8wPCoYbQIK4lQLKe2jPwgy5vmWSvoGQAN04rUphIoi3pw
	SMYGu0RpzOvdo1ZhE4Mi6w4=
X-Google-Smtp-Source: AKy350b/e82OpwPeFZbkBWEfdyCBrY4Z4wIh2UuFlULKY4B72s+KxWSf8e+jEddpRg0XpgscBNQvrA==
X-Received: by 2002:a17:902:d2c6:b0:1a6:45f7:b332 with SMTP id n6-20020a170902d2c600b001a645f7b332mr8679362plc.63.1681956196714;
        Wed, 19 Apr 2023 19:03:16 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902900800b001a64475f2b4sm109806plp.111.2023.04.19.19.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:03:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 9DEF510686B; Thu, 20 Apr 2023 09:03:09 +0700 (WIB)
Date: Thu, 20 Apr 2023 09:03:09 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <ZECdXU31erXYYB6k@debian.me>
References: <20230419132048.193275637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IVvWDvxZnxJiyVq1"
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>


--IVvWDvxZnxJiyVq1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:21:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IVvWDvxZnxJiyVq1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZECdWAAKCRD2uYlJVVFO
o+vXAPsHphc1gRa/3dMBQ7hApPrv/C8sqrvwLQIk9fQNlD2GRwEAlNlch7c+77TQ
orHk+LHMkq2pKqhuaWFCXn2978Sv9Ac=
=f5V8
-----END PGP SIGNATURE-----

--IVvWDvxZnxJiyVq1--
