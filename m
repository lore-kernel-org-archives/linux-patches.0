Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B2A7E
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 03:47:18 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d15so23688766pls.6
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 19:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ17yhKWFDqZ+SHQRDJxc5imX3OxMscf0OQsvoIBMJ0=;
        b=YUUeuIyRPRAiwZ4Uj1PPCzN5xynaLcmz4yhKPneT65KMv4YTOyNIXneP+AH9L8Gp7p
         Q0OsMo7knRuYGCDy1RlxdzyDi9Ct0pBvhRzKkWguf7o40xsHPKUvLWg1D6gHpxNrw/xQ
         y/8e2BVgTHcpM1rtjYQa6LOnZW0jBdg9qGKxrm1XbAReYxivRO2HPE5SNb9L2FmDCuIq
         o0CCXaOBN8fbU2PQvCmaJw877fnBT6jyLSWwepyhzvN+MhaS/XLDjFKGLsn1mbgiFUHG
         XNkRa+A8NlW9YyYieOfMDcfSTR9NLyA6rFtjKcJqcokKd1LFLvN+0YcBAi3jSeYuj+lJ
         h/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZ17yhKWFDqZ+SHQRDJxc5imX3OxMscf0OQsvoIBMJ0=;
        b=as6x0wvnNp41zn6kX7Q9vNRAXXNggq8UfaoyqocKQxzlDNTIshK0gRmbKm0yVkHmZs
         KqEEyRtZgUsvxcdL88qoM6zAOd3t7I7qlvtB7NLUdlURttgSBkJyUKtmQHlE+7IimmQV
         UMPQgvaB8BBGtIWnaQasyvi6zevMQpbUEQ8TaWqjwY3VOVj/8ngg3HGfRqdiF+3A/fTk
         KBA4hI89KRAIV/wO010eLTSlpxRZI3JXsHO+/C5UZ3anxoz9UKY/d8d7VKV0QxY+81qz
         er6gDINlG/3Qe/UumJNx8PQBuq4+n7OGrNljuXZRX2XlLuNsq9vcpEU2/Bb2eBNAUh3/
         gwHQ==
X-Gm-Message-State: AFqh2koO4pGHgkrHeZEnOGuvGalBVRvJSRDkpH9mEbxVAsvffjJG8GC8
	lSHdQCSp4imFm7zRADE2gps=
X-Google-Smtp-Source: AMrXdXuJwqh6YlF5u+ffcokw3pTMt9MRkwVQOwRHLfVqRrCDcstzwf/lM31BpGjcW2vUs4wqSiKpiA==
X-Received: by 2002:a17:90a:a594:b0:225:fa96:c744 with SMTP id b20-20020a17090aa59400b00225fa96c744mr20670478pjq.37.1672458437822;
        Fri, 30 Dec 2022 19:47:17 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id m7-20020a17090a668700b0020aacde1964sm12129432pjj.32.2022.12.30.19.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 19:47:17 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id DAE2F10403B; Sat, 31 Dec 2022 10:47:13 +0700 (WIB)
Date: Sat, 31 Dec 2022 10:47:13 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <Y6+wwW5qSFrsqFg3@debian.me>
References: <20221230094059.698032393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aczY2dE2gsUMA0vR"
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>


--aczY2dE2gsUMA0vR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--aczY2dE2gsUMA0vR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6+wuQAKCRD2uYlJVVFO
o5xzAQDrZbiTSMDPBdNuyLOv+1ad51pMftpgbo5ghiSqKTInBAEAzqf+jwoFvsE+
lSfOx2NeuzSSl+7m/BD/O+RaIZrBjA8=
=xQX4
-----END PGP SIGNATURE-----

--aczY2dE2gsUMA0vR--
