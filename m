Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3D5662
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:21:57 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3a9b41ffe12so1135905b6e.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693560116; x=1694164916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zGEwguk6bLI4TMWGrtViIzYLdjlDbX1BQNkbUmaUR94=;
        b=VWhUZDPeEh1UD53dTNBn56WFO0Bdk8t7agfYOQlLYgcAv0KfwofqwyR0agGAK2mXhq
         aIRyD6nRLCF8E4T4aPNWfrYCE80jZfcBzcvD2/yZI4z4Q28KDthnASgCuQG7uFnL53Hg
         A9TUe6B8H23MrFPmEqg0OaWuPAjygtAMxPm27DjTUKjk0279AVsni/846t2J/NWPS8xH
         enRIm+mwz2khfK+zQ1JeUS+2tfcxQlB9Tr6IC1jAVUFltkt1fEJ5xTot0arQWNNRNvyr
         8xG8Q/wDz4PegdI02yzk/cdGFhc3zrpi1Xcmuohvuapm0pvpV3uLR6u25l0Z7AwPqZf0
         iSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693560116; x=1694164916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGEwguk6bLI4TMWGrtViIzYLdjlDbX1BQNkbUmaUR94=;
        b=l8MUi/czqfl1jTd1hsmWQvmfPDELDuutsKVYTWQlSFpdU6wE8fwdt8d1T4KgGE9Xsy
         Kka4j2V2mR2QwHNpNGNFXRfQ6CgRxqzpMu3cT+SNIwbveH6re0NZVYCxicUhHd1lz3SD
         M1vK9SVCGUqNNEqS1RV55+N2H0eqrohZvFJfbMurJOK1Ic6odULxCEWxhJhyJambW4jX
         nfk96NOLzdpho4XtmA3HL7sBtMRKvVIEmz0LxuFTsoJM75TBoqIM/r7+B3Yz/IORhfJi
         DqdrAXrFnM6fS4M4LRii2Occnp+7M1vbX/+Ydy0FmkTFkXxFylvS99zfad99fdx8nekE
         5/fw==
X-Gm-Message-State: AOJu0YzJqqixrZlJGxJIVoKyrPM64pmkH+Qj7Njl0VlBVTkxD2g+oB1b
	NOIOHzX9/zdf5JB2s7I6USA=
X-Google-Smtp-Source: AGHT+IEIUPD+Ar7lDbOhlDJNHJ/6ZyFcCKOajT3BO89IbRVcAGO6nunvAnPn+SfG56qrN7t/pXTymQ==
X-Received: by 2002:a05:6808:1296:b0:3a7:2390:3583 with SMTP id a22-20020a056808129600b003a723903583mr2699702oiw.38.1693560116146;
        Fri, 01 Sep 2023 02:21:56 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id i8-20020a639d08000000b0055c02b8688asm2422292pgd.20.2023.09.01.02.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:21:55 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C31538088641; Fri,  1 Sep 2023 16:21:51 +0700 (WIB)
Date: Fri, 1 Sep 2023 16:21:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
Message-ID: <ZPGtL8DCiYafUQTt@debian.me>
References: <20230831110830.817738361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Pv+BAIQRhkySjQQZ"
Content-Disposition: inline
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>


--Pv+BAIQRhkySjQQZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31, 2023 at 01:10:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Pv+BAIQRhkySjQQZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPGtKAAKCRD2uYlJVVFO
o2y7AQC9eJJo28wE2CAflX8IzbkSvMiatqIpPiGTR0rhnfYNywEAykf0dUUKdS9h
CllKx1cOKa+xT9WwHmYj7NmNagE+8go=
=EqcM
-----END PGP SIGNATURE-----

--Pv+BAIQRhkySjQQZ--
