Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2946AE
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 05:11:39 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-686e29b058cso2576453b3a.1
        for <patches@lists.linux.dev>; Sun, 13 Aug 2023 22:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691989899; x=1692594699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iS5ujCecDFIUzxz+IV8xt2xrQ12GiB8yH1eSZVE6mVM=;
        b=MV4Rx3q3FZw5Y31Gqgt1YqD7oaqBWve/q/nsuNvWSuAwD5pRkTKDu2+irZmBtvHGZk
         8zFlwhxyf5Tn48LsDqEappWQ9h/W0L+/KkxqrFOnjULJHkEhPsKWPU1oSBuguVNS+DlG
         R5vXmIrZMRfKN6sNy5Q+1f5dNNkzGZBpXn6tXS75v9KXW1MyXVtBNzQqXLGa9BhVIWny
         M/cd+8YM5gIIFR0Yr3tlHhgBGTZYx8MmpxpRyjz0ZSg2VN8ilHC1Ndzzkg2hI2fQs5KS
         MH0X0hd8OQ/cqeSpZgmpWFb8KASLYrhs15AhfbFzl9D3GsmwW2UySaBGKRcg1is7wpR5
         3j+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691989899; x=1692594699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iS5ujCecDFIUzxz+IV8xt2xrQ12GiB8yH1eSZVE6mVM=;
        b=Dv6ishh+aZq0QjWdJYH8Ot8qTPmBIGzfjLwPyrpXPK9JwG/ZrEThsw5V5xeddyYory
         9NrsucaxYZ1nYXxLp2yndFKvVYhxQwjbt6oSwEfFFbdaf4x8sbkCcqcaFVigNI1Ub0SW
         FqEAgbsnPPN8wT85Jr1kiBYe1uU0uWud1GjgpN1LeH3Eu84ZQaubpeZH+HqTgGQgw/OT
         VG5GX5+DeOuHXpARbza8eXGg7Osjzysfx+MkZrvADu88ulzk6xescxOneTtpbH7W0EIz
         jt65boQEbY5A3qxxmZajc+TsL6TDlbJA4zYIRgxXrtsDvc2WMDQJuFL1wX8LZpzJ2Olv
         1LpQ==
X-Gm-Message-State: AOJu0YwSvO2eJOWpt4JAUVrAZVmUJ7gztffjEkcbUAPzC40CayR0mvsU
	kE/MBmR9RGxKb1Ly+vyC3jQ=
X-Google-Smtp-Source: AGHT+IGsV1EisACfbNAqFykmulwHZC9mkdmV9etuV8GwaWRVwxbtOMJ0mGI37JzXbUISqLCsbsvOcQ==
X-Received: by 2002:a05:6a21:81af:b0:140:694:cd99 with SMTP id pd47-20020a056a2181af00b001400694cd99mr8052967pzb.44.1691989899205;
        Sun, 13 Aug 2023 22:11:39 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b001b891259eddsm8259959plh.197.2023.08.13.22.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 22:11:38 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0733E81A9BC3; Mon, 14 Aug 2023 12:11:35 +0700 (WIB)
Date: Mon, 14 Aug 2023 12:11:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <ZNm3h5qz32YLJ40u@debian.me>
References: <20230813211718.757428827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eLTOEWlQlkcoI9Lt"
Content-Disposition: inline
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>


--eLTOEWlQlkcoI9Lt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--eLTOEWlQlkcoI9Lt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZNm3hwAKCRD2uYlJVVFO
ow3aAQDfCOHbAbZSjuJzkC3HZXW+HOIAwSXOJcuS6yknJ/+0GgD/RN2BDhB5xIe0
CTS5azA3dSd399oNCDhH1pgQ7usCNgs=
=sDjn
-----END PGP SIGNATURE-----

--eLTOEWlQlkcoI9Lt--
