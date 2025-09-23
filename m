Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764867E105;
	Tue, 23 Sep 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638051; cv=none; b=cJHM9CxDUBNOJFrasQQD3Taxcel4wqWFKMLQd7V+W/yhCaLfKkXvYbEdwrm7GlW29YN1TAIQsj1fV48Exc74DZRMTzDfuoB3Ef2Bf1125guuMK+YLSImXPtSUl9jtzV7/wkhy6oefGLQCdgISD8BkrigqcL1w7ehz7ivFF+TEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638051; c=relaxed/simple;
	bh=2rYZamDZNX6wQq9cq07mNFHSGR2Dy77Kpd8qr7CPXb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcAeGdn0fXjQRyWpcNzjZYiR84JLtXpHk0x1sprMgjJJWBxig9p9LWIe2XSLSVtqlbwOSGTh+wxwB2+JJCayj3TI5CtBEzlpsI5iVxs0k1yu5uzTf6zhU2OggJMP/U5QZTNfuXgVbvJ1FnwF5yyIM2nhs4NyQUe0pMEd1qSUDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFx06MeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFx06MeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51504C4CEF5;
	Tue, 23 Sep 2025 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758638051;
	bh=2rYZamDZNX6wQq9cq07mNFHSGR2Dy77Kpd8qr7CPXb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rFx06MeDNxfxPywptTy+TqsjjxZP8YKNNEsFJVJqUYlBQB99899SkCVtB9prtPqUI
	 /yUss/sAos4mNSugcUhmu5gt6Uc0WR6yCR9/tEzj1knegKzDv7wexTVuKL2vViXYKU
	 7Gw4sJ4k/rS81bthM2/lQGOPozZmrwBLKijsNgyr84a0Un8S/F2CD5/mv5o14ymDRS
	 qKKOENIVRyO9hvTbKJCKUUD2jI8TIS19RdOKwAUR8SLvDBu8/PRTuX5scxkrr5ehYY
	 0Tg2nV6z4I/YdG5yTTuCervWog9u4dVJjoU/gO8RKmhPXkTgxqy/9hWxpHQYYshnaO
	 mnUYW3HpD632Q==
Date: Tue, 23 Sep 2025 16:34:07 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
Message-ID: <aNKv36VSpih_kdaS@finisterre.sirena.org.uk>
References: <20250922192412.885919229@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S64QTOEvVy5fyUko"
Content-Disposition: inline
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
X-Cookie: Filmed before a live audience.


--S64QTOEvVy5fyUko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 22, 2025 at 09:28:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--S64QTOEvVy5fyUko
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjSr98ACgkQJNaLcl1U
h9BQQAf9EcAvNopLQlKdTLN5Uvdb/HT3QovXojslpc0s9lLAeYfOQxrA3BXK1Gms
lVkooh16JC9J0bdot7OVfIoo13fcGqCX1FCSy6tVmxhzy1bihSMxtbWoQq81hpZE
fxTL4zBi0nrM42WHd3snq2JIFl/A/fxdSr1JMYzqPwYm85T8jT6zQt/P2bN049Kq
IXAlJJNriym5uTS6ixuXwG+Xo4JUJZTX6i41IRPqlx5yTUOjXyZ3SM3FYynK1z7H
LyToyv7lwVQWqeNSIzKI8v/+Athw24jO1HsdbGhy4EbVAPLoBnbCpSNW3OEDCdby
yp8pGXRQPcYgLrrCRiSo1FZMuyvmrQ==
=p7qe
-----END PGP SIGNATURE-----

--S64QTOEvVy5fyUko--
