Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4226D26D4E7
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043434; cv=none; b=KUzzkOkOf42mTNRkKGGitNnFSS8zcEWuKtUJ+KoHYPL1SJZSOXeBJ58FhUPNtcALfQA/2QQ9sR8v/D/V1MRVZSWs2FOw8Ft8aL3FBj+fK9wd3fh8XEG4ZOCI2ZBog3UlyPhYCLt6RcAbpoCji4yRrcdgbYqzg9A7fkm780H7t+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043434; c=relaxed/simple;
	bh=VPPVvdO772kTLlb0Nmna+opvHwYb5mesK0BD78Xwgcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K03tsWXrhMy6JNbDwqNZ0IYJipGiIkFVrMRT3Sea6j63kpA2kQdAR9SxzV/mxsplwcq0N82gwpu6sh62VDTRE4dqePxmQpUOVifF+UgLZEan5jvVHszZE2W0Nf1cTCZagi1ua6gHEC8Ehqhvmcs1rAVF+Y4955oBnGA9Dwpky54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=POWaOFQ4; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="POWaOFQ4"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AD084103972A7;
	Wed,  9 Jul 2025 08:43:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752043431; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=g0WbzYUow2PtbidrSfvCcHw5BM6PU6Qj1La3W8DDtpk=;
	b=POWaOFQ41g2CuqJxxBw1LycHYxlXEF1VdzuqEAMcGxFmRJ6eDzxN05wToOgwzgcaIb4swe
	YqpoDExKZaeLB5/xP5ALV+A6hjSBSsA3B8MD0ABzLCFUly8vOauBwTV3a42i/bHKt81SAG
	chNdYJmd/LX/t3WtTw2Vz44a///Fruo92Lbt35vmFvaSYeIIvEqTbfnS6h01oRwnRM61hr
	Jgg/cVybDJ5i5Mjq2TR8VEsZDuWS9s4qUK1cVgKSDlygk5NjxcS691/Dv8FWqp6RHZGX9k
	D1TPp+5Y8nd4rvA5T6auYMC6+1B9CsEUSQbzhnRmDqDoa6GIxBzUGTjwj+kLSg==
Date: Wed, 9 Jul 2025 08:43:44 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc2 review
Message-ID: <aG4PoPRuSsuOGlXf@duo.ucw.cz>
References: <20250708180901.558453595@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+6FlrIFhK+31E2Mx"
Content-Disposition: inline
In-Reply-To: <20250708180901.558453595@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--+6FlrIFhK+31E2Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+6FlrIFhK+31E2Mx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaG4PoAAKCRAw5/Bqldv6
8r66AKC9wmTIPrnE4hF9x0PVu/S1Ac/uYQCfTnSmidrUK7FcuuHvNhXpcDxkp5k=
=T0M7
-----END PGP SIGNATURE-----

--+6FlrIFhK+31E2Mx--
