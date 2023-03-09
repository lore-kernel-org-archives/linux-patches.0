Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218557B
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 04:00:04 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id i10so679629plr.9
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 20:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678334403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IO2HukOAG93wp8Ck/l5gtQzjgmqxHWZs4HqHAokMTKA=;
        b=XrVkrppvNGPofaZJVDKW+UcWN4PGB7IFH9Mt8St75HAlYwY4J8HPbWp4qtLToingyL
         3HPKVVKermidtivDYR64f+PZHBjiIgSvauctV/e56dP9sKoYBKKy+2I7vHTPo/GtNevA
         FVn3DifuijKV5IxvCEmGTNKWMoHb6AErvEbs8//SF0UEYwGsmMG2SPUhGhPbW1bnsNgz
         LKNPbTg2d9ieDJX7C914HxNbXHRHqurkcjypwU4B4/MPGBbyxbna5RbiLzw0h5lSAto+
         iIPLVGLBDNHLcD1NuIhbkulaWqtCYQMjQj+cT7wYKhaBCXJw7hR2HoUyPQFcpz/LwDYz
         hQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678334403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO2HukOAG93wp8Ck/l5gtQzjgmqxHWZs4HqHAokMTKA=;
        b=mmgNCrVQjnLpP2v1gBAqe66yfpTDmY6jVeKevMarijDzU1gysbYx32IvvWP/IdtyUv
         jcp6BkJChkI4LUDNqDB9GEVxoCxWvVMO9s4o8ivhm6MI11GYncnYitBCtmg657Rrn0lr
         mjhsKFJexJAhDYvMAy19YOqDfsUUGwpRlqn+J8690COC8eROdZbRZlJ3AAMyrtF7lKpx
         k1Y1hBbCfTcYEhPp7u3GAMWgBdloWsJvOsJAXeJtLbtnWPqCy37tLM4rL2tKW2f4nctH
         JsBZ4Y0ngC2+xoMO+w+yuwrEMpekDk4D57p6aQEFrrpJSXegEbasCWcjE4FT1FDE0/um
         fvYw==
X-Gm-Message-State: AO0yUKWvzwFtC8m8KNrwAPreNTmEgxHcglB/JBqZOGtbBo1iEPt7pFqK
	UJ4PuaGvWAnD+28oioS7T4w=
X-Google-Smtp-Source: AK7set/GXvNVsUXMfn40uSuXeO/48WlgjZkGxN/0XvUoJtna33EVZloRC19GjsBxtbQ5hHDn4//frA==
X-Received: by 2002:a17:90b:180d:b0:22b:b375:ec3f with SMTP id lw13-20020a17090b180d00b0022bb375ec3fmr21656005pjb.21.1678334403424;
        Wed, 08 Mar 2023 20:00:03 -0800 (PST)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id hg23-20020a17090b301700b002371e290565sm515139pjb.12.2023.03.08.20.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 20:00:02 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 5DE391065B8; Thu,  9 Mar 2023 10:59:59 +0700 (WIB)
Date: Thu, 9 Mar 2023 10:59:59 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <ZAlZvzlxbKJogWq7@debian.me>
References: <20230308091853.132772149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PSKV5YBeP0Oo/tua"
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>


--PSKV5YBeP0Oo/tua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PSKV5YBeP0Oo/tua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAlZuQAKCRD2uYlJVVFO
o4SjAPwP/J9BipfSry1EAT7kRickV5Q2gbtX4F1PSR0mPORC7gEA/eXdjx2yHGPs
3aX1XpNOnb8qcepsW8mGOHXAwfgcnQo=
=eiKx
-----END PGP SIGNATURE-----

--PSKV5YBeP0Oo/tua--
