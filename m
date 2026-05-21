Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D28B3876D7
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779357322; cv=none; b=utZ/9U4VkRdL10fS5piBIAlkjRKLjjsr/4Srb7EGEASK5nU1mUJUxgFBcgzbTx697LwjvX9Xp/O8eoHMCSkPyCq4vNHipv/GSs0taU45WOXGdboLKSlpvsmEcPiNIpMnh5gplqiobVVJeHdlikAJuuoe/DauzZfUgt2CVWj3dIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779357322; c=relaxed/simple;
	bh=hPvSeY9tGyS4+nKNFqMDhpEjJ/KMN0ZtFYypWFwxq1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2t+yzHWayYb5e+wPv5Y4q2CbWFS8CSJ52/62x4SjI7U426941h/viWSqCUWMYewrUGNXM9rY1K8Y020tv7wrJdAQ79BFsakKHTz+A5UrXwCyI4lpkJxFjoD8CLjkZ6kEdqZI9V5Ux7c/zzj1y7FxN51iYMx3QWjBs2YkvdDkGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=DamkeTp9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="DamkeTp9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8304410CED4;
	Thu, 21 May 2026 11:55:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1779357319;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=NIBW02XQrfatk3mY04OijQIZ0lAF0RpUhejjhCWO4qk=;
	b=DamkeTp9WHUAMlWiR+MZ19SdquEm5cDdHy1ydmNPgZEnCum3BQqyXWuSiEUkaiGp0zr5cH
	FDWGptnDCynglYeByopozIZgwcUbHSaWD6l80PRMSBZZLPt+GhD1dlzEEhgICNP7ZSf/WA
	hGDb0PoLRtXk8IlMYm9SJfLErOgH7kCxZvpobkEgGXM+IxhDSPtWuLnyuZA6icqTxwLww5
	Ad3C7FVmHFioptms2E1IDD/qeqowehdgf8fArc3wECOKUEPehjVRK9hzJMi8SI6ruSGH5r
	FqZLpUjdIhOH9pu/MRCVizRn7ELXLUZGB1Hl7Y/EmrPnt95Vd/Nx3fW/9I8d3A==
Date: Thu, 21 May 2026 11:55:17 +0200
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
Subject: Re: [PATCH 6.12 000/666] 6.12.91-rc1 review
Message-ID: <ag7WhYyAeVzRng1Q@duo.ucw.cz>
References: <20260520162111.222830634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="36VgFSgR8pbkgqbN"
Content-Disposition: inline
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--36VgFSgR8pbkgqbN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.91 release.
> There are 666 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--36VgFSgR8pbkgqbN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCag7WhQAKCRAw5/Bqldv6
8oyEAJ9PxJPTloAyXx02MYmBYrOiVOBcAwCcCS5AO9t1rgoEaK9BNo6wpoOSsus=
=DTEE
-----END PGP SIGNATURE-----

--36VgFSgR8pbkgqbN--
