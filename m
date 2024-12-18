Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6301990C8;
	Wed, 18 Dec 2024 12:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734525480; cv=none; b=E0oHmGmt/vvCn1kD69PvEf+7mP0HxKSsoFL4gDsVMLf5hyBcXSf1VDTGLUUpFjDKnghKgnjAif++NzcKQllQi0g8k4w8IFsls4u4Ywl9zdQVpoy2CCYRExlJVVyeue0Vm7YwNO4BFpuJhYOOju7jwqMGbnS6GYktFfrdhsWkI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734525480; c=relaxed/simple;
	bh=txRDXM+sUzARNM6l/EDPS3KiB/2rU21StVZG2M1qE1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oG0Is4wXonZibFt14a65ecgv+SfM8ZfC7efTkdhaWxme7mJgadOM78Y5ouSbkp06BXW2E26oQASOd5YUehSKpxZjmpT0BbevBDuHi4+t5CA02m4PfKBUSaWxnYoHhLoUB4GYUpx+BVd67s8xNdeosDx9ymt1IY/GKJpMAgTLaJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW8usd8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW8usd8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE89FC4CECE;
	Wed, 18 Dec 2024 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734525479;
	bh=txRDXM+sUzARNM6l/EDPS3KiB/2rU21StVZG2M1qE1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VW8usd8qF3RVpez/sLxF+GHtecs+vjGG07p3fx6KfudV1nkdogmodryyxeat+cgCP
	 M9rWvkWoZIiUHafa96tnQBRJYmH4RQ/R13L8+KMrwwSNDSZUrYGOO48EEX5c37y8qs
	 Klh3x7/Qwhl+DYtv610ISGHxjMP3lFurjcFQ/n8Yah9HvMPKfWSEdgdTOGAarhHtLR
	 Z4PJmc6qvp/GO5z16KD5LjSQQ/M/knEs0tsNdxZfa8n9NyECRAHlAd7KeyHZlVAqGn
	 /g6F+5ylR0uqAOtKFOWl5pOAd2OWcdqE78lG3vmRvbRZucPXIe93Chi4B8GXkDU/sJ
	 wsRv6Xhb6sX6w==
Date: Wed, 18 Dec 2024 12:37:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
Message-ID: <a44a42f1-73f6-4826-98ac-276c054175b1@sirena.org.uk>
References: <20241217170533.329523616@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p7Np4/OvRmuBY6j0"
Content-Disposition: inline
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
X-Cookie: The heart is wiser than the intellect.


--p7Np4/OvRmuBY6j0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 06:06:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--p7Np4/OvRmuBY6j0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdiwiAACgkQJNaLcl1U
h9D/Vgf3cG9K+NdNCUwLEKl+iecbpPtM3kdd6srFNQgYWGB2p/9SSv+PnPNOesvO
sgM+NUK1DN+r8MoHm6zSjmK6Hzim8JMYeEV/G3dF2oU6tan2QI+8/jASzIupgf+P
AIZNvgoW4rY3S7PveCFlRRz5yWpREm71dw/ng/zzMl+v8xNxhI+N/GFYZonWUg4H
LdEEyUuxLL3tJi69FZuJPfg4VDopb+jwYVOinpWi9r9rtr1yl0EtNL8uhzoQbID1
si9jX2+yNFzxYNqjEKvESb590lsppGjywuiD6/uHJlhoO0GdskvKK5sqz1kkC5EI
uP8jXUY2051wBoxEymXMJ99HSwMy
=+Ybm
-----END PGP SIGNATURE-----

--p7Np4/OvRmuBY6j0--
