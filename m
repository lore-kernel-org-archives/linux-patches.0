Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F374B405C41
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883158; cv=none; b=u5Zu6vHf5x4hqr3DNL76Vyjp7z6OBXbwQ9Npk5n+0QA3HLU4T5XnrpsiUhZ6ndvwOgVsXBkmqSU+MPdiDYm8z2pW+VO3VGUu4+ExlEVEvZAFaBdlAJZXiJTYh3DhLrHFZ8zq5+8TuUDMw2Fs4z3T3I1KZIXY4eetcGsGNUEhuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883158; c=relaxed/simple;
	bh=riV8Lyjvrqwq6I/xroe787lp9CGmeyiEIXaBfrsy4LY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsharHptlsibUArzghP8M0nLVRR47HtwoabB1UuGzloEW0V0g7lt3HuMQtAD1BOFihPdZ/9lR3Dyr72oZ9Pdqj0LMQ4Hl+KsfnWsUYmk1w0wtJpuG9mI1sB5tGLTwulK3msjWgCuQ5xawYIX/V0KVfWcwzFMIv5cLQGdK4fn9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=NeH4cNAZ; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="NeH4cNAZ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0951D115CB9;
	Sat, 16 May 2026 00:12:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1778883155;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=a3Bn1EQvOjuAjRI01DyT5IyRun0S1KqMrTcFaI6bjtE=;
	b=NeH4cNAZYcVyvejnleZbdqKsxsCX35dbt0aNvGid8IlxFV9Q7xwdmkOPdjPITtz8HmrsiW
	Qj0ZUDaJKhBxXqAkgWs0evWWNLe9Ab02+1hJFn1sB4q4ZQVntX7nSqtxVRriPD9J6bNX6u
	cAaTWFGtepvZLvguHbnEvX3imz1nPQxLUnwuVIxVv2ULqQhRhYq96QOj9VIdFz/5wFqMUt
	UM6CzbiLkMtr9K6CraANsXyy9OloGopnVNCZOT32p2AgJOtvqSczN1YklB+TCrFI2btprr
	ZSXDsHSGHbvhoN1d3NZOIbREITQySpKcEuzu1z7C/2A/JtrwzhZPbK0oiQBsOw==
Date: Sat, 16 May 2026 00:12:31 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Message-ID: <ageaT8aaozCTMsMc@duo.ucw.cz>
References: <20260515154653.469907118@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ckZcm7Xi07Oo+dm5"
Content-Disposition: inline
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ckZcm7Xi07Oo+dm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ckZcm7Xi07Oo+dm5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCageaTwAKCRAw5/Bqldv6
8sJhAKCDDheAOIEbCYpLvR/5EIni7x+R5QCbB3+L/vH94D84vlDBaRBUTp0WqAY=
=MCrQ
-----END PGP SIGNATURE-----

--ckZcm7Xi07Oo+dm5--
