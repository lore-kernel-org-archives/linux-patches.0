Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA214D6E9;
	Wed, 11 Sep 2024 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087154; cv=none; b=UFYGEaF5DpHcdhPhCySzmDgdlsx2vbjC+z5fJNOSqZgAWE3DKYXqVTkiBWIYi2n5f4spiAXu7mBtTUuMQLAxYODJfkM0cZeocsYT173yVCavLT8tzOwAi8sjKp+IUOPQZVZ2fjiXlmewg7Hk6NcCVpYqxjyNlNohBzSdCG/khd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087154; c=relaxed/simple;
	bh=Mberz7bfJ+kTFhwQIpZlRnjeK14/N+gYa7oTCP9PYZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoUCfW2FPi5gIAbPVuLdZ2SYzleXSyvJ01mWN4WtSnYjYqoh7o6R3u+qdbvpctQ3hw5TdaW0VB32aB2GxVJ2qWcclZ+Qerlm4M0e6OX38xbYTmHGC8r+hSZge4GY/I9Ymmn0F7rfXR4MLW91FD1tKoAiX4MspdnbmLbxDGYXVy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVmv4llD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVmv4llD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565BBC4CEC0;
	Wed, 11 Sep 2024 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726087153;
	bh=Mberz7bfJ+kTFhwQIpZlRnjeK14/N+gYa7oTCP9PYZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVmv4llDlotli/qaNQE423/g+mtSD5D+Bg181sXfWKcIZpjyS0KoFAZJRI8qqm98e
	 oiTYWwr9dOYzr066ODhxZ4bI4l3/9G5rv8ibkUmAVEkRXXydZXM0/P97PnZsacvclv
	 2YuELeG/EFgE42ZIXbVd6V1nKjQVWHlcvpqqMakAKKK+CsC9H0MRkPtUotTrF2Z8yv
	 qPWbS47dwCO5ScmUVPKkipmphtBhLJiVOgGlHflKknT2CMo/MhR8l8DQfKaBxa/4qA
	 IJxFTsquVqEFgUmHSsU04P25DuWEYE6e2kKxFK5ab1YwhxYp3uSd1s9xz3ZGm4VZ3W
	 1ucvv9mZc/sjQ==
Date: Wed, 11 Sep 2024 21:39:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/186] 6.1.110-rc2 review
Message-ID: <83678641-4183-46a3-b3a6-beb4b77a44a5@sirena.org.uk>
References: <20240911130536.697107864@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="87hyl+ldr732yaBs"
Content-Disposition: inline
In-Reply-To: <20240911130536.697107864@linuxfoundation.org>
X-Cookie: No Canadian coins.


--87hyl+ldr732yaBs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2024 at 03:07:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--87hyl+ldr732yaBs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbh/+kACgkQJNaLcl1U
h9CYFAf/RqJzJNKWlYg2Qu3kRieus0Gy6COpgGXXt2Km468k/iqiHR4s5XjBjlL4
gqb6Kh8XoHDg1kXkw0rlJXOdZ3Kb9FFn8r8Jt/pLk7jLxPmHA4eHShuNQ7iMiIM2
J8t7pmaqKk5VHf6szV1FjmHTkWbBfr/YiKP+abgCIPRmYFamaHSIIb2BXPNiuFV7
l80h8jUQcECpIfCp3zk9KvBb8untqtSpSeIRNNM5xEDo/reRXmeiTG9nUuuLN0Jz
c6i06BeKx5s7wOwEBfItCoz5ywVe9fs8/Jok9EkNgmRZRDJNMTHamU3F84UD3ZC5
O+J+3YyGxf1U533Cevf/AkNJQPBlOQ==
=LCUQ
-----END PGP SIGNATURE-----

--87hyl+ldr732yaBs--
