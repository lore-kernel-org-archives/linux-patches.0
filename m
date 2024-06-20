Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2831CA89
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 04:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718859369; cv=none; b=b4OOzUX598MXE0HKnooLfWMjntABNsMKDflEtAAA1FlTfJlV9g6CGVwuWZ77kbB75Amh8jibn/76j639Rb+tHyQd36fV908Nbtz9RE4EVys1IO5xACPIvE1SOtQpr/O/pcuw8JAgswmtVwzvzO1bNj/x/QsaxsH+I4pwv+i2b4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718859369; c=relaxed/simple;
	bh=rVDIQAc9vjhMOZPIPBM4LIv8Mccbp+xBGtcT29Kj1HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxh1ODFL/MJa2aKGIjrGfi+RQcA+I6XmoNWJSFSOBS0C/zyK7zhx4LsIabsDZv1Nw+g5tlIY5shlnN5Kymr36rQMtajADP/qUWe5WsS/gilTFl4/eiTytTKqWGWug573QTH7TXQbXzBHjmKP5SIA/UCdnsV0oUbq7/vOF2FCAvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgKfotCx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgKfotCx"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f862f7c7edso3772405ad.3
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 21:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718859368; x=1719464168; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KAXM/BEJGp3eeIPmRiUCt+sE2+R+WUmpjHtlnzxQA6o=;
        b=dgKfotCxyzaHvcAJidj9dRW9KuF+/r+Y+baA8MkV6EOKsNIXzaJkYd2QHIDmLLN5EA
         MBJeGcazo7LJngP56ouNffMpFbIQaqInlzsyy126omSJKB3UFD8snD6lMyABnLorH6B/
         Boyvvpxew+/aXuQRNK0hDHreg8Xg/tWy3/bBKGeV9RhDI+Wn1WfWKUtvng/O7VoJ2cYS
         KWqUh3phhl5JktyHFWjcYOWEpdj/41pc1rdNK/KJopb0z6rzRxCbwadyXCsR308i+Ef4
         sv6uZwksxK6Oz2D+o6PH0ZFkQROH68niaAJ2a5Y6XV59+5qC3ZQhfKvGFJY10vvK+wxE
         U81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718859368; x=1719464168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAXM/BEJGp3eeIPmRiUCt+sE2+R+WUmpjHtlnzxQA6o=;
        b=uqvasVHUQ2Y81MD0zry2GHdCS9jtBHJF7MEa8VFUwC7sqykHTzIyH4LIEMvXrHeZ3K
         GRrCi1gLA2/TND1yym1vXb9/blALyBJ9UiYLaPVhKPaJnsDOnuCYiLFt19YVdw5d/xVV
         uG4Xb+R0Ho8W4G1eSH6w6WYHigNOrrcuMsuBaDJQr+LzUqgFU/55+qfMvYg0Rv2y8bbu
         Ab+1ugTmR67wqi+WNt27j0PttwYYjLLVFs3yLuTPvDQVVaPPAjUi0F+I7L+iKjFDJFWg
         T3pFxBKbiDIXHA9PX2hitoVz3jajwUZ12aBpJdxykIz0Uz/zfGlRTylRVZ7byoXjbiGB
         29HA==
X-Gm-Message-State: AOJu0YxDyNhEvTPspyF4X2qrTTpk7v+hY9Lxfd4DKn8gHpHwPIVSTLyf
	Jmun6LjiTkKsaj/HNilAXmPlWciwyJyUi/mZUzrIeyZg76AvGFC7
X-Google-Smtp-Source: AGHT+IGL3dntDRBlrzjs5w7kuOREiPO+yFKeVR8D6K5ki/cB+QXlUmkYICKqlN4JJk97p5uqYH6xFg==
X-Received: by 2002:a17:903:120d:b0:1f8:3f13:196a with SMTP id d9443c01a7336-1f9aa44fc82mr49269515ad.45.1718859367530;
        Wed, 19 Jun 2024 21:56:07 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55eb0sm127560575ad.18.2024.06.19.21.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 21:56:07 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D7AA118462BA1; Thu, 20 Jun 2024 11:56:03 +0700 (WIB)
Date: Thu, 20 Jun 2024 11:56:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
Message-ID: <ZnO2Y1AVvR6zsJET@archie.me>
References: <20240619125609.836313103@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HHnYLKCUkPdXYh/d"
Content-Disposition: inline
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>


--HHnYLKCUkPdXYh/d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2024 at 02:52:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HHnYLKCUkPdXYh/d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZnO2XwAKCRD2uYlJVVFO
o0BZAP9VnGEX2jdauijbtQv78ZO9JOEAy7J0zC4a5bSdnU1yQQD/RaTw7cwNufhh
GhUTFq1Airetl4uqBwhLZZyq1yOudQU=
=LzJt
-----END PGP SIGNATURE-----

--HHnYLKCUkPdXYh/d--
