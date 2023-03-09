Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4D628
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 02:05:37 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id y11so516745plg.1
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 18:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678327537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JSZXkOzWUjU6JkgJilE0EIcfpIeJHdOfJ4nnNvrZU68=;
        b=XJPjoCLTEcQrAL+uS+zWq6HfsAci4uyg+eY8/vBMIG+3sbi+IR6C2eBojMmBIBIV2z
         QlkjM14BmsGqGKS9Zl0AkiNWi+IqCcE+igss0acaKUVQls3IXDNR6pmGAgTu9PSFAzvk
         xFFuKR9a7bMEIn+oiBWo5rJp6Qk6oKWwUWRBaoV1UhXOjwZ2g2PYnuZGlH0UXx+bVlYD
         NSRlUy4OmjpuwVh4Y8mYheShU3YmeIVCmDxJdLIBhbLGnnpL/6UpCweJ0Yshi3y0Mruh
         0HiHXHqINKLQFE1Ddy1uNhKWCvkM6snexuoVhycerpvrvi+KYEebJT9IdIcpNPhyGJiP
         IbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678327537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSZXkOzWUjU6JkgJilE0EIcfpIeJHdOfJ4nnNvrZU68=;
        b=hzJvQ7Zun8eI57pRlJtWJUQAIXDYAzgZTMDb/i1w1gYblG6uzxyCEIsItmV4Jp91Qi
         Uxu98u0ofttNTdd/sqWY5ozGnDyawRMMozld6eRw39ZiY3WlSfyoXCnI1K2gL3h1I9GQ
         HoeQgxH24/KWji4UmAqa+aZq7kx3PUIvYfV/3TFDTkbACh1Ebe7fqvKLuGAAFJhgqXHx
         oxvBMUXy87DVj4f7ufuMeDN3GePPFK9/tDCzuD/GYGJI9q8Qtbk2V/aYUe0VuCoctAki
         7GUStYdaPmeYP9RST8s9jrsC6y3zmsrzoMREHoQxJoSgVTet87Dc2usKGxiYcyXqu4IO
         uY6Q==
X-Gm-Message-State: AO0yUKXOQvQf19RnhkpZ/G693UHvuB0YUmCNHqkkh3jNW+Gs8jY/oacp
	WBxpz+kx6johrNCjA/XufcU=
X-Google-Smtp-Source: AK7set9KMrycEaQIMCOptQv4UT7+AbalKdsIeTLKSqkyR3TqZxUx1Nbt0u02LxXIQ9uuCkmBCUeTHw==
X-Received: by 2002:a17:902:ea10:b0:19e:f86c:255a with SMTP id s16-20020a170902ea1000b0019ef86c255amr4673190plg.7.1678327536757;
        Wed, 08 Mar 2023 18:05:36 -0800 (PST)
Received: from debian.me (subs02-180-214-232-87.three.co.id. [180.214.232.87])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902d20300b0019adbef6a63sm10402008ply.235.2023.03.08.18.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 18:05:36 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 061A61065B8; Thu,  9 Mar 2023 09:05:31 +0700 (WIB)
Date: Thu, 9 Mar 2023 09:05:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Message-ID: <ZAk+6wv5eexfOK2y@debian.me>
References: <20230308091759.112425121@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AK/Nxp/4nin2VaLk"
Content-Disposition: inline
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>


--AK/Nxp/4nin2VaLk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--AK/Nxp/4nin2VaLk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAk+5QAKCRD2uYlJVVFO
o/RGAP9plKGEYwy7w+0FDYLJsdZE7lqs3D/R7+/iF52p7Bu9+AEA1rwLzsstnJMd
fwj0jI9QzV9R3VtD9DdVSNIHuFAfRA0=
=rmHJ
-----END PGP SIGNATURE-----

--AK/Nxp/4nin2VaLk--
