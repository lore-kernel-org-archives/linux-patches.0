Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC73043E4A3;
	Wed, 17 Jun 2026 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781703544; cv=none; b=t+NYVc+BQ2rh9fRR/EkNYa9BnoUoTHP0Utatc+J5U4ybDK/PCxzLX0cAfPKTWBCtF2YdLapA9dKEQfpmNLPEJBRjimRc86nE0FfuZe09YjQ6cakk2ejobwv5nWZQ8ytdUJLfZFgJvdK3H08Ldm42emD+fpYuXFuctBFV+lwuKvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781703544; c=relaxed/simple;
	bh=7n6uX5sgBP3H7L+JRySvNCAbd/Hhm/4m798Vs02XrLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+BxOV90rQQrG98YiMqQy6bO5GU4PqMqnLB/K4+LaWnlHDxfNByTLI6EMlALgBmBhkZOZ+CYQyil2DKmOUacUlE+chVTOBwn1D8/Qm+IIrvLEQYhaKE28n8eCEAaZigB6J6Dk26R1l+1bvaKqlRAU4AtGDv9E28piVTztYm47e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5BD7lWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5BD7lWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFEC1F000E9;
	Wed, 17 Jun 2026 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781703543;
	bh=Cggb5mxx9cT+ADm22ZLbyiG9E5t6gDxXFqSh1qXkGDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f5BD7lWeBnyyok/jmaXeicp3yKSLD3BUqsU2T49MYOF++pKg1uCXM2i+GKkSS6BeD
	 tSXiZstOPlk6X4KYg8ovMo/3OvDO+vOtKmBIyi41L8mGWWUuQDFXE9Wnqw1ZNHhhnD
	 ZZhRnzsRg0hDwAI4KyrUxW0iYPU5dUDygk4+R0ofdxtf06qMCpKQH8cPYF+njMm11T
	 7MlySuWxbpXe5U9ahGctcdWwy6iMGaHH26AqN8W+Jfog+MzeQZo4O+xRvSd4DMZxL3
	 dWCK/N096QXafi9AIUJFwD3325XZLNISYWJarZHJqkVBmil14nic1QvVQBoezoYzeC
	 MwEFV4ubM36CA==
Date: Wed, 17 Jun 2026 14:38:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
Message-ID: <3512e166-abf0-4721-92eb-e9b9e7f86438@sirena.org.uk>
References: <20260616145523.335696673@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PAWrbe6LmzWMs/UT"
Content-Disposition: inline
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--PAWrbe6LmzWMs/UT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 08:28:45PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--PAWrbe6LmzWMs/UT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyo3AACgkQJNaLcl1U
h9DkEQgAhIo1tZ8EGWo/03WW1o0BpXCXzD+6IpOgh9pZPOhp2X+KS+fOuvqRot/9
w/5GsVCKEeiBN5DakyJVQTwR2V0N43nmbyLnuQE4D4QTVwAuS9ZXpDidWq4hdOHY
GI9q5eztcCysTLWMXhggVj3d5oCnMCDC4qwa5c9FX60SIDttn/RQH6B71+93SZ68
jS8Ln3yN0OmjbjTlWs/Ivz5U52BFveX3Bn7fF8QMBwmQ/L1MieNOKVriy6eOjVyS
D4eMK2RKsvl43tb386fgHDamHWzlci8MnnXMLTkBfX88Gdm4955f0RhgvffLpgJ/
EOVm5asBKNeRY2S9uGl5+hFGwna4iA==
=z50O
-----END PGP SIGNATURE-----

--PAWrbe6LmzWMs/UT--
