Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF002D5A13;
	Sun, 23 Nov 2025 11:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763898883; cv=none; b=XJgFAqMt2ej/1w4DVeYEuJKu/lHSf89x4Ec1uaNoAibrABgQz9b5V+ew0y+XY3D3UO3193Jd9MWCIb5LBOs8Xbnwvp/YaoPbBuHcDgs4uGscrdLrm4w5xLecOVPRMZXJE/BQf4UwGpacF3zpjplWksoG8CLJqhjK8AwnAYtPjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763898883; c=relaxed/simple;
	bh=cjza/eop6Wzzox2vdQYw69T5vIjHaOuRrj9qLihfCTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETKhl+l9OCuolBqFYsee5rXZf/tYSMLVscBHp2io8gxjVLE3Q0M1HvdZcXnba3olsClxGMkUDjZhmh4PNE71Z1tUj5U8dMW9Tg3bF6N4gZzmkF/EdEh+tg0PNqXgxqF5KdZVv09ddRgq+29GP+brQYTmAZcmgxD4enmHVBRIPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKCXKeLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKCXKeLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83FC113D0;
	Sun, 23 Nov 2025 11:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763898882;
	bh=cjza/eop6Wzzox2vdQYw69T5vIjHaOuRrj9qLihfCTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UKCXKeLwkUpXTjy2GDZkRA8rCObQcuel0786wUN6IoCGlEZCJJ0sSxX4SG8hj3zkR
	 hyi6DHSatnjtvYsYEKvM8cBgGRFGSmjPdJxrJbmcVcJ/2rn+UKAL2AQiS0CjNwgMkL
	 7IEA3Sr7sdiiTA6ojv89kGoZ2ImMeYUHFg6lxuNo3SHnzsdYr026jMs882mKGvXUk7
	 HpXT2gjfmVt80pCFoLTWq8HBr4UZB+ECna+rJ9wIG4EBvjn60r5Bz6Olny+2LTMeNA
	 NBTIAZHvLlIgVdN+9op4fJPd/DeTLNsxalm5xefPYZfKqxOBjOV6QuUK1bwkwW72Ij
	 xRImQpz422tvA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id AE33C1ACCCAB; Sun, 23 Nov 2025 11:54:39 +0000 (GMT)
Date: Sun, 23 Nov 2025 11:54:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
Message-ID: <aSL1_-mLj7x_gON_@sirena.co.uk>
References: <20251121130230.985163914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zkc8tkjvzcUUl+l3"
Content-Disposition: inline
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--zkc8tkjvzcUUl+l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 21, 2025 at 02:04:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zkc8tkjvzcUUl+l3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmki9f4ACgkQJNaLcl1U
h9CI7wf9FG28UObf52pMFjGE8AVxCKDoqVnFjQtNRx1KhJaF/QyFVSLbsrtrBD/j
WDvMZ17/eKObTM1eC8Ld5smHpqqBOvUIyTkfm/xeVY8W0AU75N2ev0JUINQDzErc
Q+cX5iz2T9PQl05wMmyr6krolphRctBwvU+THMnGv4vFpnHadsia9tYzVQA73ZVm
O+CX0+0FG97iRCCOfTNL6+ch907SEH4FE1yjHqbiGGAvO+PZUgJg0OOSzGltCrFY
AbdgWPhw29lrC0tX2qciwciIzoyQ6i/DGMavG62r8GdIMoREE8/MxiidjVuBe0k0
36Fi1NiCoq/SboNrT+fq/W0mpgZWjg==
=kzu1
-----END PGP SIGNATURE-----

--zkc8tkjvzcUUl+l3--
