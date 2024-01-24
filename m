Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DD9F50D
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 06:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706076580; cv=none; b=EOQVMJVoNyURbd4xGdKt3mOCiDMechwy20oGyNo+KbX5x4WZGBBLbr+7W9p+9R4QJHs+7xwCUJtIdm1BCaahKG9ylKPuC1z1Zl4eB2UJDMx5q2X1RoYJOAOrzyK0kodpl+WQI4bTOgvYMVra8jI9AhrNlPnRO8IWrxppH5LPKlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706076580; c=relaxed/simple;
	bh=QPrzbMUSRppMUppd+9EXmi5fQQ+Uif6tDCZQPvztAlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exHv4z3jmIb8wJXtzwQ1K1yCxBD8XH58JBLUsRY+7ZkDRoZOWNEfgOuQrF5yypyshFv2N09UqLB890GZJLCRMZUiwADXNVaWz1lurF4+vdmLLB9TSWK3c+Hm5gcWOI1yWWyA7pTq2xSWy0p8huJwZ4hklkaArS3zfPe6QmF5goo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXWwP8XG; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXWwP8XG"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bbbc6bcc78so4127696b6e.1
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 22:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706076578; x=1706681378; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddFkrLYV49OOGsw3xBz4LEthLKO7WQPAAsxP1oQV98g=;
        b=nXWwP8XGrrFOrOF8+V/J1Dh/I1OB+mGx+fVaAP2CjL+CVte1CXppQLUxtO1MU7Oq91
         Isv5zSFvRBb6jIy366+kFG6bIusKQjUqORAMNJjujHmSLoUTU0fxmC40r6LrNUJBKZye
         v5AXg7Ad+ux58OtEFU1eIuHc4pgvKWCvJPtukTCVNz5tf4b4ccLH+HrbL3lG0ni8Sn56
         anObPfCulsnKW7ayyqlPRl77HblMWgcHKOoAelx2xE7RSJaa6HBSPF5bRiPFwol5H9+J
         lfss7zLjBUCKXlFBGGcACy4BQ2WkcHfP1hOgUTOrlY3Sh3s97p1GE7f7Lg6xkB4NtVD2
         YHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706076578; x=1706681378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddFkrLYV49OOGsw3xBz4LEthLKO7WQPAAsxP1oQV98g=;
        b=IM+kMW7zoMFLympOx3eO7W8Bt8pNNaaq23Y9J+a3bH5xGUSZShvnfnEiCRi7eqrzSD
         KFewJXyh71rH38akjQSRQ3stFWOix+7XAF7MrFBRgxW/SfEBOjqihvgvCCa8R8eNcdYp
         UhTZ/muw/6ADntxWM5BzVTTjr6GoXG4A7H2PfvdzzvZ0yfc4dbY0EeG1G1w82PAxD4as
         Fv6bPDel7DRAL+J9VIqmE0cJHfUWkDg9rHUUnZ6AGyPCTryc+Awe1JUe9TtmKy0F8KW9
         1oAI2s6wiRL7Poke3PRZLLoPcqHkV6E1Tp+3BS7pFEhjm+7Nvq5kioYlugqs+ZMPXEy1
         Y/Hg==
X-Gm-Message-State: AOJu0Yz6jRh+jK7jNePfSbEfEk6SnEGISmb5eKrIGk9XPQC2WqPrN3Cs
	1QpkRDzZ4Cs6IYN618uxGYQg/Nwb9AVsKl9/LCeOOXezrCCxL3yV
X-Google-Smtp-Source: AGHT+IHy206D+dXsznYMPRNs3sVxNuAF0r+/fh3ddUozvjmI9oIvn4prCQMnoeeRqTd/3iokULUUEw==
X-Received: by 2002:a05:6808:1894:b0:3bd:cfd3:8607 with SMTP id bi20-20020a056808189400b003bdcfd38607mr660611oib.65.1706076578162;
        Tue, 23 Jan 2024 22:09:38 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id fk19-20020a056a003a9300b006db87354a8fsm12657551pfb.119.2024.01.23.22.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 22:09:37 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 041B0184EA861; Wed, 24 Jan 2024 13:09:33 +0700 (WIB)
Date: Wed, 24 Jan 2024 13:09:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/580] 6.6.14-rc2 review
Message-ID: <ZbCpneBZPtJO2AQo@archie.me>
References: <20240123174533.427864181@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EQAs6C5Lptua5lKA"
Content-Disposition: inline
In-Reply-To: <20240123174533.427864181@linuxfoundation.org>


--EQAs6C5Lptua5lKA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 09:47:11AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 580 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--EQAs6C5Lptua5lKA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZbCpkgAKCRD2uYlJVVFO
o0KXAQCuyDhAAfWtcAEGKQ630SuIueR0MiuVhQRAwEnF4RU9jQD/Xw7Slc7k3hi/
juirP4bpu6pgj3VimPnzm9+dNuSCpQU=
=d8b6
-----END PGP SIGNATURE-----

--EQAs6C5Lptua5lKA--
