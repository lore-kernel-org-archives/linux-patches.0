Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499B151991;
	Thu,  6 Feb 2025 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738841629; cv=none; b=bTiQLLXhNsuT7bWGPayhcfwfsUnhGSWUse59IZUH7Ht3u2uGQ/RINk077DiReyyW+Q8iFeCCYEyk23h2NPe5rfwoGQnwtSFjQiSvtL8XegAKCKG9Fp8GJ+cCC2JRgZXbVQrhnxOpS2PRDZCXwO2OjRnpmZIrhxcA3M7xmBCraLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738841629; c=relaxed/simple;
	bh=TbgwQ4VMM2w1XROHRkL935VhptEPigSC9ZdvJ2Qq7Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHXu0mD9itPP57/vE4RByLsCLG4gdWrC/qpDcuZH45CdF3P71S1OcG0FpU4xDMnyJN7rL2YHziDazxL/bjvovGOdw2BhPpKg1xQo86uWPL8wzYBFadr24H4QjaESCypAxD+7M50ktVvRFNrWUz7leUTGl36mWtVLXjlzNSHadV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gc4USo/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gc4USo/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F133FC4CEE0;
	Thu,  6 Feb 2025 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738841629;
	bh=TbgwQ4VMM2w1XROHRkL935VhptEPigSC9ZdvJ2Qq7Og=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gc4USo/EEKisLzZS9X+KbU2hsEpWVLu07pcGGz8Yic5IVBiac7RngxVX6QeaLQDK5
	 el+W7HvwHaeTJ4B3lRYlvZbKejal+ASaQR1cdIjtHyh0yi/SX/gdFKIYev2tHVkjwg
	 10NS0jZdANgHXSUcUL4vxYX0YJ1ZIkqxM5/FjPrAdNRh4B6XyF0e/30bHgA+0lZqCm
	 jgL9k4JKLAEquA95mzwIU2ZudtzEjBv3ZBxwDW2kNdSOdVjquYbpEt+CoVz1NinTGI
	 0AcUg/cj47AnEBesUG1+yrzeNdJo9Eq/zMzaaWoV7mpgDgpTnY8VGL9asyIJ1DahHr
	 e04Qk5rLHhkFg==
Date: Thu, 6 Feb 2025 11:33:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
Message-ID: <ceacbad7-f89c-4cfc-95f2-3574794a9eeb@sirena.org.uk>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yJe3kDikkKh2MyH5"
Content-Disposition: inline
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
X-Cookie: With your bare hands?!?


--yJe3kDikkKh2MyH5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2025 at 02:35:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--yJe3kDikkKh2MyH5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeknhYACgkQJNaLcl1U
h9CjRQf+LJ8B39TQ0zN3gNVAJ0MF1zYiGn8LocQFoe237rzvA8brvlI7ZJ64kGQz
EQ7mhSKu6LMFWUQbnJMYFAZNlCEyfA+9BpzNQyz6CpprckAY2h7c/z5A58kyuL1j
avxcf1FOAgKVz9aUULl5dHMa1JWtS69vnlDfC4o/9V5SyQLr+rrofgmBEanlt0D5
n23sPl0e6mWyHvPMIFn7rIQr826FEGWxAnTJrgnakOccg1u5gEQNtAUxbV4npz8s
o6phQm021Jc56MGj3R/1q+Lq2mncAdGsfuMhxcPO4JjWEdXX31+r+qRaJji1zDBj
VQa9iJuvThRHqloLGjqZVOy3xFpYkg==
=1f5M
-----END PGP SIGNATURE-----

--yJe3kDikkKh2MyH5--
