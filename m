Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6F726A0B9
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059382; cv=none; b=CoWTOawXS0+HkBrInhL9RIWni+U2DA0gIRK29SaBzmzXNU1TTzop6VqfN+3ZbzsXCHsC0h4cha6h6U3iSmAj028GOpuzHEkQsovhKb6r3jgc39o8U+AyDncXFAqg+Ey/VfQ25RKZfNOuptynh+XKebsNzetTvn3CdcdJXvBPxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059382; c=relaxed/simple;
	bh=rG/LwwAVmW6BEIEi+tr7w+R7Qed6BoJTuDj5bKJWihI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5nFi6+ftVJiID5dZRR8n/5jzDf5JHHZipn0fnjaGrUlLmQaUBSSq9Z4jm95GvSulPfXfsAlhg1e5MStiq/4yzfPIpdVI660BcCjI27gMCAPwWbKoS1hEPfbktnbFmKmCVTzrV3Q99JngsqIsXXpXKTrVTPztMkTALsnWMD+76k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=As1mcnh5; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="As1mcnh5"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 234331140E2;
	Fri, 24 Apr 2026 21:36:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1777059379;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=aEkKzDfRl1e4vw7+MZtd5aBIHpdfUZjsgu7QWm9ETyQ=;
	b=As1mcnh5dIYJ+dZ6prdh+aOkpIkQJYZ1eurLONWSrGuKV9vGvcm3Q5vL7U77hw2h2ocBHd
	PVqGe1toKOelRd59XEQXlBTi3njSXNOzCzyA9zezQ6UTWI1pg/S4q8X7XOR+czt3djnb2S
	Cvw6eWM+nHS9g5oVkg5hlC0ZO+vxX3zf+ejj0Bq4MHXiXxbv++CuJ3pJYDBoGDCW3885YA
	j4UEDMdDBsgKaEdonIZq+9sj1Nru1nl0GzOSX+BgZDTF50NePdPVHgkG1jH1bUYwqY2DGo
	dqlgNOUJfxRPvprOItkQNwMaViyFbKspUMhLbaJhagPJoOSKfEy4ZLRZCgRmqg==
Date: Fri, 24 Apr 2026 21:36:15 +0200
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
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
Message-ID: <aevGLzKL_w4ekHYl@duo.ucw.cz>
References: <20260424132532.812258529@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDkkBaBVDkk3bxj3"
Content-Disposition: inline
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qDkkBaBVDkk3bxj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y                 =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--qDkkBaBVDkk3bxj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaevGLwAKCRAw5/Bqldv6
8lrJAJ9WhbaTOqCQWC0zY02/6figCQKiVwCghI8Hr1bODaXS0UQqa0UBw8Xi1QM=
=OaRs
-----END PGP SIGNATURE-----

--qDkkBaBVDkk3bxj3--
