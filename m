Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974D31E1A08;
	Tue,  8 Oct 2024 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408555; cv=none; b=hjv+q7ds0sYC/065SPmJht+K9x06u2xaYaIrv2fpI8Q6FfdXbB7C9tvUmSqL9R5kNN9HDbcR6E8lRq0YeS68OKgk349hg3KY+08eCDLTD9TIYpW/4/DX7bhdFmm6ookTshggqaAMLnpfW1lNNjntXTheniwBBiOcyFYthF4XyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408555; c=relaxed/simple;
	bh=weedNgh8dea9BxRX/tLboNqbEPJ89qgf7HNkp4mo9EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8Aj6eTCgt6sfMmJN7Vn7lqrKSUxvjK67L2M7TMLp4KzLPjmPWvB1nTJlbi4xmRj+H8KE8uCTs+X9Z4eExf60PDLOHHvmNaq6gJ/cDsunzsDxRpCgBxx54XiEldKXo5/Xs+bqoUPtWL2Crj9bhu+s6+GvbARwdG3E4sQoxUFARE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/AB10ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/AB10ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F93C4CEC7;
	Tue,  8 Oct 2024 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728408555;
	bh=weedNgh8dea9BxRX/tLboNqbEPJ89qgf7HNkp4mo9EU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y/AB10ZNsA2CArcXEVJQ3TkKuvCmMKkO2Yf1IpP+uZg6RCD8mXjmYUeGdsZYdq7k6
	 CBDYqMD3drmn5/+xb3Ksa20jQ42RQla3y3+/2CaZKNksU8WP2V70YmG/1A0A0D3mKq
	 4iB2Vy1S22XpnphD+g/A19armw2eKc2LWcL8vDjzog9HlIJORDDlodsy8FKrnCPI4M
	 pKWvRqfROKZ8Lt5qzMPn0ExY0C/jM8EHWy4yhrViBDbMzdneXEK6VSo8mPXnU3EN5Q
	 LZGnnbHykM9Rp/hmigEc1zEaPNW+catpEBo8D8TFYiGAk1Gt78TninkBfSWAk6TayN
	 SuH13JtIlnrgw==
Date: Tue, 8 Oct 2024 18:29:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
Message-ID: <ZwVr6Pvjkmcw5YIX@finisterre.sirena.org.uk>
References: <20241008115629.309157387@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0ql6jpcI7TshO+2o"
Content-Disposition: inline
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--0ql6jpcI7TshO+2o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2024 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0ql6jpcI7TshO+2o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcFa+cACgkQJNaLcl1U
h9BeAwf/RIyod/8Xy01oQaj6cz8oKX/pSoR+Ms5Jd1MXu8YtzFxAIPIVMGx0HU7g
AETdmKL/lIXqj7LeGe2o8kY00lPwHOmZHr3vv+53eEEPHrm91Y3VqL5+U2zKOQ3g
+uTZ2CCE1wYfNKiHjUMhx0r5Tdu75WWi4L8fFGQ7M/mNils3ahJxm7NHDNTcZuvz
Bz/UTeOgGU5THFW0hPtW1gLw5pLBfzFvOriBS8svNmg+oQdGYQwvKIHIdaqg+0Sp
VTm70W/GBIrWOX3XvAJN5i0/ocqA7M2sy3kSfVwjSQcWnb1IzhhRgDOtk0NTsqik
29BUlOJoWsLI7p2gSnkK+moGuZ5SzQ==
=cQp4
-----END PGP SIGNATURE-----

--0ql6jpcI7TshO+2o--
