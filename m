Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6130E7C
	for <patches@lists.linux.dev>; Tue,  9 May 2023 02:29:25 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1aad5245571so36232485ad.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 19:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683599365; x=1686191365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yYecKSQe0iHULW5+as1tqxFG/5MQ0oTCbV2Qpn62HZ8=;
        b=MsESL2Rr8Ou1aZdR1g6AT5S45QrhYl+vb0O4krEYhLp2J1PmbuyglmdFOvyjUEBJ+B
         r31pKbMZHAWnlILyZo4KZHRhh1pPACT9UzAsDi3fgwLGTHD9AGDYpZN/3Ltv+BxFJdDx
         2ekKk6k9lHbhnasy2ap9Y8dL/LloAGdnkPKt5nnYzvi5kWjUjQ5cx4PZODiLbRbOh3TJ
         SSVustgNJ/QrSfi39zgGtU+T4xL+wElZZB3zPpA03V8xZiGUAFRN15gQxUEDZfKP96IK
         WZhnXDUtvCPVfbFXK2xGmESZklJFC/2Uk9Ed0qUIDB2qkuJ1zTD1Uz7KrJyP34I1ZKTm
         dL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683599365; x=1686191365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYecKSQe0iHULW5+as1tqxFG/5MQ0oTCbV2Qpn62HZ8=;
        b=bqZzO2TvlIrBgEulea0vC4D1gKwr0UvkFZCg1c/yQ8DsZK5CV8ANpPfudTY9VtsYqO
         4uARcnvW631jL7Xj4IZDYuQf9Q0TGP2FwLf7YfB9/n2lQwyPg0fUF85HJ7n6YAGPxM2I
         OaeriBUrvvmLMZwiBROSjOuXGuqagmxVoaCiiIYtm57FZiSCLzSE+9i30A12z21Y5eff
         QPlaN1kINkawgVU4Uq6vPt21XOB4gOyHxr0ZnwA7i7bOqiUNm9t8AoSlu7xqQqByPpQl
         207akjqPKXyTDaHXTBhJjRJIOo91ShF+Puo5RxiGwovCIi1W257dAQ7/TEv6yoraF4Nx
         ZkfQ==
X-Gm-Message-State: AC+VfDzu25PXyJuQj9fTN4vcE4XPd+RKVLYokvgGd/b0ZvtXyoxT3wyX
	WgHMvDe/rymA9mk1mieUtCY=
X-Google-Smtp-Source: ACHHUZ4TY4UAW/s5ebdXDXFLOwlQUEaucFRj90lKQB3ABYpsjkZLBsNoIOkuLXzBgYOutf7yWiFhfQ==
X-Received: by 2002:a17:903:191:b0:1ac:750e:33f4 with SMTP id z17-20020a170903019100b001ac750e33f4mr7560399plg.32.1683599364641;
        Mon, 08 May 2023 19:29:24 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b001ac7af57fd4sm195050plb.86.2023.05.08.19.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 19:29:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0253F10628F; Tue,  9 May 2023 09:29:20 +0700 (WIB)
Date: Tue, 9 May 2023 09:29:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
Message-ID: <ZFmwAPqX8KggE6gj@debian.me>
References: <20230508094421.513073170@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WmofWIXPgBjLJT1v"
Content-Disposition: inline
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>


--WmofWIXPgBjLJT1v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:37:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built bindeb-pkgs for my computer (Acer Aspire E15, Intel
Core i3 Haswell) and booted. No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--WmofWIXPgBjLJT1v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFmv/QAKCRD2uYlJVVFO
o3TpAQCpc/XxsFVKYShtj/EoFmBsye/Okd166oEsvrPvj/mqFQD/bcgjMkjZskRf
o/bEM36lf4KLJmCrO3rcI9/7s4jlWQU=
=beRO
-----END PGP SIGNATURE-----

--WmofWIXPgBjLJT1v--
