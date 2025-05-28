Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A36A33B;
	Wed, 28 May 2025 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748431605; cv=none; b=d1SJ9yX45fNEVgcq/j9011m730bST23pLbJq3PnGsBEVyP5cj189ZSuMeNXm1Y8OIvd9AraA18KWAPXdvlYmb1I7JOrSlJ8a2blQqUJfU3hfocvglmRkF47nz1+iSEfxEGlusgTUlljzqW9tM34VE2d1RFBrBtwEVOLrDeaa+TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748431605; c=relaxed/simple;
	bh=pHmT7aY2EuaIEdbmRwaEn2IjqMZIspf0OdMtXL6yvTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLaV8UBhKR2P+63l8A/On2XgwyOygmZsgov9ziAy9QOfsegT3h5960K71f9H42C1sB+P0LtOLYyKIRHcbiJUQj+GyA8TRTV4sPkjM2Un+Ym4gqBu+NzgLbTs46njOv60HpiSZVKIbsnvQXSqSTeh7Xu59cnCvsQaBFu2bmrM5cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjWkl7CK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjWkl7CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26295C4CEEB;
	Wed, 28 May 2025 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748431603;
	bh=pHmT7aY2EuaIEdbmRwaEn2IjqMZIspf0OdMtXL6yvTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UjWkl7CK+doLxND9TQQ9oMgSoZsM8IiBhiX8aSR5x/44iEiuxDek4j8a29nV0x0cf
	 L/7S1EZLTiqs9F0ZEFvDj35L927Tebp3yJr+JJZPOuYZ93qAzUiHQo06j9vsIX3m8j
	 wb7pxV25/hmuSRh1G0Cb10t6D80Q9XOT81K7SIL1w1STM4CVQExN8PKOy1Ymk2YwVv
	 khVJT2hv3DmBI0NygvqCNl1H76ch7c1h0xxoHi9qtEx0hVyyFWMgqB2Okk5jIhlcqa
	 le4Wl6v48aInexCa6qvNTne4wwAHoGFtRSLMB8sT7pYy4VpDhlyNMx4RmvX/xyWHoS
	 UlhtLAn+swKGg==
Date: Wed, 28 May 2025 12:26:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Message-ID: <bedf1595-719d-41be-a002-177bee88da35@sirena.org.uk>
References: <20250527162513.035720581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nJ6UZCQ6yzhKssSs"
Content-Disposition: inline
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
X-Cookie: Keep away from edge.


--nJ6UZCQ6yzhKssSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2025 at 06:16:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--nJ6UZCQ6yzhKssSs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg28uwACgkQJNaLcl1U
h9BqzQf+NuJ+Xdh2+/nTyzAPqofhAEuUlVyCo6oMpJJTMVC93FQfoe8oLgBLZaRN
bngc/9lSBm3GRzrifFVd2E6Hwmo8YLcQKtKbjESp3VX46qRoHIhvdR85DvFPGkDI
Ys3fplTDudYDGiY6VXNleT6GeH+WKlGt5fypomCpwJ6TtYho5xVQpSQVI9rDbgqD
aloWb9Y+KxGCqx87nWTzcj6gqvd86XN9QCgngkAVGYU4G+bOWFNv2oHbnuHj56Tr
AekeoPrvf1g3EJF8xnRdRTPr3Ntm2C/JVKsxBG5G0uVNxd4vmY8gMOiJwTgZ099g
DCocFGDheAgJrPgdW3vDFrMxUBoDFg==
=zlKk
-----END PGP SIGNATURE-----

--nJ6UZCQ6yzhKssSs--
