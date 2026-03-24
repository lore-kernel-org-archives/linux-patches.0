Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91083264EF;
	Tue, 24 Mar 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362218; cv=none; b=myuZth0qsAetFUhQeWAK5URykY2/YFxMLjxBMS6eNs2DgcHg3EZGPAoVKZN34szPFMC5hQtH+Uh+GwfWLZE2CLvY6OGtWaRaWc1pn5ISfzYYuGX2WEbjWnULefJk2nI43m7VMv6h8SKO9hPwZaXS+qqNEPnQRxLhooxedd67zv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362218; c=relaxed/simple;
	bh=9Z7GaYs4fyCj9d0eSk8XQ6gvnDwH88gapww8q0oEjMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqCutYeiinj86OL9pooPUq8DX19QLl9VcTHP/hmUkHzx3KJW+Wy1ynGRZISL4U6oG5aVgGNMWvdq+HQ40c4imTM9P0lT/vEsGoOn7ejGr4GUkMiDZ/yNxx6AcinIkRscuBsD6M94ixUHi1dnGVtGCVV6Ieh3LUuZim6/2SN1YcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cM4XY3+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cM4XY3+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51744C19424;
	Tue, 24 Mar 2026 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774362217;
	bh=9Z7GaYs4fyCj9d0eSk8XQ6gvnDwH88gapww8q0oEjMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cM4XY3+VRCOB6GnN+juDD+RK1p0RSFlTP78a7gWpOf/uPC9Bo3g4XkwnQegUFaTf8
	 +lkDb7TaMRhq6DDWA9flOWzmtDkty1nV/0lJYVdK22eO6d5hLqsUdMweuD/Y3rUP4x
	 1gtv2BTi2nonsJpR9juY1La+wS57IAC8XdwqRsp06dGrEtAG/8SPiU1jBORXAaKxOQ
	 S08Hq8mNSoblxEAlU2z56Zri5X37JzFQ57vL6qWBP4SEzqQgx7/g26I7SuiNWeuF7W
	 /32fKpXbTPI2xrNaHLgiS2gwpsQsbXM7ATv9uAhS0omGii4R8/BUkzVbur5nt5+GdE
	 59soqPQcBt8Ug==
Date: Tue, 24 Mar 2026 14:23:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Message-ID: <8c15779d-e694-445e-aa95-bb1fa5f634d7@sirena.org.uk>
References: <20260323134504.575022936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4kWViM3Svr/eY1P/"
Content-Disposition: inline
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
X-Cookie: Forest fires cause Smokey Bears.


--4kWViM3Svr/eY1P/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 02:42:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--4kWViM3Svr/eY1P/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCnmIACgkQJNaLcl1U
h9Dw+wf/WWHObsFpH47lFL0ZXakvPwI92D19zu/DDuAsgbnnHM5+tu/7LJx912Oo
ixMTsyz+IJQhJLKdpjb1i4UKfjhfJN68WPHNLEXDBI/C7FnH9pP2q0a4NywoNLIm
4A3kB19WK9Ihcb+MBvWousUKH5uxpeQ83dP/IZb4jg8o1RiiYNaOQo/XME3ZEfvd
1m0kYOcKCypguVdAMvN5TiEZGAFVn2tPqB0ONm4EcfoB8F9TjGApz2mh/S/rfQ1M
MrwF1QeG8KiKdewBYXsQerhrgoELx1G2qq3Y6Xx9SQyHKGRY6+swEImLbkts6yrW
R/Dyl06iRGWwtEv6Rezz4kxBHAPV2g==
=Bqem
-----END PGP SIGNATURE-----

--4kWViM3Svr/eY1P/--
