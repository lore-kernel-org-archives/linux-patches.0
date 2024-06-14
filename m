Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE96C152;
	Fri, 14 Jun 2024 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718374548; cv=none; b=QSIJvZNddtSmCYqcRitMhzr/F3XiUZmMXSYf93Yp6vIT+nK1Kigef4JNnyY8oSbmn6MMEJOM1SIUY63BQfMZd+8MBei+QagXlcBw7PN1SC6K9BCTLE4zy5cIJ0IZQbz/xxBtECzPiH4E/NCQrM2oHilFGPfkzGe9OIOFHHd12k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718374548; c=relaxed/simple;
	bh=PFOfSpSLDRx7rYM9hoqorQDF3eIWLsTrs6bo/cIrGzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lm5Ppqi9Sl4tvPNFl0R1aod8ffLaOqgG2tA63aawu3VbK5jmUWePeOoWFX/6o+RxIYIUH4NjaYO1hyDnjH5KIiMz9Qp/cgdROGcL+rWZyhjfWcatVTseDDFBLHMGMGr/gYH4ASgHgzpQvatSRZJg9Znk0snigZ1hpx8SO4Bfqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qprxGz4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qprxGz4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C39C2BD10;
	Fri, 14 Jun 2024 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718374547;
	bh=PFOfSpSLDRx7rYM9hoqorQDF3eIWLsTrs6bo/cIrGzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qprxGz4hHQa9jNqFM9iV3afMEpRhCD3zf6fyN+lOQ7FZIEIOwyfZXOmY0QnbsVZ5I
	 l3t4rMnppKFoDOYadYcKmGNIpH2VqkMrcsubR+ajyaiHg/orC9/exbbQekY7KdFGDH
	 I6QdsXJqDUyBWnowlfiN4cHtToAxWayrQbYjLlxb+9cvvvLpFce/StJc9uEieLohRh
	 PmvtByruR34BBo94pzfdO2dUzLbzAc41h0Sq8s3XiW7J8kWm5i2hXybewaCgr4wA/L
	 sNBtNWu4zj1SghVXP2PU6Bb3xOBF5Sc87jzA+ZogYCNsHsBOixW4xlXQT6BV2DDlh8
	 nWvXSQEa1pyNQ==
Date: Fri, 14 Jun 2024 15:15:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
Message-ID: <ZmxQkO6O3QX6gcp4@finisterre.sirena.org.uk>
References: <20240613113302.116811394@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PfN2e3JWgo2v2Gv6"
Content-Disposition: inline
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--PfN2e3JWgo2v2Gv6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2024 at 01:29:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--PfN2e3JWgo2v2Gv6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZsUJAACgkQJNaLcl1U
h9CHbQf/X2dR0nNcURuD+OX5l6WtCMsOosr1rHOV952vVOSr5iEM+/SwytrSUx64
6k6UijijDjcamJ4mHTfJk3SDULKgBtcda7aaRIAQB52f0L6BAfmWx8mqweGE6yLb
yH6lbFYjmqYKkWdUZOZSnBlVlRAj9fCV8o9EhK7hcCuRxWZUbB3sKV72+0gJK6ib
cSvIrQzTgQva1HdMvivwWQskhmN5EbCwcE30V3nCB3p22L3dX3EoTpqRCyrWB0Iw
0XRXEpvQL/fNTY43zxuanHb8aHUOF2GIpYfzCpQEmae4QRY5J/NrFaBlPoIvQPQT
EE+WH9fDHfC9T7TtnRS7/JSHSw1PHA==
=yliv
-----END PGP SIGNATURE-----

--PfN2e3JWgo2v2Gv6--
