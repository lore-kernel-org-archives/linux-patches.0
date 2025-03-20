Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C36679C4;
	Thu, 20 Mar 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742470610; cv=none; b=KGIxhg4QZbmMa/iOoIyZbXoaDpEp9MJS0B5mhXySZLMFKCrwmZDwYHluCprvZNQXrDCzbr+Rfry4LctkuP5hgK/uRJhj7wUIMxX8gMczJxoDu8rbeVztGRVszj1ss86NGC9DNiMu6y8PkGzntjpFZXOHD8YPFpmj9xAF7C2UiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742470610; c=relaxed/simple;
	bh=jE6BMEtz+IHu9/rN0hajCAUbibD+BJrsVy9bjL4xA6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfYzvnZtBMUnNksDXSdPvl+rZiAAKsKJEzOWkcIjyNQxLEMyHOaixwBPy11QKvL54nsjz/CXFZ4zPmqJxSdSzOB+WK07fInNHnpsVZb82GeYMQ+B/SLvIODQ+AAeX03ZpcFiAgPW9xXk7S0IvtP3TTDYUKHLlXHp+fuWGQQZX8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpCi9FZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpCi9FZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F39C4CEDD;
	Thu, 20 Mar 2025 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742470610;
	bh=jE6BMEtz+IHu9/rN0hajCAUbibD+BJrsVy9bjL4xA6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpCi9FZB54yg+WMpxEf7+hfbL3KU4sBm97uqTU+hw4h9PMlU6i1JkBgH4Ppc+e2iA
	 Hi37vR22eKqIuFWt5WxgwG8+XyrqmgYEl153V3eEuNRB/FKVnqMNRNx5yMEPSp+Ktt
	 t18K57JVcvIrgDbqV8zqQj3KtxYij7zURChCumyzyupdjfWizKH9zBvKAD8vOb1Wyc
	 MfhDVWHgTbzatD3sdxStTkM157kI4b5zcpRSxY/AjfxHO5ARCY8CcjNsvFMWAXInqh
	 cGfWuxs7+Onq6fm4w2Jb5c/TAuX9UgDc81hp3Kq3ZJCJ1ZCss22UxllEMyFA3izH5M
	 sAjLpgv4y7knQ==
Date: Thu, 20 Mar 2025 11:36:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Message-ID: <4ed90e42-c305-4043-b4d7-f6a977610f2a@sirena.org.uk>
References: <20250319143019.983527953@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IijNCSkxrpRPU7on"
Content-Disposition: inline
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
X-Cookie: Do not fold, spindle or mutilate.


--IijNCSkxrpRPU7on
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2025 at 07:29:31AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--IijNCSkxrpRPU7on
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfb/csACgkQJNaLcl1U
h9Ak8wf/Y/Zj5MEBO5fvFdK42R8CRNmfeGD33+H460cEHRMN1f+FU1erig1i/MD0
ydclhTanDL1qUz28Tw9IJDBvXeQxv5Tfxw2YqNIZ/UeJaZfRKQHbcclaIkTYRz0r
AOgeXpVvAm7/QZQuf265bLPPKp/E+HJYLI8E3ehCfC48YFePDN4GOIZ7RH9b8wIB
zw7os4EHNSYqHWu0h1GPlbH1QCnlF6N2RleSShsT2Zg6LR2is/sLLqdZSr72cdaK
vcoBmpAupmPc8KMT+7+k3w9nLD6hjjNa84tOQe7k2z+JX/V0pvrVyVmwP8Rga0Kq
ZX/C7WqNfLUvvhCvOX5gFRMRSopPJA==
=QhBQ
-----END PGP SIGNATURE-----

--IijNCSkxrpRPU7on--
