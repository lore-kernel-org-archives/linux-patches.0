Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AB93B1EE2;
	Tue, 18 Aug 2026 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070689; cv=none; b=R8+wauYgsUopjs/K2ZdVH3V9/kwhHfHyxmbmesaK77uC2qNscYDL0Bzz9U3OougOE7rMgUV8JuHxZ7A71KiNyvjZw4cfz2pncIj7y/nwyfMuqntalDlntX7niyOBCpRfLsI7aR8Tj7RspGNNGu7ROhI25IJBkGPK36I4Ac2E0lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070689; c=relaxed/simple;
	bh=mFrI09yznPtQJq4VCwF5cCv3nhHVJbtQX+VRLhwvac0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMNeGb9oPu3z3PcIR5XLEUmnP1XYwtrHsk9PbdHORxV0f94NovaUxWsK6wimRsxctBGU+Nvv4g6wtY+cw7D26jP7LFWwQV0rrXI7y9mEyr96+a8x9RRLMZ4Bs85wx8bqE4KqK4k59iR/t9rJ3M1jKAacuCNwLsErisPmKsSumt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0vdRL1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0vdRL1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE81F000E9;
	Tue, 18 Aug 2026 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787070688;
	bh=7sDACzkJNSH2asI4Kk0C+nf0kMoRvRHHZpslmlGoxNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G0vdRL1JiLdCpVYHmhCRJC1H2777aqvrui+FlVNsHxFntfpfv6V4rfJymTwmttCi8
	 7hlshdaFssIggPYcc5YteKJXIdBXC2PMRkGOTrTJJNJZqdq0AXhE2ogVv5RKKamv1s
	 DT1GImSsKAwRWWIpp9E28ms8+s2+RVxuFRwOX+gwwAFkJGe7HzRZcU0rsR6UYvfnDS
	 wz2mTSCqepb14+5mxYULh+BHWjNW9BFGmdCXt9MtTD0eYKzXtbPqSKjx+b6IIGLmhL
	 GbumtLn0gRQSsT7crSYeWoDE651nnX4YueDI9oXWZ153DSCD0W56zI2gQBNsL8wcMf
	 eXwLnynY0y4DA==
Date: Tue, 18 Aug 2026 17:31:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
Message-ID: <55fa3efd-824c-42ca-ab1d-14b2609f10b4@sirena.org.uk>
References: <20260817132543.039278408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dWcLMMjuqSfvl1r/"
Content-Disposition: inline
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--dWcLMMjuqSfvl1r/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:24:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dWcLMMjuqSfvl1r/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEiNkACgkQJNaLcl1U
h9BatQgAgjFZxKCVqGm195/n2hia3I+gsdgct1FVMNpHbv4cflnROOL5Xy9CfJ48
20ttohLFtgnWKa1XVUcPAW6rwo3/dMbR1ddX5kvAbksS7jAF/3bqZO1LLGNBTNuG
Dh/ai+43+msBUvZXoeKlmTmN0G3NqnVhlKmXzr5McMXHXP5mHanDtHfHwI8asSxM
CYXS2V77hCBikb2Cnmv3x/OOr0xK8zDo7iOSnbTsSNxgRU9uF+duTTxHcYG9URc/
xYIZDpaEMxAjnLZrKMftHKy6J4lAianyVty3SjHkSdotQgoQjMlyl3GdnCCHfsQc
VT6vt6WJjLh7YSYFxUyoyJGDaVxchA==
=iNyB
-----END PGP SIGNATURE-----

--dWcLMMjuqSfvl1r/--
