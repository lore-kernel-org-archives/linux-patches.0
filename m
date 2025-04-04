Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D481B87F2;
	Fri,  4 Apr 2025 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743768152; cv=none; b=DZMKXSMEo9hEtWfynjLgm/vECh5zMx26l6aNxhmRFFY0tuJUI/0funyxudD7bKmb8YJ1lnQn0pIs273nLwRpvNdmeIhgQRl5Z7nTDfR3kQnoE2UQ1JjTeSPRbG8CAJYDVj1Stpb5rZxPsaaBeeV8cnkyQxrhUAYW6CiJhXnIuZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743768152; c=relaxed/simple;
	bh=Eq3EL8qAfF3ubJ3G58msjokJj0yf2Iu8YXIYO1ZjxMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n31TORY8vq+vB2Mtxr6t37EoH1GSNURkQ9tDljqZxyo89mfw/mp3mFZfRPNBSggjrXmCH4aDhUuQy3q9b102B9G1hYKauZd1fO4fKhoABcUXBwN8ks21cuY4ix5lNrijcP8BNS8empIa8/QGrHnELfmocs1UT7qVmDoJqMz1QKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tY1K6Jyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tY1K6Jyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6592C4CEEB;
	Fri,  4 Apr 2025 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743768152;
	bh=Eq3EL8qAfF3ubJ3G58msjokJj0yf2Iu8YXIYO1ZjxMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tY1K6JydiyfhSflxJ/F4XEFB3NFTpdNpMhmxpX4p12EPUHra3SlintjeP0XRbGVaX
	 Q7VKwxGrsBAh68B35WwJQfpaQPrnxChjMYMcMQXqksHFnNwmZu+5XZPBSioNPkF6Ql
	 +o6s6FGUT84L6uWD9yYKVtDSC1X0wKgnQK4Tp82xqCR1zfsoxn1sryHdRvE7WDUSJJ
	 uwAIP6EV4/G3SIOP5Ahy+gLCra2fzjrNzL9Iejt0076PRfedcTp+9/XvJl3tZN/an3
	 99FnZwt125nzld6iPTkmnJ1AU7gzfaLc2JNoFR0MfQLqgF/mb/FvM2NKWgqqGyE1dx
	 qZkL5UeUMjZpA==
Date: Fri, 4 Apr 2025 13:02:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
Message-ID: <f5e5841f-2ef9-4451-88f4-b19fbec3207b@sirena.org.uk>
References: <20250403151622.273788569@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dZ6BUzTtkXkVXXCT"
Content-Disposition: inline
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
X-Cookie: You will soon forget this.


--dZ6BUzTtkXkVXXCT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2025 at 04:20:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dZ6BUzTtkXkVXXCT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfvylEACgkQJNaLcl1U
h9CZdgf/TpsphPRJA3T1m+oApTfpHrl11zAIYDkxeGXIjOn2W+Ea8GxXivpkz0sC
IHf4nClqeXMqbcr96Ftse6LS30rel98WeIGEOD8WA9WRIo4uEPeQoKU72MwJtr+Y
Pf+dJIfjZ7B2O8B9oOaxTN+qJyN49o7ZwiBeIeeAYC7iwdVBj3Oa0z30rEFAMVOc
8IkFyQKQ9pXxoD4aD/foxTj3eVpUA9wLWNLhuvn3cACPupwnCUPX+KmbIzIrGyc1
Vd13OqIFHn2hASk5eW4dSo8py9Kb/Vu7Ih2COEN7Du3BFk3bC4P+EWHhzwASJNGh
Md98hWDndtNR1zf+piC+ZMpkdBJebA==
=lQlg
-----END PGP SIGNATURE-----

--dZ6BUzTtkXkVXXCT--
