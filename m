Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2578ED1
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 06:55:45 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-565e387000fso2321606a12.2
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693292145; x=1693896945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W02y8XrQjvud6v+7f98ge7q339v9OrPI2ILVKTk592Y=;
        b=IHkqfVJfJLlaQoxskXqSr/rqoqlDNql8XjHY9A1oVae1zGvS/Uf/AzjJLDlJ++Q8aI
         wsbXPeBmrRdUK6WomZZlVZ0Z2AFi9vysNpWKn2E0j1EGQg07K8pVr4xY2a37qoXNfa3Y
         HhsQOz+/z5LOxjvbPsIQBDn9dyYvYP15Jrvp1Rv1RHQRY5oaMcsHtelxuKRvm5hFf0kA
         vtFdxZGvHZQfnpKvuVkCiujMjVCRmd47EF0eu1JRNyiUrzXgTlhwKHzvUygbiF50hzUB
         ncpAFNR/7T4EI9kLCTepPgEsT+ywCVJJN+QwLntL78xu0y9a6G8UCs6iXs3cTNCFOlQw
         /2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693292145; x=1693896945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W02y8XrQjvud6v+7f98ge7q339v9OrPI2ILVKTk592Y=;
        b=J1gx6Kwp12X3AM7VZIfDKiJA9uuWdYpF03axbS7a3Q0+ZHCkD+RIOMBDYdSYWW+Gb/
         1h+75vOyaxxbGWJ/NpwHPSmxERRFIiZQ9OKkJCmH4JW+5+eua3Nk4L0saojNGs5xZ+5+
         a32/ARyAdgNtrqzw+CySKOVjqn2p+WUYcZjIrGF5ImXLD5zY+trCtieDXguScsKOIGai
         UzMP44A2jjpbagzUcv/tj6Oqr3UyY2L/lyqSW8SnIdXhXjoZc2HPrZGlsL5+wFN4g+cD
         YxMtxJA+z2liA8Q2bk6I1tOTetdE9n9NNLiT0uRE1QTADhR8lWSUE3mDZDkiBNZuEyh0
         +X2g==
X-Gm-Message-State: AOJu0Yy0/zYJvdXEUZXqRF8Z2S9bQmrPMOfBhrhDJAuZLu7pBI8kf5MI
	JJurJkS1sB5YGA0TruinjmI=
X-Google-Smtp-Source: AGHT+IHhVFS2lN873oXS3uZc7sQfu2xRTJ57A+h82Za47fLq1tvzxyYGfydXjEiKYXG8xBlYOThbWQ==
X-Received: by 2002:a05:6a20:7d9d:b0:14d:446f:7212 with SMTP id v29-20020a056a207d9d00b0014d446f7212mr8344211pzj.46.1693292144930;
        Mon, 28 Aug 2023 23:55:44 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902690a00b001bdc66478c1sm8573405plk.309.2023.08.28.23.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 23:55:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6014DA34B070; Tue, 29 Aug 2023 13:55:40 +0700 (WIB)
Date: Tue, 29 Aug 2023 13:55:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
Message-ID: <ZO2WbJVZarbwh3Z6@debian.me>
References: <20230828101156.480754469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e0XUHzXKRuzzbCUq"
Content-Disposition: inline
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>


--e0XUHzXKRuzzbCUq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2023 at 12:11:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--e0XUHzXKRuzzbCUq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZO2WZQAKCRD2uYlJVVFO
o9VuAQDy/APECAEj6LrID38hG+oYJy5QaBej7ftvualVeX4uPwD9HgWc/HpsnoMI
pBYbxODVZsaN9DU+RSFVGPHhjP8eeAY=
=KOyC
-----END PGP SIGNATURE-----

--e0XUHzXKRuzzbCUq--
