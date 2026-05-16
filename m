Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF344224B05;
	Sat, 16 May 2026 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778913507; cv=none; b=QqM23ufHHJJZk0+M6Y/5BR4NUBdDagXzX+lwJBYnbMbFVNkj0OilTEQS1WWnvht2qlO5DhjvePy4hkgzBqMOscthfaVX6dhxwLsDbSb0VYSiTiLXAye0tlruV9zoSyJRARQgkP8De3COa7jF5G7H3lZG8bSi+3IeNDgaehnDW/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778913507; c=relaxed/simple;
	bh=c320lPv6fqRU+3pzNVunzG+PNhRZjvR+XHAP1wQq65M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqOMF2xL+jzE4VS/PHiAOpEerNLP6ez69vVTlVxv6VGM0myeVB4DGbXQY+X7OwiGiUVN5ySp4M2LwMl7wlv6uQ9xJlL77X/nbGgRkpm1WLGNXsCrVaXHQKzFRg4tkwW37F0pvRnVMNweYmLnP4cyWCOyBNFOjzxJYclojyO7UwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeIpzUbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeIpzUbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A663C19425;
	Sat, 16 May 2026 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778913507;
	bh=c320lPv6fqRU+3pzNVunzG+PNhRZjvR+XHAP1wQq65M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OeIpzUbQGpIFbcTlf05fb5uHZ6UzKGAKaKAfVHiKL56WCuTjP8KCk8G5AifDVbYoW
	 dZ8Bd5HgJHi0kFWkZv1HCjcDLX+hFqujutaaadKZqDDFG/Tu8HThWf/LY47VG48V/c
	 NoOCMaut/P5KtAUZDFt9di8D1IJJBK1IjGukkwe8HCBJumnQcsIrQ44qWW7NjydLGb
	 x+fA/6oEVVTUcLPch9oYOImZxJY6/VwrisH2f5vfrgf8X3n/aU5vtmfAvYNtMmfuek
	 O0yyFWkuZ5bsy4qU4z6Fu2NGOcnwXiR8pzF70Gan5o806fCwiUJhXnf9jbUGKR44Oh
	 9xAAZhzVIFq/A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 1FB0F1AC5A48; Sat, 16 May 2026 07:38:24 +0100 (BST)
Date: Sat, 16 May 2026 07:38:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Message-ID: <aggQ4OhI0La1t9Ze@sirena.co.uk>
References: <20260515154653.469907118@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A9+aRNtdcoDQkduc"
Content-Disposition: inline
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
X-Cookie: Truckers welcome.


--A9+aRNtdcoDQkduc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 15, 2026 at 05:47:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--A9+aRNtdcoDQkduc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoIEN8ACgkQJNaLcl1U
h9C04Af/TJVrdLwB0gVpr8KzBnHWZEwub1jkbmBIt5oMDsQAUfPHr9fwsK+rG5n2
GKWF22yvkgklnTVJGOUrFvK+BnsN+WV2Tac0bE9ZbOP1SkvCkjVIxjxE19v39Rfa
dD3x4jMDN4lXvPgYOZjrfs8tbhkHd8mcS9dlITvCpUiWSSviWIXxlPm1n3NHUQJl
EUn59yareWf6IRXpEwn67UrEQwsFLNmdGPwKlXxuri/53tVivqy7Pr/v8pCfkkRW
K6J+E0fnJqS7h28TuRFMFmrTc4tLhx25dzpgY+hbYaBQxalvbz95qToUnKRFN96i
Kz7OCHNmV/g8n4bjFPgF+vcxwzRpig==
=KVzI
-----END PGP SIGNATURE-----

--A9+aRNtdcoDQkduc--
