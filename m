Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D95207A32;
	Tue, 10 Feb 2026 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770729894; cv=none; b=jE3NbpTsiRd6609krqVJ7LpWv7QNq1HSJuF+ziJYfam7ZCUL4nM142YBnvgGg1nmr3OivyKU+BXGFB3CK7jf9tYF/Su3HmLtypIfmcM6O3UhHeLxgC3UAcoF5mxv4NxK4nYAqmlyiU4dG+VPwbgeRviW06pcDUABm4GEb8L4uXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770729894; c=relaxed/simple;
	bh=0+Htddb+on7k/hP4fue552UhbwXmrCEeEUEKhtH5BNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EjRdH2RYdIxGSlNUV6ehn05me3b06yNJg+41KzUCKoarbKdTxxDem/ZNnoS/NjV9kJNOw6tXfPQp7UUtkAE1QlrUs9urn92M+dAhBA3H5erki+XSO0Bq7svE7s473LxPLy5uKukIBkOZZ/+e7fGM/foVF3ze2XV3qqGTL5R27sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsCqmWbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsCqmWbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D30C116C6;
	Tue, 10 Feb 2026 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770729894;
	bh=0+Htddb+on7k/hP4fue552UhbwXmrCEeEUEKhtH5BNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HsCqmWbnQJ0T9LUucJ5KAYKzgunr549viHi73OEHXOkWjruSaPXgpZDja9rTxZEwY
	 CYllvYEQRU/pSFhwZpjoyGuYcZWv1N9xzOghgIpPiWed5HVtoAZyNQvJ6JSJCGR0k5
	 Q86WA5DrWWf8Gn8JCQ5VBjad5oP7FiSAvy/2cGML74nyhmgDz70vXjw6vlk0furPcb
	 6PDFy4aIrGkX8kPXTNE//f7455DwZ39iXUdbt08fkZpRCzv/uxtLO2UVuYXi1bRGXN
	 90tPRssVDs4iyf8pdd4r/pvpIefIXIDTN00Nurnj8fjlwakjOv9hFsy9H40ffTnp8X
	 xd2nAlV5gC3sQ==
Date: Tue, 10 Feb 2026 13:24:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
Message-ID: <4ce99d33-da6d-4976-ab30-c429a07b7f3c@sirena.org.uk>
References: <20260209142301.830618238@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LOHyQZ7ReWa+sY/6"
Content-Disposition: inline
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
X-Cookie: Spelling is a lossed art.


--LOHyQZ7ReWa+sY/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2026 at 03:23:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.200 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--LOHyQZ7ReWa+sY/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmLMZ8ACgkQJNaLcl1U
h9Dp4wf+NFD7M5KpH3p4Q4lNS7Gz3F/Zr1oXYQJbZCxlRLucYzp4yZ/nlLTVeUlN
xQ674CsglUL0ekXPJsDnYoS9y9KwmDRjGLVg70IcV5GV+7AEmLVmv+tpTOyzS+jp
6tjJSkUsgI9E4EVKvgIi0psZO2jwbSH/jIACFbwm2M4NKxHx392iDKIHWQWFabbU
4tMFgRsGBKsMr67ExZhD5akN6Z1uQcLUjT0g2yR58/j0vAQUEV4rNg2EHR9gnvO3
A4R1C58PEkpWLZLJ71lh5C1wq7mRz77YPCqh4u+uHGksiYZwKYNSaixMCdvDF4xi
q00g7wtm3CDkquxYsB9EHFMFLbod2w==
=yAPV
-----END PGP SIGNATURE-----

--LOHyQZ7ReWa+sY/6--
