Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996AD271461;
	Tue,  3 Jun 2025 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942591; cv=none; b=kC0GxcNyTXqOek38AfUDBvvHyucfvJ4IVyQSXlyCGXbJ51K2FQBfGqmR2aZ6fqa2WqeGSbaYYuHtx9qTDC+C/cWvJgiYENb/Cp6Ppaa8cec2nYWP14xjhCs1Fp6EzVOZrH5vihi/KRgxek6sJHkxyblRIoCHLOdcfwjxzrZR9Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942591; c=relaxed/simple;
	bh=IGxkwBHaTsBUHdsGu2r4HU2W/z03tesVyjqacAklwc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2ab11Ub5uVU85B0sa8avTbxU77SHbG/GLAU6Fyk/JCk7jg/w9DmRoj0Aq9N0nbEklSt7MVfJRzVKTPA3RQwUGvwphrW5OdWVqXeHUwszD0194GZBbb30u7K34I1Pswmcv29ZNR/hy7ooWM4MdOF50XACBfOPHypKNwZZYBOLA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJIjiZSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJIjiZSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E6C4CEED;
	Tue,  3 Jun 2025 09:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748942591;
	bh=IGxkwBHaTsBUHdsGu2r4HU2W/z03tesVyjqacAklwc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJIjiZSu5Mmd4zBgad4lFUUywDnQ8aqALWcWOcN9xypQlWDrglDSbXRr6yWioumlP
	 y/gjMAZ6/m/y7erZl7pfc+Gbnf6NPaAVZjmCeUvFEjwuOSKCpsxsEFnxdhR+L3A7SI
	 qh6E/J1sg4lR4SHPICRoAhbVvfVbVcEuvKie7GXo8NtAMnN5ok/w0x1rGcIXA/ftU/
	 F0Zf3ej0zvbQ1gN26Vlg7n+pTZNUYQrIVhm0x7mgXo8UKlA4hk37qyscNZkLJKZ8Xh
	 4lrrUROyudaXnoobHgHz8CGcbGhljCWRZs71zgfv5I2xJsnysBh5eL/ao8d9O/sHuQ
	 zDYSGt5pn861w==
Date: Tue, 3 Jun 2025 10:23:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
Message-ID: <da42848e-4ee7-42c1-b291-8bf3c1c80c31@sirena.org.uk>
References: <20250602134237.940995114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pPvxfX2beJbnEfrA"
Content-Disposition: inline
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
X-Cookie: Avec!


--pPvxfX2beJbnEfrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:46:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pPvxfX2beJbnEfrA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg+vvgACgkQJNaLcl1U
h9BYuwf8CwrLq+WhMB2xH0Otrum69fwpXeZGNK6BiOSMjfaSUOr7mUUA1Phte+pJ
gVvblK3vEitA0zCR/s2RtCoLC0qj2C93gP5RVzbqbe2mBANDm13Ifyfyg3cR7YbK
kkTXIfj3l8VreVQSHPZQr9T5BWlzrpk0PDAqDFwEvyStTfjW3Zg2C18WTBBeZOzY
OXziGvH8hbQ9+4h0IGgRYO8xAWaGcvduR5dOSGfulsPL8KHEQRVldjYgC3yEdjSD
tBqKt6fKimoj0Qwta9sELIP30ImbcKJc0/gBVJFpUWB9VczxLpnXtA9Jn/5b8Y05
paAnSD9pZmfsa4Y6VIhyyXBRiULJrw==
=lDDW
-----END PGP SIGNATURE-----

--pPvxfX2beJbnEfrA--
