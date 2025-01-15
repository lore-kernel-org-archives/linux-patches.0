Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81762459A8;
	Wed, 15 Jan 2025 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946736; cv=none; b=JMdL/yNPcPpP6IfQC5IDydtMXpZQxIK0sjjG1FCSnijqbRRD01q1cZvkCWOMETukA8RWI4lW9gbhjJtLYQPcGxmJyB46lEo262G4Y1V7XQ/KblHvD+3VvNrzyhxiw1Qxt6uig73Pntzn8wJg6mGuG4dtW5VjNpezFDF6dg6q8f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946736; c=relaxed/simple;
	bh=kdm0rQwOCgIza+CLV0fRHifocOaggSHvfaiau7bX2aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfItOtF0shBFvDpHeCL9jkhFmF4yevWvhr3lyUbS0rtWyo75tPNvdAedSdN5oqFR3iz/RvIuRh/pAtmmMuOOGFd8m7Oh3Gd2tKujjoa72eWWsJJWWpkmsINPKS2JPAUe4VNqV2136Q8ncM8DAc+G8Xo830VFmzwznH94qfH79bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQ39ZrI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQ39ZrI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E132C4CEDF;
	Wed, 15 Jan 2025 13:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736946735;
	bh=kdm0rQwOCgIza+CLV0fRHifocOaggSHvfaiau7bX2aI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OQ39ZrI/kdpiBbm0wtPnQkFZaqvTSnqXj/V1hJnf4CiFIz3s+1ZuQVF/qzlE6J0Rf
	 x6r0Gt9PQNW8WF4HBd0QJuXh4G7rILb8RUT6qJkgDIxnEZCu2KNH8b/VHTuaaDK+L3
	 YpcXMmiWkkd5gu1KQdUT46C0EFAv6AItV/GWsDgM8RcWRpEk5p12Cg+u2trZ4bisYa
	 EXG11YgjduZLClC2OYJ8PLwjjzrkYZIvGlCd/idGWtoL+cRSHWwt0591AebXwwVyeU
	 q2yV0MjNLoRU4Mgu74gRQa0seJio49G54AvfFnt5Ah/rtDBttoJPBhHlIjnvclPG8f
	 Sl17NSwLknuMw==
Date: Wed, 15 Jan 2025 13:12:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
Message-ID: <4dd5ed58-271d-4644-abc0-c6e926b6aca4@sirena.org.uk>
References: <20250115103606.357764746@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+uHWbeXTmhCwVn9g"
Content-Disposition: inline
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
X-Cookie: Phasers locked on target, Captain.


--+uHWbeXTmhCwVn9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2025 at 11:34:56AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+uHWbeXTmhCwVn9g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeHtCgACgkQJNaLcl1U
h9Bv5Qf/RM+/X4niDssyv7lTty6vM+Qj1NsvsQQ6tsYLawTtFjk6qn2UMJd8Qz0+
ED51R/wcTYpmzuMICH8E67rsX+H9Fq2gFtUuqX7tqf5xSwSwREDUgpWNn5wZYtKp
VcktVogU9p5oInDx9CbJ/Q6o/epR1S9lfx7a4DXdnTHGF8pa2cGaa+66rSGzhvWW
h49GzX5ZJCCwezu1SfzeTxH+b+C1UncK/CsQBm+82xl3ZNweX5g2X44xlpAbd1z9
U1AGdLlmvJjoXIPe3gL01+mhQlGmUOAgEy+qg8sjS+gG4E3ydm0/t129e/AyJTOu
xtzcLYGdB6NSYFGDc2zmvbweZRj3BA==
=y1jh
-----END PGP SIGNATURE-----

--+uHWbeXTmhCwVn9g--
