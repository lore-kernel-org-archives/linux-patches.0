Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105D0397694;
	Tue,  3 Mar 2026 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566928; cv=none; b=QV6ARFcGmA8VH/xlh7zM711R6OG7ERZ37oDcVxxmJojJH/CRJwKtBGZ3aPLA5/AQBOIW9uIbV0acd+SbK3BAI2B6IWQLSn28kGMSM+UrLcaeBBkbUE5gkCbGzaX0iyCKZto+4rpAVh5rYMa0zVG1CLoeLtKoqUEdHFinzsEbkzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566928; c=relaxed/simple;
	bh=jWETE4cDtnLNff40KSJIINTc9plzMhw+l7lT9R5nqvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/5hxTx482vLpJWbgdUbFKcB2zG5YymAKs7NMgnd8NZ2BIYOGv6wEtZ93DK3TEeHOO3NiVYn6lGdWNCZ5SvXGRkNo7uiqxpaC9lH/Ypv0FPB6ub4ilfqSoS9IWFn6dfqGz8vPb/Q9BbMnoKsbOHeI1pnSB96eMJXSO+lLXmAT+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGKqhq+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGKqhq+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB7CC4AF0B;
	Tue,  3 Mar 2026 19:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772566927;
	bh=jWETE4cDtnLNff40KSJIINTc9plzMhw+l7lT9R5nqvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGKqhq+woL1AG+PykCW7oYHcQVKzuNoNWC6d+QWgnpaBmjPG8I8oI5jwHyF3H97OP
	 ZEYoHWEqFQobY/E4Y/P7ppUg8K0zBgZ92OrtO2XhHXG9VggMuBWMOX55dZc+jHa104
	 sNkwaPYVPouAKv84A4ZAwmf8hYOJd/2iIX5KNAV4sIboLo1Muj6hKc3WDYW4avIg0v
	 RjUHNL9GL0wQOfTlq1138T5Y0GCpxcbVh/c1p57cqRH9MwZ4IxLB29TtKI56DDDYbP
	 wnQ7NeAhav8stv9O99BK8jFSWMTu94MtVbsZlIqiepzr32zsQJxo5znp7QJYoZX6jj
	 9/Ix0vSEydjTw==
Date: Tue, 3 Mar 2026 19:42:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Message-ID: <69dc32c8-1857-46b2-86f2-a4b3df0f3df6@sirena.org.uk>
References: <20260302160955.2522727-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pGZOSS7cpIAc3vB0"
Content-Disposition: inline
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--pGZOSS7cpIAc3vB0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:09:55AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--pGZOSS7cpIAc3vB0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnOYgACgkQJNaLcl1U
h9AubQf/XsieS6m72FFPwkfrF6aw4X2PRSRHFO3uXA2meaBQQZx5KSSmnpAMIYSe
JgYUn71GUHOc/2722QwAYhs7GsK8ijJXixXHAqxJbD1uYsADlmmhofw/89YQ44ZG
0j6sDPH3yIaRuLscNqlWAJ+iqgtyJcrw597aGf6ViTL0+zEkGgbt4Ne09G0Tqpz3
E57aYvdecbl5lYbnVt+XKv7MO4P4tOW3Djnif/Y4XgGJX2lcm7mQA88A1An6Ossn
6/zdznrvct2iFyVHs8rdWKLNmGrV7GUUQVuRSOnvIWiSznBV5InMRQXh5lvZ7+Gf
kkab5LJrT9wzbZBMT4GY+cnJ3Z9jLA==
=NMu1
-----END PGP SIGNATURE-----

--pGZOSS7cpIAc3vB0--
