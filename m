Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2121E505;
	Wed, 15 Jan 2025 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946944; cv=none; b=Aal1ttlMVJfBwbK2kvWAyOQRr70Pb4Wf1Zn0tFwx/kPzvYgPzvLBJrtsfcsSWjCAsx8Q0K66QsMiZEuT9J352+IlIiKXSRa8sDtQzeudSq4pTS+8MmXOyIfwr76g2hBkEXR9u2eeS2A6pEl23F0AAZVK1t6IGR0snHrs+AmSX0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946944; c=relaxed/simple;
	bh=Nl1gEuEnf6YwK3CjZoWFycwFMCCPThhRvRamWfWhKEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ShyAJR6nqwAf6JAWnyn2Onq3I63UZ82cwbEVoQ2fYeIMlIACoDdw2MGoVjkOWpufGNnHZGkgUsADAhe5paDmfFtspz0wJVewBCaNQi4WGCFVRlFNp45k7aS7qNJldooCehhP9AZBSNwv3HoMmrcVacXFad0oM7g6ph5LrFmBxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlnjB+54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlnjB+54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6983C4CEDF;
	Wed, 15 Jan 2025 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736946944;
	bh=Nl1gEuEnf6YwK3CjZoWFycwFMCCPThhRvRamWfWhKEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlnjB+542eS/bPEkUUgFxXH6Cc7xlR37KWFo7mVKDTA3+83g/74VBb+b4LL1LK9fe
	 Gjl4kiBkb8+6TPJKwK6jPcynjSxcEpSdWJ8Je15HIPKx+Ac7VcYvbwihRYYHYKkNzO
	 wyPMVLEezPyUQRmHdHKcVMk/FXUr7DCwbPUdhKcouMl5L+1KNhB9Ir+FTtlIfo499C
	 l8eWfgky/grFoYzpoyStPlX16xa27/1Nq/m/yWRcSFOcfKR2Z1VXS2ln1LVrwu0Geq
	 xs67YWxGhPKkteS9OluKQ9MTpRTqhXpoijcbaR8Jile4U/z6n5h5fjLM1Mj3oBcoKD
	 qumEJ8sslMUjg==
Date: Wed, 15 Jan 2025 13:15:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Message-ID: <adc286ed-c66d-4ba4-83fd-e8904bf2f330@sirena.org.uk>
References: <20250115103547.522503305@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gHLTcWe0PkwR42ZH"
Content-Disposition: inline
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
X-Cookie: Phasers locked on target, Captain.


--gHLTcWe0PkwR42ZH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2025 at 11:36:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--gHLTcWe0PkwR42ZH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeHtPkACgkQJNaLcl1U
h9Bjfwf/fI/3ThD/LjkVvvz8UJs773QYChvdoNV9V+pJcUWNAoHy/DxeGFH81ese
MBLc+yvC/+VXy5CW949dlrltS+qUbJCvdMUwlC5ckG0HbY5FtQXVFqfOL0gv1FlX
AKjh/IHBaqEmdU7ZlGOmxcO8Jn2tv0sWLKh1sg+rVAp+ZaBi6xn2KmvGaTBtMQVX
0GvHGY3x6KbNAZU/KhlPIvV62XcynaebLRL3T1CzTDdTZoBeqfdPuMGES55OHXlm
ikMWgynHxVeWqdqW4BGMx27/efW+bO53VumrHNzeIyVvFNk3Hb0UGrxiHpfZhNof
/DqmCeoZ3sjOMi0caiaExbn3JPongQ==
=wXBb
-----END PGP SIGNATURE-----

--gHLTcWe0PkwR42ZH--
