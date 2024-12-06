Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29D11FFC47;
	Fri,  6 Dec 2024 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733509631; cv=none; b=tkCaxKuQ4N2QihcgPN1g6JhNLiH5uIuhaFrLThOsPN/RDSIVvmreP3d4C/hBwyhUdRvmq7fKWCutmeqzWnYBB5gpFWn1Iz3gk4E09qam3qlJff0Jm4swtMOn14sK3F0IyiMBVX0i/OHI9CKjwd0Yyyvnv6fXSNhrigekeD1GAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733509631; c=relaxed/simple;
	bh=gQICDubasA8BeXox8HD9geLL3hPzglB8j/QXZHsNIsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8kP9fEDimmSnX0LYyKX4R88kZscSOuhoiTTmXtBofY0nQ18PWwZxAx9bEKH47It8pJtlSS57bnvjETUymE4BBV8EISKkK1I8ARxjVbkC0XtMSxfFUilmf0LQhIGOO2vAsBohQn+i+hdtaNISIL6DEcR2h632jhrLwabehy/GTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGGpyjra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGGpyjra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB14C4CED1;
	Fri,  6 Dec 2024 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733509630;
	bh=gQICDubasA8BeXox8HD9geLL3hPzglB8j/QXZHsNIsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VGGpyjra5TaAPWlndu6mOoiPlK+tfoycDzN9aDTgWBDfwFLYdHBRkCvUMyfAy4gMz
	 EQGyPmEhwAiByXGb5v/ACLE18ZUnUIcvHYpQUdz8oNqrdeJEVnLzRwhhMvAKCIUO53
	 oKBLuO1hK24MQ582thKBCuYcEjkGS9U9vtn4pFsuCdJgmdpWdkpH5gL923iT9d+bGD
	 509/nktnXyHEk+J0hDOQTOXW1DTpbHySCVoUcIXCBj0quqPsGHNTZCZk++I5jmGYqY
	 t2U3qhGlK5Qv4X2LPu1kiFU/Hp177qAKnzQ/hlT0sLtJr9U+9SppQBeLLOOq5JTJzl
	 2ZwfeGSE/NaPQ==
Date: Fri, 6 Dec 2024 18:27:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
Message-ID: <2904b937-bb47-4e38-903f-2277982b09e5@sirena.org.uk>
References: <20241206143653.344873888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KElxUtpqtXd90UhZ"
Content-Disposition: inline
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
X-Cookie: Sales tax applies.


--KElxUtpqtXd90UhZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2024 at 03:26:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--KElxUtpqtXd90UhZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdTQfUACgkQJNaLcl1U
h9C4aQf/eyTf3b3mfzyGC/0vIHe0WEMrrc4MhSbJsrQ3KQX9O4YE2YfppjpWlTYI
RHbkrpB6HTtfxk75hEyWGFIpmM94lG3isr9+Mb53gH0FQQ4/hMxtmaGcZ/mnpLh4
u+4A1I5V/yUWhLwfLV80PpVS2pKy286P/xw0CPRvvtO6IuloSG17HNzF3Bi6rPGD
UTgz3PMUQUToFxxxNQbu2buZgGP5uO1lHoY2Fjh2ADXzRXp3Vp2Rxjod4c+clqU1
X/+fR0oh+jhr3+1tRyJRkt7bwCvFMwca1fOKMODSorMoZ11XYi8/6v8ekTSCLZlr
A0Zm1jgsWFteeHBsxP0o7oHBl2UC/A==
=Qzz5
-----END PGP SIGNATURE-----

--KElxUtpqtXd90UhZ--
