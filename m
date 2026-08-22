Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D756523EAA6;
	Sat, 22 Aug 2026 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787401546; cv=none; b=GX/HEBNJQDGwtiSiAVhvZdxaJQ4DDprePfcbTkCePNbfDLoO3oBDewZSKqGtRy+hpK+4nJNqx1EGAzi913+nJFOAaDLzUji7xML9ZaioRu4iI+wN5PvGk1PMdGbULz3CpcYabUoRA+2yYhyWMPm3GKGtpKitsaDCwUcmcxvRl/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787401546; c=relaxed/simple;
	bh=abVW4J1jtEfJP9p5EfsOC49AoQztpk3AkSbrkQsp9pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c97cp8FhqmQTFh9nx+ja+wCm0tVFezOVefIdBJSpEY3VNX6pA8mM5dgSgXpyuGEpH1cfpJJ9Zb/FgfIcrcF9usNR2W/IPr4TVNgBSSPQfIJUVso79r7U3yFJePW/rQZqlbSit3glyWJjxd+mjgfwD/AYX86ecobGXcPg2zKGSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvMLRPMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvMLRPMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608B41F000E9;
	Sat, 22 Aug 2026 12:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787401545;
	bh=I5DaU1OSeXS9hnCs//+B35yAK4TKygPkVqI7+oMNIHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mvMLRPMg0bjKOys6ltZQejegI43RwOyN8bWqMDhUNfJshHaFYKeKw/tM2Boilh0Ft
	 RjPZLIUBPT4w+BLTxQFZugMCx39BjQ4eXUvTFzF4WqX9RXEmVZ7gaSlmFXGeqwZz0U
	 4L5zbRI2cMyrZzg+TJ4vjvuHp5IpqAtsQUAwgdS9/Wgdbqb/MHo2AhIKXc5F+6F9hB
	 rUdhRzPUlsjY8Kce7bXeBy7mH+kuiXNUCx5YcAyeOa0aDp2pFZ6Qi4L4jxesZ56bdA
	 7TSGEOYZVv3lKrlWRuDbQGk1bmaEufI1e9ioT4HkP2dCp5jHmB+Fbe+4Va+loEl6yQ
	 S4AI/5ZxdVqPg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 724861AC527F; Sat, 22 Aug 2026 13:25:39 +0100 (BST)
Date: Sat, 22 Aug 2026 13:25:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
Message-ID: <aomVQy1Tralub6Hw@sirena.co.uk>
References: <20260821142844.249995408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aT/R70qQ70FuI1Ir"
Content-Disposition: inline
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--aT/R70qQ70FuI1Ir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 21, 2026 at 04:30:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aT/R70qQ70FuI1Ir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJlUIACgkQJNaLcl1U
h9CcgQf/ePGBIkWGN9u75k9ONEkIlztYJdQA7nLUyS+ojoVRncAX0rAjug6o3+Fq
mekM9tlbwK+8MSn/hdCBO5Efhv8CH/tgBoQm8P5vGqb2z1aRwjqnJH8u1A7G6Cvt
4mld+2TTN+iXyEXg+RL0teXCGO2qHTMvyAKjigH3QbP8ZQnnFHmqKPmw9efmTWwr
7P+XwnEcMkPOKtOt2NRTWxmnBmx9Tdc+F9i6mcj49WsMeH8vI7dTHR1srO/XIYbX
RTsMPDJyeLGultCRZiau9b53B5VRQq9f9XbF5Gxf4qzxXKBiNu0Hmnu9vjyb6qlv
o0CwMMF217XcsBQ48U5y3sqwHBnSkw==
=wrRP
-----END PGP SIGNATURE-----

--aT/R70qQ70FuI1Ir--
