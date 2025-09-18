Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE9631A7E8;
	Thu, 18 Sep 2025 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758226282; cv=none; b=rLIpaB0t9hBgOzZas5nrVmF3bvsgZy4UPVEnxth5U7ccu/M8GRvN+UAAiWNTHyCUshjwUMPoz8mNbreAr7MqHgpyt+rhT64wUiPIcIGEGc8kFIrr5QUBQNvxQ4QLQqnu6bawj8MSCRRxJcS9ZTY1yHEgeVoGwC+egUeO3VodIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758226282; c=relaxed/simple;
	bh=zBVhlN1GwYUXnZX9CmY1mrZkHSRr62JWrSfhgie83C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mA4osxWVoBNVFudzFQlR2RzEgdaDf2x06cb5rmf5JeRTTdW/BZzviyjmT2CjOZCzakMF4LtfsktruXfGPRhMr4qa09FvALF+iJoycoW+kfscqN+BWuKIBWbaAEzJkyl8kpZSZxO5ZpG6yhoxo6334DWj5uMXhcEs7QywvJqvdZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjdvDFCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjdvDFCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF75AC4CEE7;
	Thu, 18 Sep 2025 20:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758226280;
	bh=zBVhlN1GwYUXnZX9CmY1mrZkHSRr62JWrSfhgie83C8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NjdvDFCuov6HZWppBzO8pTqR1ayFioN1T3GpI/YyQ2r737zVJSNSaHb81JP/fEi0e
	 hM9GfFgK8tkwg9Po13XH3rp5ZblhMi/6DIHWkUcRFzLIWsyEP8+fGWA6BnWCBqophM
	 jtxKLX1HvR7O0TzdkChoNi2e+qSASnBgPO1ZcAuPtwu1PouKtifaUrzwunWsRwTHqv
	 TEnoW+4p07bsrF+3YkOoSTgBHi88MWU9+xmLEBFTbQaXE4GRmOrM12w+oITpqwh2Ey
	 5QzL4N/DM9rIGn4H+JDjngViMrzhKteFl896nMvcHeQzNCrKJgaCH+WhKrf2cEC5ss
	 xqJKCP29L8DLg==
Date: Thu, 18 Sep 2025 21:11:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 000/101] 6.6.107-rc1 review
Message-ID: <d410823e-f878-48ae-9e23-ef905cc420da@sirena.org.uk>
References: <20250917123336.863698492@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FhI8FIYPQd08Qdox"
Content-Disposition: inline
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
X-Cookie: Victory uber allies!


--FhI8FIYPQd08Qdox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2025 at 02:33:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.107 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FhI8FIYPQd08Qdox
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjMZ2EACgkQJNaLcl1U
h9BWUAf+P9mpYwAamuVIav3JAWuk8Weri0u0ikDDUJQgKqmTNiM/ylsc9m0P9K9v
LeiiBBvhQ+aTQICfZ4ljwRL3v6g3Ag5nuzCz4M5nGQ2G55KeV1Dq/cLWH/ixmU8R
MilpDlijmWMcFSdK0ffh7cg7sqshwMisNrY+BRQ9sq6s9MR8iAZEbJmMBz00/LPN
2gYYxvfgLjSj1ctkIFXdZrF+LiQjZ/qAXELghh++d1ZfooGMgHRRxgPlaVWy0LWx
l5m15YrWiAi7ahVkvcLqlkFGTQBffohwp9PXE//IrtZWKQ1ovJ0HEUAWJRybWfE1
/vNQ3pHMHdgZc1GAaepkks1YHvDRiA==
=ZT+f
-----END PGP SIGNATURE-----

--FhI8FIYPQd08Qdox--
