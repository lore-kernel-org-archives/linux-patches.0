Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ABB1F461D
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 06:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759474693; cv=none; b=ru6UMuwASA/ZyI4RjcOhnOGy0KcUh7tvJ7a7Le/jm5nkeM3bSqLeE1FiSyiu7Hp8fRHqU3iCJ5u+2k1PBlOiwVPEtATzbpPwlg8yYtoqVOtJOdE7Gzqv/hi4jbAWvuCxa74gUG0wchrC3JMSi6NEPhGfhF/VBa15bRJU+qm+bzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759474693; c=relaxed/simple;
	bh=ygHJ1a2tSCkiw3IPvK5T3GMVSP/bOxGvIO78g0U2oqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhyiZ6oscbg4y3EKa8dzD/nsQGLk+JxsPste0eclVLOBbbgBWmDfTurzQXSVnXOYvnRWaShbpWrwqgxFVDw1hrqaWImN2s0HmbF8rOhUf7wb6+J3Bb11IoJcuMAowgzIhAfRZJD2/fzZw+beaqeXjRveK7YGgx9LZqfjRVwLHhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Jld+0fzl; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Jld+0fzl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 27C16101D1A39;
	Fri,  3 Oct 2025 08:58:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1759474689; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=16mRRpkmibLTIgo5zX4xc23aofmm3S9PtXoTu0vtgi8=;
	b=Jld+0fzlmK3NdbjIRDq8ZCZmJYWBzZUt+HpFdK4zchwzxtV6Mcw240R8h7ZhW8mN0LkJxe
	9RzHqPewb+e0dAM0tIVsSsEV6xjzqdmFGysBohoIh/V2DuMAqnRIbZmhLh3/ee2xALTC1s
	l8DSMaCRfzECDH0jGQz5H83You7IZLAsU14XG8SN+NJXXo5bzZF4O8iYeaN1W80tRbv3KR
	bLvDgWsB3ZzYFHdyB6/Tq9+v/pGsWh22Iwm8eCK2fra+k6ZgwEWgzGMkq0rWO/17pm8uh2
	Ysv6VZUvLxvDI35Fe2jjvG1S3Os17hH/mXHr7/p5ndVUdK01ZqlFnK4eS99Anw==
Date: Fri, 3 Oct 2025 08:58:05 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
Message-ID: <aN9z/eFB0pYhMPxU@duo.ucw.cz>
References: <20250930143822.939301999@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFmWpGlbQqNCRvmw"
Content-Disposition: inline
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--UFmWpGlbQqNCRvmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.245 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--UFmWpGlbQqNCRvmw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaN9z/QAKCRAw5/Bqldv6
8iu9AJ4sUsI001bzGUDTzwZLNN7ZTh72vQCfWWiiOA/gV9vVXYvCfYuoGcMmnBE=
=zIcY
-----END PGP SIGNATURE-----

--UFmWpGlbQqNCRvmw--
