Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D54418
	for <patches@lists.linux.dev>; Sun, 31 Dec 2023 08:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DMUL90XB"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-28bcc273833so6659933a91.1
        for <patches@lists.linux.dev>; Sun, 31 Dec 2023 00:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704010261; x=1704615061; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qNU5f1jiVvfWfhV5Quib7e5NTPQnlPBAE6ShQ69pG70=;
        b=DMUL90XBuluRRS3V0dWeCAeeG+NeHcm9d/5sKI6wT4z3brbIE0lNIOVpvuu3G5d0YS
         BEtTF461WyNnLWGEgDL+72wOsFxgAo5FsrIXMgAW9weZ1LrPmwijz9uNaZQ8Me/3dfVl
         F7Zy01C0xiy6iryNJOOv4equouHtDd/jCYDmLMrdIb1duNkXc6C83LGoOjcHJL3yNtfG
         +ZWG+RSsXMwnLqfA6TnLgRI6BkQ02SYFSh2EyNk7kabPqYK563B7N3kWJmEMMqb2sxYd
         15YbSqToDy9H2YXewnuCFgwP9eqyoTJmoMSzphWjkaPiYRSKB5+mz3J83kF/TTwV4nuU
         1jQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704010261; x=1704615061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNU5f1jiVvfWfhV5Quib7e5NTPQnlPBAE6ShQ69pG70=;
        b=uVSc/f6UGQ3PRH2TaRDNNnFoiMvyemm+NF6Hx+Ue8DWSlxDjLfUMX1WEFW0qVZG82f
         H5upB8LOcpV4PUR1RTcCQzGkG16uCcui3n7KSoq1pyfAsvUcdgxogaPlsHwULUBHLiEJ
         dg1eiaRXuFi1TFQavijupWt+AMKHfn+VLDhjZqS83INOSasV7nPLd2BfoUBAHM11Quy3
         /9Tex4707fT5IgSS+bmpEsFiCObbXhgW7nV0lSj6y7QP/fW43rKmUm9J+CfC5y20j661
         K/ErW+GLkgbmXaXMAuCO3YdWt0YraQKdNNsblRNVbjbJX3p849pMZnazQ9wDTpWvtVUA
         3K/w==
X-Gm-Message-State: AOJu0Ywoiu9HXa6QEYPh3igm75pzwZ74ILx86rfCNoPWkdcsMzJlkfSi
	VOrpZIVHhQ/HxgWAyNER/ew=
X-Google-Smtp-Source: AGHT+IFPMMmQXICk0Xsb8doenjlLsZpwV0V5bK2hxpjhNQxxQC9+e21mLcKuBDT4Q4mHiR2ZbxTUNQ==
X-Received: by 2002:a17:902:daca:b0:1d4:4768:5f with SMTP id q10-20020a170902daca00b001d44768005fmr13873909plx.37.1704010261427;
        Sun, 31 Dec 2023 00:11:01 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id jm7-20020a17090304c700b001d3e6f58e5esm18232091plb.6.2023.12.31.00.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 00:11:00 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 981A610213F98; Sun, 31 Dec 2023 15:10:55 +0700 (WIB)
Date: Sun, 31 Dec 2023 15:10:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/156] 6.6.9-rc1 review
Message-ID: <ZZEiD_ONxq8TYA4O@archie.me>
References: <20231230115812.333117904@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B1Z6bosjNKpAgHCa"
Content-Disposition: inline
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>


--B1Z6bosjNKpAgHCa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 11:57:34AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--B1Z6bosjNKpAgHCa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZZEiCAAKCRD2uYlJVVFO
o26yAP9tYDzcg0457MaAvIx3MLTSyyhIS1qzU7VLxPRpjXxUcQEAy0ujbZo0iOYC
tqCz07M9cy0joTywum50wyTerTV8jQg=
=IVGP
-----END PGP SIGNATURE-----

--B1Z6bosjNKpAgHCa--
