Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C4115BA
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 03:36:14 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id z18so9798368pgj.13
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cc5DrnEojv7YzJeakKQDE2SxbRr1LRl34O5JQg2M6PA=;
        b=awX3m9vefbZpc3RuCHE7jwwzjw8g250qVtMe4fA0XdztKNV3oF4Qz48I2beLUTlx+Z
         eGFH7EEwbYVEM4Z9x9Lp5BYSqbvMvck1Ql5Y3vhrakrr6vY9qXniDu0uc21psLy6rhaM
         z9dJo/2lKryXLCAP+jN3J4raQyMmb97/xSVUHtfDGWHZF+engVHAu23KPyzOaSNkCzfe
         dEvEcwDJO89ueQVR2kIG1A/Ai3BZd/EHJaQK8Whf9ruaYFCCzkKosxS5RaQyPDPaGk68
         E7zn8A43yoqaO7qJ0G917eUNH40Tgr5hv7uJnyzmAL3Df0gKpX7YADP/oJXWFBLJzQTg
         MZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cc5DrnEojv7YzJeakKQDE2SxbRr1LRl34O5JQg2M6PA=;
        b=Ok6Bn4h0n1GRQzu/Meop9++O9zK/83FE+3HgylQfx7HOXjIfY5WYIG3E+0AVfaxFeJ
         H6xlPFKHCE3IhELKTCQEHNI+W+AQ8J1nxT280vQfEB0U0vO5CB+R2ah4T4Gl6IdJ1r8r
         SlXEwgzFIWKHJqOL1jSbHx+ycercxebFMZSoKtgg6glK2ySHebhJFJcUW1icWoJqJi+b
         jCSWvL7FK5VsU1moF1Pu1cjzgzPv1rh1r0+SYDuu0MNEW5r6TtUgL8/0ZjsNMicDsz+D
         d2HvoK0ZxTffdplEg3UqAREZLX8RxRZ1LGmXklkPKzRefCJ+rD9+KJ1Vk15Nba1nC68I
         AgwQ==
X-Gm-Message-State: AO0yUKWtqu3sQM0Ahf+sKuoyIt1XGT6e3Tj/bOFsWN5psIMC5Klz8RV5
	LNaBNPqW4tF7Sc9l/CGqTHc=
X-Google-Smtp-Source: AK7set9xQymjHsWW4dxuyE68uy9S+v5E3RymCn9aJK+gp2C0qZe4RXxZjI1qHxQBmvGQmfONI3RrlQ==
X-Received: by 2002:a62:844e:0:b0:622:ece1:35d3 with SMTP id k75-20020a62844e000000b00622ece135d3mr868953pfd.5.1679456174115;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b006280676b8b4sm3653085pfn.220.2023.03.21.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 20:36:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 43A21106772; Wed, 22 Mar 2023 10:27:15 +0700 (WIB)
Date: Wed, 22 Mar 2023 10:27:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
Message-ID: <ZBp1k17eviGPhnnW@debian.me>
References: <20230321180749.921141176@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IKKBsrAChcI1rFR/"
Content-Disposition: inline
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>


--IKKBsrAChcI1rFR/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 07:08:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IKKBsrAChcI1rFR/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBp1kgAKCRD2uYlJVVFO
o+i9AQCnTzbFhfiMLuDyojdMj1c04sIPs6urEuudcbYtprPrPQEAzNZiWhHQNnQl
99rE/5k5fDZCstp+6458xOgtWWZEHAQ=
=8Hhb
-----END PGP SIGNATURE-----

--IKKBsrAChcI1rFR/--
