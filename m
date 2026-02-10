Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F33203AB;
	Tue, 10 Feb 2026 13:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770728908; cv=none; b=I8G0VWqtZxQnLX00juBqvWhXFSL2a18Rcjp4EUvQsN8kdKsCce19sU92qYSWLbj2DAzYfQ/IdPCpQ2Aw3X3DNfgqZldC1QvvvChBBokiNaa00/6djg3Xd6Vtl5D4uzy7tXwhe1vigUH45Cz0MGsgjrJRJCgU033oTgV4FfoLW/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770728908; c=relaxed/simple;
	bh=mxNiKWQgdixFwbGGLin08PfpFvvO9+wF/vsvxWA22Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rL0NV/jvpQuZApwkOVCSWElY42tv5sbYbWnKkdQL/3gW22LjPUPdO4XJcTqhpCLfbkGx+LtwuzsMfFRt8oUK8mNKZHcHlhDInHDcbJ+6nAxnL1k1mG57t3+apXhmCYcT17oPBrqJsFbAAeDongT/eeXP+hTtBvgh1PuFmdxWvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnq5t4zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnq5t4zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4784C116C6;
	Tue, 10 Feb 2026 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770728908;
	bh=mxNiKWQgdixFwbGGLin08PfpFvvO9+wF/vsvxWA22Yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mnq5t4zszBQRCuFnq8jGYoRxvNgUhz1jUmGllHZlBLq3lVgnIl7q97ycclz71rALR
	 dZCIiI7ZhDeumtvnqYl+ylvXBI3Na/uYmK+96Rvui9uIvwYe06Fu1794pWO9tcTNhi
	 HD8zBoARwIM1AsvbTIaYVMP80Z4FLOhiGxTOitKVXLm8zqMaauOmBQ5LAjY87HdkXX
	 OuZ99K2IMwMIBO4uYVo+VDFRBoa+UGUG5VHLJRqwknskoN9ZUxtT7CMkWar+60C1rY
	 x6OqJOU/eZayBIV09EdtLwwZQCg6+jgTEzYnhTl+p/Tv4gPBlbWtOwO35QweDk1O8g
	 xzn/OtWZ0+PYQ==
Date: Tue, 10 Feb 2026 13:08:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Message-ID: <510a7841-7641-4f05-8d3f-64e06acfc310@sirena.org.uk>
References: <20260209142304.770150175@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m38Va/9QBSzi8nHk"
Content-Disposition: inline
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
X-Cookie: Spelling is a lossed art.


--m38Va/9QBSzi8nHk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2026 at 03:23:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--m38Va/9QBSzi8nHk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmLLcUACgkQJNaLcl1U
h9C5pQf7BA6nR3joQa021yUpFXbFCtdq1avfqebTP8i7X2L0Y9Iu9OlgPhtaoZh2
T6V1frdPoVz5DMsQBxk4u+K+LlvAZSx2C+591RkxHTtTQQsKpqPqtokfAlw7QDcb
JhTLdp1505ICcHal/OQhWADVSzbFGjzcQGBKWIH+b0D1SXrYrYcJ+3tyZ4QEj0pM
B7QtkRN7N3HvWR6mMA9KL8LyNiiJcKLGAPTSDGxs9rEskWBDBAM3pbfDUoGlc7Nf
iulUdjMuT7P8jZ340dYRgOE7RrJtCeQP8i/qbYRfbAVSQbOsGyj3+KQ5fPCYqlC8
LBEa+kb0NW/gMwEqqgc1Ms39nrmlDg==
=g0b5
-----END PGP SIGNATURE-----

--m38Va/9QBSzi8nHk--
