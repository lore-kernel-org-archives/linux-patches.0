Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F4A3074B1;
	Wed, 25 Jun 2025 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750880940; cv=none; b=nSxP+t83A3/yLs5QySCxABQO505wVUMlPA00kJ+PqoB4Rg3ZHd46pFEGOzICArCWDu+z8mrWtRxBIzhvtMxNj2f22+TKxU1ipzZdjhlC6j3ucy8ixOnjNnli3ldsUAwwWg5tJjgyM2HxND0QQIsXkRIZoVPT6VUJ3eoTrxDZ4ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750880940; c=relaxed/simple;
	bh=x1oeVpcrF31Lt39XRUptcsup5ofQNvFnbEzOBrJUMSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzVG+Lt2pVgC8YOKKu4esGqrovMJgO1vH4js/O77pBqkCwJKJA5uQW5UMeODiGPjGXCrPvBnhakKWROLq1HXWL7fFOpxx4GBG3CLlAkn/LFzh4Lxf4n02gPt6+IKBWev3FlEHCanL12EDfvMJBeLRN22xVmp3F34MqrKI/fPl8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLHNDmS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLHNDmS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF0CC4CEEE;
	Wed, 25 Jun 2025 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750880939;
	bh=x1oeVpcrF31Lt39XRUptcsup5ofQNvFnbEzOBrJUMSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLHNDmS1fIQDJtbO2C5ffCiGuJJ5qc2EvzkCgDYcSR0pBt8mmZJxsuNvxfXDN9YYt
	 ELxZz6/KYe0eAe5VYzSmKieK6PV6ZxJLbNJ4PPi3a6u+O2trabJ5pqcnRi+5i0byvU
	 JxjBnMwvnADel8TxT53yUuuUM4+Rzps5qXGJ5+9RH1Ic9MvROqaxbikgA95eYTXoIb
	 PZELChHCu8bwnxcOBYJ1jPKEeZvHvZeH6illJN1LFQCsu7cr2y5TtsAImK5WPU0Aaq
	 j32B05XNLTL0JxnKhKgxAf5wFWPJBPyHjXu8spyU86A+XutyoSxpMKQ0UWZvQREbVm
	 eNUFgMtenOV2w==
Date: Wed, 25 Jun 2025 20:48:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Message-ID: <aFxSpzrT0XJ1cGXT@finisterre.sirena.org.uk>
References: <20250624121449.136416081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1739lPO0Yzx431Qk"
Content-Disposition: inline
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--1739lPO0Yzx431Qk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2025 at 01:30:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1739lPO0Yzx431Qk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhcUqQACgkQJNaLcl1U
h9DaIggAgXU66VMCb8bxwFrMjJJl5nIVr1bfSIThkFXw6SSbBHhyX+J+ENMM2qZ6
H79yXrl0vE604SbZQIKm6UZbzInXJjQE+E9SZfy6RqSlay0Nz68mIU+N9AcmLz43
HYwZ2w8l6XMVOAAcLg2V2IMHpqfckNFypFTCOSzUKkJ2M/OR1nk5DHCJ6XsPEVcq
7wyyUh64tzg7A0WE29X7symx5dCGnlLmWYDMqLLs83yJ1nSlCUjE+s9yJgqWBlWE
K/TNzsTsbc98ZuOPT2scmxu3tjwcPB2zs7gVoNOIdlfWNFFx8QD/OS4cAWFDDGA4
iW59IDMoSxkfno5aXwt7+T6F4fD23g==
=oSzd
-----END PGP SIGNATURE-----

--1739lPO0Yzx431Qk--
