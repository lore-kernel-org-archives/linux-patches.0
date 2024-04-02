Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7B13D3BD
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712045183; cv=none; b=noIeav9nGkwwWGF1TNmO0uSiPtQ9Cr9l31DQymb+1rQElIkU4h9L+8pZRuBJAfxYfZysHGFU6kzkQHG58NXoyylBbOP1XHwNBaZrk97wP52cbxJ2kFtLjI/uydXJ2a3Vx/8oKxhmiQGqAuKE9VqnTcFX33rO9xETfcKs/CvPjCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712045183; c=relaxed/simple;
	bh=kJgQirTI1I953hqjFcUemxh/SZX8R5I6aDYfAnAz6fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyFYCJ3WfLlI+giD1svpbhJojCW2AiWV6/lKR8pKEeqwu/4s7l8wDOP+zoo2AUD+sMzcqXtbXAk6CSa2cukmWnodQbMbFTLra6TJSkbK9Z8n9iZg5PtihvLZIwfTQk/es4GJghws8UMqKrjmtHDmNcEeQyCDEuhbTEywxTqDskQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PouS8JHd; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PouS8JHd"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-2282597eff5so3744015fac.3
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 01:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712045181; x=1712649981; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPHs2hPWTLntkIggErFbbhASWchhF98xlAmk0EF4jpQ=;
        b=PouS8JHdFHL5RuIlSloJl2bzvhcWk9ickxdcIIMMNQEJUFkK1LK5SAiKHG0DboA2i5
         pdrKiVKTI8ASnC4/Ck7xr65OWaO4rlP1Zf7XYjEQxYQcMuMUkaABVk6+mVxtWUlG22Wb
         0NBXIUGmspZupTUqS73S62GqJNj4x5a/+X8N2fG/S9sNOgqXlxqj03BKOW7PK84jGfu2
         23PZwrfgVR0X8OhedJVad9U9Mqp219Gx9H+1sSYXgsF1P2CYSCfd5711XT3ItWIX5H2+
         mjueMlH9qfo0omoTJcLE+KawRVi81yohYqR3hOhC3M9bpPbvkFsCJVl4ApDf0DcWG8uU
         1Tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712045181; x=1712649981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPHs2hPWTLntkIggErFbbhASWchhF98xlAmk0EF4jpQ=;
        b=rAj+luR8Ku+SSbCL1FFQsDrHJZOLEytyHeV779nevW7rGgZP7cIf+IcHtI5y6Xwu6o
         e5zo2ae0JXMf5dJFAI0ot5FXdoXQDI9EH/tObd9AhrefVlXK096gvI2WviPpMPSvVgUQ
         jHcKVpJtssN3UZy3xw1+c5Pz5zfSkO5Fu801SB3PdfNZKqZaP4+mwPvQMqW/WDnkcqXp
         kqu69+Tc8zOhudq6K9ckajrGJTkNUnXsyXNv1KTuju7wL1Crh9iwBm0GiQ6EkpUcuHyJ
         wQhHEGCCVfZZ/qHEQ1tOrLgW0m5KsU18dh86VkE1hXd1UZj1TmoUtcn/t7lVkjt6xVIa
         JVug==
X-Gm-Message-State: AOJu0Yzad1uQ0+1JzMV0+1zJMYkxu/R/Kz9/sAYNpUrW4fhQjrjnLIIR
	XeoQG3GUaf/xz0qetFZUGNlj2CwtvyPjriq6RoRAInFr8N/h/vto
X-Google-Smtp-Source: AGHT+IGqmSpF0yhkNZdjEM3dvk67w/vLKdWfjypi6wQ2vQ2Fo/gMkH29noVnqfITEUtTUNfT1+Wpeg==
X-Received: by 2002:a05:6870:a19e:b0:221:bcde:29cc with SMTP id a30-20020a056870a19e00b00221bcde29ccmr14025852oaf.21.1712045181208;
        Tue, 02 Apr 2024 01:06:21 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id j23-20020a62e917000000b006eae33e2ad0sm7713803pfh.30.2024.04.02.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 01:06:20 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1A302184797C2; Tue,  2 Apr 2024 15:06:17 +0700 (WIB)
Date: Tue, 2 Apr 2024 15:06:17 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
Message-ID: <Zgu8eRIe-8V4EFu2@archie.me>
References: <20240401152553.125349965@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XFKL76haxz2xDr+I"
Content-Disposition: inline
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>


--XFKL76haxz2xDr+I
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2024 at 05:39:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--XFKL76haxz2xDr+I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZgu8dQAKCRD2uYlJVVFO
o0vEAQDaf16bnXQX8ruA/3MxP04Imds1t7wRYp4OW4lxH0a78gEA8ClknHqRVh5O
SShmSC4erOY/HEUqZ/IpxgcpZj1tTg8=
=ypa4
-----END PGP SIGNATURE-----

--XFKL76haxz2xDr+I--
