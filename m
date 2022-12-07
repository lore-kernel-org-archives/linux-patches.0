Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7B11367
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 08:17:09 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id q15so15830274pja.0
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 00:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAPTC0pcx5Cs1ZVVn9tDcLNvXAwFQP3Hg05dJynKWJs=;
        b=gIvaZ6nFPNi7TfAepCn0JAN6xTgHcfMiDvtRCFrDV3/HqwnZq+cKfPkp38pTpnCNbl
         CviQva2t9xtWaS+WufWTeLqqK8zoGpZUNSmqBt0V0qo8qUEjILHklqsK5PI1BoAPvqiP
         weSn1CRR7/RXGyn7urPcmOAOPxH6HH1gbUARaLhE4k3FcNdgLozoSw+pBBDDUltfvbrH
         q6BO1QuLK3Xx9ECtyQkckm8nEqU9xblkyntS6YoaF9P6aWczf/kkKvonknlzqoIVjMj6
         rhzXbnTw7BBmMcoirGdFvKrplMOiAlDWZXx1jW6UexgS+XzBRw9Hh6aYTaRd96pBb+zE
         QJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAPTC0pcx5Cs1ZVVn9tDcLNvXAwFQP3Hg05dJynKWJs=;
        b=ApPkZeILs4VgcXWQCGPxUEuk+x4yTpFl82XFjF7Tbj0kmfLQZ0XyBZflBr4TYtrr1/
         WDjsd4ip2pPAajaGMU9RagvqFQPsigGIluVyH7DLz5WL3ZfyP2A/PznjIlT+ljD23mIg
         2zV4D6xFlkU0VNzUAG3CB9ZrSikwOm0c+xHx9P4sI+e7XpdvclNHTeYXi9XCdFXSl0if
         u6iobmvDqxoIIwzuU4jjcjolS/oDNyaQy/kfEuZHFUPHVFV2vXwZNIk1A/VVkVv0HfkF
         fQ3XxXFrQfJeVwKJGGGnW6c9p4Wz8jNbJ+A665pFNZurRVF5BVUcQUTsHlJD5YK/smcw
         VW4A==
X-Gm-Message-State: ANoB5plJT8pP/YkQFRpA1Y0aiolWoFWdoB/zdCr49tDKAlWgPYBDepff
	RRWir+IOFAQKNW3KUmmnPDw=
X-Google-Smtp-Source: AA0mqf5rOfqXwvBQRguYfOqixMUKc6QDzMvqHm4p+EhLYjXsp7KoXsKgqobco1YZBFvXlnOxo/Syaw==
X-Received: by 2002:a17:90b:3608:b0:219:6b1b:63d8 with SMTP id ml8-20020a17090b360800b002196b1b63d8mr34265621pjb.143.1670401029266;
        Wed, 07 Dec 2022 00:17:09 -0800 (PST)
Received: from debian.me (subs02-180-214-232-19.three.co.id. [180.214.232.19])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b00177f4ef7970sm14052212plg.11.2022.12.07.00.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 00:17:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id E6A9910444C; Wed,  7 Dec 2022 15:17:04 +0700 (WIB)
Date: Wed, 7 Dec 2022 15:17:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <Y5BL//a2Ftbri276@debian.me>
References: <20221206163445.868107856@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MdC5LBBVftpr3B+p"
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>


--MdC5LBBVftpr3B+p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--MdC5LBBVftpr3B+p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5BL+gAKCRD2uYlJVVFO
ox0oAP9o/4S6HMhOrCEn3fMZ5rdxcKvEi4X1OtmR3nqXGUIebgEA5EqF2xQn1cXQ
64yoHlJTUuLp/6zeCxjkHz2RutJHAwM=
=gp2s
-----END PGP SIGNATURE-----

--MdC5LBBVftpr3B+p--
