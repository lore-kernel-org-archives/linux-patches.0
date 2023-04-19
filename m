Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8356817D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:12:26 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-51b603bb360so1080880a12.2
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877546; x=1684469546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjRrX7Cr207/2AFkqWjyBdlIptaOSff/aWSeLnlvosE=;
        b=pSX3tpKO8FmwmX09VpJnXV+I00I7NnIGVPms0waR3IO2mRKG6OqORHQzzJNP3qi+WQ
         LyPyZ5TCXOWHMAq0D32Z6IHXaf3i8FpKlM50i7OD/G5E3nROeAiqtcDGihb0R02DgPa5
         oco7cew2fv4erDMMRCYyCha+/oYZbDnZQK9TJJCUsuEyNUi6/LiJJ8kNLdHwJD72JTOl
         Tv5A3flvsjmBg+MvO16MMFN/o2FhuQlh+5FwR+Tluyg4p4pRarFQ5V4L8oY0bd2lk3Tv
         QfrubJsxhPZnB5r/SQIAgP2DNsEv4s6uvHffR5Q8UbSSv50tHFLdKmbOxtE+jbnGaozi
         ytIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877546; x=1684469546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjRrX7Cr207/2AFkqWjyBdlIptaOSff/aWSeLnlvosE=;
        b=EQPaGCBrQazP3LbjD0N1NMqIXxHT0rI23p0EMGwRUNv9BoW5k+o9Ez6jdDmIe+KJLL
         IZSlrNwK5eVT3Z6uEJwUPyATJji8uQmKyFu1zc6aaMYhV254vq2v18IpRB8uPuStK4KH
         JXaajieny9hS0w7U+ITVs1xn1kIk4fbX8/eIgx9IMazkY46pbqL2R2354pPSTsqGnmyV
         Tf5dTJqPz8AkINNg9JV9+ZLLMo3HjK7STyXY/zIpmSYrY7Ikwuf8wSCnHa3BqlhByZNV
         bxzOpLmMUspfZ9qJGbbxDnoqo/EJxF4kIsI/2A+2XvZ+L+/68RxNEuLEmxB2B/gnMEO7
         MrIw==
X-Gm-Message-State: AAQBX9cug0LsgmouVl2mqtPYtYR6/mb8X8XcWwo0fxRso8jasoWF1Q0G
	ucBxb4Bqwkrq6/qnSGmmID4=
X-Google-Smtp-Source: AKy350btQkPuS3Ev/1/TgR6EB9ck80efR3JIIEw8EW+AVP/qR5ng3lMivCW6MxQizDseiv5r1Vf7IQ==
X-Received: by 2002:a17:90a:5415:b0:237:ae7c:15be with SMTP id z21-20020a17090a541500b00237ae7c15bemr1589931pjh.30.1681877545723;
        Tue, 18 Apr 2023 21:12:25 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id i4-20020a1709026ac400b001a1b66af22fsm10337208plt.62.2023.04.18.21.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:12:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 76DCA10673E; Wed, 19 Apr 2023 11:12:21 +0700 (WIB)
Date: Wed, 19 Apr 2023 11:12:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
Message-ID: <ZD9qJA4yjfZm40uJ@debian.me>
References: <20230418120313.001025904@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/O/UuFJ8aKeLPfEe"
Content-Disposition: inline
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>


--/O/UuFJ8aKeLPfEe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:20:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/O/UuFJ8aKeLPfEe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9qDQAKCRD2uYlJVVFO
o/nMAQDqu5td2joHEE6hPbbI0+QsBxXHW2LNzFaogzTJEb5uswEAsmj4JGK4Cyw0
cLnLHas2wPN6IbVDbOoIKvLk/u+KCgQ=
=EGr/
-----END PGP SIGNATURE-----

--/O/UuFJ8aKeLPfEe--
