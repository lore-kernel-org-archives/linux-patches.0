Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B0214226;
	Thu, 24 Apr 2025 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745496480; cv=none; b=G+YOikD+/nJM4yoeu/bRtkP9c1rTb6gmnj0LkYA1gayG9siVzHYB9R6isOI9EXiikz3iOGd5HvBozWmM51gF72mdkExBu9k4wOQbWFv78prN8G4bHhrbUalW57HdpQqs0rINpdSTvDWI2lIQP7axQseev9LtKX6Ga16QTcvzy5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745496480; c=relaxed/simple;
	bh=GlRuJmmQf3lAEIYkrp8Y18uixuSGL2Mp48b1XN0uRwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qke8TtDu5Kkc9v2tqo2xu/7PPhNarq4yBT1im7fJDvVddx2lyteedCDwOLgwPHWOhwRd3LBq5lkGSBV5tWHB2GaltAUOTPbWGx90VyBZxeSLL0RzSCO9b+8d6YXweYHoKBq5p9nZ7GAmSVVOClaKpjzN6NeVhQc07+s674FxiAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0cZOUer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0cZOUer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A8C4CEE3;
	Thu, 24 Apr 2025 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745496480;
	bh=GlRuJmmQf3lAEIYkrp8Y18uixuSGL2Mp48b1XN0uRwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h0cZOUerRdZH7CLkHRq+De+ZFxWc/hPC+PCFBYNBXo2pVRYCkwtUz8TAW1+IWwOrz
	 /nmpUrD8YIkl3cBnBFIZuraN6TgPVpN1DTsk3Jzahcqtuie/KD6thd7BxxAYz2XeFI
	 YMJao9qPwlNMVu2z9X9vJz6TpR3Vdm01gBWUboJSXQFFEZlExSlbyQd4rpuuHhEduN
	 h+iQC00FfR3FEvDhKoPm7gviO2eZTblR0D2882vKMlrd6yDrgBXEyeDmXpOGo4pO8q
	 UKMVfaTmEOQttPAcGg/ZJXjB9AssRBj7VXD8HRAHv+/VohS5jUF/PsHEktikiQKA3V
	 5/uUQupNCseBQ==
Date: Thu, 24 Apr 2025 13:07:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
Message-ID: <85a2b452-df67-40d0-bb13-61c1a1636bfb@sirena.org.uk>
References: <20250423142620.525425242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Pq1YIdaxbQ/0Rf6e"
Content-Disposition: inline
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
X-Cookie: Star Trek Lives!


--Pq1YIdaxbQ/0Rf6e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2025 at 04:41:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Pq1YIdaxbQ/0Rf6e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgKKZkACgkQJNaLcl1U
h9Bn5AgAgMVKqz9C4FWYmE6SrrZwRwIg4OEliMB9LsBH4mm0qA5bJiKnm8j8qz6J
grMR1mByMim7fFC/itkliQ5CMcRh6xyKokk96fGtB7siG09dkFLmXtVBxOiEclyh
hX/vBlaBl+LpbN9wCoJFtezjOOBKmsMitRB0WkFzl7I4a3C5eKZ2hfOis0UqqZ3z
3fWLSLw5mTkedhObT1CHvzWcnGSgIQQHvfb6KS6qJ380ncldmwPsoAYBZBgV4qz2
f8lPYJcbgBdytg6vVTbed9tVyvT1o6a1W9owub0MO4527ulcwmiUcKTQaBBd8WWU
FXTe5/ZRLcugbySFO7sq70uvAZUngg==
=OQQr
-----END PGP SIGNATURE-----

--Pq1YIdaxbQ/0Rf6e--
