Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645DA371
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 04:32:13 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id a14so1023007pfa.1
        for <patches@lists.linux.dev>; Thu, 15 Dec 2022 20:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oHCCuw298uC7S+tMrUZ1Er7Xg3PYJV4C5yb/JEiVNoA=;
        b=RnCrxue86DUp4v/CQ/uLrjdjijleouqzV6EAFoAhsHkyHDnTmpVG22/LV6jN79czkX
         jOPjexWjtesLSQs1oO+KVWYLoHaEGTg63vqv7y59pk6dhq2NP7BtmZLMzzVuzym46i+J
         kAzIDljQls6r470dBtCWp+68vxHbFa7Cuama6FQFwLdZG5uBMHkhbVWJzFlY4W/Htx4m
         Dyn7xtnKKGvlrdGX361WzhAxae8AS8PFQKzVqqRDPwPwH0/RX2ZMaFw6mQQSFontIsUC
         mQbM1B+xVYZW1GAyUeQTGxUk+lJq0WPmhEcxmuJseqnTp4MeoeFeaA4xx4AUK097vR8g
         p8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHCCuw298uC7S+tMrUZ1Er7Xg3PYJV4C5yb/JEiVNoA=;
        b=RYsNPRtl0l/v9PIP5DowfQ7pJ/aKxXL7mtmCMM3HZpqNO9abCpHeiAtNCY4GQgCOd8
         4QTqB7kMC/gMvD4APAh9WppMwtTPXW7CpAgWmFmmRIuqUhfZjSLzir11EiHwejTk17Kw
         dpBzW/BCp4iaeW7vov647zBTvKipmjT+gbQ2IC2bNx1i7W0cB+I1nPsjhjOLPqiTESYa
         LnPUFkP3Aqf0Fxg5T8UzSeNFjFQc0+IoH6MK70QUeznlxyuWZj2RitwKBpCy1LVZO8Jj
         aLoYsEBhGd+ocLKyb8p70ORc9Qz88a+kaSH3r8kEtXNDJZB/reEC2xCohvK/KxBSGAIP
         7ZLQ==
X-Gm-Message-State: ANoB5plIMdnzMWbQzQ7lyfrY4kzSPegRjXOF3YBnZN4TKMTCZm0+yoXo
	MfpVv78k+0M5NvplqKB3oIxFUexzuAE=
X-Google-Smtp-Source: AA0mqf7EThoZQ2V9zANsJYr1MDcCbwdh92xbEddue3cfypQWSUeGf4ZBkho2m4H38b77I1g166xTxA==
X-Received: by 2002:a62:188d:0:b0:578:777e:7f18 with SMTP id 135-20020a62188d000000b00578777e7f18mr22783552pfy.3.1671165132698;
        Thu, 15 Dec 2022 20:32:12 -0800 (PST)
Received: from debian.me (subs09a-223-255-225-73.three.co.id. [223.255.225.73])
        by smtp.gmail.com with ESMTPSA id z29-20020aa79e5d000000b0057524960947sm442027pfq.39.2022.12.15.20.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 20:32:11 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id F0D14103CCF; Fri, 16 Dec 2022 11:32:07 +0700 (WIB)
Date: Fri, 16 Dec 2022 11:32:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <Y5v0x5wIRbNj5TEB@debian.me>
References: <20221215172906.338769943@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="R180pMqcGnsqKwiS"
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>


--R180pMqcGnsqKwiS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--R180pMqcGnsqKwiS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5v0vgAKCRD2uYlJVVFO
o19nAP93ROelBBB1P6C+ieeJtlERdLdkjdze3O1tkcqWnTdnPwEApXh94oshE1FZ
+zFALVEoatEiqZ45KBu38BY9mUG3aAA=
=1cFY
-----END PGP SIGNATURE-----

--R180pMqcGnsqKwiS--
