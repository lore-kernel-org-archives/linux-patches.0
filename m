Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821ED1DFDB7;
	Tue,  3 Dec 2024 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733263656; cv=none; b=PTDU9w5c1pP0pLBmxPvXvVY057TAJ0TByWla8k26tHjVlQsxDbxY2Vo2uWKM7Kj6CSXj8W0cpGm/AFSz1+08ThwVKY4huaUt3thiy8d4ucBbQaI2C5nAV6gyWCQvmcOEt6Lg29B6NnIiBV3WTHss3dRHI7/tulMEpuKAVHOzEBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733263656; c=relaxed/simple;
	bh=OIjbYUHcpaJOxkm+vXUJjFS0EE0BneByEJsmOHd4foQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsOMCkAmomID6qkaKEOP9O9krR6sNuZh3ZyEBecxqrfHk4iR5gY0tIUy5IjiGzWVgnt/5n8fSkR9UoXXCPFuWagagEDzQ/EXiJiWAR7ECgj8KjJbPWuS+G4XeD4iwwTFXr5c3Bjg9UuLtGu8/LP4qRI9Py5gGrhoeyPq4OcR/gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUrmymSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUrmymSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B1C4CEDC;
	Tue,  3 Dec 2024 22:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733263656;
	bh=OIjbYUHcpaJOxkm+vXUJjFS0EE0BneByEJsmOHd4foQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KUrmymSbPhZtTspcQv6NxcvmraKbuM6IKuqtifF3CPWOWWsw28lHh+8EPkx+BeLP4
	 Yop/mKR1TEMjaQd8tAOF0siRra1fyich7xEfFpqEr/QCG3dHjoOAlqjgbVN3XxGjC4
	 pXd+tMrEYjTAsA7WhkRaXqLMZXFNq0LQLF1mVNiOzOw+1hZLBDhsfyvLC2l/QGvVEH
	 D9OgJk2veq60BakiOtUYE9FCvqsq0PVJ+CsiihNNqTUF+s77kv7yeJp1mFEJZF1FOP
	 zLb465Ws3X+wd79iIRmEri2gTzuAIsUzsV/xNpfP9nL2mNx4F46QBYydTL+0xx61XA
	 qhn8pSSV75Jtg==
Date: Tue, 3 Dec 2024 22:07:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Message-ID: <3839aa45-0840-4f59-878d-99eb63dda597@sirena.org.uk>
References: <20241203144743.428732212@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XHruKO7Lc62mLxpA"
Content-Disposition: inline
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
X-Cookie: Alimony is the high cost of leaving.


--XHruKO7Lc62mLxpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2024 at 03:35:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XHruKO7Lc62mLxpA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdPgSAACgkQJNaLcl1U
h9DuXAf+Je105aGSjV0zU0ljgUEBbrkAU3UoRsXr5cK0NDhjx3lf4kgdimgPpqIr
5tkX7bXYi46ZqIHLAwjOK9prC4Y6R0S0M1fOaNjfAPyh+7klD4I05gR2zV3bQC7G
16w2ZvFxtN1NgThtG4TidQN2H8uEnBr23dWxmOqmQHGnCgg389zxA56tnskXDNGc
ChAtDydN+EJdPPWT4mcVKAcgvzCq8Y4NyZ3YzhrrS0lH7X4agMH+z4zuwBn4NtTS
u4KF4L+zNXqwk0mcplmCbW2A4L9vHTAbWRZoZDbALiPZsJQIJaeQlUa/MepmgJBD
Wz7hFFicXuQMGaB3b9mgf6UM1HKqIw==
=YLZI
-----END PGP SIGNATURE-----

--XHruKO7Lc62mLxpA--
