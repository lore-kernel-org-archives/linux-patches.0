Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681B11DE2D8
	for <patches@lists.linux.dev>; Sat, 26 Jul 2025 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753553090; cv=none; b=FfUzhvtlpDX13jH4iDq0NGvP7kA70g00qHeBaVuWyJ83zXDEloQ7I01XqAeehCRasmYDqpkKWQZ8bGGpXvNvnn84jGmtFfG5iqK5QcLfrT42sbAyH8zGfbAfZojXjse0vfTTxOmZBQF+XIGXGcZhlcHr2nmziMDb8i7R6IRVtGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753553090; c=relaxed/simple;
	bh=KOsTbzXFUuVHscLuFwUnb+ac/sH1DI7P1rAb5H4ELlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WYDIjeLVI/6R81EQ7GcWtMG9u1dFZSurVMUkusZpf9e/FUijc4qfKQFB1pJm9q/vKPRGsFQxaP7NlTiffTujifWPhfXrsNpErHyUohvllVx26u95+Gk6gq8/oaOAglQpcY65Fs46r7DAtX4M42k8QZV7EPXYSFhjEH7575EmF+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=FG5xsgQS; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="FG5xsgQS"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EDA1810391E80;
	Sat, 26 Jul 2025 20:04:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1753553086; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Gogg7dq4nTKRYj5+cWYCaLkdkeYYwxLcmAFRklXafrc=;
	b=FG5xsgQSLOd/+ZM3KlPNuTGpHAsiysFWSe8U1VfDIVruSHzng2RW7h7zNUWgy/NFXjm+0L
	6t5cpgx1o8xNNxomqcavnR6LS9Xzk+3qoyPBEBD3YpBd/7njPLKSb8JMSUMqJ6HNp1KQyi
	FLk9Bsnh1Q3BNekXRIATrLpLcK2X7NwaKLA6+LUr4v8PrPv7bbVdSj+PG+FtX4tzQpcZWB
	w4SOSde9vzhuRgurw9lTfP5MWDZive8zBRzO2T6n/qASVNUCY9XF+YF4WnZKF5DlH3KiXo
	03wOalgspFfjhZpUf0/R8Rq1c9pZPdJon3QvCVCPyjnSF9Y64i4HIGrHlOeLrw==
Date: Sat, 26 Jul 2025 20:04:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Message-ID: <aIUYt5Seh4ZVIAmy@duo.ucw.cz>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9J12CxRnMw6XO898"
Content-Disposition: inline
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--9J12CxRnMw6XO898
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y

6.6 passes our testing, too.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9J12CxRnMw6XO898
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaIUYtwAKCRAw5/Bqldv6
8q4xAJ4o6FbKlHYWBnCEK0OsFitUag0V9QCeJWcr4xXSsQzwmJ7Nwo6hDOX6B8g=
=jVsu
-----END PGP SIGNATURE-----

--9J12CxRnMw6XO898--
