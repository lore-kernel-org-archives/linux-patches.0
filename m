Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C8239DBE5;
	Tue,  5 May 2026 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982710; cv=none; b=MYcOMJsq0ysi2nNL0dtDwfDhrqq1QRmF/BIAfo0wU3ggUgT0PYZIN7Gtxq5vfXid98gTeZcYGSGLx8U5m5hHQk/t9O4upkgTnDCENMTMGI+zrxt+05fPIewoQ7AMKza4AGYs3/me6inKL68rRGuGbceiUVd/on/rLZ8vxPeZ4iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982710; c=relaxed/simple;
	bh=h7BrOhDjQ/zS4N1iZks78+RSx6zGe19IBUClYJBA00E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyYz9hfl3OzUI6ItKSZCtmz2hnnVQNZoxQ4yJyjAuXli5Jiggn2cqA2s2jvTGDPghtU+KDL3bx8GxWgxRPl5jL0cIGbAPDQ+4e5bfxa+jmipF2FAbOd3u+9fwMcv+Ae7XRb/2vza7c4JA4+Ea+DbhfkfVNtvAd4Dln4AFLp8fJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tpntxd8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tpntxd8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8813C2BCB4;
	Tue,  5 May 2026 12:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777982709;
	bh=h7BrOhDjQ/zS4N1iZks78+RSx6zGe19IBUClYJBA00E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tpntxd8X+CSI3kRjf7zAVdc4/Yy0yMwg2vZs+tNt9QmZBBZcFdJ41FXlE54gYJcWa
	 u0wXPJSmR3ubDPQExX/PS/wSvDcZPBKEXQVIuPTttvhkXI4Awc2ISWDPYww2ZY4M8f
	 q7Bq0DgBtAa+JNVK8ovyJ9EE7WUhqFnmCHdyjRUYXj9/mr/vXnPtV2tliS6fi1eCmy
	 fVZ69i/9b3HkEG0EVmIy4t1WHyJQ8MihiXhaEyyz5BAQABKcNzPyKtkRi7YTaEZQvW
	 nTqeC1peZwP94KFVMDGY+E39TicjYVoU2rp7kocLcjQ50Ov3L7bObR8HCwj5miu/ye
	 24mzdvBHY/exQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id A07BC1AC5871; Tue, 05 May 2026 13:05:07 +0100 (BST)
Date: Tue, 5 May 2026 21:05:07 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
Message-ID: <afnc85u7liaWaB_H@sirena.co.uk>
References: <20260504135142.929052779@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S/2yRsCELJ6FRsKX"
Content-Disposition: inline
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
X-Cookie: Alex Haley was adopted!


--S/2yRsCELJ6FRsKX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 04, 2026 at 03:49:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--S/2yRsCELJ6FRsKX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmn53PIACgkQJNaLcl1U
h9C7Wgf/Zxh+IJq7hZpSMd2zKFMLukTb6ptqjWuZOXzekkkFrmbA+fodw1fpN28e
fdI6rieSniUjz87zSZsw1OrLXWQWSng8qFZ7Cgs1Vt8R866AatagtVf5mhBAOqc1
1yikLNwtd+hrAGkkql9WiLcvmfDzLSWdzxiTgcdQhoggwYGSIKwmfaL4MUi2ujYT
BFv0D3udYx79XUgfGZSVHc/Y57hqYEsrFL/lkCStoPoCkKxjNMC3oJMzkA10800A
PGTz8oIJwIO1VsF4rTyBRCMQW9Qp8Mhp36cVA9OOiRdsUwjeUBB2KuXJkm8VuLtL
x0fF0FpG7hF3c5c7H1AGhI4yBMZNmQ==
=mdMa
-----END PGP SIGNATURE-----

--S/2yRsCELJ6FRsKX--
