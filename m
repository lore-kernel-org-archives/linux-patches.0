Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E719E1E495;
	Fri, 16 Aug 2024 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723814204; cv=none; b=orEyXoScnT9A06w095H6LBHulLsHs+EW4+x5Wo7oZzkExgS4esQBRoVBLfNkCbFy5MNQBS9Z0dNV3qJKnA3OIsOTKUWFG7NsH/WWRIk1u5aVSCT6HdraMOJRFPY+q+4ljgDhNUkPJSlAIh3O6MmiOAnrpNY8htgXk3PiVabqeqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723814204; c=relaxed/simple;
	bh=oMRP9g9WrHtUyx2kHPQ5xZCk6nck2HERE5nYlQTHlRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9XBGNJk899jYJsErAcnDXTtV7ubW3a0zY8+ivjzaxBdvsiWS5FqpbKP/C4ZIiTUWQii/Op70zgTp9U03MaX4lQKiSGBuksMthYRI/IwkLZFmRuA0xEuqbc8JQ52gjj6oGCPYEm7RYh1us0gGV81I/LB+BXXHGOVZy7aw4fTbYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SP8gz2n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SP8gz2n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6230C32782;
	Fri, 16 Aug 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723814203;
	bh=oMRP9g9WrHtUyx2kHPQ5xZCk6nck2HERE5nYlQTHlRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SP8gz2n0mqEpzEBzA2L1XQOpj569rNX6n8SKH9K3f9Vyc1aqzp5JJbUhvheNS8xsS
	 bv9rJl/1DIdAh1wnuMKool0gaPpij35HNQ16uEBIPqm1mOEyoIP2/qoKXD6czKAT19
	 0f3l4iv7U6+RYcxdNkdw+jv6c29Xtu8QpUsUWbU6QT82Os50UD2/W3ev1/3Psyd9ky
	 /ac+6yAYVlI5qH17OQQ2zweEpw23Yaoc+XwApkr464XRF+V6fUEIenma490Wk/oZJm
	 BjFsdzdHgNQcwa+ws1MBmhM5hObXX5gNW7Md+a1WEoB1q1Qdpw1l1iIkRPa5uVW3NJ
	 8jLlkEZQcQKqw==
Date: Fri, 16 Aug 2024 14:16:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc2 review
Message-ID: <b8e4af66-d952-477d-8227-d1eb9527b701@sirena.org.uk>
References: <20240816085226.888902473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uWMQWVIot4EaUV8o"
Content-Disposition: inline
In-Reply-To: <20240816085226.888902473@linuxfoundation.org>
X-Cookie: A Smith & Wesson beats four aces.


--uWMQWVIot4EaUV8o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2024 at 11:42:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--uWMQWVIot4EaUV8o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma/UTQACgkQJNaLcl1U
h9DeXQf6AijF4ILS/JM+FwC1iuB6FCt4GgSXV3UaBG05ojS/lnbkHTenWCajZRoq
hQd/tQpL1/Dq4LfKIAPIKn5NG7cHP9qlvpeAxbokOi4th3PMY+CSv6l4EJQPnTJ1
D79xR9xeakVUSnoqoyKL/ulx8Qk9Vmz1hmiRG2z40kpxI5R3/kWozfczy0F9OrCl
p3ncHPdABed/1T+t2c2NMDOUYObalHC93tZ/yTuMJ/XNnhPsCZJP/tnO/Wb6CgJA
udXD9s/0yVKsKp534f2pzRGvPqLBw+8k+WEPbpf5IfOUQPt3kT6g3ERApqdry5if
UDmjJJSg89oasCF92nWywGCxcPqaVQ==
=1kkm
-----END PGP SIGNATURE-----

--uWMQWVIot4EaUV8o--
