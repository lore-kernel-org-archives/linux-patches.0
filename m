Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA179476
	for <patches@lists.linux.dev>; Fri, 17 May 2024 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715916483; cv=none; b=afFwO8GJAQ1Pe/mQqlgzco/xV24vWV+c3GJCqXXlvDTTjUV3BIDyL3Io+j/6fBfm8xhumj/1rfDrqHC4J8zSpRrD1JrNoNGuSHmVgm02eOruycB7njpR7LFwt9tFoklsenTajN5DyAEEq7HppbftKKUqqoWXHbTAGy48wRahvCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715916483; c=relaxed/simple;
	bh=2YlnU3dK1FoVSD9j1pKO2Ij73DNUAm/lDhMdu3e0DA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU33ySSICnaIM58mTgRcKyHT68SzsxIUldXK3Fzo1B4dOog1gstJ4yAGBfh3szQeJlu5WYpFUdzg2tABKRPSPL9z2svGXxOKDS3llr+XagOjTcOt5tbqRgM8K4oFQoxKuoMjjHxFUWPTu66Scn0czsVhqHauBuQI629ADvCh6ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUXsfY9R; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUXsfY9R"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5b277e17e15so656285eaf.2
        for <patches@lists.linux.dev>; Thu, 16 May 2024 20:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715916481; x=1716521281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9fW8G/HvOS2fwoglBUvP9d7Wl+Tt937qFLudcraoP34=;
        b=OUXsfY9ROPgKRYSFoquuLeGKJCHlHbWNXcg/YzMiLnIjvIaRyaaBIU9etVBGnCgb46
         UiLiPSSkyprKu1R374OCbuwh0mKKR/JMJeQsD447o9tukqbCgZsddBubaXyhnYJnRnct
         TUoFNyqEqLQOYHAN3msiH7rz29UVP7EHR/Jy+RRpFM64d+VHevTwaWCEVYU8Z65qcxBa
         lNhmCnYWSZZxd4iuXhEeBjaPvmbAl37h47dEUQdPjUqCBgq8JWzqlOtkAPWvOhICdcWW
         ZSmvnszLarqjn44/4yP73iONntwZkQInixxXC9YdG94XOp4IYMePlgB5ft4XBNUVR/+y
         Mxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715916481; x=1716521281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fW8G/HvOS2fwoglBUvP9d7Wl+Tt937qFLudcraoP34=;
        b=ui4t8FnMfp4WeAi+frkcj2hj1dMVbp7liWK1Ss5az07a6m107FKLukQ+G28FnFg/JU
         nJdSGXkU/hitZG+9ff5vEaNwqms0TBA6Dvd7XyB+kpj0NmS8/Rss6KSvhc7AAvlbkzpm
         08vIgXl7q4Vi8fBxeDQXnIrNJJbsIss2Iss5jWhdMLPuvGCmXErmrirpKw3Q7dbO+Cag
         jQAxGoqTiXx4xXc4h1REvPJSdMFfO8a/V89mWPy+6QkIMsxzxmpankCGYctoEVIm6buR
         vNvPPMgssftfN3kmw+3EwmqqdEjuDveG0WdSuJkY17p0fO5AFF9ibXe2nt+ze+TlyuXb
         mlBg==
X-Gm-Message-State: AOJu0YyWO03xRYms6Pqq2gPXJs+5f9ZTi5qp/7zdcqj871VTi1jtSZ/i
	ANcg1NLBLylyaFEg9TygVztGWl+88bbhiLtAUZzVNSoSsnvIUyTB
X-Google-Smtp-Source: AGHT+IE00rADhK/l9n4od3Czggi3pFMm0JtiMdobVn8lr4Yb3oqDI8w/95tuuhXs2VHoz0x6KKlLvg==
X-Received: by 2002:a05:6359:4c9c:b0:194:8d2c:12a5 with SMTP id e5c5f4694b2df-1948d2c1ac0mr770608255d.31.1715916481045;
        Thu, 16 May 2024 20:28:01 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-634103f80absm14019096a12.65.2024.05.16.20.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 20:28:00 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 685BE187061DD; Fri, 17 May 2024 10:27:57 +0700 (WIB)
Date: Fri, 17 May 2024 10:27:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
Message-ID: <ZkbOvSPM1ZHn1gZp@archie.me>
References: <20240515082517.910544858@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0IExNrFIihGLwV6u"
Content-Disposition: inline
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>


--0IExNrFIihGLwV6u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 10:27:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--0IExNrFIihGLwV6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZkbOuAAKCRD2uYlJVVFO
o9p1AP4rhcrTfezKg0poR9HjvP+a1jf/DYeoQCc027IA1qtW/wD/eVY7RHrQo9ri
bdRLN1HPs4bT14VpsGJGnuhcJp20gwo=
=koyS
-----END PGP SIGNATURE-----

--0IExNrFIihGLwV6u--
