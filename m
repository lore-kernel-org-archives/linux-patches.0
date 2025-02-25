Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F572192E6;
	Tue, 25 Feb 2025 12:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740486728; cv=none; b=NwMnvGrB4mpCBYrGIaGSAg+lastMXjkeS+0uEODUlXgsfWgdpT6bsD+o0oJdQ3YQRyfoA/Jyv/xVjw0BOwUEwoNnEm7tR2nkeiDEIlTC6oTkTNZ2emdVgeZMjeleAhpy1D9AnaHB+WQFhnTpjqkaF0vHyjpcUuBJmM+DMsqo0VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740486728; c=relaxed/simple;
	bh=2/EDKQtqzN5mDRO/PeqOSFhs8UvZidhjbkvV4ZctUW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgcvlq5jDY6B+aN/QoxJm7M59KWZk08tftxzDvWha2ceaeYvNjT+UbSTLnKXUlQTgWDzo25p5AVJX7SC0RNqEjAfS6SR1qYhg2HqF67cRXL89UEOoD9+gctdRNW84lBZPglbOcRfKfCTR79K9LUFLoYh+offafWzbOORefiaW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqKAWsGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqKAWsGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00443C4CEE8;
	Tue, 25 Feb 2025 12:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740486726;
	bh=2/EDKQtqzN5mDRO/PeqOSFhs8UvZidhjbkvV4ZctUW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqKAWsGJR79zbFjC2g3xC6/XuZD+o+ZW7Jq5xaw3AdmyG78MeZ93yxYNT223UCjS6
	 3y4qYqIEnRjto0DMmFEdCojpUeTI7jaO1cRv3Mx9H2f4WF4WsQ50uNhjHuPPoycGpv
	 RrEH1/Jy4+S65KR2bqprpMcAaJ7PifymxwsvX1qJMFkACPfXUSEUT6abp1qsXQG+9V
	 xtcsRHFTjW0dVF93rbyyj+K8v6ec5a9J2/CYwVQiOz5+0rWy+pOXu0DBQqQdulgNCy
	 qBcDjdkJdhQ0HwDr9OjXuljaN+dkSAJqgvJ0G2W28OKxIc/dayn2qUku9ksgKraeGQ
	 r4q1y9DhnS65A==
Date: Tue, 25 Feb 2025 12:32:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
Message-ID: <ad36c5d4-18ea-47d7-b2cd-f0be95e5e70b@sirena.org.uk>
References: <20250225064750.953124108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TBaEGPcv01ZRiNyu"
Content-Disposition: inline
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
X-Cookie: I'm not available for comment..


--TBaEGPcv01ZRiNyu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2025 at 07:49:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TBaEGPcv01ZRiNyu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme9uD8ACgkQJNaLcl1U
h9DR7wf+L0ir5hwpexKIZhwVrpl9nV8H5KBQK/tATcV5bnlj0XKrP1BqMD8H7p3u
0yZr2lnE+Ag0PsclWusoFLvNAG4qCkmljas8cEllEaa3/G7v5ZuowbKO1SXKQ1wL
vqmO/6bgYod1HjWJPfAPoKz5TUW75xIpX9qaZfLeXwpqstkxfi6uSl87L/LgfNLN
IQ4DT5n9zBjkFjGOqRUjhWf92fD3sSssu/W8qf2TLpH4IfrR2Ssl3BY1zFaTcT48
b86IcWqtdEMw7fZbEuRS0YLIu7FSyXb6EPPiam/dz0FfCaCQ3vglv0bDJxHjZlGM
pKtTsixjD7M9lZOq3rC/7cEs3Va9Ww==
=iS6X
-----END PGP SIGNATURE-----

--TBaEGPcv01ZRiNyu--
