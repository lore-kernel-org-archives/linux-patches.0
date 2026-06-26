Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFA3F5BF3;
	Fri, 26 Jun 2026 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782479761; cv=none; b=Ppp9jWiS/sceALCC2fXXhIqw6Lsajz3uEpF/frMvlhDqr+PZuZ68TPFLIUNVfzGSmJ4n9SP42l6G9HCeaoCShtK9wExRelrlRWMnuqaqTQhC40QycZ12kXX9OOjmf8sJ0RbLWPavJ55uX5gYHvC+O18UEMg9OL5ofxxJA8Sl6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782479761; c=relaxed/simple;
	bh=B51oCACwxrvDmtzA5qAlGHDHZSqXkh7dHHl1nnbNxho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjAeLyCPgvzDWybaY8W1blsoFIXL8fVElTDOyHvHGd1sCwYPIgEfZlLKcbFJBp5T73l0Zttt5SzkVYmKZ6CkMGUyFwly6nnmYVisY88JCN/26zSbFoCgPPSKFJh4WovSrTmQJJfRjUqQ2PF4dCt0FByPSGckqvBu8vEk3I/RCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsJ0u1oL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsJ0u1oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC41F000E9;
	Fri, 26 Jun 2026 13:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782479760;
	bh=hhS8ZIdRoEfL2AsIyVc2sUYCvOq/Yfaj1ekUFxea+w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WsJ0u1oLRri6VPD6ImoBPZfRtHPwz1AyFcRRxocROBU2OlFkshducDyRYm52kkIlS
	 aJgwOhSGatuvlbKIV+pr0tC2rhrNBgZrwC8IMkLWQwMfTWx5fSmQlbMUzRaWrD2gjd
	 PKfKe3zF8YAnbisqkcd1WQtGQHpj/GjnHqM57mRBENWowywtH22bDewSpmxHOkAOEn
	 rzO8/iiV1vwPw2w1Cg1i/ucVevwTx+0D+QUIpqoW72kUZOjI2xsZ/oIa3OVNhKblO9
	 ZHlwBubqQ4oWzFpH7NiuyBWH0Q/i7fRkwZldaNraz2XJWsIE1vKTQXICpeD2JSBnp/
	 z3jSBUc7Ewi1w==
Date: Fri, 26 Jun 2026 14:15:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <a3037033-7f01-4027-bb3a-3e69d0ea77e7@sirena.org.uk>
References: <20260625125613.243729608@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zn4WxeI4F8JtANEK"
Content-Disposition: inline
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
X-Cookie: A company is known by the men it keeps.


--zn4WxeI4F8JtANEK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 25, 2026 at 02:03:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zn4WxeI4F8JtANEK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmo+e4gACgkQJNaLcl1U
h9DLWwf/Xx5h8yJyrxjF3AQJt8NaceeMcLRjm+f4vXkSVJTQydW/kizwjFxYvJ27
pv0bUj2b3qEbGK+uqCFeVnwCUoKD42DnlcjnP3zeKLliHrEnglDk8NhvU77f8lZf
26rJSHoS6l/GOdRwDUA/rlMzE5NoRYMPwyH4Xnktl+dJCE0UVAeRiIWwrV7NOEX9
AETY+6JxUG7cgZu4kdvXxDOogInxw2hnyvcu5efZM05Q/EWWylw+D0TOREZFbs/x
pwgyLwrBo4wYYAEEnZpWW9Uxbf7qJq+U+4vCEgNTPjloZtBRbP87ShFPFhVGehMB
qOubqZz/gBWFexLhIOShFpisLriAMg==
=Qcxp
-----END PGP SIGNATURE-----

--zn4WxeI4F8JtANEK--
