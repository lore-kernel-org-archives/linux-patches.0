Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA54C7C
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 03:28:28 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id bx22so3932123pjb.3
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 19:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmdIpFXX/Pnd+rThHPSIEqn/ETUzOMU9w26EKl0vXWA=;
        b=FaQQgRbSWlX6tu/FaH7yaf8hQo2SHcLcvhh+G+lbUttH4FO+9+mHKW+PvIkqQC08P9
         IBvcZDTimIZZfqW92uIUEk0T0jPj4xi9492J2A+wfjGK9hDOwEOGijyVYhzhaT8pZNMt
         BbG84gUM5ZgSCCLw0+1MxOEqPC9epG+8mCU2c+v5UlcLQE7sxcFQc8OMB7tuM70aK4+R
         ipgDLvLqjadVTODjotX6B7QaK0gsu8eB62jn+0XEOZb5/oXfOI8gN7QBHgzag7Zw6yyu
         rnd0AKr8pHK75QBBYfOnFtg0xylFylPmU9Ku07zqGPsHb9v9HJ8bGW3MWhJitNvWGCrp
         iQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmdIpFXX/Pnd+rThHPSIEqn/ETUzOMU9w26EKl0vXWA=;
        b=O1qpxHG/5lpZ69E+PiCt4d0gp9aBKMWIfdJri7CTK1ZTt+9BZ8PXzURknDNolzIW3q
         OXYMoFxCowNGNd91x00kMeMimo7hcWDivfwIb3Mj0tDDzLgiXCBMaipOlCPVs6FRS9Aa
         ddXxjWa7CzrWG0P3sEUZgHXJIEB0JeWJEj+RCRqaxasfo++BMf9/idea8QTw8yS0w4D5
         tJxizG3SSzE4U9rdu+crp2i896iLNNdt0fx3BXvMptTzN2B7b7CrRsPyQRHQGimZg2uC
         kbCc4lmUIP8hr7DGT0sdbY7WE+t+ukpGAOGFL/jqaTdO8If4y4Yfos+twU8HRhMsSKf/
         rFDQ==
X-Gm-Message-State: AO0yUKVEuq6rl8TZ7hHZHh02NDjg99UhjmTXl6WG/iAl+nbxmeO+Z9rG
	4mIw63A/4u6s4xkVryh9+fo=
X-Google-Smtp-Source: AK7set+U1kE9VIbXjv60qobe9B9PSImxBIcUvcu0G5TQsQPkLsxmHIFlCLxBJagQRby/ps5Dl2OcCw==
X-Received: by 2002:a17:902:e0d5:b0:196:3feb:1f1e with SMTP id e21-20020a170902e0d500b001963feb1f1emr9398591pla.47.1675481308285;
        Fri, 03 Feb 2023 19:28:28 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id t7-20020aa79387000000b0058d9623e7f1sm2576612pfe.73.2023.02.03.19.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 19:28:27 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 54C361052EA; Sat,  4 Feb 2023 10:28:23 +0700 (WIB)
Date: Sat, 4 Feb 2023 10:28:22 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <Y93Q1iUQbFluIJPZ@debian.me>
References: <20230203101009.946745030@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eKrxPjNJTcq3O9+b"
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>


--eKrxPjNJTcq3O9+b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--eKrxPjNJTcq3O9+b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY93QzQAKCRD2uYlJVVFO
oztAAQCdjQyW8RqqYKwJH6cAjdNb40AxsP35XFAy3/AaWulmeAD+OAwoLS5PJwwv
WeHJEmjhaC0KoMnLb/W9Uk6AX1mSgAg=
=0bAs
-----END PGP SIGNATURE-----

--eKrxPjNJTcq3O9+b--
