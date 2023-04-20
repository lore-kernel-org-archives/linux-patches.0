Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37120F4
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 04:12:39 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-63b51fd2972so508421b3a.3
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 21:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681963959; x=1684555959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCOQnQggN0JOswFzdNPgIIbMyyc4QibhYHQ91Y21has=;
        b=Lp7y+Skr6D3DxztdWnM/dDFZYun5ivSMHFcfpeWAZht3ov15BMhC4H4fwJcLmeBXxD
         peeMpYeMLs+3u9PqZV5o3QhNt1jvKr2rJLWq7igUf8bu6uC8UAhagj5CluiPtQprcS84
         znAKEw5JnXQ1FLSQGRdHtk2QMc/3vMWC66OPUJFlCFcHwCXnd62UOA8c1WC9GH9N8cFR
         Sej1wIGUQyQg8zNoYwq6FaiZTI6Kjnc7209aaptcSqk4qlYPJhboGj2KhDA99gMwZUWT
         SLtQ9W8tIxvcPWYRKwJSXz0un4Xc0+DtnaUTsF+Kg2wXDfiwsc5W1N4gg0+DFhJJzLlw
         aYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681963959; x=1684555959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCOQnQggN0JOswFzdNPgIIbMyyc4QibhYHQ91Y21has=;
        b=R4JIB/dVIsRXQa74oRNS358Lt9oiZ/W2G/pcN1z31fKtgPkAPdR6GjMaQmjuut5wEJ
         wNvPvirIie7uUBlVKyA/ds4jZ3eHKAi3gvbKXzajWXDINypPSeHEeiG+5t21fh/9kbbG
         eoxIjxPN8Iu0s3vy/GNSBEpQZmdVgxRSL3jl2pIFhXlfpbXDEuODPDXKo8o+ojtEp0pl
         2cWH3o5UYOTsEWuCn1qhQFkfUYtvx1xIVc3XlNDKZ3OTiVAnNWYnWHmMn73lZVQwZPQk
         4EoWW/v5+VFheC/6qQax1bBliz5y53YpE+NQyTthDbordd9eI2NXWralj29v4y7knMB5
         PF3Q==
X-Gm-Message-State: AAQBX9dUUixbHr9H+hZSdMMAqjLI9kshgpo1IPw8BHEObzw0fPKv4lUi
	Y0tOtbvwoy8YqFFr1OO59Ec=
X-Google-Smtp-Source: AKy350aPwhS7nuGapUUqTFmjGK1V7DZIhYWqCr6e+hPvjCq9TyEzamNgOaCSMkcsxgtbHedE2p4itw==
X-Received: by 2002:a05:6a00:1409:b0:626:2ce1:263c with SMTP id l9-20020a056a00140900b006262ce1263cmr6849744pfu.5.1681963959349;
        Wed, 19 Apr 2023 21:12:39 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id w35-20020a631623000000b0051f15c575fesm166684pgl.87.2023.04.19.21.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 21:12:38 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 849A310685E; Thu, 20 Apr 2023 11:12:35 +0700 (WIB)
Date: Thu, 20 Apr 2023 11:12:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Message-ID: <ZEC7s9nStY5nwAKr@debian.me>
References: <20230419132034.475843587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RmCqRgRkBpcHdJPQ"
Content-Disposition: inline
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>


--RmCqRgRkBpcHdJPQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--RmCqRgRkBpcHdJPQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEC7rgAKCRD2uYlJVVFO
o2zQAQCSz+DUgH0E/Wtcs9PCN9esaY0dxEghl/v1Q+mVbXriBAD/e1Wc3H1iKMO6
oaFh6wYRSpEyjzZX/wpnOcOK3D7JIAk=
=NG0U
-----END PGP SIGNATURE-----

--RmCqRgRkBpcHdJPQ--
