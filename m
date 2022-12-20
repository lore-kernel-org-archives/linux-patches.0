Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750851112
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 04:45:27 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d15so11114099pls.6
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 20:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOeTTXb5u9hnasLHrrUspCoXmjGY8ZJBIUXqDr3S45Y=;
        b=g/cp0aBoXYspAuaHZNL+dWHI0ch9F5RYPvkLQAxzjaHsj7uyrIyu8gOXRJX1Mp4MUT
         s4zKRXT4Oi3VoTepOW+m4mlc+RQcAOZYIjsv63oIlnPLaxV/E+eRIedesfC6IuqQrHx6
         kpeYLzm7pLB7DegV/yVFDYnGc4DYGrjo/TxXlwZNtUWMmtfJUNVJKqhNlUy/O9WU3S1g
         Be8BWwb77KxLWhETyE4z/qhM4+v6j2iZGSgyV5gmhp0GAjSRQg3EffYvbs0Vl7aY4XmA
         7hdMLFu1mWziCR8yIX62ngOk+jCPp4H9nt/Eeym+96AACjVNRH3tEPhadgEZME7Xw3Da
         De4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOeTTXb5u9hnasLHrrUspCoXmjGY8ZJBIUXqDr3S45Y=;
        b=IXGoZXlfK8FAHSia1u5LKE1HzUg/lTjJ/BSC9E/t8uRLUDZ6kZYObvaeRW0AfsFS6O
         5jEDqjxGiklrpgIRoMLY78WPQoBnbqWiiFL3e+n3AyEuXY8L0c7HBJSyRgnT9QGEyStz
         3nZ5bOrWaLrFexNpID5jwy1Sx4Kl0vfig0mY5JOoat2KlC8sTYUK5wrv+p1YtQyTYUOd
         t3xyPABpR5qHQgw8JWhsKqbv44atXznKQXKWA6ctTPDrY6N3b5ceaNX2v7gnKoIVv2mm
         GUcsA7De0pfyJDKGW+0stWz9Oqx3OTAZ9f407gu3mP3y6JrABByuMXPe/CkHApmjj/CP
         9X6Q==
X-Gm-Message-State: ANoB5pn+EgSZUHpeqWmds6VrBD9hc9Fi/XkXmupwj1ZP22UTzxM6HpoV
	wKZUwvfS70+yatVCSB7zUxI=
X-Google-Smtp-Source: AA0mqf5DijY95PNQc1ctcVyWjlHZmLaJnUxCvBkO72zafsU1LpxqIyWvV0/JN5zt9vLPFPqun4L8uQ==
X-Received: by 2002:a17:902:ca14:b0:189:bbd3:a5a7 with SMTP id w20-20020a170902ca1400b00189bbd3a5a7mr37757934pld.51.1671511526918;
        Mon, 19 Dec 2022 20:45:26 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0017f756563bcsm8125599plx.47.2022.12.19.20.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:45:26 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id F2E70103E99; Tue, 20 Dec 2022 11:45:23 +0700 (WIB)
Date: Tue, 20 Dec 2022 11:45:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6E9405o6FuJaIzc@debian.me>
References: <20221219182943.395169070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kkANSztESN5M85yf"
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>


--kkANSztESN5M85yf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kkANSztESN5M85yf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6E94wAKCRD2uYlJVVFO
o5WkAQD6ytjGIzQaUDvMZxCmrEbW6UpI/8g3WPkfIL6YrklMHgD+K67qbgqQTXiV
Az6d3qdjZRX3805CUQ2LuHt4o9/ZSwg=
=SRV4
-----END PGP SIGNATURE-----

--kkANSztESN5M85yf--
