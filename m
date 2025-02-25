Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDABE2054F1;
	Tue, 25 Feb 2025 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740487090; cv=none; b=cnp2OPJ5t2kKnb7djbkl4mypBivC/vPJKasQnH/1q/PPqUlSe7nlU3BL4D8qeRGYtR49QjC9g+qmwa6Y7pHJXk4/HVXVj/EZzvPsv0BPK3xQR8fUR1ER1b0WLHAjFV4DLWnFjdBp5yzG7R8k4MRpsLSUIWFZ1dghHLaBmO31+mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740487090; c=relaxed/simple;
	bh=evE3qQk56fSwtr7XXclA0YrzLLmkVx35PNXiBipGRKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWPB70m7RJ84d8YDqCdXHh6RV1I5NELdzhYFm51BdrqwS9ZYTzrWRkmACTCUuo0fEBp4tRD4i92SLjAGd4oMQVCEMkrQc46w1DlmX4aJ5pHJCy6ETqT9mbeiw1giLMCOvlvjtYheNdai2x9dHHlFOlc2WiS8x5XIKwGym71LzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvNrR1dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvNrR1dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F160AC4CEDD;
	Tue, 25 Feb 2025 12:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740487089;
	bh=evE3qQk56fSwtr7XXclA0YrzLLmkVx35PNXiBipGRKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HvNrR1dgZWMWWTrLSTvJRh+2mysYDFQNES3xLLXMVx905ZSFXdwa3YnFSbpy6fQme
	 uXFyXBGqyl3VBSU5IK4eMv0MUHyE1em9UpOm8/VZavOAOQyFoYelFrRCnVLDzQALBe
	 5mGyXftgc8IUD6D+FSKk4KyZgyi/3DyhaUo1kymCmH7LLZa65IilPgViBorqdAE1LB
	 xPuRJF3AjOy42ULpBm24U2A/lPsNMAHE+vNaogdGoZwVkzXHRIM7iaU5gQ12zvKDu+
	 lCmx4UF1fDazjfCy+Vj/ma7eGoO+feJsKcytuhq1ju08I4Wr2CNuBqh23xXDW5Of2m
	 //WvlxVtVwmug==
Date: Tue, 25 Feb 2025 12:38:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
Message-ID: <535f548f-c5ad-4fd8-bceb-8063f360a4cc@sirena.org.uk>
References: <20250225064751.133174920@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Zpn3ZcMiMiv7Yser"
Content-Disposition: inline
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
X-Cookie: I'm not available for comment..


--Zpn3ZcMiMiv7Yser
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2025 at 07:49:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Zpn3ZcMiMiv7Yser
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme9uaoACgkQJNaLcl1U
h9BAiwf/dw3Untav5Mhl1tP3LHClqo8SBTdvNZ70K3+Kdp+NxtTctxK8eeFlqwAW
Bz8hU4iUuawiuLrP+wNNTFsLEPkR0aJeHyVMjDUqQb/1RqTUbxDaQhMu9p2B9mLw
UMsL8MxKhjBt7mmaoGkt6U5dTMOjJ8A6IkgYTHXcV3Ey/aMLpa5Mzx6op6j6bajm
OmiTZgwrywvD6lJrCqiy6H8HvR0diIzUJaZBCjrWD0Fo4rhq3zb2YHwN/5eQoExD
ax9nj0mxMPbraHrMEeYOYDZI+e1Z2XHyWmQI8I986lh2U5C7CQhfXuPhO/ClgLxM
0BoIyfJaF+BvP3bmd7jHgEdD6dC0UA==
=ks4s
-----END PGP SIGNATURE-----

--Zpn3ZcMiMiv7Yser--
