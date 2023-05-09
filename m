Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB9392
	for <patches@lists.linux.dev>; Tue,  9 May 2023 03:07:12 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-64115eef620so39260295b3a.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 20:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601631; x=1686193631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JvMCL94HWXtWXaOhm3x+6fo3/iFeZR4RzaE9AL9QZjw=;
        b=QFZQGPsD1BfzCUW4AbgKrpjQaC1YPI/GFHIglygbGb+FHpJBb0Eh/GVVKUO/a2CWdD
         dbNu1Gp5lR1RbXj4O+0S5YSiuw6Nme7L7TdDIyX4Y4ZHKpzFdCsc25wF6GFqhtrRj/Oe
         oezyVgkXk0+SI1JjLJ5Aj34qj+Pd2wpnZWvvxYoUgStjnfYcMY3L/4quZIIaahwe6qqq
         rHNj5Q/pzVdemgsNR+E9wVWvGu4+l0/5oYNFwg3lzANTc1ogSx7EwCmdNnb+nZKzktTT
         uk5ipLaU8rKplfgJddruHLO9wZCMn+Dk7SsrJ4JuNWLwM56jc2HKsDmmhGfZum5bKVlI
         IKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601631; x=1686193631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvMCL94HWXtWXaOhm3x+6fo3/iFeZR4RzaE9AL9QZjw=;
        b=Kb0E29/cv5ryYTJDdWZaD0ZW0zlViRiEWsv3g8OZTOFoi2wGmL/N5p7Cgewn+GwV+L
         F5k7JoG3H4XTiUnRFi+KURPEvbxC8gOvRYMOXFwCiMw6AJ2PCJR1EmkyfYTCcurmTybS
         jnHXmvDUzd3pEVRFHLSoBwoM5UuECxmR/yWG7+St9npkxdKZn8XQp+uMvZSaazctwPIl
         6y5NhvI1ue4b/4OcQwwuqvR7QmOm7bqe/KOnM+ZPCn0xGUZVPg4iSwq9zyxuq8d7QW3b
         v+UPNIptgQBeSMW9gBpYoDu09g9qtJKaA0+CN877S2kc2xLLn1dAxwCSJWnvENQtprG0
         BAMQ==
X-Gm-Message-State: AC+VfDyw8M6jepofI6fq5nUjRrFcjwshlZ/pOMbcBiN9b3Dk/rhx4NHV
	yqx/lVE/xV1TRvyPmkgp+mY=
X-Google-Smtp-Source: ACHHUZ4i72BhMuhdVOUaapXiiooE7xVTct+mEdco635HDQ9hdQZOQU2mEC7xd7qquoku8W3rcQlLEA==
X-Received: by 2002:a05:6a20:4420:b0:fd:4273:f45b with SMTP id ce32-20020a056a20442000b000fd4273f45bmr15571802pzb.29.1683601631521;
        Mon, 08 May 2023 20:07:11 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id o33-20020a635a21000000b0052871962579sm208121pgb.63.2023.05.08.20.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:07:11 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 473CD1068A9; Tue,  9 May 2023 10:07:07 +0700 (WIB)
Date: Tue, 9 May 2023 10:07:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Message-ID: <ZFm42pTaUG3eHAOc@debian.me>
References: <20230508094432.603705160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="saZ15ehIGs6aFYK6"
Content-Disposition: inline
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>


--saZ15ehIGs6aFYK6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:37:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built bindeb-pkgs for my computer (Acer Aspire E15, Intel
Core i3 Haswell) and booted. No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--saZ15ehIGs6aFYK6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFm41AAKCRD2uYlJVVFO
o+x8AP90Lq+s2GGcwxyRb9hzvNGUrV705Jn0xjD9qaXeU2IVMwD9E1Pqy4nicVOA
00HXXWTvsNZCb8fzdRpz1hpdICraDgY=
=e4sA
-----END PGP SIGNATURE-----

--saZ15ehIGs6aFYK6--
