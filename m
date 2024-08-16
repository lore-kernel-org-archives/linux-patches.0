Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756CA1BC09E;
	Fri, 16 Aug 2024 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723817851; cv=none; b=hYZTqrUU4VCBrem3P22fn4x524klFBWdQ2L+moRwxBsb42YksxSxHdKvMT21GlOWnfBsk9pNPjsaedBE3HH6Sdrp5UBcPN6rhzMJsyMGdW+Hpl/RFQ6O1+NsuJ0HsAGu2QpCFtDUSX5Rp9xr6NIxySey9iAu4T2bM3twrUoW/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723817851; c=relaxed/simple;
	bh=l6a/3nMx63a4IQhEgNbIhpMr2Y6lm5De2psJ4sPW/4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRhr7zd99wcJVqFb1k+4KhiFKo3IaDMxFAAjFQ0VQ1CFXddgzg6VCdw8iUXwfuacSZzDN4FP3mARLNDyksInQU9MSb+XygxVbr8mUrtHHDg36RNOBKrO7FkwQqHYNv88iy6wRIUNTAJ+BfqK7aWSIprkPZMoG/wulpkXU8VV/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPHvbC34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPHvbC34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619AFC4AF09;
	Fri, 16 Aug 2024 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723817850;
	bh=l6a/3nMx63a4IQhEgNbIhpMr2Y6lm5De2psJ4sPW/4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPHvbC34jT/QOe09ZXaM7l3RcxL5uqab1A4XS3sDOEo9CQFxnv58r3YZXUi0C3ZY0
	 38gA0WDDRb3suruepKMc2dqkTbSfAwbpvjZY5QxUeS/Sq3DeHGznko+F6Mitdd2M1k
	 Av67kKIMPjbw5+Vw98c2K0VOfyBgbhjf2rm6um7kLOH65IYRmdAm2KS+6Ac3N5qnZR
	 Vhsde/OcQvvOWQJTTjCPuOZ4JlA3qJUnzeQbmZwSsOx782nKrZ0OSNx7pcO7O8vcZ/
	 SiyS8nTFB9ZtoPhuEK02hQw39eez28iXiswCCSDzvkQiG+6WTOBdbPQzUzJvWiXRg9
	 cyuN0kB/gsggQ==
Date: Fri, 16 Aug 2024 15:17:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
Message-ID: <d48bb7d2-8f56-4f62-914d-f7710ba2e850@sirena.org.uk>
References: <20240816101524.478149768@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hd/2dn2JQk3oIhq6"
Content-Disposition: inline
In-Reply-To: <20240816101524.478149768@linuxfoundation.org>
X-Cookie: A Smith & Wesson beats four aces.


--hd/2dn2JQk3oIhq6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2024 at 12:22:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--hd/2dn2JQk3oIhq6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma/X3MACgkQJNaLcl1U
h9B6lQf/d0kRdY33zvTAQvkht5afwyuoCaQB5tJIsmSYuSGtJ6dLeDcHT7BEF2o/
afxgCkCdqnk6LN5hh40IMYzvy3tU9UvXikFPCo3nkvuan+fJM76ao8V7yTn9nAnl
Mv0BWLrfZbeXu6ESve2aa/aFQfl09INX7jtLQxnfmlAtStADMUzrHOgZSPO5QlhP
VB5xgdrUUA3OT/+8KDTwczW+34L6weAk0k+LvUGvNUvyUL59KxynQY7kHhwd1CJj
JWMeGmmTq3hsNGCuNho9MNjJEw/P+j/AhDQouHK2VUrNyEAH5Ts1wBhASyClZaI4
yrSBjetVlEVhoTzXxcxtnN+LkSfdnw==
=Ofoe
-----END PGP SIGNATURE-----

--hd/2dn2JQk3oIhq6--
