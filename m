Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDB7BA4A
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 11:30:09 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b0236ee816so3877165ad.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 04:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686223809; x=1688815809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQpBGT9U0xk8ceOcBXPqmShJrbITkq5sMpW+csFBGQY=;
        b=hlXxBLnEnFDNUflMdn5jr+gLWr+60M8EzsIaGh6M295trLDPEJBVKtIGQG3Tu332Ur
         nbZEidukoIhBfjOKqokq26paOZHdSOkeEwEGNDYp1WL1HyQlf2FAasBc/Y6Wfq14TJpp
         rmo+nv2KppjXllUY2GJg6hgi58cS2IRushwVUTChj1TQlTLCs95YYqjdoYPeE4L6WaKM
         VyJ+/ylNVw+hySkuQouv9oJGMnOMtT8lbO8+UA72+V5eDCl0iGQx9yoQ/WNysFMZPwbG
         iQWDzV93ViBrQAngLCuzi6c/umzVqO7nNNGCnKOwd5CfT/MmnWnzetyJdqhsg2vRZKzk
         Q+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686223809; x=1688815809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQpBGT9U0xk8ceOcBXPqmShJrbITkq5sMpW+csFBGQY=;
        b=lsWzpsqQnbALWoXCREV0S4AWRAxnhoE6KK7GbKcXK13Ulg5tez9JWLJBd6fVZboHFQ
         rAn1lMiTt0NknvQOPfm/fRMrVwGArlsbmifzKpRfFApmk4grCxQRZ9BC5V8FwQgClBMu
         8fztz2XvoJO3CD5ZX6kufUozji1kVeOSp5HNQb7F47OEwVbd6xo9JNvM73su5S7r9ZLx
         iGST5PTNS46r1qEC8GsJvHuJsZQsW7UBl2OSK/hP3pAgc7IE+1+K4J21K+zhPMu1YfiD
         9zCzQRW3Aeu8SKNf6347K3Nbf1NlZU/rGXtu6iU904ex5nrkdEfYYYPUt22KzO5uTWj2
         FHYA==
X-Gm-Message-State: AC+VfDw0sQ5WV2nEn+vPMxdLGf7PQfzZhgF8gikppBezZMjo4UpLXSKT
	2E2GOIyh3v5hSKJsSd1vjkE=
X-Google-Smtp-Source: ACHHUZ7OiXr7qHhfDSAnv44x1I5fxNmN2hHourGMao2/pPl4DNJYgnLOXyteMkZ+/GfOuBL5YIBOFA==
X-Received: by 2002:a17:902:dac4:b0:1a1:cb18:7f99 with SMTP id q4-20020a170902dac400b001a1cb187f99mr2069933plx.30.1686223809358;
        Thu, 08 Jun 2023 04:30:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-16.three.co.id. [180.214.233.16])
        by smtp.gmail.com with ESMTPSA id z24-20020a1709028f9800b001b016313b1esm1233913plo.82.2023.06.08.04.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:30:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 88222106A0E; Thu,  8 Jun 2023 18:30:06 +0700 (WIB)
Date: Thu, 8 Jun 2023 18:30:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
Message-ID: <ZIG7vqctqmK3r1RO@debian.me>
References: <20230607200913.334991024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HPOmJrhShDyJTZTh"
Content-Disposition: inline
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>


--HPOmJrhShDyJTZTh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 10:13:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HPOmJrhShDyJTZTh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIG7vgAKCRD2uYlJVVFO
o4a0AQCqKU5FlNDVavEFwm/2q6G4JMaislj6oe9n37O7lZwilAEA5Ks2L+Rvp4IO
tC3edwHvYKs3fNv4qtD4nA+o2suisQQ=
=w3eK
-----END PGP SIGNATURE-----

--HPOmJrhShDyJTZTh--
