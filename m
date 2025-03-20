Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1079979C4;
	Thu, 20 Mar 2025 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742470465; cv=none; b=RpruDj2LHlYk3+eftC6lUdzz2N0/kUx8RJCpq8TnKWpj+3wvtCGio94nSX6zgiMYyRnbof6Gz9gOOc/IhZVrUm0r1bEDuv8ZqC8jb9y4by3IvvEAsyff28gwbWAnJmFnTNyNjZFbC72Um4fZDI7Er5xeyQQPJxTiVru4We/uCgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742470465; c=relaxed/simple;
	bh=twDOHZtwATwzEptT5F2OxG0CqVkfEqW2mvpie+Zq1DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmSi46sRZuiBMubvejuonE1bj7QblB3Q5J7RXMoe9gcOCDinCybbjh6hgaKn09MLP/gugC1/Wh/+X351jaDvKqedTmOSlUzgkLMei15TKD2z5Hxf1sMHdYZadAHIy5smDMrxWQo8cMlxiUtfo2RI27vaZNIoPVTtCXqJyAPkpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEMBAnlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEMBAnlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE8FC4CEDD;
	Thu, 20 Mar 2025 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742470464;
	bh=twDOHZtwATwzEptT5F2OxG0CqVkfEqW2mvpie+Zq1DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hEMBAnlN0aePxZCL9iR27VfNabwMdEk9vOI8nrRIBmkmf5G1uUfAChxttQbwrI6Si
	 9zz6szR69s1F8g5HDK/4ncNHn+4MlcbOYSZBdDdLPTcWubVGJT7e0hzLVc8TaIe8pi
	 qK5cdUq8Fxyw3EheD34hEFZFpjM7XSztDfJxNueZ4H4n+lxQUYhNRG/JFQfD/7e/L8
	 CpkNd8ududYoB0CZGoGx2nSy4DKz8Swf7YLUd26xoobB96qRVeSEZ+WB2Rn57YZ+0l
	 q5HLO2g27COsqkO3Xff545GgLmsc+/t/sYC1TXduZEdVyvpPPN6/Z69DHNKSxMaDeQ
	 It25TzymJ5ceg==
Date: Thu, 20 Mar 2025 11:34:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
Message-ID: <28cd837c-2537-4520-a130-1262bad106b0@sirena.org.uk>
References: <20250319143027.685727358@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F3JSvU06hCLg/7BK"
Content-Disposition: inline
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
X-Cookie: Do not fold, spindle or mutilate.


--F3JSvU06hCLg/7BK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2025 at 07:27:50AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--F3JSvU06hCLg/7BK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfb/TkACgkQJNaLcl1U
h9Dkjgf/Q2ru1hyufk/4RFHSx/kxmussEXOcPMeBSJQbhAeTEEIGHS67sZdM+0ry
kmN1CRGNiucOGpTVhOSmjJ3y+knWyKo8hFe5TAZcndZ0UeNy5qwa3p6SwnxltAJ2
7zCd/qERy5JgT5F+5w6Iz7pcPpgbSHIygmaRPj774O0bBXtpV3txU7c9TXiNBTy7
J8V9KI9g8crVLmT7/1fdP0W8keg9AAg+dMz/PUPwYK1qEyo3Auta81tMFywxvMbM
y6Hu2m14JK1BMBfqZbNnRC5wqQsnyjyWqoT/Gvo2oZNaI1D5XRhUU+Dnu7o9zNhh
zAaTKShaGyl3xYjsqFlqWKddBPJz0A==
=Be05
-----END PGP SIGNATURE-----

--F3JSvU06hCLg/7BK--
