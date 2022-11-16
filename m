Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EDC7C
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 04:00:10 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id c203so5181468pfc.11
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 20:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=636+W0eI2tQLj88G1y9xJ1MUm1p0RSuNiUGbqqjBohQ=;
        b=KE7leJ0Uz3prbgKSTiG9YV1cKCjWZ8VBEovgWpDZYu/wZabtoAozr8v4iSB2+zv898
         6/RX6eRPPnc6f4xZCiRGUNsKVw5h2xYUgazIxgs7Xl9pibdOAAVKWEOHvNBlhO+mUQlu
         pCp3vxbDMBmGtEpQWnoVC9qcEczoifuuErcBnUsXhJaC+HArgazRmT1VfFn+iSFMjfPL
         DN4dlQKL3AojOaOxh0S5Gc2sQG7/MBQsaidc8Nl8k8FXiMcROz+6E+e9RONDOO5E1LIh
         y8J+xlam/orU+iaIplIedgyEQWvkOBgYd5lq8+f1jFphLw1Zpip8cnLj+Jk8GkOgQzw3
         01kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=636+W0eI2tQLj88G1y9xJ1MUm1p0RSuNiUGbqqjBohQ=;
        b=yCM+DoRp5lxHPGjkxceb9Osb+RGid4oIDu5bYpMBcjcI+3l/kXw3gYUpDK07qmc5bJ
         txiSudc/vcMLI+FFK7wGu5mHajtBRgTyuc8ZXJaMJaMrDEMkoQGAAJWAEmPjtYubpKYE
         xNKqZ5ta4W4u0ccRCkafH4ERNs+uZeudMiCWJRgEnHIAPJss04oxRaoKkUwChefmzSCh
         geJqx0PRsgXnP6GnhRezycT/Z6JpSe9Rz+ZcfvlcJBqv7cyOLd4YGa2O8c1B9O+/85t7
         xGk3Iz/8o2JMAuwxtY159Xd4mbPg038jHD0XFdyZdQ2MO3Ekb+lrNAD+irGdn5HvtMJk
         /EsQ==
X-Gm-Message-State: ANoB5pnGbRyY+zPm45k2m4TVKI6LyWIlhVoUyH1OMoVlKB99792o7HvV
	lBZuyO+nceMEBwYv5SQwLm4=
X-Google-Smtp-Source: AA0mqf5NgfbsNJwE2wpIqhUmA3w1BsOVZLvpn8CGkutsjZG1eAKyT7LmzNFKNAIkqD6oizXgWyZnyg==
X-Received: by 2002:a05:6a00:4211:b0:56b:6936:ddfb with SMTP id cd17-20020a056a00421100b0056b6936ddfbmr21554023pfb.15.1668571210288;
        Tue, 15 Nov 2022 20:00:10 -0800 (PST)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b00179c9219195sm10735808pla.16.2022.11.15.20.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 20:00:09 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 1BF0B10417B; Wed, 16 Nov 2022 11:00:05 +0700 (WIB)
Date: Wed, 16 Nov 2022 11:00:05 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <Y3RgRQtpdRcYkmyv@debian.me>
References: <20221115140300.534663914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9cFiUmnwINFl6Jo"
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>


--M9cFiUmnwINFl6Jo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--M9cFiUmnwINFl6Jo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3RgPAAKCRD2uYlJVVFO
o/rVAQD7zavBgudoB1bmapSnYKeH2LX9yLVqpVO2gJ20+sa0HQD7BpZr2n0mRtIu
+xsAUVEzbFPC/ok18Mc+KZDY6pjW7gU=
=tAps
-----END PGP SIGNATURE-----

--M9cFiUmnwINFl6Jo--
