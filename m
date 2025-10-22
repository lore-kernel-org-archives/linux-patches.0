Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008A2D94A2;
	Wed, 22 Oct 2025 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156187; cv=none; b=hAVzs3/8nAxMx/h6RFX1ldXUpne8M6LOxr5uMJQHaeuvAV+ttDrvgBCCKDlLAWwrqJStEbH3Gg37jBDEIJrtoIPSGIwD5nMLMV4SxMKp/ikcQY/Et7j54WFpP0jEUAkeSu504HUfM3zrjTM2k9PdfCuDaQpycqbiv61TzOh18es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156187; c=relaxed/simple;
	bh=Dw3dM6Vb1l7agneatb84ENnPoKJyBFrSmg1DGPom7TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayveO+y/RYLhZggqNY/IhN/egpw4TElMmHlQcjC9Dgu+ArrJfelr1XzGhDwjxFGNcFPW4fIkc/0gUjHfGBI9sLvDTVbSMtO4d64vP1ZkuSWL5tgeHhJF5OZJPv1ze+GDn7En2jO3uVICyQgc7JoMpetRCv9rpHNmqAqlQ2RPF5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SimVlNKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SimVlNKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5055FC4CEE7;
	Wed, 22 Oct 2025 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761156186;
	bh=Dw3dM6Vb1l7agneatb84ENnPoKJyBFrSmg1DGPom7TE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SimVlNKU9XfJ5lq9SdwAOtd0LlVh+g5kwGo75tfVxuTCdC/2v/AbJ4yry3mhkTkiN
	 Vv6mmYAsdSOJQkkv7nknaw/dzBZUHpvmpBRR0huId7tpFMswCEb0pAnxaJxhIsgG+j
	 NAYHUtjkEcgik63D6E8hLqtyPaC+vulFU9wn9mF3WcQzn0aX5QfAiZoGyHX7niC+bZ
	 kFHqvr4GrwYLS96sxD+FLCiAdNodyqopF3mcnZIEJIXUs8YKmgky5kDPXaxWgY4pid
	 b8U9i3E+EJ/MaLoLIWyqlblQkUYc55kIj44RqoXKdCiNk7AWnxddTGvafzpA67LR9/
	 9oRK+Yp3dNgHQ==
Date: Wed, 22 Oct 2025 19:02:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
Message-ID: <9b76ec32-8796-4eb4-828c-776c66a4d335@sirena.org.uk>
References: <20251022053328.623411246@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AOR/dPx7B30x/puz"
Content-Disposition: inline
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--AOR/dPx7B30x/puz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2025 at 07:34:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AOR/dPx7B30x/puz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj5HFIACgkQJNaLcl1U
h9AZ0gf/S8msISugJ5i/lkhUz2BAtTlG4+6Z5J8UC+YQj8P559lEagvj0nmZAC9X
qfA2EnaW5lkxbdullhNpxCW9t6YosdvxyTc7S2vHOZjXCyZoSOi/QSEDMz1gClMf
UY7tV445W6b0A797HeoZ6P4+4dsdXGYzc1FX1L2PTT2d+YexIpSJ8PPw7BvLs2ua
wZmjwXxvPd1BIP5nwAT9LBYxljU8IWKscIiq9XNBMRosYz+tJJ15Wn1pGtCPQApR
fmnMYgzf6t1sHZe57f/ris4ckZ8cinyEbtU4TMqxJ7tXogowIxDQpne7zcLkz85Z
ytwnCQtpIqPaNR48Q7aZbKCl+K0izQ==
=zYqU
-----END PGP SIGNATURE-----

--AOR/dPx7B30x/puz--
