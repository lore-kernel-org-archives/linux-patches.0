Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EF818DB01;
	Sat, 22 Aug 2026 13:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787405427; cv=none; b=CXW3w6bLQn9Ku7CTKS6NSi0UMMfYlS6oycYEVzS2ueVOM5O3XKR3/CdAUeELeRO4Q9TFVA91JmV4L34HH1rxYs1ztP/tIyqvhdx5GgsBTs3w1TVSYnO+aqUMs0IN4Mg1hQ7KcX55MIuJHBmsxUMnPT/vvms/qy2KCQcOU2zOmIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787405427; c=relaxed/simple;
	bh=Lx4RimSFEoBYF0WGPvuNg/cyzjkfYEbEOtaT9umNx1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5aNi8SKP60v9/N+9dsX19vqXUxOa879eqT8TmxoXPMJLPBEdHLGSk53Pj29sRFwTYgP0xHih5/F8YI6zIgfIUhIN+q5NWT40yt4s0cDndn45N9xq3uit689SeHn7LUsjBT01+6OqdRwYbF80MZkJZCy4SqEkBP6HhmY5F0sQ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPzdMXUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPzdMXUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D966E1F000E9;
	Sat, 22 Aug 2026 13:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787405426;
	bh=Hx89CFd/gfJqth2Zu02A2GwcoYsp5N7R8QOT84Ievbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UPzdMXUMXJRObrlfSuLwWGgAHMoXaAKlFTPnAJucxCLYXq6rZdOUYVJaBY1sT/xki
	 bSy6tyV2EOKYdbRCjSRilBfOHlduP/gGE7O9g7RnyACW8x45Vb+xEMSl6xi4xc+G7C
	 Va/N9vip5/8N4STY23HMcF4up6GU3cUDsZeiP0DH9m8b7YVgGGYGAc5aXw2H1hromC
	 cRYEJYcwOLhrRCGn2zICxRjL6OwGLbIe5iFCBleec+2wG7IEzf/dF2hkdiT1exKFud
	 3M5BY+g4iaN6/JrEGa1CAZg4OLwT1oO0UKjKw07p+6ITvzyyDxpChCU3AsRu4ujg4g
	 NW/ZQy80otPsw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 740D81AC527F; Sat, 22 Aug 2026 14:30:22 +0100 (BST)
Date: Sat, 22 Aug 2026 14:30:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
Message-ID: <aomkbubCNL5XLuO1@sirena.co.uk>
References: <20260820145231.229664293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zgDCMwYn7Fzqj+g0"
Content-Disposition: inline
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--zgDCMwYn7Fzqj+g0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:53:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zgDCMwYn7Fzqj+g0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJpG0ACgkQJNaLcl1U
h9Bduwf7BEW3W21LXLOuCRpZKOcAIAOvnAqOBZtqT88Tu5Ifa/Eh2ljUrJK24+6q
iISCAfAiHegTQUAWSg7M+LMFzHHgnjhtMVBNr7WG4dtQVBZmLfK/5b+QnJz7ROos
BUhfzLj3y3DOLtZXPbuKb9VmMXIOujyZIh3PbpS99lPRdZlgoO2DXMK/FeCrJGzo
KZjISfyGVqzwgl4GEWx6TqgWdYQQ6XPA5y0fUzqqXMuOHiuGsI9ckIP1RbXoRw9d
3ZJ/z5Rk88D1Ih8eqLM1BTqmz+oKEFIB7tZeOT/SLJTNp6uNcSicHUAeGK+5BhSp
kMYORTIO/DnseR1OMCwZUR/7ew4hzg==
=3A1D
-----END PGP SIGNATURE-----

--zgDCMwYn7Fzqj+g0--
