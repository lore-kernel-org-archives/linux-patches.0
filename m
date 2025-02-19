Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECA61C5486;
	Wed, 19 Feb 2025 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006734; cv=none; b=r5Ijv2WAErpHKCvZ9q49V9gxxB/q4sJ4ji5hCUgX87bx9FKjAQefEhanrCfaCUcfg3jMmj6S6SVNr1Ve//FfMrYfxL5PTp6GuEYM73y7oF56h29++ISIR5ernfeUbpF26eElhH6vxN5ji5Knv2oNCD8JzeyRAb23Z77HO+Hlgqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006734; c=relaxed/simple;
	bh=JHWJ9kd2xeW4nTrxGK3XP9zXGwhafoV75RcPhsG98oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUd1VayMp1FqWYlpsq7ZdwtdtQ+FmDH7LXzm211RqC8Gb+oMrQKozEwKoSxh9Yh8LSzmt118LTISDEFRGeJNrYy9RjrXqLKjRDLxBRDB40daNVpP3zZp3PH0oZzNWR2cTozDFKY5vwChFkBMGtCWPaPqlNWyvLF5uIMY88E7KPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gz7v1aeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gz7v1aeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45763C4CED1;
	Wed, 19 Feb 2025 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740006733;
	bh=JHWJ9kd2xeW4nTrxGK3XP9zXGwhafoV75RcPhsG98oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gz7v1aeulx0IhYVD0n/Ga9ZwUtAGMlXQpPSvIndKoaTkHju79APYjL3m3uHD1FuCH
	 5V2rLUYqrW86vW3D3l2D/jvVmoDDb0BB11+qeaM7SM5kZr96sXh6FYNS4VGLSEhbNc
	 k6ga0jXK9YvcOxXI8yYN431LU2FcnQFlO3tWtcG6XdS0uv9FwM5SqpJKh/RNrGnGsw
	 qo1rQFsmEwK4+4a9FRg/X2Q77QM111YUEYUPriwWa5zA+bmyPCMm54qFUNKyQWZBx7
	 7iRE1dacBG1kEM87oA1ft7xZBXvLnfHxY1TO9SVJvnSlOa67QvXY1LDe3QCOSG3NTu
	 mIXPMlqRLkhsg==
Date: Wed, 19 Feb 2025 23:12:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
Message-ID: <Z7ZlShFx4-1AU_ui@finisterre.sirena.org.uk>
References: <20250219082601.683263930@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MkrPmH3Lw+i+4FCE"
Content-Disposition: inline
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--MkrPmH3Lw+i+4FCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2025 at 09:25:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MkrPmH3Lw+i+4FCE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme2ZUkACgkQJNaLcl1U
h9AQWgf9E3XFaGTNlZTc/emGDuT+6A0BoLICqIdCDJYMPgFY5gaYifVtwM2oz62M
Sl7tvmGSzLZuS9ioK8Fb5Pg7CT1l8JQQ0S19pp1uFWEnn6J3fjw3BqMEBnCWYoyy
Foy/dphJk8iD7ut9xf0Np2x62TwOYM3wepzd26t0JCYC7rc42Tz4gF55duAuMpkl
IJWTm8O+AYoDnqvH8nz/o5atQzYux9VOyovkj0byc/rEOiZlUGRPv3OhM3tsomwW
3TFlFhAOkZwL4zQtIQsZRBgQnDAZdeBFh/F5GJ9LlHa3dnKCYTXmHEAc2qfULWpR
31lKUbiByz0EaL020D5mrKKg9mtwrg==
=LHJb
-----END PGP SIGNATURE-----

--MkrPmH3Lw+i+4FCE--
