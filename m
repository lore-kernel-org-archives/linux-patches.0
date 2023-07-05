Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8D5ED2
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 06:49:50 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7653bd3ff2fso679022885a.3
        for <patches@lists.linux.dev>; Tue, 04 Jul 2023 23:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688539789; x=1691131789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN4dJ8uJf+yfpLbNOPBTsXnaH4U3xyC1VSZoGX/yD5g=;
        b=m4T+3PxA8HKfBr2TtZ/oCxC/7I+nwE60cEOIjA0Akxk2fo9u+kXotl/Y66pyVMpYy8
         iKdcXwMg1fGYqsgHGd7K1+wViX3AhH1x4gKM3cbCHomNoVLKvz2wQ/ASV5YU/ZPA/cOR
         H6brhmnxUTUIDsMPUiW4AsY4RltaoK7d2+L7RY9R1Df+bAPqeejptgmtO8x+zyipm/3B
         nHQyKxILNe/MUeIn8t/U4cdUz90v8SadkxouoS6yryYeOpkvmKr2ub4VNJgWEmmf4f8G
         NgHdpM52h07tHqnAL7pH0Jl7vNjXI4n02ht0ImkuECqbTi7WllRuCWYCSMYoTM79YP4V
         ZdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688539789; x=1691131789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZN4dJ8uJf+yfpLbNOPBTsXnaH4U3xyC1VSZoGX/yD5g=;
        b=NcQ/7q5+0gdQippVgcmGcH/cWY/I7+gC4b1JhbVHTLgyXO27YFg24p7QGil5o94x9V
         Ns7YjhKwIW54WP7jIc0i8hTObI/HN6rEUuFq01TNmQ8HpEkkYlATucnOdPBykS0frp6Y
         6QhWiC9Uo5WmFawFvJK+HGtMX1+VrMAz0/vPa3GDasbx4LGjm0Kk7h4e/G0OATurx8+y
         6kT1jUtdlkX3ux1f662mjtDZOB2V3uv0dzfvN2Yhk4eSI1iXww4LGJzN8GVjXGPcmqbP
         EpoDmPk/aSUwpxnJy/7N1SI4IuAWEmntAEhxhmlyYIVIbWUSqxzARED0THeazBtnVQoI
         zMig==
X-Gm-Message-State: ABy/qLZGPN+0CFV5YYd2+xZwNmpzr0qp4lhrpEsJvMs3V+T1p4mabYiE
	iMponMbp7QJfcIKjQSZACZQ=
X-Google-Smtp-Source: APBJJlHKocwWU4up8nA4Gn1I7Nh1oYffL5uD+Ha03luBbt7pFqLDhuLz8yNEvDhyLcxugjHdl0J5Ow==
X-Received: by 2002:a37:f718:0:b0:766:fd2c:fca1 with SMTP id q24-20020a37f718000000b00766fd2cfca1mr15674220qkj.75.1688539789332;
        Tue, 04 Jul 2023 23:49:49 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b0065980654baasm16591235pfb.130.2023.07.04.23.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 23:49:48 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 1B2D3808759F; Wed,  5 Jul 2023 13:49:43 +0700 (WIB)
Date: Wed, 5 Jul 2023 13:49:43 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/15] 6.4.2-rc2 review
Message-ID: <ZKUSh0p8ynyFCG4n@debian.me>
References: <20230704084611.900603362@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5eonTzacrvwGSkuM"
Content-Disposition: inline
In-Reply-To: <20230704084611.900603362@linuxfoundation.org>


--5eonTzacrvwGSkuM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 04, 2023 at 09:48:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.2 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5eonTzacrvwGSkuM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZKUSgwAKCRD2uYlJVVFO
o3uiAQDbj4eI9kQDllJlbiIZXvqitq2jET2swj+CoKrC34S6/QEAygBCFW5W6ort
46cTN7NMFBFj8fuLvf4fvc9Z52VMkgM=
=Ag84
-----END PGP SIGNATURE-----

--5eonTzacrvwGSkuM--
