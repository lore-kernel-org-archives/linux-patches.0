Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9226B3D9678;
	Fri,  3 Jul 2026 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783085497; cv=none; b=laSugQbFPqIAdGEvxARPkjgG6b+l4gTvUKJsJTEJKyBPZJOJBwh5Cu9tTzpo72PqUop/mztDNyIHVjdF1OQVVsEPGjSZ3otllI26jpJt96d1deNZQNc2EdoL/X808+jtKrhxVlncNyemzSxijlA9sFsHW1h5FhvS+3er2d7gBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783085497; c=relaxed/simple;
	bh=kZLk7ghCVbCSFPPDkaeSR2CfbII+vKfqi9V+jDSWps8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f42o7zqSbqcEzkQaXa65Vlytd19frK0qvbQHXhysAFN7JSbGXcOQighxP5lXMdo9b0orNXSL9FQP/FbsSp6p3n9nG/7JEQjJbqASrE4O87zjfgubIyctUTuFb6873F5NA2tm/X8G+zWhBbOcHp6YZk+u0QN+9gAW0YkgzM+X0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kx4bnfOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kx4bnfOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DB21F00ACF;
	Fri,  3 Jul 2026 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783085496;
	bh=W/y5VMl6Mtir6SIMs0KYbOGnhMQplN4Z1rEvnEsHCbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kx4bnfOzW1rb6kOwBOm7/JFM9nAiqODCErdISFKJAJe+E00runOBEFTX1lVvVeRta
	 X1p4dhRo54HWJQg9l8w3BA/AwbSAIDAoMgjZ7Vdn455EZvKGFIrOycfFoBDE3EEIwa
	 mYia7YfTtPSZV/4UWn2/6ASYp22MRqZJAK7E8s9yg8f7sWRM9Ag1kagy8gOoEARwgs
	 L7oDmQdyfJFmjcWh9DmJV+fQk9IF0n8mZFTfoYpcjWOcUcEvBMmBDQ3NSStf/437pr
	 R45qggXQcNmMCaACZuLq9JPc6RxykYl4hoIfdhdYANX9QeH7E+wzV+sN21A/8UUxPr
	 VSbWQWcKgVaYQ==
Date: Fri, 3 Jul 2026 14:31:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
Message-ID: <6489ff7a-2484-4241-ba34-a6d1686b73e0@sirena.org.uk>
References: <20260703072825.068705122@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NPU5EGL6A+CkoV3D"
Content-Disposition: inline
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
X-Cookie: Another megabytes the dust.


--NPU5EGL6A+CkoV3D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 03, 2026 at 09:35:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--NPU5EGL6A+CkoV3D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpHubEACgkQJNaLcl1U
h9DnWAf9GXZE0SBAHvn6Us4ibX1k0BVFAVTlkTs/oRLUtv0mdlLw6ApMjPxJXR32
Kwr8qiAC5UatefWxNdAMzw68H/EiVG0HTGFLsGN25aLzFVLkCMyc2pVtdCvub6hj
DRKDLN2BExKtNsIujNiCl5Lld8RFP+I4jQZbiXiuM/ijexlRiT3mD2RuqBJZn+58
av0OnzrH0xRSvGCNVS1iUCIrfx9O0BIgOmApGeC1Ve0UjUNWkMeI6VIJS4+Asd0n
u0smKTcJxp0acV0pHfoXn+LJlWDYqoOxmvbcZSUVTF9SQeDs+fbHWKWcyjuA3Loj
bcqAt3SbdYNXbUIhAferWO/f7naV/w==
=MDGd
-----END PGP SIGNATURE-----

--NPU5EGL6A+CkoV3D--
