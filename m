Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6DF2DF3FD
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760729098; cv=none; b=JjWGOxH5V7MfEIhiDT6+VGk823oW38spJG/dyQqJSSOBXJxheEuXwuDvBc2Elahr29AvywWJ0vuTkpRyGtPsLgEbSCpB+QKwjuJ0k4kUOe/7V+NncwqHwGFFe6MbY/upulQH/q0e9M9+5Q7oSX6c4u29TR8jKyv2HCk2M4YJ0mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760729098; c=relaxed/simple;
	bh=+ekQUCcS9V3nXbf/8WXbtN6NHy7BxIyW/MYs6538p5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qt4+m32P6zfRP5NA0GzlzeJQakrYMmWqmTm6m78iYTQCdjw8VzY48TITsxWM51G8jR3tJtzo8lHgwye0YOsdt8eL03P++JaTcBtm4hvjpY1rj7/y501avrt4kqL5tDsqXdtUPBrw9yqmqFbwlYQD3+rFLkKDYhc6yOJKfUhuJUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=IxLB8Qqx; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="IxLB8Qqx"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8EC92101DB819;
	Fri, 17 Oct 2025 21:24:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760729095; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=zOHcqv+FC/slv7MeIrdYS8P8lyXgaYUJm+dJRJBxQSc=;
	b=IxLB8Qqx9fb+bm6okdSl+Tcm4xU9RM22cgNduoSY/AcAbECHfFGkUttQW4+B3q8NUOXyiE
	LP/+gnL9zvO/f4ykEXCE7hkktSY4qNMkKkiBvjspPNec6XXpDonT/N+QlKprpTiaex9Lio
	Wassd/KImF3jryNj/Y058hpdoNFJO0ISuZ9M2Vy5QUhzJ0iYodyX9/xHXbyK84USrZb368
	FDDGPWx6SIWx5NdEVSI3bCrZtMRAwgUgwiNmdYNaG5HohakUNiTS2VQvs67wqTRgyW8ecv
	HlbV4LVW9fvDuP76RgrpTaJIUDNDyOByFQufx8R4haZbX2DJvlntCopHdA/JuQ==
Date: Fri, 17 Oct 2025 21:24:52 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
Message-ID: <aPKYBM+PPLUfwxmt@duo.ucw.cz>
References: <20251017145147.138822285@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HRGUmcsMeoWlhzla"
Content-Disposition: inline
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--HRGUmcsMeoWlhzla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HRGUmcsMeoWlhzla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaPKYBAAKCRAw5/Bqldv6
8o0uAKCV92LEkrGeGGdaW38GKtV+A7DZ7QCdGqMViK/U/K1LNB9YZke/E52gvuU=
=3Nt4
-----END PGP SIGNATURE-----

--HRGUmcsMeoWlhzla--
