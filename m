Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DF2252911;
	Thu,  8 May 2025 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746714320; cv=none; b=Na34ZAKy13y9JgsXteWjbcvfTy5urabAjSKWEKbsoYmmV0h4UdbLB8yHUbB4QFYqoaj0l+pTlClIazeru7yIjuKRXkjh+MP5BNGK0zWqtxKWv6Eabu+zR7hEPdTp5lposk/o2XxqVWO2BS8rUedbXvvKRUeSOehMV7cV0/cEacs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746714320; c=relaxed/simple;
	bh=Xzp/Lb3zn4uFl/Tx6OrlUItm2XLz5MFsHY/bpobYqio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IciJsC53HCA77ozdoObAR9bACZQFPGV17UuMrBKzVE0EKDOcpRgTjAHJyt5r0Wu4gNAQwkyYDhQHCyB4nSIOQO0bmiBgoktPRU3MvWOxy8KkPKJkchc3JOJIijyGQtRqLB7LYnM0Hc5Bz+EamNcWyVkFhf0yEul6/V44Kx8Py6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPWCz0Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPWCz0Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5E2C4CEE7;
	Thu,  8 May 2025 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746714319;
	bh=Xzp/Lb3zn4uFl/Tx6OrlUItm2XLz5MFsHY/bpobYqio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dPWCz0LuQxcUKq/yXSZLd7xVDSrtrJbli+U8NUxJT5Fgvk4mEfvIB/xAoa+zZq9y7
	 nBz7LoSNDsG0/HMkH+NQYOkxQBJuG8GCorFlprZdfc/nDHtFrihsYpBLpmPm8nT1bk
	 YqEvzSbvplC8SVxxSAGMkNzJQB/kBFTBIL5XjGVrs/ZkBuYVZVCLe+Z7TX9Qkl1eb4
	 csqWIv6kNdjveUemGrojv8Z+1RtvrAGhMWElxUjHy0N4T6CD4JfKj+hmUszT75Kv7C
	 ZggXG+GhwDn5EqYhhmM7dVOqjBnC0cXfEt4KVZndBkl7Viawak3JhdUA4yV+vZKHZR
	 6GQYNXLtocjrA==
Date: Thu, 8 May 2025 23:25:16 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
Message-ID: <aBy-zIuFrc41Y_SC@finisterre.sirena.org.uk>
References: <20250507183820.781599563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iHo7JpHm56HcqSBP"
Content-Disposition: inline
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
X-Cookie: Well begun is half done.


--iHo7JpHm56HcqSBP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025 at 08:38:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--iHo7JpHm56HcqSBP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgcvssACgkQJNaLcl1U
h9Dsmwf/eogupOBz6n/1p7XdjokSsGNshp8+WJbSRnXYDn21ZQcMuNQrtEzTkBBJ
UdLj+EK4YkxjZ85fJw8xwsIfvCGPzg45XD2ZIAMoQ3lIpzh9UAbOUOaU3CfEepd6
2TiGsaApVyZX7ckLBT38ICyPxvp+KFrAoG2PqkMehcusdGOdtaVnr91ayrpL/f4n
K0I3EjPCuLxfzd/X8u5h28E4jZEoUrwWIGXLWKjlgSjVEEnnbxY3czfCsf8EA0HZ
WEXJkI2zPlQhc6mrE8WvETT9dKJeQ4DrQEkeLPY1KQ+rxpux8EoGsiMu61EN0rVM
hq2RhBRSvoIJnW05jfVLq86lRZiVdA==
=KK4o
-----END PGP SIGNATURE-----

--iHo7JpHm56HcqSBP--
