Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E781C138D
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 09:51:16 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso5577390pjt.0
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 01:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=60NkYdzUVc4ugspOkWoX2E7c3V0ybSgQKa2fBToU1oE=;
        b=F4Rw3yoDtedDA7R/PDEBjuW+OFvfbFC+aYXItqyhvrQarZzoqGEBjvdkuIkxsYQwyL
         xTCZuRkXZ/irlV4q6l3bnjw/j7YbktKB0QiHi4tlFd8ySUE2WjAhc9X2cDg3IQeJB/E0
         p7Y9M22h1j1hWDY4lrNLN5GWpqt1lvRwW2UzJ71u8SQRPzUSt4eKdsL0/ijCXw+w6vYx
         5LaH5m4lVtEEkSN7rSabAGFWv3IfgqXn7gu9bNtM6DEODEfWKydOELKkwLG9SIQuFYta
         +yGMfzobeg+OEl5pIDw6Eu89XUshEq7wFk4ignhJNyBKpow8PPho25mjWl6YJlsfAHIF
         R6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60NkYdzUVc4ugspOkWoX2E7c3V0ybSgQKa2fBToU1oE=;
        b=4B7+J6pXmP63F7jLIoIXJugKAmCUTeFCYBqER0UiRxmFVqJvxdrnCR9yukk7k3N3cJ
         1dNLeHYAelO1W8ZmP3NwLyQDL7zDq2D24hWRHF829k1t6iY4d17gR46eFoTUnPWuPm21
         FLi/brDKf8VRG4bWgKB0Z3wFxHWl6RTb9rnioufQrxQ02s7k4UDXMRzdI0nF01gDNRhy
         QvHBzxgDjbUi0SVn2znZYDmp1rZp14EypYFS8sZ2gRcv8pj597qul+0BiCRrwfDWgvUj
         Q0s0Rcc9qa+p3/8nuEYKFCDA0NAUa8wcWtcrdMFqcDYpJ4zmPeefGYp8o/7+VS8GbiGd
         7KnA==
X-Gm-Message-State: ANoB5pnHQy6YOgEc1NolONcy3RuvpJE7Wx6vnQkg0lgESxrlvUphx1jz
	h9jxInafqvUt5BnOp/Z62mg=
X-Google-Smtp-Source: AA0mqf6VTExRhdd9tKtj2GLDRYat99+cuGg2pjSGDbfeIaDj747S9GwjKK7uAUpdVLxeNgiVP3XJRA==
X-Received: by 2002:a17:90b:2d83:b0:219:e002:1ba3 with SMTP id sj3-20020a17090b2d8300b00219e0021ba3mr33608411pjb.9.1671184276334;
        Fri, 16 Dec 2022 01:51:16 -0800 (PST)
Received: from debian.me (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090add4300b002135a57029dsm991511pjv.29.2022.12.16.01.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:51:15 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 24AAE103E00; Fri, 16 Dec 2022 16:51:11 +0700 (WIB)
Date: Fri, 16 Dec 2022 16:51:11 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <Y5w/j0Q3DLzLAJXo@debian.me>
References: <20221215172908.162858817@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Gb3aCbW83YrRToag"
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>


--Gb3aCbW83YrRToag
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Gb3aCbW83YrRToag
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5w/iwAKCRD2uYlJVVFO
oy2aAP9tOXaBQdY6BRm0L1BWTo/pUAm8/VU1uCoBqixus/gmmwEAgQkYrtjKkp91
toeRdUS01sQRiJy/lNmUDzCFYA/puwc=
=28q1
-----END PGP SIGNATURE-----

--Gb3aCbW83YrRToag--
