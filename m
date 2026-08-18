Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6713876C9;
	Tue, 18 Aug 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068176; cv=none; b=qx7qXjXP4RlZELSScHMbadC6LZQDZRMh54zS6KXVzzbSD4cFN0rrBjx90aleYQz3Kj7/gU2zFbaIzUuIjBsNm4bxMOUzzRavM7+iwzruSzuYpLSR1yKU1S0OPOA2rlaS2tLdwFbKsiZKoFRAhFOL5CdUtgUyZVBDyMAu2b4Ws1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068176; c=relaxed/simple;
	bh=i4cYoJyIrqf6oqz2LMSN9KbcPCe3FdR2XXsvR36QdPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7qskJOH2pcUh7Lk2eQOq+J3oXn/wDH/cW8Oi5IcVABNj7Ow2sXz74ykWIELvJ47ms9DqfUju4UFdUkygZWAzCmX3E06bSHaq/ofaESeZc8+bSwA78EnIVIo6c4GdkEuLHpokAI84yVLNz6PjerPTASboHX0Jgcb5ZMwwmYy/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwErbL6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwErbL6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C4C1F000E9;
	Tue, 18 Aug 2026 15:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787068175;
	bh=HNitprvoh9kyx6YsDjAhdm59wo4jZmgczDAnndMarbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WwErbL6ZQjP69iq0P7S9obHUu2UiTLM80k2jrlGKup7RKsNasnsErFZ1M0xcuKKbF
	 DYuBkhZyEdIjVMdD8ykg8s4wcy0DWMd7YGsV1hpLKBrDg9QUFvMcPQVJMH4nrUKvQ+
	 lW6U7Ji31CeV2nP+UzN+U+ko56fUHjDqdKHho7lm0RkCbG5vAI42+fpNV42VCtjb1Q
	 eSK7YsETZxBD+OiB8MZecrUt11yAnYglfSQtj5eXW8zioS76SYa7SjwPf0hShDetvA
	 dWU1SQrj+hciDqLGLlbZ5M4hGnkuNOmW+L021gt7v36e/t7a9AhD+NS5lop6LJXoah
	 Nxvm+Oohb94vg==
Date: Tue, 18 Aug 2026 16:49:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
Message-ID: <c9710d76-f5b0-41e9-b96e-e0ae74ec9955@sirena.org.uk>
References: <20260817132536.466235697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FXzizoDZDRKVstUP"
Content-Disposition: inline
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--FXzizoDZDRKVstUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:29:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FXzizoDZDRKVstUP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEfwgACgkQJNaLcl1U
h9BlVAf+KR+AP6RDqEIkaWctEy7GLSvVN41wNsJTFSzcfdZh2COARipd1I3LyAdc
VXJTOcacigW2M7XoG+sDiXULUqozXMmiA6kPvrg4B87kBQrNOXfkMQYgfJbUsEgc
vBRUJtqx6Ah+KYOF6MAhR1Je8xaZfyCsCvhYf1zXOAE27uAk0T4meemjrNuwqqbX
RYdO5sJqpuBE0lOiz8w/jsuNiGVPFAELy/wIPJWFS35XACZ6SKP05j+aEkilzF5T
W9/UjI5ieAkVh1gyisRu5NU+hnXKrJXCDBdDNSuJe7UvCGj7PXxgYCMNg8L7wmEa
DMFKt298XYCpvitvZi1rhBZ/Pg28VA==
=eqad
-----END PGP SIGNATURE-----

--FXzizoDZDRKVstUP--
