Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC07C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 02:40:15 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id kc4so29954237plb.10
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 19:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hsLwm1EHEyYDkMQeHbfyAFU1DHax2tvFD0Ukhfp5Sv0=;
        b=CjX4dSxmTaHcIZNVM+5KTB0uMtfMLjwba1P3tYomisUYidCXZQNo56NPNrDX4pCvkt
         fNR1Kfop8036+6DQEY9aOXz7i+ycHbEgdsSy9zez/gq243TioUCbWSaPkGQlY3eRFast
         ht1uOAVTjXaZG+n9dshKFMroRswPrgqUF1sz1IfP7I2fFM5+6f7TdMX/ECJTE/vznZzn
         EM/v/TMxMMlnKHIeNCtSTX+5WFLr2XvUZs1Gx+TdE/1uMGDgwHlS8sEWtwplkTzzFjWH
         K1bO5zJrT2k7l0xurQPeLRa88t+DMDXsNscooCrnXZOAkXRF6zff2nJQSpsAENH54p6r
         zIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsLwm1EHEyYDkMQeHbfyAFU1DHax2tvFD0Ukhfp5Sv0=;
        b=pxW/uNp0fAFE41FD3zKYL7RGMH9YTom1A16quR6S3hY2lH0x04n3zIP8AWaTIFkI2I
         tNj3GCycR8+7hz6elphjpkpsUBrRXPjkO912k8G/ZNtRyNOm1L03JL2VoA93v36VJRTf
         1jXmfehLVs+t0Z+57npA/8o02+hMAqUB1reRf81ffouW2EnpAJiVAS6Q8nAzPxjOPlDI
         X24Sq94KsFAjRDn/xUfiuQEHc+8e2nwP06Y5fXqXSpsTE2OF9wQB0YXDFqNKLQZiYrf8
         IxeD9UYB9W0f2iPPAGsEM1aCurzMYLF6JpfFfZ1Pu/a8bwNgAVSCQ9A4+trGrLwsjzo7
         RjOg==
X-Gm-Message-State: AAQBX9dGxVDmcnR+/MkXJseqHL05936SQ1Z49efXplZIp+HJ33kZtLz3
	xwndSOtMwWjYQKi1MKUDV5g=
X-Google-Smtp-Source: AKy350YFNg5wvUZ9P/AmY87H662bqvjMmoajBJYjuohMKZW6W7mUmwO78p/ypMuDupfhL008SKG8CQ==
X-Received: by 2002:a17:902:da8b:b0:1a2:89eb:3d1a with SMTP id j11-20020a170902da8b00b001a289eb3d1amr1069723plx.6.1680576014814;
        Mon, 03 Apr 2023 19:40:14 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902761100b0019ef86c2574sm7183350pll.270.2023.04.03.19.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:40:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 53C6B106782; Tue,  4 Apr 2023 09:40:12 +0700 (WIB)
Date: Tue, 4 Apr 2023 09:40:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <ZCuODJdxJkCjY3ZX@debian.me>
References: <20230403140415.090615502@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="anJnbe9DFqrdacgl"
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>


--anJnbe9DFqrdacgl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--anJnbe9DFqrdacgl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCuOCwAKCRD2uYlJVVFO
o0gOAQCqAr2QFDL+2lMaXECBwGwFcP8Wd5CN/kUcefb3Su4eoQEAub0jBU60FnWy
NynWfqburQIpfiAofFITDDvnxrmUTw4=
=/QAC
-----END PGP SIGNATURE-----

--anJnbe9DFqrdacgl--
