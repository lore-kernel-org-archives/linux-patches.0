Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6227C253D4
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 07:04:18 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b8ad356f03so31337655ad.1
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 00:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689663857; x=1692255857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Axjn/sYToZar4H60yNlZc/j45/MEqGujqOR5kJMzvQ0=;
        b=syzFUPiuhKsHj/zRkF4XZWy3HiXxr1fNbAK0cu1r4Jl0h56tac84Lll2SB1AN7aPCn
         mTv5xSMW3CQBvvKoNc0KDskxHstGj7iIyJS1f8oJaztk95QjaDhhgPmQkc9zekHrlAXz
         IePwGL70kBs11M9sdeJGusbs/4livWRpu+nlIIAospZpRfEgjAUNweonSW6belL4MeS1
         bzxDry1QiGyqxPhr26G85KiasmJvkWxLToROvKpPZ5DIwhWrQrDHpaXZXQGi5T5iUSek
         q86SCq12X5DnfziKkGg7nC10pHX6EgGm74coSguJo1zOIHSe63GNYXRyn2xmn9peuxe8
         DnWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689663857; x=1692255857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Axjn/sYToZar4H60yNlZc/j45/MEqGujqOR5kJMzvQ0=;
        b=ZqkhAjSXEVk2Zxd0xuXQAmntJkYfZ98WIeK3O0EDSE1spAiQzk2QIIYB7HaJbuhFOp
         NDXne5hbCyHvkkyxf5aMdm8BKGuvpcIlNQFj/nd43HBBwolcBn+7tRhsfB6PMpO3ITJM
         D6Ffdikd0C8S26p2RMRxOgI5O4UmHu+kYh6tbkatvUIYL9uCdesij4EiUFd/YpfhPduk
         Gu7F5MppUcWt68w850J7VD21OxBRqifPAiN+dub2+ilR/axxNJsAvAoIASxy8O6zodOt
         h1b0WXi40D2i76xLbSY3LTrrYFOexT52Iu7aEel//qoWm4YD6+hY+m1290E8Xkz+TrV/
         gkPw==
X-Gm-Message-State: ABy/qLapJ9hq8bJyY19iH/xCBSb7Wd1Ug/tSM5IKjIL3bTRhP8hUSuy9
	8gK1aKUzsxGjBtgZ946+TLk=
X-Google-Smtp-Source: APBJJlFWRwBzYYJtipfyQ3793K1v9vPM0jcqBgO6bDamwOYRvtq2qTt+gU9+hQGIPLxW03UhNqBcjQ==
X-Received: by 2002:a17:902:d3c6:b0:1b8:9552:2249 with SMTP id w6-20020a170902d3c600b001b895522249mr12243330plb.43.1689663857458;
        Tue, 18 Jul 2023 00:04:17 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id a22-20020a170902b59600b001b86dd825e7sm1053041pls.108.2023.07.18.00.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 00:04:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 985AA8191864; Tue, 18 Jul 2023 14:04:13 +0700 (WIB)
Date: Tue, 18 Jul 2023 14:04:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
Message-ID: <ZLY5bHubtrAsw1MF@debian.me>
References: <20230717201608.814406187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1sg3vSecY7TDSFAN"
Content-Disposition: inline
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>


--1sg3vSecY7TDSFAN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 17, 2023 at 10:34:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--1sg3vSecY7TDSFAN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZLY5ZwAKCRD2uYlJVVFO
o58xAQCNWexAdaOo/Wb5FVc2wvy9z6YkjgytmGLRAcgWggQmpAD+Ml/DN22Di3F3
Zd/xTggvE2JYL0wtbF3i9CyU7mYJzg4=
=usL+
-----END PGP SIGNATURE-----

--1sg3vSecY7TDSFAN--
