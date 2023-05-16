Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF67168CA
	for <patches@lists.linux.dev>; Tue, 16 May 2023 08:21:57 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1aaf21bb42bso97865015ad.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684225317; x=1686817317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i1tMLW6DSWJAntE+I5KuWI3/gKXK9s6L51FeppahMts=;
        b=fXe2aaHfUQG2KOp4zGNCfvmgZMOcSYl/YktISj9YlZz4cdvcya36Mdbk26BupTyeex
         Nb1IdMYvTqX3V6gE0sYW6C6tn3aWXd5WlOZHIoZ9VrSCiA3llbJ41s1n0bSfgIUd72KS
         KIMokZRQfhzRLvHhiWmHgZ0QR8Ked/BGPmTu+8g3kmsSTB0yJLsT0krOEA6cAfzs5OOe
         dP7ufWH70Da1Yfpmaaugb1KDjmUhYGbAzDZM/IG4w6qDwQ7jtdg8AFfiG1saB2CkArVa
         Id7JRSZOH4WWaymFgeeYkwBYsBKlXA7hrHyzXIk9C5Jnx15q+7p8WPmtoTu/4Xdui+IC
         Ql1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684225317; x=1686817317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1tMLW6DSWJAntE+I5KuWI3/gKXK9s6L51FeppahMts=;
        b=aqRD8HbisyIl+vcF1dINfIv4PE4g0mRun2LypRnaTtJWwAqi/SB9wALtssuhR7Tmqb
         zpu/YD9swMm8dD7rBki7VszOGF26sn4vhJEavxPZ4NMf/jgkp1ISp49xSthzlL24nFra
         SxDCuRmBEe/ACHTlReAIu1OtlQQ5/vFXk0XewQXHLQXqidwKKFQo6yTOm+/DiJ11k/2s
         PFmY5gEDQlFWxMOsdgmgg3d1J1azjHdLIgg/HarBVQGZ2apyt+qTQIYexsoUH/3+bGaF
         S4QMoG3eFaNzuxax565bJ/UNMam+ytdT18Qk2qgVwVKSzL1ZpzpPfooZLVB8WEoNe/mh
         HPhg==
X-Gm-Message-State: AC+VfDwahQeBVWVADttfeh4IF4E+/KzphAKVkFlA5F0NgCsAtI3R35ny
	3IlJFSS5T8do25cLg5DDsf4=
X-Google-Smtp-Source: ACHHUZ6r+lC3evUL4hZ/DojRzT+Z0EuyD4+mKiusnp97fHqX7MLzfh2KfqRInTuiytCLFBBt9rGzlA==
X-Received: by 2002:a17:903:2452:b0:1ad:bc86:851 with SMTP id l18-20020a170903245200b001adbc860851mr26642602pls.45.1684225317073;
        Tue, 16 May 2023 01:21:57 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b001a800e03cf9sm14841603plk.256.2023.05.16.01.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:21:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id CCC32106212; Tue, 16 May 2023 15:21:51 +0700 (WIB)
Date: Tue, 16 May 2023 15:21:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/371] 5.15.111-rc1 review
Message-ID: <ZGM9Hw8eNLr3Ay4/@debian.me>
References: <20230508094811.912279944@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8VmfzJecd+40CVXP"
Content-Disposition: inline
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>


--8VmfzJecd+40CVXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:43:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8VmfzJecd+40CVXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGM9HAAKCRD2uYlJVVFO
o8pxAP9jb21peI8gAYzgNHmohZHbJNs2E1nGig2qbFWQsb8BfwEAzYBNzMugQtH9
ePnO8axssFE7feYe3fEblNxw/mqtpw0=
=RTB5
-----END PGP SIGNATURE-----

--8VmfzJecd+40CVXP--
