Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399C4C94
	for <patches@lists.linux.dev>; Tue, 23 May 2023 03:22:26 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-53474b0c494so4843922a12.3
        for <patches@lists.linux.dev>; Mon, 22 May 2023 20:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684812146; x=1687404146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wScoHaonyaq/nmwLXnQrRcEsJtUPZNvmHqQ+3wj1c7Y=;
        b=PGty89Z194hNfiRlVhgeX2AaQq3OVyfFULNfonJ6mlfknlljXlzXi6aZf+7yeqmgD9
         JgixV2UXkyo63B2ZYVuQrSJmrFvQArIOcPK1Z5MLAjfp8cGgkX0B0hDziHHK7drAeWHB
         mBSzvTLk4YUJCavERSUoandUq+OERa60xyLRm8111POdSPfJA9uug7c+nRkt1brRriad
         hTH8fwRm95YQUXWVvgVFadgydxBIpq9o8WXVRZFWjz/m/se8BRLJU0yCGyYecqcnLzBO
         5F4ugfImLZYHu9x17+7pMkzCSJiRvkyzb9QXaAYTrstGQ5Mo3KOZfq4Z4rXHKlvzLARi
         cZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684812146; x=1687404146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wScoHaonyaq/nmwLXnQrRcEsJtUPZNvmHqQ+3wj1c7Y=;
        b=R/t2EM8z5DS2wVxVkSqOLFN4c6XGT8G/EpnGcl0Z4caZZbJEb45MadMVeLLQZQt773
         epPAkuY7yEwTwKFURb+btMEohFpovAdYvDSnFwgMsJ5FCYGTutojhABbZ/m6kybu5xVM
         exU5y9LCeSMmn+wxCtQ5N5Zs4Vb7rFYlmaacMWeXyDmTmUUGxNK18EBrvaQtS2m8I/7D
         HtywlOY0mwddJTf7B60obAgxXQD8oUXNyNwq4weYWSAR5W84FFlItPXW7D7FREgE0RVH
         Uu8w8u24wEC7m+I9h+Vov+BbppDgH4qRnev2adh0Z+AF72JtXojL7c39LfkFcivVEWSy
         wkww==
X-Gm-Message-State: AC+VfDy1uNOZA5fhxTZnabyPDae/cxLzMS+khlqIeEQVuIIFK0HIIPPf
	bqIbbN1Y02JqegXJl0gYVeE=
X-Google-Smtp-Source: ACHHUZ72t5zWk7QJMTtxie0kNq6tAKOoMnBbsO+nG0/0A7HkPGcLXoLkFKtP/PT+OFsHQOl+AfDkDA==
X-Received: by 2002:a17:902:e314:b0:1af:cbb1:845 with SMTP id q20-20020a170902e31400b001afcbb10845mr831019plc.16.1684812146132;
        Mon, 22 May 2023 20:22:26 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-65.three.co.id. [180.214.232.65])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b00199203a4fa3sm5506843pld.203.2023.05.22.20.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 20:22:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id DEE6B1069CE; Tue, 23 May 2023 10:22:22 +0700 (WIB)
Date: Tue, 23 May 2023 10:22:22 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Message-ID: <ZGwxbvrafHvGQHme@debian.me>
References: <20230522190405.880733338@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xyvu2VAPqSGMtjFj"
Content-Disposition: inline
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>


--xyvu2VAPqSGMtjFj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 08:05:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xyvu2VAPqSGMtjFj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGwxawAKCRD2uYlJVVFO
o8UEAP0fJDfOXL6dJV+IDtNwbj0q1DmsvnKafWz2X9fVDX5FhgEA6qLBfKb0Eilc
5l1zOnsWbs1I86zF8AXAv/LkTnamGAU=
=r88Q
-----END PGP SIGNATURE-----

--xyvu2VAPqSGMtjFj--
