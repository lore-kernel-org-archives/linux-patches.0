Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F9D2D97B5;
	Thu,  4 Dec 2025 11:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847806; cv=none; b=d2IHcHTswRtSHUQZKiWK1gFzDeYq3gE+HtzqjrK7Qq6LzS9RKm8I1lXApR/taA/AauL9p8bU67y47ok+mcIq7AA+kN+6T4marXRtCFpHaTIwIP/dwLs1oSDVGbcQNqsXKWGs/wg/+3ZEFPdWejmFgF5NujYXnRHcTmUpZAenzwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847806; c=relaxed/simple;
	bh=VKslpOJkN84PbE3DCM3aeDTtlghsIvaV9Ws/MM83kwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfwRCy/grKgifo203Ajm4jjaZQQLfcItkKpNg41H4OVwJpDOO25MlUEN7OZUCok/YsVDFid/P85cYb7eLMU5/etsYEIc/qfM9BEJy06HtisAtfnUERStFfDO+m0/6JHX5NBpIWjpAy8nHKBKPHuFWv8aOVqGO4NdtJG56xcSA9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKC9hEMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKC9hEMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371C0C4CEFB;
	Thu,  4 Dec 2025 11:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764847804;
	bh=VKslpOJkN84PbE3DCM3aeDTtlghsIvaV9Ws/MM83kwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pKC9hEMoj9xhekfJ/Jbg6uFZPw2KHxRixi9VfEtdl4qDkgJgURdw1hjxaDfxJHpg1
	 YzKLW/DCdU6lkW7woXc2A9I8K+IBUKU8ma5GllBXp/6sIWxmlS5kI0K4zZCKCJYoE6
	 Nqy5EnVAg8c1L1neztbWp8fVWIQveVEyjcqVi81sK5WK+iHvNcCyqLRKL7lFDQFPV8
	 1OWzNyoUAxfTxuGTrDEnHv6LWZfrTCb6Qc61M/krQyoKHdNgjPNeXb8rZbVBvfkzxS
	 tBfNrFf7aROd9ZcVLbS+Xi1Z903KUtl/z8JnzYKUwvbnSuea8MrV1J16qhdEMTfroR
	 6+4WnScNNdliQ==
Date: Thu, 4 Dec 2025 11:29:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
Message-ID: <bd672737-55eb-4832-bd54-a03d9576e11e@sirena.org.uk>
References: <20251203152346.456176474@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CUqYYpTjzmhAe8gF"
Content-Disposition: inline
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
X-Cookie: volcano, n.:


--CUqYYpTjzmhAe8gF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2025 at 04:26:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--CUqYYpTjzmhAe8gF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkxcLQACgkQJNaLcl1U
h9B5+Af+ObhR7IoTGAmxQ5/accai6vlWaFslNUc+KQr1LVpokMKU4YyohTVwwJHJ
Qf7FbD28dJD6BlIyfPny5bY+6Y7cxUP1k3e7KYmKqVoJhyu5kZ0uQTdYt4lxhA55
DmEgM9F48ZERxObi/8L4Zb7nEpLp9SqFECaomyJHAo9nci9hy32RocSNcX6eHrz3
9TlaY6fy3uS31PCnd5ZpCG9AFFHSyv0Ux/Ttbx6L51VsjwfUSyT9j1WShPYU4X0A
g7zNTC1uzcsHpeqQkPmcRdkweAtvwjGpu3dointFdykDE7QHMKdOBaSsSbV/+KUb
261Y5AR4UrXA+eNXuysraQmRuIx0Kw==
=lHVL
-----END PGP SIGNATURE-----

--CUqYYpTjzmhAe8gF--
