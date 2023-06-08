Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21C5BA4A
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 11:28:10 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b02d0942caso1862485ad.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 04:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686223690; x=1688815690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LR0QghZNj2zTc0D2V5r40rM8DIgSPHbR48m3RRcLmCM=;
        b=n5H0ExkkA6IesCR64tBnnqRJF5/XFC96mu60Llj4lEj9pc2Tv7+NsDVWs2Rb83mMb2
         SQBZ0OFZfq4DvBF0deyr+KtvlXmwQf3lt//0w6TV0OMJs81DxY4l46FvpulqLc47RfhV
         9Ecd/BsObGdwsXzjr5aaSep8ECcau+QWyLJC6F4j6diXKNQ7ct74oh/FthB8uq4bDByG
         awx3Xppvm6IRgd405MoYvfqYPIILxdo2ha3Ms0IiHatIM9EwsgW8lQz1IirapMZAQAn3
         rGeq4knvgQ6BO++401Es537XCe9isZyIRUxMJxFXXz1n7mNSPaM5F/x4DI+RUnw8ReIC
         PSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686223690; x=1688815690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LR0QghZNj2zTc0D2V5r40rM8DIgSPHbR48m3RRcLmCM=;
        b=THOgAYiaQJRG26Peb85pXKfaGmxFQoIGmKWH/X+wdSrsYi0zWIbs/dHUjng6WyVw5s
         6rgihmsOobT8iuhV5iJ4z5gMQDjrXLNDQBGJ8LTVWM+1Ks/DFU6mtoSXnLSyU+2oIyQ/
         /RUd7sPBTNDqj+j5+ko/p715U/gmM7SQeIwIMKxWdhMTa43cyBqE3/Su9sW946QbmyV3
         uLylqePvNvdIs6wwSt54QZ5bhqWAXZJFfEy76NRBRml/IPwN9M2qnQCeKA0wdCZRzIjw
         0+sKbj7dqbRAEcVF+/OrwJgS9KALZQy4Vfe1ftwFIzzxQ6toI4fjMHJ20T5VzvRptB50
         pceg==
X-Gm-Message-State: AC+VfDyLDHbaoOfk30XKDIeK//oqFGkT9Owrce9kfXtWjiPEj/K7LeWD
	1Is6rC0lXZIIYgbWmWUY6J8=
X-Google-Smtp-Source: ACHHUZ7S+2xH0uqwOZNdKwuC2d08iZquDkW3swDSyQsscIUOAeyAbZenZaksV1hZTo24O0Jqg13jPA==
X-Received: by 2002:a17:902:ecc5:b0:1b2:3d0f:be33 with SMTP id a5-20020a170902ecc500b001b23d0fbe33mr4533385plh.27.1686223689718;
        Thu, 08 Jun 2023 04:28:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-16.three.co.id. [180.214.233.16])
        by smtp.gmail.com with ESMTPSA id jk8-20020a170903330800b001b0358848b0sm1222348plb.161.2023.06.08.04.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:28:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 456FC106A0E; Thu,  8 Jun 2023 18:28:05 +0700 (WIB)
Date: Thu, 8 Jun 2023 18:28:04 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <ZIG7RAcyKAXqF_TG@debian.me>
References: <20230607200903.652580797@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c313YtrzuUNFtKdY"
Content-Disposition: inline
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>


--c313YtrzuUNFtKdY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 10:15:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--c313YtrzuUNFtKdY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIG7PwAKCRD2uYlJVVFO
o7E+AP9D3UNFQ86+a4pFoU5JXlMfXixRpZ2k6jdv2V4jTwOqFAD/fh+JprL31ynZ
PPKszEiBLcHsAyHEJjZOwhIqXYCeowM=
=AnWe
-----END PGP SIGNATURE-----

--c313YtrzuUNFtKdY--
