Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6837C
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 03:30:57 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id cn6so392991pjb.2
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 20:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YEj5OBECUBzAdwIoI2YKk6Ne6SPKlmrZMcAm1nJzScg=;
        b=fmwUmHqO00Lbpi0eRp2PUAJm70IGVAwXU+H6lxOhMGtU00LVZjuJjiVzMeLBIuoXJP
         2oeh7a+DnYfmWpUwnaRY7hEsAxYenVTSJkAw80njt5Aq3DmcZRkrzmrTrgQtEIBnp9kt
         QjK0w1Zt7652hnFyZNDqqKoUU0E3vzNv7YZX94DHRrwwVGz827cdr68NmLcxCpfSSB/W
         If+JOCgfIDQEWDOGagYg+kkGSRG90rj4xChuj4ufqa/3qfii9zR/8yX3gQatB/rEKXPM
         gfCzeGCj7ykTAaFE/twfk3nLgrOH7VFN1N5fyOLaL3BMqYU/xfl2braNNdYQvgjuTWWt
         UKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEj5OBECUBzAdwIoI2YKk6Ne6SPKlmrZMcAm1nJzScg=;
        b=FWC2KcutHteJnfLBLD8J+6UOPPJPivmha7jj06dJxNK2NACZORQaJuHGrUrAA2VZ5a
         4URSl2Je8xB86NtwKYw9bm7R4YH+mPuaLUb8vxwILiy4YEQLY30BEULTZ0mqiAFskj2t
         Q83SA84ouZXt86cdW6Yf5W8xtaFWcXtex/rt8Q3YB0XEkEAgvBJCj+msejc4it1St2K1
         UY/TKQn3nQZjmc4WLPVfa2DogZNZD3GM0KKaF7hHQc5JfG3gCA2YMfPDuZKu+dx6xAgB
         Bc1yrGbZam8gBnS4uO/GMs3xFTyc9u2V1c9L0HYXy9NBdWq3E0peSojaUmD57fAfqGvZ
         69Dw==
X-Gm-Message-State: AO0yUKX0/3Fo5J+Znjmy+cEqf84ePokc01Zhsm79nyHuAjwKbbCnZGIh
	GnDnW4v3vjBitK/31CFcczI+UBwbRIE=
X-Google-Smtp-Source: AK7set+HAbU6lA9U/X2srZ5Xk4qpX5aEt2KI1YecH4Wupgn0JhzGtuCC8dVFOpYr7Zjn5c22QQvlsA==
X-Received: by 2002:a17:90b:38c5:b0:23d:35d9:d03e with SMTP id nn5-20020a17090b38c500b0023d35d9d03emr1888838pjb.48.1678937457414;
        Wed, 15 Mar 2023 20:30:57 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-41.three.co.id. [116.206.12.41])
        by smtp.gmail.com with ESMTPSA id q30-20020a17090a17a100b002349608e80csm2030395pja.47.2023.03.15.20.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:30:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id EE4C6106569; Thu, 16 Mar 2023 10:30:52 +0700 (WIB)
Date: Thu, 16 Mar 2023 10:30:52 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <ZBKNbLP8X05cvm+y@debian.me>
References: <20230315115740.429574234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DmG69jtXaUvq1CLH"
Content-Disposition: inline
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>


--DmG69jtXaUvq1CLH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DmG69jtXaUvq1CLH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBKNZwAKCRD2uYlJVVFO
owPRAQCfREexag1qiZ0BXF0Jn8/mVjc+Uip9feQfZAHWEqThdAEAwTcEvq9eWgdq
0uz12pCm/DgbLfTRyUAqC/1eXbw/IAo=
=9tHI
-----END PGP SIGNATURE-----

--DmG69jtXaUvq1CLH--
