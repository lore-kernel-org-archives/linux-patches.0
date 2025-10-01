Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB9E1A3165;
	Wed,  1 Oct 2025 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313768; cv=none; b=J9++N/0WAibxwoG8J89tLgcJhAoYcjD4snQd7ZY9NGgVjbzamzcMW/MP0OAsRSzR8TSY6trL6cC3gpHTxATqwPjVDrbDziPGQGIXweW8vVjVzVnxoSYQCbzy5Xai5llWCRj9FSE9Ac1vGnT5J84k1pZcp4WHz8IHr5hViQ4KPGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313768; c=relaxed/simple;
	bh=FFiA2VPKM9ub+PH1WOCEZAji/KKfDY+krWy2iZdyhos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rb+WI+Wd+9weRuhCarUASb/+4+/eTlk7wiFex3GxQdCTUXxp8jmScmHiY1CtwSg77TahZAE/4QIT7EO7T68bbcHAegEgHDbd7hBdlnhb0a2ZhB1q599C9V/AQrW/oU6iTZ0lJjsoDKYPeKAfZdR2MPtsBfeWiqRMk0YfMk2t0uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioHAYj9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioHAYj9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E4C4CEF4;
	Wed,  1 Oct 2025 10:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759313767;
	bh=FFiA2VPKM9ub+PH1WOCEZAji/KKfDY+krWy2iZdyhos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ioHAYj9ALluGLLd4QVo4vrbuGmFLvgjTZz84w+PBl8vB5LHsqjKdTFH4I0cF/GuXU
	 H0qTAjtnFh8d6YhFMwKQUdFD5U2fpTjGMuB0IRYQs1JXp3SzZZyD5ptZFhoDLZ6NE/
	 2rjBkKUz8QOXO0GTegJ7H/Yfki5OOm+XHFd6nAJTyJT/TeA07HB1SCDpbCvzlKrife
	 XeC3SMe4JZjpdcz7yDvVjVQNfo/bo0QTBWkVzuCqEVbaR/rBNryhHamqsUUshwJKB5
	 3jqGPvc9K1XAlCrdSaH51oCkbeBhrMJ+7XW64MrqEVJ5qU4WRvne/YnRKRr56uUT+Y
	 fZw6HvLM5BPRA==
Date: Wed, 1 Oct 2025 11:16:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
Message-ID: <aNz_ZFhUqssPVt-2@finisterre.sirena.org.uk>
References: <20250930143820.537407601@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4+9eGoEYh3YG91DU"
Content-Disposition: inline
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--4+9eGoEYh3YG91DU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2025 at 04:47:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--4+9eGoEYh3YG91DU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjc/2MACgkQJNaLcl1U
h9Aqxgf5AX44V+J3ErMA7NdZYMQ2TGQzYAQNuEHs3+KTi1LdJw8U2q2Mwxtsg1os
pz2rMmOzgQVEaQxlSctLIt7QNvpsqkColD2+Ck2HoeBv4l6fn6CQ2MfoTQSf15mK
/dYW/8UVINQ1bZ8yOjP5QV3GdPDcOOEIMO3kf74KFyIiKA2WrU/lLSm8plg7ruaE
Rt6REYYyu5GEkBueWQVnAHgmXQ61Ys1+02EMV1VjDcBytuDSJ3okx3wcK1SqMZ26
T9/lgD0O+/ZBJXwkpRsNK4z01g34+cTwM5mvGlh5X+7JKaheHgiCBQReRpH+cpKI
TIcNDbXR1FqeQZ3uqXwmmvzq0Ri9DQ==
=vYFt
-----END PGP SIGNATURE-----

--4+9eGoEYh3YG91DU--
