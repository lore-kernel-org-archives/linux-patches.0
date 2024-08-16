Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C619817;
	Fri, 16 Aug 2024 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723807466; cv=none; b=IBgS6F6I1nKE7ZwmzxpgOY7niqJyz3P6XVE/yWRlnKKZNX91mBx6qm1CjhdpEIoMu93Nt3tASEpPGDCBtHm0Dd5dwgNyaFZW5e3O0xeoEAK8Yih7LCcjKBTMGZMhZSdc7HLMooXgTHdjg//2ZuCVvFcaB8dVLM6yi4b5HWGx1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723807466; c=relaxed/simple;
	bh=CIa8k4fVSjK6nYD3UT24fpf7JYIO4ow+0PW32KSxLxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAJ2D2liHV8Yn2KCS/VW3Rvsshuq6aHiXGEPAjr976MeoowToNrR7EQ8conMXwk5n/f2Ry3gEVfJrMrKcYBmefe7m1dFFPL9dxyMvx8tqtfKI/7AaTIXfHucgdPJ39mLujAIyb51yRbklXjuZ9NZRYHiu3NPcV+kh2gsjTWjQcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9B7AZoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9B7AZoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A208C32782;
	Fri, 16 Aug 2024 11:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723807466;
	bh=CIa8k4fVSjK6nYD3UT24fpf7JYIO4ow+0PW32KSxLxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u9B7AZoMesnNh1BPUv5R/NSezplIGk+GGHCWpgs+flBlXx/cE4LQ2rdQMtiKeu/sN
	 5SCZD3q3eyl+t2QuGVQxsSUTNJDp3Q6s0UcpQHi0pGVMx1MRj+UkeDVPDbTmO5d2Ek
	 VzJ06jJWde1WDQKI0thH3evHf47LRbynjFWHD4/NmQ2RYFt4BK2FLNlbq7x/19NYbT
	 2AStj0PDe6lAHWTH29qqAAIWpuUdtE+w+1HyWL43hqqgO2kn8hyNaCnXQhN5jOSlo7
	 igPB2OKbZDwaZBqwtVhlRjBHcwS0HZ7CnjXihKrNTZSE7agKtQ9U7tcuPJmVEmP//T
	 hlF4ej10Ev7IA==
Date: Fri, 16 Aug 2024 12:24:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
Message-ID: <fee4e621-be61-46bd-8419-079516ca6211@sirena.org.uk>
References: <20240815131838.311442229@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="X6opF1K+7eWo49yV"
Content-Disposition: inline
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
X-Cookie: A Smith & Wesson beats four aces.


--X6opF1K+7eWo49yV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 15, 2024 at 03:25:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--X6opF1K+7eWo49yV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma/NuIACgkQJNaLcl1U
h9AdBgf/T+n49H644wzjjK2vCf+7y5GY3p6T+QGOAN6B92EN1AXl8bxsoMKoaizh
I24X3r8+scs6yXVjERBzqmjuzmeQHUE3EUk3eAhUHKZfDK5QXrQ2cVuqJ+d+5bis
/gV/g9lcEwu7RuRrJr9xaM3UcTrXl19X2KtdX0S770Nul9v+jikjIDfCNpJ/O+rN
qACPtupEJ+TnYsLZtUStg61c5lYjeW8D/21sV0VcBE3jWscw8rSIAAVkC1pywVEL
Gr+1VJik2UrENFEmmiPA8xz4XIi1C0iOjkXjGbwGwSPjxgl0gounIUc1gTqleMM7
YUzBUyxtsFjvrcR3nHaVuWq1/5ihFg==
=Fy7B
-----END PGP SIGNATURE-----

--X6opF1K+7eWo49yV--
