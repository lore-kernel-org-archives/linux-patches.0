Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713544207F;
	Wed, 13 Nov 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504623; cv=none; b=iZwRCgAD3q3ArJzxsU9ucH9qwJyFbeFp7ZroUV1EBcrX8qOYDo09/d1ZepXf1Nsi1QYJEIfzZV5qvFiFh2ZZLOpr5QLNr2hmsmQv4RaKsX3JDiPPQDDwag0AdhUeQBWd5LlKaeznva4H0E3NbWcUIJsdwbvcDN97WnuStK/Qark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504623; c=relaxed/simple;
	bh=LYiHAEEmms9v/+JLKNl8eH/dFEgQiVE0R6fN+9zGMQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfvdZ91CSXkN60iDG7cXykreaxA3R0OWFbV9aF0PmikcMy6vPYsqVv47gidXcXwPip2YLey6I3W36P7DMiSDKm6J8Oh6ln8iabTnNhiEbbrYXumGIZTrvenBvhDd/W7cvssY5xL/nYnyrNEvv9yjP5DaeSeb676kmUcBN77ylyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pe2F4FjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe2F4FjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79630C4CECD;
	Wed, 13 Nov 2024 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731504623;
	bh=LYiHAEEmms9v/+JLKNl8eH/dFEgQiVE0R6fN+9zGMQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pe2F4FjOvcpzjmc0VepQzFyHTQ61njU3mV3PeFvMnyuXBHMYeLSGjxCWP4JLFEpdM
	 02WzO7exlON8LkZFAT85ZVzRHdO+yMqD9f8qEu3fbv1APGfxMr+fwAH+v4ZkQKEb37
	 ZLn7dig8QdP0XrymY9MevHo2rkp38xnGddYjnI6LYX6Ot8s+Bf4BtDXgbDE7G5foVB
	 GAMzoDTMAnucCr58+4eqhhlaNZYikw9AVm7BzMkWxvKrPTgWwaGsk8YgmILYeqMQJU
	 SC1WJoBr/LDIOXLvOoOKXZMbXQqeMtKAqKpkgKmhsc4kWJ8bpBN7H8sHpWqDlAhePH
	 sRvK93vlw4sIg==
Date: Wed, 13 Nov 2024 13:30:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/76] 5.15.172-rc1 review
Message-ID: <ZzSp6z6cOkP5sbQT@finisterre.sirena.org.uk>
References: <20241112101839.777512218@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q8shD+rdCTehZxor"
Content-Disposition: inline
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--Q8shD+rdCTehZxor
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 11:20:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.172 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Q8shD+rdCTehZxor
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc0qeoACgkQJNaLcl1U
h9BarAf+MCSfWYXp4hHYSDuW21Rs2m+EE9/7LOjtga0kNnZhgQUrfmAqzusUzOIm
X26J0KJriXsEaLHIQnNYQPjz9Ms6LdOv+yTVhwWoG/EmiDNFA5UxJfKu0oJRi9KC
YxhH0bTWeoqmDDl4DwPVnkwiubl6AdxzHAQaOBJZWbAj+aa4+6riPPbue2B22iBr
mBnC/E5RcP6KAQBNaFflgy0+z2uyvEhATHp7cjP0uUXgH6xRiBqtyW3YM3xOFPKO
a5E+Xu6Est417xSbUQczuss5eAHCL2R8e1/QGzrrrYxliSLBPuseiA+lXgxU55h/
rS9eoIykW7jrktPQFHsHXG1Q6i7tEQ==
=jXQQ
-----END PGP SIGNATURE-----

--Q8shD+rdCTehZxor--
