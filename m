Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB552AE7F;
	Thu,  5 Sep 2024 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725545891; cv=none; b=jN21aQ4WSTf7oWoSML/JQRoDeA5OoOyNgFM/8KlUAdP5blk8dR9fzTsa7iBhdigMXV2fpXYvNJq7FztksQPJNYKOqODaMgbTKtBUwaaPb8GdwSSBnmn+c35gcULPWPDkDcMBG5vzwUMXYkUJ85Aw9PvKdgIRsRA6cbQfR/eaWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725545891; c=relaxed/simple;
	bh=+kJG3MWd701xj6aWVLxnJVwKEiqr15ER77Vl4LvoX8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmaOSou64tb5oqEj9SwYkknpw86BpCSDI3LINVOBcTKFooEP+6+prwm8AP3AVfizv11LaQoedGzzLSHYl9PWX3n2RdxJCW9PAP6ArC94287TARAowbjVBVYLneZ2ah8G5ijnxQovaBucrGKraNbjLiAqcaw3NOQ5FSvCM2NRwyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czgZWYAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czgZWYAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ABEC4CEC3;
	Thu,  5 Sep 2024 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725545891;
	bh=+kJG3MWd701xj6aWVLxnJVwKEiqr15ER77Vl4LvoX8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=czgZWYAd/9bwzWsitKwIVnOwLV4eqH1cWWYar4R8VCwHJbAvjpeO3mbul3cCr+YWE
	 fnlPsI3+iORdRfFSdjMxKP+AVq8/9CheOTpfdbQv5KEPcvxjrwuqYTdQeT6qlIuotj
	 +FQ6woxyknEM2q+1S0SZZRLA1XVbJq1qKiXRzAJe/YpiG3Emi7jBBl8arLx6gfFzsP
	 w5a60yx5WCpQ6aNOdTI5UQPtiyy7ox/YDbP1t5tsM5wjX0Gs4NrPh2owfg+/xWwk8f
	 TTmk6Sarx5OYejzfImS3mQpa6miFWpYMrdqHE9P4J0HmKPUfnOUVSJos7/ZV0Fa1oc
	 QE7eSDrv+BnrQ==
Date: Thu, 5 Sep 2024 15:18:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
Message-ID: <18920b5e-03bc-4004-bbf1-06043c8db795@sirena.org.uk>
References: <20240905093716.075835938@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PNcUL+9LmE6mV15a"
Content-Disposition: inline
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
X-Cookie: The horror... the horror!


--PNcUL+9LmE6mV15a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2024 at 11:40:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--PNcUL+9LmE6mV15a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbZvZoACgkQJNaLcl1U
h9BlFQf/X58FIEMg45bLFxPGFruR0cK9ta0HcT6vlgsVLw4RjmhVuCXzfrl0yzr0
U1PB4rh+rWt6dEfYUDoXEA7o2QKh4f9VxnzYsIGSwsNsv9JsCtR3hbmWhD2qJauh
VgBayO3BOyV6AqFqGtZ6igNNj9nnT2o8f8qhZWXfGgH4TMUuEEfP5vnS+FzskcPJ
7XwcKHL6ZnaJ6tosNwrZRiJ0BHJjAE74K7yhkYhmPwaaz9r95Be/EX4uTB0opb+N
cvsxI0AJAUB15EYOWhOOVuCPgNfqjMJhMNzDrPKywbUGPUbiIsL0zGCYHhphPfqy
WbiCKWkffcfHwC8SVy0S29p3ioFGfg==
=z85G
-----END PGP SIGNATURE-----

--PNcUL+9LmE6mV15a--
