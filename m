Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC5226173;
	Wed, 30 Apr 2025 22:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746053298; cv=none; b=W+o1U7PIKdC/TJIywCV/u1lRbqBbWACE+fB3ztX5roIMD8i4y2d+U462BNuOh9YVBh7mXGy2vmnQmijNyLvRCA+9JRrHnT9PGt0a1KRURP09DJ1nuVyVxUC5rGIT8h+VphISNoBQYSnmh/WVp3Va26INMNboUX4cnBPH3zZGlWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746053298; c=relaxed/simple;
	bh=W0ZDsZgDYUU7aWIWxxjNCOCDpbUdoHg4UpnSu6Hqxoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EO3Buqg0Wpqe6mZ45uP3x2B3AlaSPxBETDpPr8FvKtzelj9Wr/YM0fbOx1okZflcElmepZ8K1FRELOBPPDWmWM3AIUXUlJjuJEedcIcbP07bDVrdrNSxKAXZB19QoNgO15wWhgNriD8joI6EHvnD8TrFg0Lm4BeK9otYGXsrKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKuyFbj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKuyFbj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C79C4CEE7;
	Wed, 30 Apr 2025 22:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746053297;
	bh=W0ZDsZgDYUU7aWIWxxjNCOCDpbUdoHg4UpnSu6Hqxoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oKuyFbj/B3eOA+R6WkuLYmarnNkdI4QdjoJk8cZGX5nNkPIIBpF8hcJlSJoarQY9c
	 Ipbm/qkKKiwRd1JHOtAOl7ce+1CqrDOc91F6LdMZtkFRDEiUxO/tpGCUKEZiuek2Se
	 3z3XYCOKMWvN1VwgrSY+oqHFtLWTBaiqamoCGrdEZyiPkk0gnzcTzzhtyTJbefJrhj
	 BcLFOOafIBVN/AQURhr4/N4x2AKy//5VGr6oJJwG9HdNO+foPVI3dYOaeeIxLQwBp/
	 WyKp732cKTN1fT73VZ1BJHeQ5pAkZq/LOGuHa/UG5wSjH0A6Ky6vmXEJETgK1WE3+R
	 rFgzi9vGGdIcw==
Date: Thu, 1 May 2025 07:48:13 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
Message-ID: <aBKoreZDgpkzUK2j@finisterre.sirena.org.uk>
References: <20250429161059.396852607@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZKoObXE0DMqr8Cqx"
Content-Disposition: inline
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
X-Cookie: Well begun is half done.


--ZKoObXE0DMqr8Cqx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2025 at 06:41:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ZKoObXE0DMqr8Cqx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgSqK0ACgkQJNaLcl1U
h9AXiQf+L5r3INkPm7WCA8h7d8WM3kvxnqYeEEgDRXg9ZeMSWC75YIj1mox//d7/
DJUNyusiun3hA76McbfKDfJKL1msZcRdSvYDj/EKHuAQEYkdT8z8UFza0liwYh4l
V7vWlbewjVbUKesEFHi9tsWvqtOWQMgffbXloc37xv4jv3fGpliKf8xD7yLLbptd
LYF1kSBayXJ+/BFM8bTBKfqgp/cj0Tmm43erQOnpwP+V2IYhqfMP+S3r/96d8b99
EebdmDhuceZx/05tuZlnhI7nY971HNKWWbkHduYDHBWXixiylWFd8h1qhl4G9XIi
akKJvef0PeFLt05B/83mRvSx7ygAig==
=K9JQ
-----END PGP SIGNATURE-----

--ZKoObXE0DMqr8Cqx--
