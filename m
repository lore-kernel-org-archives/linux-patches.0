Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A69C481CD;
	Wed, 24 Jul 2024 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721820760; cv=none; b=EZlzsjnZmVCBZ4Q5Z3dRo/vsMNPU3Oa0Hw8LHJRMyMqoY45zIC5SmxCJTwPv2nHBfSkrY6j1fjReKgIBPcnUWxcYTZvr0tOo1YMG9xkLj55TF9duX35s0/EWE+L8wDZ7/l9fSzNYTvyTJQa8Cgbz18gYZOMNCLPmdp/0gx/1Kkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721820760; c=relaxed/simple;
	bh=cqzsFEvVYnokFmyB/R44eOD3y5gwx5/v1eWx0qRnyo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CaZHurGTC+jVkuu1ul0UHH/OCuorqQFNvm3Mfuw4gACNYW5cu4mU1AgeV6lrH01UvV1xwb4RtaKEC5FMpZACAbPwmSZiFrmpdjPxvrK7iuU2b3/8QXL54InV0HftqoGX6TEgY+g0gn7+QpEem0umrD8RitvJhfWYVj+UQsGQYR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u21p0ZvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u21p0ZvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CACCC32782;
	Wed, 24 Jul 2024 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721820759;
	bh=cqzsFEvVYnokFmyB/R44eOD3y5gwx5/v1eWx0qRnyo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u21p0ZvN8hNc5m1y+QgR5FNjPkDXOMXxDW+uj218N2fiqmyGEEFwjLTJ9GnL3cqLO
	 xQU6uazdED1VKZouzhCuflXjtkyM09YVpiL4OBLlfWJyDVWv6ycmyaP7OyCSevbyaS
	 ss7ttOqoa956dy2uXKHNk5KElqq/2s28zPYDBkUGN1sE2BYxyFX/+XnmkYExQNFDNm
	 GWk5Sf+/j5IqEGATxkSnfR4hhxE5jvmuwjzUav3OwAU52sFm7AqO2BFkuOgTLyeAdw
	 47MqRFjHQnTKSvcuXXQRUFrS7QGhDbQO+YPJ3uUzPjxqoIVykXCC1Hd4mB1JamVztw
	 joEL8fGyEXy6g==
Date: Wed, 24 Jul 2024 12:32:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
Message-ID: <00cbf5a2-3da9-47f2-aa40-87d4bdf2605c@sirena.org.uk>
References: <20240723180402.490567226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rlkyrHSJjbzdVaph"
Content-Disposition: inline
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--rlkyrHSJjbzdVaph
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 08:22:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rlkyrHSJjbzdVaph
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmag5lAACgkQJNaLcl1U
h9AF3gf9H50yfiU6M4PjsKrX23LN1p1MSEyWX7fEKbsp5Fu8LOzm/BkGo3PErPFH
6CHJDmG8/hUhspVMybpOvPwdfZy2xdnYg6hdaCdNXgrAq3BGK5pGyXEfCPM/9gJ6
LMP8SN4aWh+xlXLTunO+8fvlgm8NlVXrcsPo/mwB/iLXyjuL2dljaihbrvKm1MLL
/ywFOiXcw9xFN2EBI/oYk6ziEJFNPajhU9hTze9jpOUxH1KyF2Llb4FP3PIkvCaA
nYolZORHiPmz0U9m5lxN4QLiuWAPaiPfrko7NnCZ+hdp86WcbnheDm6naV8qbvSO
pbKw6qdVDax3TJ0RDy13a/KmAAmSGA==
=vNzz
-----END PGP SIGNATURE-----

--rlkyrHSJjbzdVaph--
