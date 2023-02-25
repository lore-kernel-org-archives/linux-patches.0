Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7877ED312
	for <patches@lists.linux.dev>; Sat, 25 Feb 2023 04:24:18 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id u14so1512085ple.7
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 20:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OJU2kROOoIPQ44ETVMfvc0e0M4O9ezpagsF+vPoQNDI=;
        b=ma85Dt+rXI7pIxydy+VtgeCbDlC2aO/yjCkqvNKE/GYrlqRmMJ3bLCMEd8ZtoM8qQe
         3XMEXkM4VjVEfm/b1D/Aetb9b9v+kheXIF0QPc9kvt70WVLjAnnf9J/KzSU/Vu31EJMN
         7dkuJ3mwlgnFFGSTskR1jouqI8GidDmcSdAeBe8DjcFMl9rQutebi8QcKrkJeVgjzE5w
         WqJyQAkrwdYVETL4lg2Ps6rbCOgiuVoJqaZ47RaEzh4UGtOzjizz6Dfi+XU73w5ZYOgS
         sF/MaM+MHDg8L1QqbL5UgScFnOvj8UXFUgqOMo+nXKyNJM1SEuHTnp0hAveOMddwBKUK
         TdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJU2kROOoIPQ44ETVMfvc0e0M4O9ezpagsF+vPoQNDI=;
        b=IMC6FjRSALJyM8z2ZhEeX4d76H03c/kLrmdb8X0TbTJcISaQXc4p23pHJmVRXiCnzu
         T95ru6H8TsBQEUYxnimwtvaTg+au1kzSy8cJLlxcsOgJCHKD6AjsYoif0NcpHnNH49li
         fF4l70L3pKqAFIJOo5e4E8NHx9GDl1iWVM3YTb+1ImSmGVT+QmBWJx47+0aydp5R7AA9
         YAARGmCsEn+johjKwJ3qEDxcNdJNyaAbZWPvNdNIoy6osTudLWIOATjbXUZiHLOIiooV
         C0tQCckUtZoOaFDATWkraI8uaUM7ymVyZjecL9aylO/eAmKmdoSdN3mGsOd/P4QCQtqP
         BEJQ==
X-Gm-Message-State: AO0yUKUhUnTKeaP/RSGBkgy8DFfzwiGT8SufKTjs+/yjIgjdE6uf/R/1
	9Zo6Sb1dTn7CduR/m6GPREQ=
X-Google-Smtp-Source: AK7set+PGV7PC4AM/gQz3u6x7AMiNlRF7EwfICAcrECVvng1a2dxWWSpLsfGfJLj2Tg1U4P9CLBldQ==
X-Received: by 2002:a17:90b:1e02:b0:233:af77:c075 with SMTP id pg2-20020a17090b1e0200b00233af77c075mr18914834pjb.36.1677299057783;
        Fri, 24 Feb 2023 20:24:17 -0800 (PST)
Received: from debian.me (subs02-180-214-232-79.three.co.id. [180.214.232.79])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090a67ca00b00230b572e90csm374038pjm.35.2023.02.24.20.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 20:24:16 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id CE633106473; Sat, 25 Feb 2023 11:24:12 +0700 (WIB)
Date: Sat, 25 Feb 2023 11:24:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
Message-ID: <Y/mNbLJnHULALOUm@debian.me>
References: <20230224102235.663354088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2eysLsWwR/qUe1TR"
Content-Disposition: inline
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>


--2eysLsWwR/qUe1TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--2eysLsWwR/qUe1TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/mNYgAKCRD2uYlJVVFO
o0O+AP0Z/B7hlIXv+rzD0Lv0JaqmOMR4pSN5wjBLP8A6zeVH4QEAj+Qv4n1MYMYa
aM9vJ2oeaGjSVhQYFoSuyNwmR7ruRgo=
=DYgO
-----END PGP SIGNATURE-----

--2eysLsWwR/qUe1TR--
