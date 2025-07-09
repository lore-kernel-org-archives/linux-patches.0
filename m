Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD3C72613;
	Wed,  9 Jul 2025 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050853; cv=none; b=f8GuNlOayUOaN4UhG+yqQvWPdAigyzi37VMfvpMg3XORDQgTjCJMGbLCMqoam9W6BcZ6EGg9F3D5sR3qllFFMAf0IvFChzdSQUj4uSWzWB/vUEeUKMqUx5Xg2KHL0IyML6Dhfxal6foa/KHEBbo73ojAsp+wwFUJ+ymfoyKoMPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050853; c=relaxed/simple;
	bh=fD0dzbOkacBdDOljzNnCDpQuGKdQ7jR3LD+aLbSRucc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsekw7pIuN+O6dr0RuESDVcOuCyHmSx3+dxnYDFgkRgLq3zgPX9cSNbcM1zvfjshtUVcTVxGpNg6OvtGvYWknuHtM4LjbmuUDBddx5UrKZCgGU8VnI3Q8PrtoEJA8Kj8yLS36eOBVrTusRJFbLunRoWzQKA2C3LTj/kxXna0leI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKZY3jWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKZY3jWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B109C4CEEF;
	Wed,  9 Jul 2025 08:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752050852;
	bh=fD0dzbOkacBdDOljzNnCDpQuGKdQ7jR3LD+aLbSRucc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kKZY3jWEq10sCHM78SzXIYjvs68p5Phsomm28IoYDBxaBD3vtB4euD/OevmQ75xIp
	 d7YqLoLMTxl1NrpPAgMZKQ5ets2VbnvqkaeYTL5dXgFTVuDbEN+VhSiNN2D5x20P9d
	 IG5Fjo1librUz0VLg+VmrGYbHj8o48q2I5iROuFeat+XtnStCmeKdc1vYWMmy9yQ1u
	 PMO0qTnp3mA4NsK7WqIbIEXIspCyMgg5ZGHu+A3bK/pbA2imu6dgfdmdxUjweTIyhq
	 Taoa2j1/Ij1KeH5UxU9xgvb1jTmcnnmCaNXRUcVsAsUg7sSgG4kdgellRExV09s7BO
	 M+NpIoz/CKn1w==
Date: Wed, 9 Jul 2025 09:47:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
Message-ID: <aG4soWGGG6nSMYge@finisterre.sirena.org.uk>
References: <20250708162241.426806072@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3AGhXWMoBOUEyvOa"
Content-Disposition: inline
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--3AGhXWMoBOUEyvOa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2025 at 06:19:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--3AGhXWMoBOUEyvOa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhuLKAACgkQJNaLcl1U
h9D2dAf/ftv1gt+QMfEUwV9b7oYFTCx4SiUOQtX6yzvVld8rtN3HdUMLyTdNumXP
8DEUo2k0V2u4J4E8HxsjZbajDb52pxCWJOuL8X54q35ALCKzu91kS6GowrmmOpkH
KkwQx6TiQWWDtwqPiooRd8cO53jOvlNEO5Q6ypmtDswI2+oeRBYT1Clq7s+Catss
swlCD7fum9L1PhCE2KnE3xOB/ySazj6RiTQ7pz2zCWAHbjUhXr5rGPsklfBsDvhB
YHXK9U1cwemKB0uYpIcVgMEnG4YTay9FFUm+GSYwdMObmSJQNSdsRNCVdr61btLk
+tUxdx+Pf5z8MeKGx8LGt40uhhHfTw==
=3Es3
-----END PGP SIGNATURE-----

--3AGhXWMoBOUEyvOa--
