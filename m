Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625737B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:13:55 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id p20so7662450plw.13
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 20:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678508035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4wrNUARGjvj/HU6mgRGoiN0wUdfzuQZe9FSkh3ZviA=;
        b=pSdTEWFHXcWVIZUh4KoPl7zWCe7fQ8upiLOy4UVnFPpqvonfGP0801WnCu4N+NVIjz
         Ru+Nyh9DM4VWyz8RXUJ+xU3SVfSEUDQ1QBnhbIoZ7pn45vA9gbZEDc6a8q5YTm1eKZe6
         Xz0GHejRsTcMIanVrxwKy9xdc9Vnja7TW7+fNfZlBScU1Ol1dCesiO+Lp4znbwOq+EQT
         0CJDmACacANWeCKXHwbfsLluQgLpEf9AQmn1LFpfNjJAcuUgCHHKTeVXVXFdPQ4Zfz3+
         IkWS9nrk0J1OuZM+HcJpyrdBd/5ynQmCId2+ksKxRevYWitmPJgL5adgFgJHigV+JOqX
         vUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678508035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4wrNUARGjvj/HU6mgRGoiN0wUdfzuQZe9FSkh3ZviA=;
        b=VqaXpNRrdF5QmdEd2RAjZ/8iSwYpSI4FvLrGfkWA6qtcuhYDF8nQjfmGCwdYqucmue
         qF7BcVaSb4dqcytUeS6fMDnOBoG3RhbgnQZUV58ZDs374zHUep1fOhwO2sdma8BcyQ2s
         2XMTDrCNTO7HP8GOOHavyL5KgasJVPiYos8xfwvxs9efQ3q5gRtKJcH44Z0zwDDv6nrT
         EOrgo9B12fXrqIj0kPxn3rIU/4b5aCDrM2Y4HWRFWmvfBlSCyfS2Wysd1ZZI8zDSUj2X
         +biwHyJ5rzjyvWVQcRatxi2DFJ699fgNciav8fzsMLCZDpUhv/yUieFkPRBvLfsJgWMB
         pohw==
X-Gm-Message-State: AO0yUKVyDI9z3ZyD1czeUdeEXcwoVkSYMaGdO5GbHGznCwwcQyshQEcA
	BPacjQmsTvXY/x/+J1PvGEA=
X-Google-Smtp-Source: AK7set/VndVMN8a2gidiWncHpSkIdCVoB5h64xS7mFcKibXLjzQwUaQwYhzCkeeFHLbUvyD0fRql0g==
X-Received: by 2002:a17:902:d4c3:b0:19c:c184:d211 with SMTP id o3-20020a170902d4c300b0019cc184d211mr33492300plg.37.1678508034805;
        Fri, 10 Mar 2023 20:13:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id kt7-20020a170903088700b00186a2274382sm717312plb.76.2023.03.10.20.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 20:13:54 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id DE76D106674; Sat, 11 Mar 2023 11:13:51 +0700 (WIB)
Date: Sat, 11 Mar 2023 11:13:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <ZAv///zz+tUCIgdv@debian.me>
References: <20230310133717.050159289@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KeVNMFZt8x5fBdGy"
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>


--KeVNMFZt8x5fBdGy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--KeVNMFZt8x5fBdGy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAv//wAKCRD2uYlJVVFO
o7hCAP93Vv0oXBK0Or1ACOgmPTyWxOxKJL8GcHI1tumxoPHR1wD/YioOdLpf2dd8
OUi/j16zWRTrjWNCN2H1cKbjK+L+0AA=
=d7DB
-----END PGP SIGNATURE-----

--KeVNMFZt8x5fBdGy--
