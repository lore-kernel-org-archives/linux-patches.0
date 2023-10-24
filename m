Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768F79C7
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 02:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxViPyl1"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5859a7d6556so3153520a12.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698114756; x=1698719556; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYbdw1OGHS+Hev8vQpJN9on6ARotJmO2svQ7g1yvwWY=;
        b=AxViPyl1aIoaEQF18sDkvgx7bOV7EAsHzf1yu5xwbTWMnjBYdfMKsoEg9VvRVM2jeN
         6B9ZRVgP5lyZAE8qeqyHHwBOOypPKjmhC9VUzVdX7m4uC9xvyjLWdLld689q+iZvMlPa
         VgURRB5ZYm7Zlyq/Dz2JNDE9z8WVBSipE6YuLusKfQt/9wXD7/N5YYSKQL/2p4t2krgI
         jBwD6N9YE3IpDIFGiRSiAQhQE0W3mJi4X/dyNlNuADsS46+9APz0VEEYRb1spn4XY2MX
         Qk3DKaHU7USd+Kat9d2t+kOvZaS4ypk7wkbH/9vLKhxMpX7448xlj0Rvu2yqzKodkxYI
         VJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698114756; x=1698719556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYbdw1OGHS+Hev8vQpJN9on6ARotJmO2svQ7g1yvwWY=;
        b=ZioqS9myki9+bVlG6FbRIOcGthDLzBAh7Pehd1/STiLJFBsL/gsfPwfUpYqZC9FOu8
         SXsefC2qhKsMAT303fKsx2rmo/R35J4Tun5qXVLrAW2GsHoM79rlw3tiwixO1x6ezc/W
         BCVkopsxIzzaKnaWXjbfIAUkFbZRqi1MwsHtC0W/7uM155yQQ8UQH3HzvP28iR0s0dvk
         vOjW9M0sDI1HcbUJh9sv1l2kCVN97ubGpvtU563PfkZyAvD94KHr80BZmOEmsL/RwJEw
         6q/NbN3zlknIf6Xy8HFa3IXMgih9YfcuenwAEC94RMtb5n2hP1+UIl8gERf7PSW9dkDI
         k81g==
X-Gm-Message-State: AOJu0YxK3bZ5oKoLE/bxeKV2uQYG1z7IsMABIFBSvCpGzbn6W3bidtdg
	2N+Iu/imise4jgMz+xFoOso=
X-Google-Smtp-Source: AGHT+IEgGLoEe6xUiWhp6CGY6KR5dAZd7dazZc94bf2Wvrvn/dPZVonoKIIPf/n1xYRf0B1n4eJFxA==
X-Received: by 2002:a17:902:ec88:b0:1c7:733b:27c7 with SMTP id x8-20020a170902ec8800b001c7733b27c7mr12300723plg.56.1698114756391;
        Mon, 23 Oct 2023 19:32:36 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id iy20-20020a170903131400b001c5fc11c085sm6611318plb.264.2023.10.23.19.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 19:32:36 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 8001F8155C30; Tue, 24 Oct 2023 09:32:33 +0700 (WIB)
Date: Tue, 24 Oct 2023 09:32:32 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Message-ID: <ZTcswG1m3hzdzz38@debian.me>
References: <20231023104828.488041585@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UW5aPAKQ5y9VxUhj"
Content-Disposition: inline
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>


--UW5aPAKQ5y9VxUhj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 12:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UW5aPAKQ5y9VxUhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZTcstgAKCRD2uYlJVVFO
o3jRAP0XqZesn2EP0Y3/mLCengEAvBjIWlbNyYAruaHRRsgipwD/bIpv0LPZ7GzF
1j/29mV0Zyk4E6FNrZT0LILkDVwptQI=
=To4G
-----END PGP SIGNATURE-----

--UW5aPAKQ5y9VxUhj--
