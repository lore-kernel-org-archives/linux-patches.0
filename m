Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00D2141C0;
	Fri, 15 Nov 2024 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706008; cv=none; b=KyX2WROkrZbN0Zc6hN+KP806UsOlfosyVpFo4EU5AS5wmQZ5iXj7ahqkOF9paM1Z7lxcCw7fek9fimcPXVfZs5Z7IVtNTJor6s9gogQ9TA/mH7N457lCgC60+keOxVvm5jjOLzJOZE4i7R2LEGpwY7xV+YP8wzHC/APC53OdsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706008; c=relaxed/simple;
	bh=w5X4FSnROO1lkTzvJYh0fwF0Y3KdPPXkVsBsQQuztbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9EXnezBYJeKbiLqRUE7bo2i83u1gZ7o9yjAEeeJ0Gk8MbRQUgzebmKkaZMqdifnCx0gDw5Ds3UKMVQVcIvqlW4Nq0b0OFZAbs5iik3N9SLaxFYOb68HhF+PxlAp2gnm8OlNDRb87Qfqi5RNPgkPtVaWemzS2MsPrlyp1+CdQ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qbSYxLuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbSYxLuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92250C4CED4;
	Fri, 15 Nov 2024 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731706008;
	bh=w5X4FSnROO1lkTzvJYh0fwF0Y3KdPPXkVsBsQQuztbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qbSYxLuEs1dg1wjdZwiPZwtIHCsA4ZNkLQcTly6BTgbS/ibAlmC8dCyE2t+eaWQUn
	 BmnAFMzhrE83R0ChXvF+AYIQ+Qbgko4jnW1W9uF0FEZ8mlEApphJg/JZ0gg4lIv+V9
	 2vxNNgofnU1oPSy1lr1Byt5oEmNGGQ0WwsvDN/mG/MRM4NAMiP8jdD3ZOveyVyYO9+
	 HdQ2DTtUeYqi9JQr11+xZqWf+VibUaW7r58DbBsp4TzVtHhks2VbBKz9bqBv7WN7Y3
	 brK3qkoR2vaVUzi1ARL3lYxufpalJ6Xs4AioUGBXTD/jKAF1mPaHV66xvouiK/N2kB
	 Yq0rwFSyuWl6Q==
Date: Fri, 15 Nov 2024 21:26:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
Message-ID: <Zze8lY3vbKpOIKSH@finisterre.sirena.org.uk>
References: <20241115063722.599985562@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oUO6ULBSqVOHRjqv"
Content-Disposition: inline
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--oUO6ULBSqVOHRjqv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2024 at 07:38:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--oUO6ULBSqVOHRjqv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc3vJQACgkQJNaLcl1U
h9B7mgf/W7RMwii7/hhRrIef30SlKlmvEK8essIZJCcluAhV2xAW+wcIfJnQh6i3
GbXm1+wlSerAmAwG5beOTCSe0HWxsqDQBM4JpSCidiModpswbgvjNGs5a8knVcPr
yGXdmwmP6BQSz0IRZ9ll1JoMv6rcQUOull6FlRY3rwDKQXDDXnMHtR+0UeUh24hQ
q/YgJFCFujIlCx/Ak0aW4SEqCcVSKAchT7YC5/y3F6NImxSPpr2WNGoMCCU3pgVu
GtNHsPyXkfwGLM/dGBsargFHUHItTn4t2W+llsupvvKOeFJ3F+iSOrIGcUKB9hPu
HTnvUS2MOPGuIMCogHXdOgKRUTK+GA==
=8oaI
-----END PGP SIGNATURE-----

--oUO6ULBSqVOHRjqv--
