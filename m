Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C95647A87B;
	Tue, 18 Aug 2026 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070587; cv=none; b=aREyllVMgyZNjJKeCh91h7DdW2SjMadPf20+fvkyU1K5G3moCErZdGrY5ebEOUZK+ZtYJVBOSBhR7AgeaA5xyJE0GtGmC5J+XRaQFIs5E/a8tyM0bsBvB3SEvSX3FF4JSe1tfmlTnLEGuagtRjGjSNwd+VFSt2d8jUx093a54xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070587; c=relaxed/simple;
	bh=o7A+yZp4XpVrimbjjs2hR2ew5aFlqAHKoqGyEzOWrkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7IbWJZS1Y5IHdEM+Vqvv8115D3ofJbdQOSVgFEUbu6KbwXaw6VhWJfUR3QitXpr6kZQ5jAdTrk8sjif1I/G9wTTgCOtuvxp1SR2EmON/VameBtr2GFFXMuV/qpuCzAiYOvkYvkfvqoqtO0GT3DVL6ZJZfB1R68/WiV2CEH6s4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSBPU+9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSBPU+9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C871F000E9;
	Tue, 18 Aug 2026 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787070586;
	bh=ndtCIL/CIr3Zb4jBPHBOLmYvh6RHBZIr8s5fhW6hKcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WSBPU+9WpwgubiawFPOsAEGhR1turn5lOyqdcal9qp44EPxxPJOzpjuJhesafEn6g
	 rFStm17u25vhBldk6i+DpeLVVxR6sGBt9AyERgC+b7UTLIclzyqENkUB058zsgpdPr
	 UQ8XkaF0oYUZRa0huXJD3jS8u7dd9A7H2LgZzJkKHOIT4psF5I3YuXVRHS4zp8Yz41
	 Vfx+1GiCyqNezbss7V1cFJcRT//1n95bQZAcxXbDECWJ8Ew7V7LOPQcBX1WZWqszd4
	 5rL/Y9oR07lB9RXquV+TTCJ7ai3JM7RkeBF9GALuesZn5Fv+IcVBqDPT0nchSdM6tH
	 Eonur5gdfZk7g==
Date: Tue, 18 Aug 2026 17:29:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Message-ID: <3097d9cf-ced4-4775-ae93-f58c2e89f017@sirena.org.uk>
References: <20260817132534.666299318@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mkm66lCKVsYkK1SN"
Content-Disposition: inline
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--mkm66lCKVsYkK1SN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:32:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mkm66lCKVsYkK1SN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEiHMACgkQJNaLcl1U
h9Ct0wf/b+38xRlzB/THb6kzC8xEikTddnDCQKf+EY+EyB1AaGgGoEtGVzLVqaha
DnL3fPLEJ3EarABRKSOo9l9FTjZBj2PXXJQaXLOktbzik983v9ws4+yrhStAnPWX
Ma32be1Db8UUj3RsbQo1sznxW+oYGrtu0UiMlsnQ8WXYpqD8vXFmgsy17ATxqtNB
DRTcLltZMBot4meofXs2kMYraa4TssuS8qSVxkWA+zuqew9AoohniBqxU7B0s1gV
EVJwO0nSzvssUHiVwjXrmDXYvOLoRwnJ97nOXW4YsvZhcjsJAsJVGUyZVSAR+qqv
sjklnD1CQg+ajQTHY5qUfZHXMeCslA==
=0eLe
-----END PGP SIGNATURE-----

--mkm66lCKVsYkK1SN--
