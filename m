Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BA62B
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 04:19:46 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id a9so16504844plh.11
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 20:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678249186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NdnP2NuqTUPQR9c97oNwJuHVigZrUCMRYT3RPXB4eg8=;
        b=CGW32gDUCcp59MH5OiqxQi4X/6gx3MXDB8I8Ct3qXET3WQhZ/Bnkc1I9D38/g3OrB9
         rCXrf+TgjAvAxsq725JWYYtXxpXgaQt5VSRmqXC9DJ6SqmGJmjTF5MX+g6HNjThlPE9E
         WRkDWkEtCL+zOB44OMU5hg+Lb+BKMXMxApSl9yzrWGI/WrILwKta7+DQ703n5YMx7Zqt
         K0QArZGzeU40rsTCXDbGlZ3SOnGL0j5/N5ZParu3xXmR42PJFXaKP+hAjdex93eSncqP
         VEQxYraDPElrsVIbkVn0hoiqlMxR55bLRnwC5H7l70n3JZHNmQ5aYT0CEuI/4ETBUMRX
         vJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NdnP2NuqTUPQR9c97oNwJuHVigZrUCMRYT3RPXB4eg8=;
        b=FWTC5FPBy8r5mEdgxP5PcJtgm3ZtPxKZ2oqUEOrTC4MKv6Vth3jHFisb6TdkWJlTqm
         yGezvlAYOUGtdDqlTxY3vNMqsISrKM+2NHwEjSsEcHmXOGsgYrf1xrCjZbUYAAEUsE0/
         /qDrplJeqm9lVMev4MiO5L0/rPI86FYEML7p6cab6iwcFK/Trgpyq8TavpZ7lutbi5IS
         Hf3AjZi/JHKlmymbjJ1Wvl4jyAKDL2amT2iahSDDpyhNXloS05g4HM7ksGfsd8PurSnb
         FtRQK4qU6shiaz+Z5Wz2Ply5SrC03+qC3xColDuPXhkQjh8l6O9W3u0YqTZiQ8xKVzfx
         9cbw==
X-Gm-Message-State: AO0yUKXqaIwr0CzJoCBfABRPs5f8n7HyoflqiFyrmDp1sffLK38CgiHp
	7Mad1B/W3bYXPdAfGhhVnlk=
X-Google-Smtp-Source: AK7set9jbSODgLHbXn/kAV+3HwfXtJO5bm8WTPGni05zefS9xzKFRCjNuJf0+6IAVIjT35vJc3HJyg==
X-Received: by 2002:a05:6a20:4290:b0:bf:5d4e:704b with SMTP id o16-20020a056a20429000b000bf5d4e704bmr18072653pzj.32.1678249185667;
        Tue, 07 Mar 2023 20:19:45 -0800 (PST)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78282000000b005905d2fe760sm8640309pfm.155.2023.03.07.20.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 20:19:45 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id B189F1065BB; Wed,  8 Mar 2023 11:19:41 +0700 (WIB)
Date: Wed, 8 Mar 2023 11:19:41 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Message-ID: <ZAgM3QKYAjAwUPAC@debian.me>
References: <20230307165905.838066027@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bUJ/i8HoDBY6xz5R"
Content-Disposition: inline
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>


--bUJ/i8HoDBY6xz5R
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:55:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--bUJ/i8HoDBY6xz5R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAgM1wAKCRD2uYlJVVFO
ozYNAP9XfjII4wqBZaXGJxzXWRLdClapsON4hmRauDKRPGMM9QEAkWpRvIRY0hFX
Jr8fqUFjjsTY59i1MLn15rW0FiNJqAI=
=jRwl
-----END PGP SIGNATURE-----

--bUJ/i8HoDBY6xz5R--
