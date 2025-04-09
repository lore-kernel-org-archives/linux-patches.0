Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467BF26ACB;
	Wed,  9 Apr 2025 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744237946; cv=none; b=jenAdnAY9TTjCNjF7ybuP0WBvEBkLA4fAfn6vOsjPuhXCP5mLAMI8oGALFKv191KArAkoidIjDj+77gBVo9/4f58XjYtHE/0HsSx2qLfsrB2eROOieUicMdCUbOYR337Arm1wHOgttNG/UCRn2tyImLzp9W6j9rjjWn6YQrl46g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744237946; c=relaxed/simple;
	bh=HIU4DgAYB/TSofZ321L3TG972sj3AAb4uIK2lxCHGtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGDkEsu1JPtIJ8E4xBRWA8oeONb8/TTV2alBwBydImx00ziu+xXFR10fpcq79785gPi1xwfnK9/dsNrGkaD4m7LL/TYCBqRTUy5C8ELqGZzSoU6blKorKxOkGbwTwKfzPGcDHFxavSY4uWg60q1Wzyp1+36DVBEmtphyqzfKP74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euMShFHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euMShFHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD41C4CEE2;
	Wed,  9 Apr 2025 22:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744237945;
	bh=HIU4DgAYB/TSofZ321L3TG972sj3AAb4uIK2lxCHGtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=euMShFHGIEBHjz2/aaS3J/r0RDvAUQYkxo4NelIO5uc3JQC5lSf/dNaYZGi6NZB5N
	 0apOSnRf32tMInwYJefy98CGaWT4EL3Zbit1JkF0VLzPC0wmbo2EbCHVexuFSWqqM2
	 KBp7fyAaZta9XXFIXjDnU9v/5KMMDgnBNsUxZz2tU3kgGRHQc2+IbaMHbkzLnp4DeZ
	 sQZPDzZrxosubcFfAYVM9zfffeE0MvX6D37QTMkDi3AJfp4Ns3Vc8l+5BY0Xd+ZdSo
	 sdGOEltYcc+ZXQgFsbzAO9ODTOIkuk/QlgVwo2xjp6z07rkyaayY1wnFpnryUq3m9J
	 CagiLyVCAetoQ==
Date: Wed, 9 Apr 2025 23:32:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/228] 5.10.236-rc2 review
Message-ID: <9dd0c0b1-6b0e-4c01-b706-c21dd185a836@sirena.org.uk>
References: <20250409115831.755826974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VZmYilzS+EH2b6/S"
Content-Disposition: inline
In-Reply-To: <20250409115831.755826974@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--VZmYilzS+EH2b6/S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:02:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VZmYilzS+EH2b6/S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf29XIACgkQJNaLcl1U
h9CAOgf+ISS/GlK3nubntxGBkThwaMknIvFV7xGjiYMPdaAlDaM3MPu8LxnsoICX
PO17jICXcwLB3OQwKViVYEN35XKU4tWPwQUhPG7pVCpwmQk6dCyoUok1speW/mKx
AVJrMV6/XzwSVefrVjYim/3ULaTshES645D7KX/TQieBabcY8ilgFt2RVpkitpvd
shaYmSRumNwwxlJZx/hJkOAR/Ncx+nlPq1J1gQtRltHdl19DwaKRjkJUHRR8PaMT
0+kud1ZDw8FE9e3/+5CYTQKolUfx8aplDuGq+hNVZAvuRr1WvqHph+J+F0zqPsVH
EPbZ0686RIZQ48LxjOo762DB0/ncug==
=MFMs
-----END PGP SIGNATURE-----

--VZmYilzS+EH2b6/S--
