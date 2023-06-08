Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5BCBA4A
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 11:29:37 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-256712d65ceso241130a91.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 04:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686223777; x=1688815777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CdZkN37ZILcUA0SzaoHvQXMR2eu2xrCGId0Fwo9xSEM=;
        b=mmeQy0RxY3/m9n1Tc/6VyHFiFtTESs1UzwRqgXK7qiT3exDguzfoKKIexdCPiK0rqC
         9QsZ0DBFkJ3R8actzla4TmiF/nJI9x5YzWwBMqOq+2HogXS9Rrg3S3a+Crp1/kfC6Gms
         9rzFvxa+ZCQrfPDU1SgjlvIaNFTS1TuDw+KhiCseC43oMAEGMDLRKvssihIl5hkDdxwY
         fhsX9LckTuvWmnfXAH7JTCwqBkE2rUmCRohxl/NMD1AZvvdMNgB/UYvQS/5pgqtJeOwA
         YR6m2OfSY3Dw9UgLFgI3GFfFgtVSN1W1ija+cNjJObff0tM3ncirGZhZZintVbsjfN5k
         rU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686223777; x=1688815777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdZkN37ZILcUA0SzaoHvQXMR2eu2xrCGId0Fwo9xSEM=;
        b=R7/f0DYsFg5+u1A4I6382oPVbqHBG+6sJsNbEYhRv8AHRZkaKjLvTI8qiXsFYVQrnw
         vTnLBS0uACSOYAFw90Ym9ncHqs7Fuw5p2ZmTo+MIaQWPqe3rdB/6Gl67hR72vpq6GeDi
         8Wc4PZR8ieXjbRVnCwwbD9D7z36NetUGjWvPvEA1T2IHbrJdlaKlgwBYZHFZbzN1AQPb
         hvN8MP+eUsvQ0YOYmfoWle8IGH6QiwXmdpcw+0sLF1dGh2JsgolM0QNzaD02J3Q4e0Dz
         vUVqKr4OTbw7VVAApSaSV43g6bMKneU84xV+oo9E1IzIRRDfcSUfptVonFbkQyTc7WN0
         X4pg==
X-Gm-Message-State: AC+VfDw/uWWEfiLNvGWS245ppaXyd0xDDDsQ1xD3BFlE8Gw04KaPcpnM
	y+SC2zSZV9LsIBksqf6ptPM=
X-Google-Smtp-Source: ACHHUZ7eDxuCuVIbcSWQGxEzT4I4LHuPHji8GPVD8NARhMMZTVM5qicIZ1HtLmCdXawNWuo0J8BHXA==
X-Received: by 2002:a17:90a:6c42:b0:253:749d:205 with SMTP id x60-20020a17090a6c4200b00253749d0205mr3303630pjj.35.1686223776885;
        Thu, 08 Jun 2023 04:29:36 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-16.three.co.id. [180.214.233.16])
        by smtp.gmail.com with ESMTPSA id p11-20020a17090a284b00b0025621aa4c6bsm3056840pjf.25.2023.06.08.04.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:29:36 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A571C106A0E; Thu,  8 Jun 2023 18:29:33 +0700 (WIB)
Date: Thu, 8 Jun 2023 18:29:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/286] 6.3.7-rc1 review
Message-ID: <ZIG7nTLICXoVn_08@debian.me>
References: <20230607200922.978677727@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DXfqkyGF6d67kcHE"
Content-Disposition: inline
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>


--DXfqkyGF6d67kcHE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 10:11:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DXfqkyGF6d67kcHE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIG7nQAKCRD2uYlJVVFO
o43fAQCRl0BKECL0R96Z8JXOY9Sgh8i39Rf4//oqKfag3g38VgEA/L3FNS78m5nt
0otloeCVR4Y4yfbim8cQulyUDD1SPAI=
=yZft
-----END PGP SIGNATURE-----

--DXfqkyGF6d67kcHE--
