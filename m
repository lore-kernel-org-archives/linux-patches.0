Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D3B2E266C
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354449; cv=none; b=WNfSgmRrCiTWnNIuxH5mYbz4H3sWLP8fR9ASs1vOBA99TVBQNGOfdsRPzESp7B28BjtGMBotoVRWepA0K5Y+oOysEI8FVYAcQ1z1PR1bXyumRdUDk7aubJVqXdySo78qMGouTU0WBXPqyPL9xruHk2UIgWKJJhvKGsP1nLniYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354449; c=relaxed/simple;
	bh=cEN6x/iL7qstH16qZtOhE2AAHzW0XgTtPAZ6xPyqGGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elfCtu1OG6u9uwZbHW23vAun7/wglNRfvCiembJlBFJVy1XvmV+KSV9KiG+kgt5QhDBb4hrhWjSzGHeAhHPiUGuH9Xg3VXYsSB4yPt0aBLqkDJroHst0RsY4pjnACVaLGbBiprtEzhOHBUUnXX/iPUtUqtfUrQ/4jH8ERnI+EJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=E/ygejF1; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="E/ygejF1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0314610CED4;
	Thu, 21 May 2026 11:07:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1779354446;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=+CYeJodYNTSX6Of/MwUg56V7jueUY7bFX3HMqJTLzX0=;
	b=E/ygejF1Dt/iHF7+OYpAP/UfkohAvE5pX3qZV28W7tS6ddTQNZETPFz5I/tXQJ7qA1K2Ef
	VTfWSKaJvrq3ZxTjKTDOQmjVbuOEhsDDCu9OzHl0bgiKPpAFu3LFp2WqUo01+XUcm2ZRK6
	GwfpM134A3g91DeM8KdUN8xEm+yEQAWySQL1mtR6tTMENF4CBDE0MrpZgpqc31FvrtOYom
	+Vrgs40FiAuO39d5zdJWSJPHYa3LoGuwNRBbhrwmgSN8ycx6P/RdPJOGSXr0pttf/UKlGX
	fgWpFcZ0H4DGVz1gWOQKEeK5cDFAqjLVpz2NXIG2SZiAHXaUNS+VLXD0wyKpvw==
Date: Thu, 21 May 2026 11:07:23 +0200
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
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
Message-ID: <ag7LS2irt7y__jGu@duo.ucw.cz>
References: <20260515154715.053014143@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fhtvt9MadBpywHnu"
Content-Disposition: inline
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fhtvt9MadBpywHnu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--fhtvt9MadBpywHnu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCag7LSwAKCRAw5/Bqldv6
8jgpAJ9sgbSZy52eP7AiTGy0vRX3cnxVcQCeNUUUQaxgPKKSpGg2uB5CD3h0H/Y=
=jd2M
-----END PGP SIGNATURE-----

--fhtvt9MadBpywHnu--
