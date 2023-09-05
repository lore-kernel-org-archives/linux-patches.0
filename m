Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C447E
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 04:28:08 +0000 (UTC)
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-76f18e09716so126346785a.2
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 21:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693888087; x=1694492887; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uWgaTVmGKK/1LEN6gPVAr1vwp0h/BBNqjSFG08wB/fM=;
        b=dg6OypqhXXnb1ADVXUOw6Guzrd/48hRAgvGTiI2V3WbqjuqIkgSHzTNj0i3ncJKcJW
         2RD7hGEnC/nmXK1lYe8cSnGnFfR9KAA+FwGZFokm1DiRIxkOUFzsBDqP+ukg3IZaSgnY
         JRsYpbw2k4u0BW+ylit9YSMTWny6uAi/v5zFObbS9j96TpBBovY0Tq4LA2Jo1+Rrykso
         jjee8GcvtscUv0oaQ7S+/6xyiaerj1L20e+nLhpI71Sn9R+sjD0esVmdIvUhuyKMYoY0
         iRawBT4sxgIx36+Qs37d5JKifR5gsvZMexr1liwYmajSjeOjAM1n3I3QZA7/xjYgEFAG
         e4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693888087; x=1694492887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWgaTVmGKK/1LEN6gPVAr1vwp0h/BBNqjSFG08wB/fM=;
        b=lafkTk+18ivtYuJZ8DZ3Cc5RNAij7x1mVMeImqjohaflbCf7k8k5MlhfEemaz7larW
         7V8K4qVq99ek1odV1Rugskh+DNB/n67wYSYVzs9ykQ8cwMqQ4GKp7t8fWnIPx1XejZnY
         mYpolvB8hHwi3/KKhajjt3EWsvp5dz7wk6l7wc9Qsp5Yr4nixCTVmnkuWzRYd263fFsM
         o+JUm++J+GpVWyzAPSUST86cD11nyERYrt/EHL+BVuu83YaacOZKs5pc36U8pCl8Dvtk
         lPP6uIkGo8zxQZndRfG5uB9ftNLoR0pwkMN6xvBVAhZcwGE5YIZ5wKK/XmizuzR/y5tc
         WCPQ==
X-Gm-Message-State: AOJu0YyndnocKeNZGrxc6d8GLKctpC/Jiv7nIlGWPeHZkezTsZwiSrnu
	lGKYtyOLK8LeScsewXClNFQ=
X-Google-Smtp-Source: AGHT+IHYmroJtrEm5/Z1B1aI2s4sLP9zuqfgFu+4gX/0vKDvIhcALhkfGYKpGlwOu0KgUF+GqAZXUg==
X-Received: by 2002:a05:620a:461f:b0:767:de7c:b60 with SMTP id br31-20020a05620a461f00b00767de7c0b60mr15733201qkb.9.1693888087229;
        Mon, 04 Sep 2023 21:28:07 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id y27-20020a63b51b000000b0056606274e54sm8377370pge.31.2023.09.04.21.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 21:28:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id EC2DC83750AD; Tue,  5 Sep 2023 11:28:03 +0700 (WIB)
Date: Tue, 5 Sep 2023 11:28:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
Message-ID: <ZPauU72HlP_dvnGy@debian.me>
References: <20230904182947.899158313@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yVkkHyRm0iPHqxli"
Content-Disposition: inline
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>


--yVkkHyRm0iPHqxli
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04, 2023 at 07:29:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--yVkkHyRm0iPHqxli
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPauTQAKCRD2uYlJVVFO
o3r+AP9h62zr6s9K35mx/rdIZyM29OCsEzKqH6W8hX9yxhlWaAD9Fb7Nd9yAp6+L
95NzBDP+jkfCfOLwYTv5g/bX6/ANoQM=
=db7D
-----END PGP SIGNATURE-----

--yVkkHyRm0iPHqxli--
