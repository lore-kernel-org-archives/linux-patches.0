Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F4113CA9C;
	Sat, 15 Feb 2025 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581024; cv=none; b=F8CmtDcNo3yyC2fo2l5Y0Z3tk9QJ3dIMwnPhf6fRfrGD6m77aIJVLGAuscrQZPY+Tn1X6nfq6Nm2d3ZenwfhQN18GytBCpcZxLMG8cektA/ithuhLRQguqGJc+fh8Wc/qH8K20bLaL5l6baYB38hgba29SmZanDmIK4lJ7OFgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581024; c=relaxed/simple;
	bh=imiRXcRe5fIzga1fTl2XI0oxBCEsG3xFvR07QmMegj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtBgXtMG58EEOUQTVpAZeBJxctnZXdOooMkqpoR5Mxb5t3t5ZxKK5qyu9QcFRYfgVbLJDBzs2N8RI74RhMKD59xtAWBo3de1N9KFG9s3OQV3FyIWMhF7MjUV4vyT1Fq+LHmK9Wc6JtRLeTjdIBTZwPAU9zmx8gmf42bk+SwAfjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtsgTaCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtsgTaCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F33CC4CED1;
	Sat, 15 Feb 2025 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739581023;
	bh=imiRXcRe5fIzga1fTl2XI0oxBCEsG3xFvR07QmMegj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MtsgTaClPzNEeNFM589RpXlKOsY6YNX5SrT20oR5i2WSWVQIA2sBcgRkL6roIoAk9
	 Z5VVHLTLn8qirFBrwEtZ+7AJXyGamHTeanDTXLSqMQcHZUDImxSJe3lIhnv4pWPpUk
	 YOcPPb4wCXftDpbLQVz3mQNtNxRS7YusiLrZNSielDmLUyThQbJonkm1UXSNQpI7LJ
	 dCtcl+3vQxJQAJ/lqGCjdhRQMH8SWEnV+jjSLHT3dHs4tTIXhoMl6AyUosZiLU18Fz
	 1eUdPB0eOPHZQxc5YVdsrvZscfIng5R/k6bTKaqO0LpC5a2x6NYIh3lLCUfImB6KuS
	 p75eqMwUImy6Q==
Date: Sat, 15 Feb 2025 00:56:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
Message-ID: <Z6_mW-l_zGRthtBU@finisterre.sirena.org.uk>
References: <20250214133845.788244691@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b1zMQeLm7Y0fmuUQ"
Content-Disposition: inline
In-Reply-To: <20250214133845.788244691@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--b1zMQeLm7Y0fmuUQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 02:58:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 419 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--b1zMQeLm7Y0fmuUQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmev5lsACgkQJNaLcl1U
h9BK0Qf3SzoFKJQ5kz2A1VqO+kHwutHNzrjB5O7aSBnpK4EMWhRwrIVV4qhT+tA7
xT9Vj1WX4in3tBlXf2hGGQXLHFm46ARFn91DkrxAdj6HYTQynQ8fDyQtehmCnHSV
STZvh9VFVBrQKLYBzsY9ljJLBj0BzZ8LHwX67es9GYQvlh0H+a9k+l1kOB5voJtc
6vExTBBJvIzWVwpc81mF8mE3pH0IK33qSTXZ4voZHHaSW3yTNiaczUWCyXEC9UG9
Jd4ob3t4CFsGGjZEm/55CqirUeF5dnXEAFxIEEpYVtKpqw80DKsGgUledfKZkUuo
rxaX+0JTOBxpPAMWGqUh0QABTTwi
=qL4n
-----END PGP SIGNATURE-----

--b1zMQeLm7Y0fmuUQ--
