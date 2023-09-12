Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6432C171DA
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 07:18:27 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c1e780aa95so35424375ad.3
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 00:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694503106; x=1695107906; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=py9nFuvmEUQ+zP3nRmEje4+bypXTvMKZX3lUiFpTOCI=;
        b=CvKRuHqCdpqH9uYKDncMIO+ra76BRWpCb6GaBimKcliVkkfnfS58d+32E60R8wppZ0
         DP7AWzplp5pvpPmsvjlgnNtW13okhD/SBRR63x4/6zeKrdmzHJieAFotmFyc9canUpCo
         WWfsbI4GVfK/fF44zo54GBPOYbnq5gUrUP3AOkwiSP1RODooVm5MJ3gQrsn4P30qcUrh
         /S8UIzVLF6USrAJqIZBqS7RnrS+eByJcgcUQAPkYi7ibiRjeWuWRTDTWUgFT5kmkke2m
         lkC5r3ydoOH4l0sKATCbGHYBP/kFgTUchQPwc4WJfbNw0hDycuZtLQN/rWnIS2rIXk8l
         lq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694503106; x=1695107906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=py9nFuvmEUQ+zP3nRmEje4+bypXTvMKZX3lUiFpTOCI=;
        b=Gnn2IcrOHMMYE3AYo75tGE0oyvnuQe4AxfZj+IIvgL+u2//GAH3KsZQv0cwLVmdOp9
         GumhnqKN3D5MYns7Q8CFREszUrKCf2HdW3qSeLSMxPTymh7xjvRwcvqFqGy2efMjaDwG
         01Iu6plIv7PFSI1R+P1en9tfMepN9PtyGny563Cg/hRTjFq84GITWoaRd0lDeE8SAT7U
         Az077+DzlfkzQKf2N/sVQlt/ausQH7PihulQ7+spy37Bh2unAjFx9t2gHLF6+yaANd4U
         zHEGDEwtBG+VUFUue9bQpe1SotNNs2iFMipaKn1VxyIH4QSQOwyf3MeoT18dcEc8oKhm
         zoQQ==
X-Gm-Message-State: AOJu0YzSXukSnlHIZ9BQzRHOP8opJAfH2vLVy3KhD4otVD0tSsdug8UO
	wjLOH/IOtfjDkpEtGfBE8j4=
X-Google-Smtp-Source: AGHT+IFdRiretyQ1GLC4nVkoZnVQXsRf4ZGWCkA57gDwbbQpjyUOgVo2r7/HskBM9sPFmopIIC1J0Q==
X-Received: by 2002:a17:902:eccf:b0:1b8:b382:f6c3 with SMTP id a15-20020a170902eccf00b001b8b382f6c3mr12885013plh.13.1694503106567;
        Tue, 12 Sep 2023 00:18:26 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902748200b001b9d8688956sm7642137pll.144.2023.09.12.00.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 00:18:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D9F8C89F3BB3; Tue, 12 Sep 2023 14:18:21 +0700 (WIB)
Date: Tue, 12 Sep 2023 14:18:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
Message-ID: <ZQAQvRmK9UfnyMxP@debian.me>
References: <20230911134650.921299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bXeRTYoIFlIhUA3G"
Content-Disposition: inline
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>


--bXeRTYoIFlIhUA3G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:36:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--bXeRTYoIFlIhUA3G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQAQrgAKCRD2uYlJVVFO
o+KcAP0SpWyjL29RPb71BbYJBR/nYBooxJWHXCU18IdF4rKebwEA9fHzwaIHTxTN
5kOGubcYpMYtmbblf0q+jDcmoJgilwc=
=pRu3
-----END PGP SIGNATURE-----

--bXeRTYoIFlIhUA3G--
