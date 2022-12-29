Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74860256F
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 12:46:21 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso18557031pjb.1
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 04:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+mEh9KjQ/GdcuKLXp+v2G022zDuswizkrwudMFHtK0=;
        b=pomTjC0YvfLxexijq5CJwg2QSh9tfGBfybUi1RCNvc0mrOuYI2ND1w+/6sPOSrlUuq
         eeCwP2Sn2X4yC/TxfJaxcSyoMyM9UQETKdQJEdVec8hpcabdngFKae2oESGdNNOgI5as
         loE8TI2F9IVCLo9NFohOCz1bQGEujBofVZBAC8J5CunzmBA1sOyOJ13V365HDnqFXPWu
         sEqB2gDuWOseVgmImjgCvjvBLFY8kv1XindD8VG15hKbd6stGrEHdEQvqqksiz6YQAL5
         c6SZlO7Ini2L0b1le9sXOFmdWyft0GIqEjKXjY3j0pvZnzydaHpI9rWn5y06e6ZL/C5i
         33LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+mEh9KjQ/GdcuKLXp+v2G022zDuswizkrwudMFHtK0=;
        b=PVkIY5RRx9H6Mcmek7CxF6vvnFjcTdwgKBTMESBcGBpT09bTBvEaZdY1/K5Y46aLBj
         f/lTgTh7LJA3uJcHwSjoxr4f9VpFHlKF2S8GnOBqvTze9h6j1vzpiBnBB8Dg/fqTvqo8
         OJ0EestTXuJRp/JdirSzX9uThpG1ebpIpoDux6BZQHt1YmzxTiuz/0hX9uEAMOE4QEux
         xlRgKizdZIzTfzIe0y61ZC18LiSc/YYs1HROVk2pFWrXVHUvaHuGBUz0w4HP8OmAysYp
         3aTCAzFjyQOHIPhnHRoM1/SWubsHMPyK0jTxofhTSjvuUy8toJMk3ZWivHGYJY+pjLGA
         XNbg==
X-Gm-Message-State: AFqh2kpWZXxu8XN01qId0o/ZkxTlpRm48DWrSnXiZMZcDzfCjoJWEewL
	zZpEcuzqw6KW9kEJBRrZvHc8lVy3w00=
X-Google-Smtp-Source: AMrXdXv888hB/bsG4VHkbFoEIBWCykz1M6bY3r9edWdOcbuAyoKm0Z0IseJepcdSb/FgznOQrVFqiA==
X-Received: by 2002:a17:903:40cd:b0:180:f32c:7501 with SMTP id t13-20020a17090340cd00b00180f32c7501mr33157024pld.0.1672317980849;
        Thu, 29 Dec 2022 04:46:20 -0800 (PST)
Received: from debian.me (subs28-116-206-12-43.three.co.id. [116.206.12.43])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b00189a50d2a38sm10016316pla.38.2022.12.29.04.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:46:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 3E5031046FB; Thu, 29 Dec 2022 19:46:18 +0700 (WIB)
Date: Thu, 29 Dec 2022 19:46:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y62MGrp7N0jrdWSS@debian.me>
References: <20221228144330.180012208@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C2zNzXWLX2WW2EYn"
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>


--C2zNzXWLX2WW2EYn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--C2zNzXWLX2WW2EYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY62MGgAKCRD2uYlJVVFO
o2rJAP9DD4wmJTSRCUEZ98vogIc/vL+3Lxvkwy+2YCA5hOrNwgD/Yief6eXrfEUy
6YT2w+O8gj2rq7GdY4SIuX6v+TZ51AQ=
=eYBH
-----END PGP SIGNATURE-----

--C2zNzXWLX2WW2EYn--
