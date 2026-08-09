Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7EF380FCE;
	Sun,  9 Aug 2026 11:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786276525; cv=none; b=Ds6qV/B6xjPHSia1Qz2+poZ4hUe2cJ5NWxWtrWUHpdTybuDvNNAPHKfJpVrRTyMn/X5kDqYeT4i2nUBS7bNksfGxHcLiV5O0J/o9OWWvrfhtrpknwkv8dt57YBh9SX1xwpb2wC7gzlskR0+c1Jx5Kw868vfZwpr13vrPfJVaIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786276525; c=relaxed/simple;
	bh=q5l0BtM5SOl1tI2OWSGiiyHWSFzwAuF6m0CWAExG4as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJE/AmpHF+E9Q5nRvRn2SrOkSRMNhpio4UIt0i8MLtcCyYn4YriOYQlk0ioALOqcB+1u5wOMNTBb0O1sZJGV6MYc6UPvr7oOBi9+/9ZPfPmmw1H5G6auJJgVjCrPvlwR405k6mTTfMfF7AwC2zwXZ98+VWDVbceA09Ly00qFUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrrFcEoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrrFcEoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6592E1F000E9;
	Sun,  9 Aug 2026 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786276524;
	bh=0QDubVJ/q3Cx43h9YOzO0C6Ppw0KU8wBEBO/vF1CCVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hrrFcEoKtZa8n6TnUU3OnYID5mqwzjBL//O7w4SG5MfR+y275pkBRSf0jy/+V1E3J
	 oZV0T5LABlLCa7ZLTJSkZY1NHEkJLDo1YZgx89budeO/itnyTOG3F/WV45eftsLZPW
	 ijHnjjzBGgy0C5+V/BTTMvASIvZMZdwYYcOGCjUixEODpeP9I4+jU/cJDUhPrC3sXy
	 5HXntJN+wlbtEx4Muvzw7I1+teqRrVMoXkcGmOI13oLExbHfCeKKbX4gEuaCGCbgJM
	 QdpQsvnM5gzP1aDhekfgSNZFv/vd2GeInEDuiFJLKmdQNCn3ydKt5AnaK6wWgGAhGO
	 Tce+3kJtIdVkw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 4D7081AC56E2; Sun, 09 Aug 2026 12:55:21 +0100 (BST)
Date: Sun, 9 Aug 2026 12:55:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
	Ilya Maximets <i.maximets@ovn.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
Message-ID: <anhqqbGJReX0ZXPd@sirena.co.uk>
References: <20260807143418.516897842@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C5UaXzQGc/KDtwPe"
Content-Disposition: inline
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--C5UaXzQGc/KDtwPe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 07, 2026 at 04:33:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--C5UaXzQGc/KDtwPe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp4aqgACgkQJNaLcl1U
h9DO/gf+P1dvbYyEIu6xopp672N9Jhhs7auila0iSFa9o5zDBk7VxcUGDYXd4Vnk
0LlYyGz0rqTWkSNdmx3VlVTFwMx1ffiv3aQmnLuvNgS9TyeekJ44QNUvGjw+xO1i
zc/GW/kY2R5rqyC0Z8Zx1xCMHUu6crFh5ak+QBDJhlZ6TLhXCLqYmyWS/wD3K7ZD
k4xre6Mx6nMLzzkMrbzme8jb2PipfGVgY+NeIzmnU0V60oYzfOk5TbhY3x5+dQZs
H6PMoPVqQl62IPNGq3cNcyZeEVVRH6rVFGPe584Jao4vimgDSIGFdRWh5fJiF2LO
jUbU4jXDZP9AF28MVs889CCBfCTFPA==
=q/0j
-----END PGP SIGNATURE-----

--C5UaXzQGc/KDtwPe--
