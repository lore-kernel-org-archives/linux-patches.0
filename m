Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA822F0667
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030077; cv=none; b=jP47go3pFJuT1Ebk5IzoVYLskpDdvzN2br+DXGiMiTss97Z8IA29/DeZdyv0yoOgmqWRH5Q84zm6sknq9yegB52cxvAHevmYrsgM2yDHqP8rr0kGR9s/0R8mXODgtemuG4pAAyLIe/3p3J69TuPeTLlZkonPVVoTrorX+B+pBHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030077; c=relaxed/simple;
	bh=6jq3Sco7VjlEZUkd5ouW+k7+8IKd3s+xC5YDBNCtE5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2N0NDZ/uG7O9mrVJwEhaUBA3rU7VPXZRSO8DjelXA0b8aw77IAJZ41gT2ReXbb8VFqVXnWUEGcP2EKUwB6UHkOnxNcMpgCtnubTDzCxh6nrsKEK22S3dNAf7cJm44rlqRX2u3s3LLJzIZOK8dNzclw9dysqme/5EpM31dpu6l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Pf4mcBAx; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Pf4mcBAx"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B8C671038C11C;
	Tue, 12 Aug 2025 22:21:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1755030073; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=NbzqxanBciSPpYXRi3yKdnGG5VWD30Pjvca9mkg105g=;
	b=Pf4mcBAxgTRN7sYU2aFTINug7P+K9D1FGUrateOC34zRuNRzR56JOA9HGDQ0uuIbcbx6jR
	PR3kFLTcvtlAGTR4DJEwH4KGY36G284JsSrOJaTY0elsXkA11s5z+Lkr0NH1HMom0H/fx8
	b51D78+IyjubwNvujYCmRM4nnsj1Dn7KG/jedmIFGwrxyKDkIm9l8wphgYLwj3TnRcVcbH
	z+XD6mIXEqX/zz97cSagjrEnubXQgiVVYZoelw5TOYDjhTiQOSSX6n3J7+43QCEyjkEaB5
	/TMALndxww7cncjhm8P3lb4E7mgM6sMiSzkr26PYZbHk/72gdsQLI3/tTdQIzw==
Date: Tue, 12 Aug 2025 22:21:07 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
Message-ID: <aJuiM+BEx6CKEwcm@duo.ucw.cz>
References: <20250812173014.736537091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KvM3FQO+iWeOhCBY"
Content-Disposition: inline
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--KvM3FQO+iWeOhCBY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--KvM3FQO+iWeOhCBY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaJuiMwAKCRAw5/Bqldv6
8iheAJ4usuBbnrJF6kO1C0+/pui/DsWi2wCdHKcU0P9sb7yUzUkrPPSpyTsvTSw=
=KpMc
-----END PGP SIGNATURE-----

--KvM3FQO+iWeOhCBY--
