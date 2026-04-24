Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025A3329E4B
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059419; cv=none; b=jGWSPF7uW87xSq4+2xp8V2WEsoqteP7DX4Ydmx8c781QBCm96e2PXYiwwT4vwFRG7ncmp+21DIcL3NBxMB/ZDfn+oPEH5+hz3Q7hTCh45oY1DMpZZESu1k+bSUSqKGRrHrU+SszIj+h54ZGlSCeDMgAp2yACOmFgw9P8LcDOXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059419; c=relaxed/simple;
	bh=ZArQKKOO/jpjwDTszCNGO7m2Q57PSNA8DRKGJguyw6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+iCVIDuUl9gvVxKUteLPGF4gmA91CIwJoBwM2Pbe5bAGxPeogo1VctEW7j9p+6jO03yHN7w65Z5mPALZhpkSaYuQrbZ9Zm8evciTKbAp8o000ZeT033J536kz1BXweRnKmCltYynvU06EQnP9U+mlIVqEEegU7BsCG3FN6jR/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cI2d7/8U; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cI2d7/8U"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 305D71140E2;
	Fri, 24 Apr 2026 21:36:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1777059416;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3Qbj0n8CM1rkoryXZaXj8YuyhC4vOWvB7H8uGLYWpWU=;
	b=cI2d7/8UiHq78lp2u2BQ1M6KsKAB1Al/NbIsKQqvaDQHby2RxvYw76pLJZBQOslqFxeyyb
	IBRFswy2CiMuX5XDAhrkK72WpsI0VjvmIWSsgoCf9VAYIhDpKb355WurfkZ42j4pNZhCSA
	MQBBFqAV/Ak7ofnb8t5dEn4Nj2AhIm+MskqHMeHtVQEUxF9XXRvjKDeYbxXakDfAyJbeq4
	ovvJDijYiIxoKSDH+MjlYp8MhyRq8UtReAkzxbk1slhzrVmRDGPsqlEg/HtaVTMDOt98lr
	9QJ++wVzPxTM4CVP8uWCvz8SR9izcOd7Cft6lFoigp+isq3XWoTtzYyBF3mqlg==
Date: Fri, 24 Apr 2026 21:36:51 +0200
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
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
Message-ID: <aevGU7OtAOXivj1n@duo.ucw.cz>
References: <20260424132411.427029259@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LICLsT4C/wie6Kmk"
Content-Disposition: inline
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--LICLsT4C/wie6Kmk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y                =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--LICLsT4C/wie6Kmk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaevGUwAKCRAw5/Bqldv6
8gQ3AJ9UknfFVqcu1DXTrK/Utr3BgyPZuQCfb1jm/iEbKTSEde2kd/eXXlCN6zM=
=Cy2e
-----END PGP SIGNATURE-----

--LICLsT4C/wie6Kmk--
