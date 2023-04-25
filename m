Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8787B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 02:42:31 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1a66e7a52d3so40978935ad.0
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 19:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682390551; x=1684982551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3sSpTQyJae640NPfdp+kpnpJCBMCY3ZeP3l1VrRYZo=;
        b=h0oXTRaMIBOlAgxpQI2FtydYC5qR1yb1IBDDQ7EvpbImoXXJZRX/6u/1V8Kx1NlhLe
         e3hqy1gdxg8NgXN5fG5ZQHKZR6bmprLO5eWO8UaUjJUCjzCx6JcDnSB6xZra90vFNsxf
         pO96kYXVEaBDDV6pplG5FvkXJCCHQr5zinyqRoR9mxTbh4sakx4EoX3IrViqFAUFYXbP
         pmwDR0/wsOTSMYHL4fAaUMKR+6Dz/25glJVFX1cF1ZmWF19hky47xeFTml4h/rQHSGzP
         FFwfNOLOotr6lzB8L4MiG7svo4Nbp8iJWzmwV7n++3sQvNRRvvxRXdw2KA68kgCdgsm5
         MdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682390551; x=1684982551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3sSpTQyJae640NPfdp+kpnpJCBMCY3ZeP3l1VrRYZo=;
        b=blLjYthEzCRLDLCdy8l3+GOkRD4kb4rHLMonGaG8Bsr+GFqAJFKAuaT/aPvga1EeSW
         QUHaB9ErlrNuCghuSDmw9GPoY0TpbIvpMdfpFCbDCCKg/T4ckVuQdut+mqC3z/Bi5OLp
         aBogH3B2lo6+2AJyK1ot7OTGWNZ8jz1VaPXXFqyMHfc6sjEQ8MMyGPdAE2i1FcbyWF36
         nQxkP0k22Tm5Yn4ap++N+2+CLOPGu8KWN8mIhJRu6aR7WLH3fSLaBKekctknwAV4yKCp
         CZVHIcI/7AIF6kvQ0fKejIcqEouV1XYuuc3ySDdt5Szl2wZylTESmZAzQEI2jmO/WEd8
         rlrA==
X-Gm-Message-State: AAQBX9cp37oy1ic2jRFx3eV5+QO4KomoclJOZ6WRaVjTabo2eyvhG/QB
	4ZBVnYFCZ//WYiCCp/GzZGc=
X-Google-Smtp-Source: AKy350bkDsXlhnThiUfY5xtHWu5hMzNUt8LAU6X5/MqXswyEXhHWB/aypyTqdSsDLXvBA5mkaZXgxA==
X-Received: by 2002:a17:903:40cc:b0:1a0:6bd4:ea78 with SMTP id t12-20020a17090340cc00b001a06bd4ea78mr15871117pld.31.1682390550952;
        Mon, 24 Apr 2023 19:42:30 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-29.three.co.id. [116.206.28.29])
        by smtp.gmail.com with ESMTPSA id y18-20020a17090aa41200b00244991b3f7asm11009480pjp.1.2023.04.24.19.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 19:42:30 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 27F3C10692C; Tue, 25 Apr 2023 09:42:25 +0700 (WIB)
Date: Tue, 25 Apr 2023 09:42:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Message-ID: <ZEc+ET2ZDSOKobZc@debian.me>
References: <20230424131129.040707961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D2HFOL+8vcKbRPmn"
Content-Disposition: inline
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>


--D2HFOL+8vcKbRPmn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--D2HFOL+8vcKbRPmn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEc97wAKCRD2uYlJVVFO
oyg2AP9d1m/sOUSzCIzB4Tw2fgdvWE5MqCVgQ5n29CgsSxl5rAEAlsfVavMIS7G7
a3ANvdmm6QjPrFLQ9FVrjHG0X8++Lw8=
=/YEe
-----END PGP SIGNATURE-----

--D2HFOL+8vcKbRPmn--
