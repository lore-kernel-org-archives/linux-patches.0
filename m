Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9D820DCB
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708497744; cv=none; b=I/FqimYqd5w7eXMgGxHWVeZPLK0SnRvuaFlC1mXwENI02yt+/Sbfb5J2AxFEBkVZli3ubgcULCDHCIQeZxCJdEPPg5/eQGk76IGxeP/vmN4dsqsENX3mRJRidfR684cbQJ59q4X5Zj9ZPs+18a87XDloua1zOVIFtfzuswRpkRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708497744; c=relaxed/simple;
	bh=VNdJmD/gpyse/FMH9lufHreZgd3FLHQhGe9fMKcG+6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKCZtgH6emYx1PW6X2U4anEayBOF9WUP0j/KxhKTmfw2cnGIBf1bWMmr0FKhp10MAKLLhXCl8BcFrWQ4moXQBgl/nKddv1bJvYLGJU4WsLceJ6i07x+TsWgB25kydQvHzxcaEEQKa7qQ3ULi84l+6qtYUTqx0m2uE0QbnzgSYUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlTFd9NK; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlTFd9NK"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e44c9a62b6so1396380a34.3
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 22:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708497742; x=1709102542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8qepPg3+JSFA4GPvBKRhv/lZipuP/R6kgkTa4naVw58=;
        b=GlTFd9NKAQrjS+o47kMFQKeK6FOu4YO6rPvaNvC/MqMo7iKb6/dMFlzq2sFFPsjokz
         vn4/k3jSdfTihIJcIAyXW/HWU/9G709WNhcxgwuJCaWWB7MI4ijmNWlWj7Q4DcR6C4ey
         NO3/ylMyUX2mAK7a6wBD5+CMjzFuKOsVXZiFXsQCHIAHTtqSZ9B/pyJKjVwvjKqtvMaA
         dv4ef0f3gvduPoIgws08qqEn9sApc6D1oeClQCvp1aZ0i6jy8Hlri8w93GW6RXN6vW9R
         NU2qU7cJkDqBVfUVpN7v9sERST9BspbyZxfMGo4apCO2wFoLFbLJhLy9Qw4YJtb44tvG
         V8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708497742; x=1709102542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qepPg3+JSFA4GPvBKRhv/lZipuP/R6kgkTa4naVw58=;
        b=DF2LK3Gk6XtSYk1OhvyaN8P4ofnA4t3uGBNjO8ZK6qmCDDy29r5Kn75LLceWtiDqFx
         TfTeUViXBh9vlkCI4HSgnP6+6a++m3pbuVNE4Wrajv2JDPmnoGSE8Dy59taxI8HCeWRw
         Rax1tKboH53iA/3+4oiwGwtFFyU+JPY7JMnFFUJ77zwRptSpUS967/6KID6QjdgZiow9
         b8pTU/RXMwFXT6MH8+gsP7I1aEl3+DRDFmelrOeNifU1X9vqYOb+PybaOhAq46koHm2s
         QLQ3ZDmJC/gZWQ84U1mWnqTYKBGfQNR8um25v/bCxr4e4EznEccdLAGdNdFXMmARFInl
         Qg7A==
X-Gm-Message-State: AOJu0YxEWMn+mYzWz0t7MIyz4TrozPxM63uRvBjZxN6l8+KLzKA5uI3f
	zDKo17LyQhkKnOOCr7HgzyADheP5EdyZMh7EUvoPo/XeWRxk720v
X-Google-Smtp-Source: AGHT+IFX2wH+plNNcu1hJmDhVaeR7nE/+xXlIrJD4rY1IqlkWMMc9Bz7kLC8LWre+uDoFlouYw/hgA==
X-Received: by 2002:a05:6830:12:b0:6e2:d9a0:b2b0 with SMTP id c18-20020a056830001200b006e2d9a0b2b0mr18278306otp.0.1708497742019;
        Tue, 20 Feb 2024 22:42:22 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 5-20020a630f45000000b005d30550f954sm7667671pgp.31.2024.02.20.22.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 22:42:21 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id D76C318468568; Wed, 21 Feb 2024 13:42:17 +0700 (WIB)
Date: Wed, 21 Feb 2024 13:42:17 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/331] 6.6.18-rc1 review
Message-ID: <ZdWbSQMfQoHUZFMH@archie.me>
References: <20240220205637.572693592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xfP/hcoK8GryOZ4A"
Content-Disposition: inline
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>


--xfP/hcoK8GryOZ4A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 09:51:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xfP/hcoK8GryOZ4A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZdWbQAAKCRD2uYlJVVFO
o8gSAQDcSoCptSpp/zoQllZP4KjRqZXxe+YdNcfeyiCxVWalRwD/TXM0d9CHkfig
QgHIDWMCF5pGxWzKdg02GHHmkFstiwQ=
=OaW4
-----END PGP SIGNATURE-----

--xfP/hcoK8GryOZ4A--
