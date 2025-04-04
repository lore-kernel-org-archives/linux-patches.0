Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1519CC1C;
	Fri,  4 Apr 2025 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773651; cv=none; b=Okbbbn++zX+mEA89Noac7rofXHjyYctoDzw+tePaDuzzFnGzEiKfB3mluEUX7HG4rZpHdPny6riWujAFN0T9VyRmCdxXvwqcD6smoGqZ3pkJJ4S451HmSSrHGPnJuLPQn1PDfI8URpiQ71Dppdg06DxMzRdzN5z9EyAOS3tf8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773651; c=relaxed/simple;
	bh=fXx2TT06NMGBgxOL3G65Nch/rC6ljUg3o7ZJCyczfkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/9T88VpihcMRdzEPhzgkSXi2ZRTxSfKyoRPIL39hoA6/vAXgOsOJKI3OT4OshtrruzY3d6LOfI3ZdP9AXC6P6VfJsi9IXPxWsBcAJ2D4TPq3wFfEuFMkrgyQNwSgC/K1woh6jbz0t9FBb5v9bgVXkRBtNPQSVP7SxghbYwTtiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uy6KFdmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy6KFdmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94896C4CEDD;
	Fri,  4 Apr 2025 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773650;
	bh=fXx2TT06NMGBgxOL3G65Nch/rC6ljUg3o7ZJCyczfkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uy6KFdmJdsJyOekAHvCkjdiMAcxmj2o0dnEMYJ2jSB08Q9CC/hGwW71QIkW2GcG1f
	 kz0G+aTeCyLtTJ1nCQzQ8vvyoKwYyg22/VKUVcdrH3p+MN3BP7QUQ4LyhXfLN2dJ4y
	 UEsUbBa1LegmhqDqBMABbwELtLgoc7hJqpVO98PuVUyCjh0EkE1x2n/+L35Y8gFIqQ
	 88BgFLYpsknMSOnmu7SaCrqpc3HpI1ftOZgCcWdVy7IFqAqzqBdChpXd7Zht5p+AP7
	 wr2Vq9kvQyZkxmMNbMfy1trS7orfjsui1QEU86QUqYM3GcXK/IPcWwaXbWUrORbdA5
	 H5RDA1mi/ObOA==
Date: Fri, 4 Apr 2025 14:34:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
Message-ID: <70018d4f-997f-4c9b-953f-09f842a621f8@sirena.org.uk>
References: <20250403151620.960551909@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BWUgjqJq1jHExExs"
Content-Disposition: inline
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
X-Cookie: You will soon forget this.


--BWUgjqJq1jHExExs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2025 at 04:19:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--BWUgjqJq1jHExExs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfv38oACgkQJNaLcl1U
h9CvIQf9GkquaN62t1bD7vP5w8ZpF2DEiKEbh4k3euMlXwNjzr7zUoWo+T9dI4Cm
XntNhMwe3T0fFqkSzaO9UX7BUlDcs85GnRI40DvAOtnmHMzxjhePXVvYZk3Rxlyw
1nBEcBwdzwdlPtzanHGYRrptWNk5sQN0Czx8QjIhrzrzy8I+Uj0GuoZlPOkWRT/L
wrANAtL8pyQAbkqwMpbwRBfpRZ3lnYnceUnkQdhKCEzWTt73aeOzhZZNSmsybzzB
capdxgI8orTZhWlokQeswqpTltpHTuqxGp3ohfA6Ap+xCtMtYqnkDEGPLHPliyZw
WUozNzEF3pGPAGlGWIvbqsg89+6rTg==
=eEBd
-----END PGP SIGNATURE-----

--BWUgjqJq1jHExExs--
