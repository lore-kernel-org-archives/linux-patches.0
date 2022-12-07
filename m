Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA416374
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 04:02:52 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso330438pjh.1
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 20:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gIIVDiA6O3R8AWSLOqlskI8v6XgtpOiioOau4DQUd/4=;
        b=i2GYnfuB+2+O1kLixvLlcum8K8NFE3r9kxr23sxCkdsnkR9V2HbbIZs1zvCEVKDSik
         gSn5jPdkXsO/eyNER8+FsWy5vNoYdfe4iO5AB7MqcWcsY2aZBKiKSG57Ryb/bKt64U84
         XplaqU4am4YNyOj/PtqGfs+LX6AhqYi6ph5q+Gy8Df824W4xPO8gJNjfXZ4n0r/KUfDK
         0t2vNa04Sz/+lKN/V8m6hJprK+iiIcbP35n45+eKSkzWd68qhM5Se1XOGpHJSg5v5Rb5
         lg+NilPBWImI47df0bZtf62v36/8H+JdCEQywEZ3H+6kQULdjzUDfZeecrDJIeCNmnBI
         Di6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIIVDiA6O3R8AWSLOqlskI8v6XgtpOiioOau4DQUd/4=;
        b=pUxTk8yiM2P8U6tLE8Q0hNdCTjrAJIRIV5UUx/UlUEdRF4IM44wsgl0Po9i4phYDM2
         dkEuLrRDZVvSICDmu2beMdEMHyBBx0pUSv49z7ldlylcvWEvtN6TfrTF6M5rwYyQrP97
         RpKbwpn68WP+Jgd6+RxUeESGAckaEYFJKU82a8uQSrCd/7lMjxlijuWLDVaakNhesW6m
         Lwd5rL8KaWXc8I/tATV7a9VTscVk2XZAuUv/ufcRrNfr0isEFAxn54VJIuoNtQRSRFLG
         XcLimiZMNJ0oUOt5iiQMz/upirP92jnOxM9d7LnPexJvmmdAdd1kpJeJ48fez21QyfD4
         jspA==
X-Gm-Message-State: ANoB5pn52hEaEHXUR4WjXG1wi1BWPWPg/EuLEeSS7byfYWxoBvWKHlrT
	heRIHlOYjls9c+BoQMQILig=
X-Google-Smtp-Source: AA0mqf4hCWSTp51T31E50oShmQ6K6IRU9l+gOM/nt5Crvt70lzo4yZT5hwf4YKd3BpyVWVqjan/Dlg==
X-Received: by 2002:a17:90a:6c46:b0:21a:401:d2c0 with SMTP id x64-20020a17090a6c4600b0021a0401d2c0mr4968212pjj.34.1670385772133;
        Tue, 06 Dec 2022 20:02:52 -0800 (PST)
Received: from debian.me (subs09a-223-255-225-78.three.co.id. [223.255.225.78])
        by smtp.gmail.com with ESMTPSA id c10-20020a056a00008a00b0057255b82bd1sm12365502pfj.217.2022.12.06.20.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 20:02:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 08D1B1043D3; Wed,  7 Dec 2022 11:02:46 +0700 (WIB)
Date: Wed, 7 Dec 2022 11:02:46 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <Y5AQZqNP9WI+LKV0@debian.me>
References: <20221206163439.841627689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="baYlNvgVIsIVFk5h"
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>


--baYlNvgVIsIVFk5h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--baYlNvgVIsIVFk5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5AQYAAKCRD2uYlJVVFO
ozOIAP91FP4DCdI2z2mZOt5hqJqBBLpORz4uwkJTDoUI+YBu1wEAuQlRrhzGS8sM
qE+z4iXWNMc3jK4p2ipEaRwaREc5Lww=
=fZ66
-----END PGP SIGNATURE-----

--baYlNvgVIsIVFk5h--
