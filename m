Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5300D7EEE7;
	Tue,  2 Jul 2024 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719956328; cv=none; b=YyKWscnrCi0djRHLtycgbet+4RJfbgm87uWpJGgsl6tMXWbz407Jz6Mecj7VIH4pziLYksMTXwuav30cU6ndD+EQKqvjI4kr8vZ5mSAzgXXZyPthAnk3VYBkIHy5bfCouZ414r7YNCfA4FpNvtuGOQQWP5ZEPWt+86oUvIRW6sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719956328; c=relaxed/simple;
	bh=Hi2MAjeoOywR2rNMt5PjIhlO64Ph+QfHrP4FVwlVzNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGEyCkmrEmEUj6sNLn2j3DNLZWlz4T5oRVqjMAdT+/YV6n3SphN9SSmmg2dW2+VTQgWLoMdRFxQQxC50LC3ZK/7tPIsAvphdLdhAlEIg9R2CC8fHu0Oj/TBqmLPcPOTNEm1kKLRJdbAVRc4k9U8qNd799VsbAeB6MkqjXMdQCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULMVfy5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULMVfy5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA50C116B1;
	Tue,  2 Jul 2024 21:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719956327;
	bh=Hi2MAjeoOywR2rNMt5PjIhlO64Ph+QfHrP4FVwlVzNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ULMVfy5VdDI3GfBFmQowVhuWTIBE0LdL+ZOMzxib5hLe2FZR3TlRretrQJZ3QhVQN
	 gppxYuW3BeDFN5abCYMCM3OlcGK3N5SgicmAUAOyLBRb4U5Uei6EQAnKPGDzv6WzP7
	 OJzHElyYFC0DJdRbrsozViN8pfkUFiOvtvjtt0zqsrns+54YaYqTljz/hxc7Dro0ch
	 F/feyLURAwBfJ4jwwXBbuGtobHDit+wBi5Aop29/oFp+cbnKdohTpde3zVDIZG9Tkf
	 p8kB113gyHwlT/lbi0I6t/h33wDXInXk7ixZp9vi8WVdVVljA3DjOcLCdaooPn0uWd
	 ljFKJf0eHBLLw==
Date: Tue, 2 Jul 2024 22:38:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Message-ID: <ea541956-4b43-402a-b66f-562b4f1a9518@sirena.org.uk>
References: <20240702170243.963426416@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DQPDThAnoIZ/tdqC"
Content-Disposition: inline
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
X-Cookie: Phasers locked on target, Captain.


--DQPDThAnoIZ/tdqC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2024 at 07:00:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--DQPDThAnoIZ/tdqC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaEc2AACgkQJNaLcl1U
h9CK9wf/fRKt+On4eGZ8UduWir3za2toZxkgjloGSN2nd5PC1tdX0FimxNcpcSD4
tf1L5gaiyfVKEY7k+hDIGh+cKqBhphUH0jcbhcy4ARopCHJOJpZ49BYTNuZaaoTn
wtBEu9V/g/nEpGFs00RMgm/MH7Xglh3ngQNBLlqzxGQzdjeuC23YLUt/lxgLo642
iWhnCZPDxkXTKr/mU1J2Ck6moLYQCx8HgUNf6TJgEnU9opdyHpXRMDwR8uplF0Bf
fP1hrr6zvEDG73653PzNAoCNImW+TNKB9YCzp+F6Ofk233paIjc7CpcywNV36a4k
RxD90aXMdwGaLnx4ftrxNwQSVAS/tA==
=XTDv
-----END PGP SIGNATURE-----

--DQPDThAnoIZ/tdqC--
