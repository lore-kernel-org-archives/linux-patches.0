Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD2213E89;
	Thu, 27 Mar 2025 11:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743075771; cv=none; b=mCCkx5jCjM8+6drjnPbKIT41iryIEGWq6SpJBz1wJP1ZLx7D7vz4nikI+eUz0LVi1n+ElP60elBkkbWvTJ7CuIjwRod3kWah9PO3NQh1apXhPShsckSc3mlH/LBspdUn4QGfRx1zqAV1Ps7SqRB5COH32Xal9siorsqzzKyNmR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743075771; c=relaxed/simple;
	bh=RakhnoMPABa71lhIIUj0KdaIOqRz0wWIi87CD/jZimE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWijWTswfxJvS6Lg3Kdc/FehHo3Xqc3d93n/Uqx8ge0yJeaI+6DC63fFEDHBgNPCPH6pj7U8KoGEhXFwlC2db4yogSr7MiaEJPp4J7shnP1zpbzdbVYs3bx9y4tugKabxVOafd55qDCUn+rDDaLkvwjVzy6pOqNY4P3D2QzHYus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8Edver1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8Edver1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA75DC4CEDD;
	Thu, 27 Mar 2025 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743075771;
	bh=RakhnoMPABa71lhIIUj0KdaIOqRz0wWIi87CD/jZimE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8Edver1J53rwV8Gnsazt/HAq4QHVQNNuTfr5oBKS2Lsm71dTIAlhmYvGNCJT/Zq2
	 6TR3hCSlLAgzglh4fUm1UNTxRQfcMgPYWMVGb5aKbHTmgqTrkm7OBT2Q1eZyP938wn
	 Js47VJMhjhBGvgxP5JjTCWRIj6DGhRq/UvA/vJ5F0rnfIZ1dzcHJP144JPzMn5qEtm
	 KwomvJqyR1NewoBr8rNtUdxjrcIzbYTWZSMjeN/RAmBtKDHkJ8dJ2jnGaHd5nqzkak
	 dshX7GwGuddxug4YtAN/j9bLAaJYBZvHMdCfX96hDcxjSriw7xdP8eKWbVfFzjyKhi
	 NG749msum9RjA==
Date: Thu, 27 Mar 2025 11:42:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
Message-ID: <18c620b1-b04f-473c-a331-748ecc433ccb@sirena.org.uk>
References: <20250326154546.724728617@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FCPf0F7oU+UyRez1"
Content-Disposition: inline
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
X-Cookie: Multics is security spelled sideways.


--FCPf0F7oU+UyRez1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 26, 2025 at 11:46:02AM -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FCPf0F7oU+UyRez1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmflObQACgkQJNaLcl1U
h9A0JQf+LZmfizWcsUTIoz3GihyUn/pi5rMcyZ/k7PaWvBVxZcmhxwerjWuXBNK2
xi5N1/O69v6dDZP9IV1Vw6Zi+hkBSZXQPTWqbA3QQNVuhZOjZqILRMqYiiSTX6iz
0qfvl021HE1VMbMQtQZeajhUj6Fp0ItvLfp5gwZt+Vn2IbTkW0cOvlzfoLLIOL/e
IbtICMF2GaLUixwsFkoNx9gybW+DCaDpEYEU7GmM2ODCbEopQP/TDUKAcBWruCnn
fkdN9AiMJ4LjQosPID1lEl4Yw6t3LBkaspQc7/poFY2sMGIJ/J54XVbdlWG7JJ+S
diUw1byWItYo0JN1HRgLMnQBb/UHaQ==
=/kxc
-----END PGP SIGNATURE-----

--FCPf0F7oU+UyRez1--
