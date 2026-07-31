Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C648636F8E6;
	Fri, 31 Jul 2026 23:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785539987; cv=none; b=fnHv7vVhQEvGGfCoiTnt0lP35K4I6ysTOrid0PVsVRwPUrLEQVQ19U+Vpo8cixiXw+JW7q84SPFhnP+ehoRl/XU/s0dMD+K/VqxOoUSPN3hEiRAdHiEDsqO0X5inUqSHMfC75256QVxxDOsnhsNES6v7x7idAb0EedsBaKhTr/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785539987; c=relaxed/simple;
	bh=Kj/XVU0300JPATErI8PfrVG7ypiIaGjAObUJOKfxkB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5uKQrO3CCKmI1jPcIJ336hTwC/GIrgirnIL9MTRTfQodjyk4Mb99PG1mgjgiE1glFNLh25pY8exk2yTQfGRAPQiNCDL+ukzgtmT+WGQ1719olYNLDt2+ydYbq3kFddpfnzwOn4Yi4lhQOPOLtoYd7FuFT+qv6w9k28anOntLMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnRZG6j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnRZG6j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37211F00AC4;
	Fri, 31 Jul 2026 23:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785539986;
	bh=HHV4Nj7iuDZtEKvzVqLOj3NxS3Ehn9LSyCCun5Ex6fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZnRZG6j/ziUom29MrZ8uXGeuQl+r0cUiW4nlpnXYCRGLeAsnnHkH06ZOluoRQyMrO
	 y+u2r30qtuZsCZ+yVv81/l7dB9sB5aJo5kDxbUfa35TOOcuPvvgc2Fvjvq1qnCQ56j
	 Z4wKN/Z+mOBNJZcNOeq5pvoElhXwS5I3HKWzuu0JZqz0mAmaa+6iQHxQHFTVtW7rVq
	 9AnNVU5VuOUgmIFZxk9Jmj0Jrotiwtf91y6X4lhw0rzmD6utYjRfgKf7XFsFpCoVXa
	 b9shV+bKQfz2InvtHQpb8t6iUI6K+bnzyo9MFYVrSf8WkYQmPCtmQcaSm1gdKwUJ/J
	 krzH6iFrMWhMQ==
Date: Sat, 1 Aug 2026 00:19:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
Message-ID: <0255a971-bce6-4705-85b4-472b8adc2529@sirena.org.uk>
References: <20260730141435.976815864@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GA+CzqNNnXUmCNY2"
Content-Disposition: inline
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--GA+CzqNNnXUmCNY2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 30, 2026 at 04:06:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--GA+CzqNNnXUmCNY2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmptLYsACgkQJNaLcl1U
h9C5Twf/Z34mT3QEGxG3dPdxTJOu5LD/nlBYxp9kDmZLf3tOP9DmXJvXGbPL3Gdd
ZqNTg8GwBu1+8hvLu+Y0bia25czvTMd+zJ7QpCOqP/NVWw3obaH9teLkbjFOciAM
XEL0hoFu5OOC0rr6daE4kvgN9EfDKgBmyACedwOZ5b+sCul+0rlwKN7I4Dujtx8u
gWs0tqcNplkE8vjt0tYKzpv2YoLnAnAGiRE/5JtvQmvSp5oVzd5NWsft7hp5gpZu
TyW0Bcdn2Es8sk9HHrtuFNrNR3qiP0y/oPahP9cIoOBUrpePVjEGOOQVD8I2jVOy
QiL73QOCRxsjY1EgfaOp7Fh8+P0mHQ==
=BTuE
-----END PGP SIGNATURE-----

--GA+CzqNNnXUmCNY2--
