Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F5015539A;
	Sat, 29 Nov 2025 01:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764378169; cv=none; b=SbqX6O5gV+c2I8i6pIZUDkuC40zuHtIWffYY3Rln3zeZrx+3swGjW/bAqpT0T3925dPmVA35ve/IhH9n7d1jQDBlmBwDmcj0MRuGHnuLV3RzjWPnvX0WDEjKHQylE1sHuMoZ5j2ovMj0yuDgh3cG3ob224FVqe2CtHb6E+JX+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764378169; c=relaxed/simple;
	bh=jlvS87EN7Ev3y5P9xNVDePiqSC5UxqZRk1g1cDVPA9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I31TUYML+wWayQ6jNplh+oZc3qWR68oKiK4Vh0mi6ngPZ5y1ppjgXK2sZSMUKwatYWc7LCLGfYprTDMSQI4jhODjezChu901pLcf10lwtCvADS3XStoq2ZTKm2UyYB26A/6TfcAejJoaXkvjJeCJmzCyufGl0cbxYJvJHWZqcz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzOE9AXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzOE9AXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB96C116B1;
	Sat, 29 Nov 2025 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764378169;
	bh=jlvS87EN7Ev3y5P9xNVDePiqSC5UxqZRk1g1cDVPA9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GzOE9AXGM/X+5subdpw4Z3Le5+i4s4SwhTKj+25ZivpK8swHpvEw3hDkovWWdY4AY
	 0DXq+YMGgEk6tvjGmcFzs1xSF4d1eFqN65y5THifIA27AYNiZT7rPbtco5g5ihHUIQ
	 1ixSRwFanCQU0L3YqEKxE2ZrzrbsnwRfvhPn0Nt6Q98edoMYMY2TqI94JFWKCTLrCX
	 ZaXlbMQIl3XPvSWSFq4KJ0vTg4eeI7X56lOyPzYKIQtP3m6Pxzhuy3hThP+439ADjs
	 va7kAjjqvJMi5dBbZraWhBz029vVVvzEidfuU4ZJ21gpO/KlDElqKbHwm9/WbBP88G
	 kNzjOB5x3NwUg==
Date: Sat, 29 Nov 2025 01:02:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
Message-ID: <589fbe4a-be84-4021-ae87-5ee0452eb208@sirena.org.uk>
References: <20251127144027.800761504@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jWSbZDhX4PifJGrh"
Content-Disposition: inline
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
X-Cookie: From concentrate.


--jWSbZDhX4PifJGrh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2025 at 03:45:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jWSbZDhX4PifJGrh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkqRjIACgkQJNaLcl1U
h9Cj9Qf9ENg+BN4GQ4dhYksueD/oXFVSNj7ZxrMc8Fq0EH0gRMNjfFSfegovXakD
s9K8dmyyNBZk2JmlHedRnQsj2QmH3dJuRwRvK9vCyFYHdHx6FPrZmP+0MTlp8P6P
Ji/HF8W9vm41V525GkyLUJYxZrvpRUoLtLoqlmTS+y9QBXlHLImPfcDbwa6fjQcU
dW4pJtiOiRQOy4ZKHk2Fvm/SWfy0Pkksf1U7cPnXWNekLT0GbLRobVclUT8Tnuna
OsT3k4kVgi1i8F7gQZ2KEvPCCalrXg+Vt99FlF01s+6EC+bYcArc+6+U1zN75CIv
mKGz7gGDZSE6Fx73RPmTVp6Ff/WfUQ==
=NO7M
-----END PGP SIGNATURE-----

--jWSbZDhX4PifJGrh--
