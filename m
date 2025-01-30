Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05F41EF0B2;
	Thu, 30 Jan 2025 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259935; cv=none; b=LFr+/l9EuyUbc2m5xr8k2mQjJT/wAWFUUuGIlgsiTKYTlp4QFwFi6QdS+no7QOlbw1AWtj7NFcLKiQ47McIpKpCFEE4ypWm5EcYKOk78Xk5cLspjW0TyF+QUk5fO7PZdC7YVSUK7GwAF8iNjo/ggt0uI2qJQ0jGtRogBloPG/qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259935; c=relaxed/simple;
	bh=P7Zxi/RetccR9vV3oZrgTPfxrGIYSi/fRiLngW3D1uA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WP0MaQAeowtsJoYpdaaoCABPwnEYnjB5oQu69zi3nJ9hjOm5yDCUt927cSDC7NtYv0zODoMIkHwLNSqa7LCS/dnirc5D43aqWBOs16SAoLO1Idj2x3P1QP269X/nPd1cCTfOyMYMsr0HjDrQWfcnHVHl3YI3eutIhqxCmkOhI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaAP04d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaAP04d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3499C4CED2;
	Thu, 30 Jan 2025 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738259935;
	bh=P7Zxi/RetccR9vV3oZrgTPfxrGIYSi/fRiLngW3D1uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DaAP04d9ZMoaRssUUnnklfeX7ROZRp5s+EUEL+OMZDTXO5uKa6DGWzMm0f/4Oxr+z
	 Q4u4PeqrHhg+AI7+IJuyMvTrS44AUZBkNoNb5yhCjcgIlaKIgaHM8kJ/pgWGi1MRB+
	 1v24BDpENYAOWgE0LKTuOJNJZlVyYmCLVXOw0ev1FJ6Ty3scTEh3jkWAybCpPRrcvb
	 YXSrAxSpeGgQwT7sTdwQ1wPsm0jKnS50LGy/yYmQhC2/batwOJPylyqaFQBYuHFE27
	 fhkhVgtHF5z0hZ8cToQa7l1ElGa9sIS23AberZqyOW/0GteJ4QRq9bRlBap+PMy7oS
	 kVqVaqHHQg8FA==
Date: Thu, 30 Jan 2025 17:58:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
Message-ID: <2e9d40d6-65c2-43ee-aa00-8852a4691eba@sirena.org.uk>
References: <20250130140133.825446496@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rkKQJ5n2PjocYu7O"
Content-Disposition: inline
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
X-Cookie: Password:


--rkKQJ5n2PjocYu7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 03:01:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rkKQJ5n2PjocYu7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmebvdgACgkQJNaLcl1U
h9CLZwf9FRgZN8/PdblTYQzc5XStO8yagU7ab4VNNnDi6cG1Aj7qr0CsPiLTl6F9
uGS0EHhDT0bmsmVr7FkcBfhrMfEwuvKgCnZbdxdwKfW9cuMRL8WkWhmJUy4Lk3fd
UdBVhPED/ad9RziQ4nj5HYiC419qHIZMqjJRw5356lViHQb4VrEPJUkbriX7AwU3
oGGu6gZkpJ5X5v/4ozbIkOKKi4vTgKPYJWysPJoYHAnofp2+c491cuOdcO8SAUoD
Pi4SeMqVVUzT8B+dC6DFt1PLMrfyHPmuAcIN2aTEFssJsxD4sb0HlF4+X0e5EF88
+Ywtt/3eTodnbWhBBm1fvppEm138Lw==
=uA83
-----END PGP SIGNATURE-----

--rkKQJ5n2PjocYu7O--
