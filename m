Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE2A374E7A;
	Tue, 21 Apr 2026 20:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776801888; cv=none; b=JdLQfwONlNVPkwredbQmsUXxJPX9GPIIMC/vYQkUQUbcE2cudcObPztaxjYwkIa6coCs0p/jU9xQ/gJXm841F3YA0bJMJM7kOgrMohVY5QhxzkOxiGO8DB5WfDBnavFyaO2OIGlZKIqV5Lf0RYhnq02SQfYFZHLJDqbzjrrPUnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776801888; c=relaxed/simple;
	bh=WybtY0lMzqcCEbRto++JM6GkPDutZ76eh+c7Eurl0Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUnk6WxwRDmIEPrKD/6phqqyDKyTCEBn2bQYf2JOnJG6oMdOfX0DidHTh7KVMNn+syQRdi0MKF/GeFBUTQ7e6xd+Qot7fK6hwiJAgGmiV3aBet3YmlGprEuCr7pQYBbmKMLItbZs3R/KiXpqmJ2QTguAncOg88tp4DtRwdTfmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zue+wSUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zue+wSUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42246C2BCB0;
	Tue, 21 Apr 2026 20:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776801888;
	bh=WybtY0lMzqcCEbRto++JM6GkPDutZ76eh+c7Eurl0Ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zue+wSUSTuF/0CUel5mRMOUVaJAKnbWSgbFYbRJjRK0k7fx4iHJK7p3LkLvbIJGL9
	 tRTMmoU+yD0Q4TOiD5SvRSByD1VF/hapHwliduk8g9h+KPDWjptZrtpRgrp/Ha3Jf5
	 s8oDrGjQLcAOEiynplJARmyzExpQJ9VzjSgs0IRFXeiUldXLKcmyXypD70821FMAct
	 v1s/VRcdqEzuEhD0jgaLv2oZn3oQGx3R4nwkao7FDNP85KoEP4fLsIxlM/MOndg2xA
	 AX7AtPQGWA4kClLwaZAmz41aMBy5dk711/JCanBbbHdYupoCN9enkKwVdL9RyBhXef
	 g4kYzLJmkR19g==
Date: Tue, 21 Apr 2026 21:04:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
Message-ID: <7dc1dbe7-a030-4d5b-8c9a-e32d8fb1bff0@sirena.org.uk>
References: <20260420153910.810034134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ozitZSXaFsarPyAx"
Content-Disposition: inline
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
X-Cookie: Jenkinson's Law:


--ozitZSXaFsarPyAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 20, 2026 at 05:41:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ozitZSXaFsarPyAx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnn2FgACgkQJNaLcl1U
h9AhDwf/RKJavycvuzoK7ERmzKaBXhoKRBeB6xObNMhTcZjCIbTSQNLRxkrnrDGd
8Gsm5nuFScHxLEYGOHMCROVZsOVtRzUhHHXmCbGeqmDlmoxqh4UWh9dGuApwdyIl
2b0n9EIyAOrhGCQqzqm20Q3TPEqmuVggXmhCstLv3hkgiC8pqdRCZyrrwfHKsi2J
eDTkJFummK7TyU7/RBKeWEgWjYemtZXF1WDlfhzifU4gaMq050aDMmI+ENcgAKzr
srRxTLetcMuQvjBMT+EqEnBfT+L0zRREmO0MKYJnfHwCWcRa17P/WcSKR49we8j8
t4NEjX4W9hZd+DsQ5LnYk8tK57BLPA==
=WcpM
-----END PGP SIGNATURE-----

--ozitZSXaFsarPyAx--
