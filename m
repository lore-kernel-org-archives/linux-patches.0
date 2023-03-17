Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76522374
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 02:50:23 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id le6so3810156plb.12
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679021423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eqOf+CxGj15FfKuwcu74lHhmDEBF3KHOJ76Xs74tsCo=;
        b=JZvwoa5Ef9PAedLtfmTHXeMTJSaerdQAhIIO/0fM1fEVLJfU+DpZEa07vrhzguD0VS
         oxzTUa/8Pd1FAnN/4TXZlRLDidiegGz4h5qANU9ymG9MiPmjtyybYohl3G5jWp4+K4Th
         5mlr3xZJXHv+lxvrR/V+vji6H+P24Dr+SqW38X1FRgT9joDR4JzpFoM5h+9MSyFuYGBG
         hOpj5AlSsWcfG1UNKE+p9JCaHhFWkuIz2bZvvqsMXTyzkq0PI4TL+OHaifyi34M6XKbH
         3ub1Ai+wXMa0Shh8GzCvyHWw3jimj71KuyVDnQZmdQZ3Bg5ZrwKWQ7zWBYLg37H+xkDX
         6NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqOf+CxGj15FfKuwcu74lHhmDEBF3KHOJ76Xs74tsCo=;
        b=O7zHgD++e8BWJ9AYWkSiCVBjiPuBeJ7YWiF+xMipn5N/WaZxBL/rTsjK72HCfjEp6H
         cZ/S2VRID/lNGpAvRmmA+T8W3qW7M4y0zXYBwG4tMjLRAwQIPdLwTfUZ+xQpl9q+9GNb
         mK72DabE96mlde6cCxfTwU58iYt5xLeEgp1ugFD9aKd43vCchIk43pfE8haaJmLLfQsC
         I8jZfE35CVWtPbL4W9+1fnsxoAk4m7sqfH3Taf+vyWpDIh9VdwNg6XGaRAPVLsyShkcH
         P7A5blKgf5k7vYhSg4vytJv+JZIv4rqGZPHzwC8pis35Q/LxZWa/sWN/66dCOXbPZnf0
         K0lw==
X-Gm-Message-State: AO0yUKX6LrgzzLJlMvuQLhWSkWJ2dxQL/w++IYOKfIV+kicJLKzqv22S
	1/EyRQkr/+qXOY1iPVWbaYs=
X-Google-Smtp-Source: AK7set+v4mVgYo7xq5UuvP/+1h15xes5JpADeaNqzsp2Wtx8siW6JkXm09m4A5J0xbYsRG9n+d2Vtg==
X-Received: by 2002:a05:6a20:4320:b0:d0:45c0:1421 with SMTP id h32-20020a056a20432000b000d045c01421mr7271059pzk.48.1679021422972;
        Thu, 16 Mar 2023 19:50:22 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-44.three.co.id. [116.206.28.44])
        by smtp.gmail.com with ESMTPSA id x17-20020aa784d1000000b005dc70330d9bsm398175pfn.26.2023.03.16.19.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:50:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E3F24106830; Fri, 17 Mar 2023 09:50:19 +0700 (WIB)
Date: Fri, 17 Mar 2023 09:50:19 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <ZBPVa6Bjb8MycqR7@debian.me>
References: <20230316083443.411936182@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G5gDks0r2/4k1sM6"
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>


--G5gDks0r2/4k1sM6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--G5gDks0r2/4k1sM6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBPVawAKCRD2uYlJVVFO
o1JlAQDmo1xyFn0bF+wqbHTfjl5EH4NqrNB5OIqt0w9tkkjzjQD/YLXBymEElPyV
D7qJStL1c9hx06Vio0druOR2et9UxwQ=
=2EUh
-----END PGP SIGNATURE-----

--G5gDks0r2/4k1sM6--
