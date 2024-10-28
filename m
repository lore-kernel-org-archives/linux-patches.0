Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC51DD0F3;
	Mon, 28 Oct 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125112; cv=none; b=GDrl82r9G4v/d7Y2orw2K4uyR+tS1bGBtz4Zo8qGhw8+jZmUGN4nUJVH4nFzuCb3afwRpCk9OebCfvDUcbHgnkY5JO817AmijetWKtRFsMbGMTO6ELt5wWkb6BTLtrF8tmV0gqjov+QpqzoLvHUe3CjX6Ez6i5qbIKcV4mTJq+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125112; c=relaxed/simple;
	bh=Tr2xNtlX2gKzK3Zs10xZMhPKhiBsPJrJ0Fzek6YeBkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0yoNva1Wwi9tzY6dgVK+MpMqMYW5qTan6lmCDXxZWWJSHafMlJWIrS09L+x0KLTA3w1kSIh3IrEGfF/wOqzj1Z0+Zk1qaBb0Weyia9Do1xdymWIhfU7QAtJuBH7ja3dkMYiBUdn9SDnl6s3gccScyJ2mOL5xLvK+J1rW4UeBfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1Gz+zYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1Gz+zYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10164C4CEC3;
	Mon, 28 Oct 2024 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730125111;
	bh=Tr2xNtlX2gKzK3Zs10xZMhPKhiBsPJrJ0Fzek6YeBkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q1Gz+zYlnQiW9s5e89G7rgG4IRK6yZM9+g68skZgyyGvk2cD5qaCfZFWxv606HgOS
	 3tmTgHLmp7KLhQXy7e6aBd+B1rmyG6vvTpf3Q8fiwQ5fS0vC2bfid5BnooNT+Bnmym
	 K0yYIWaoUWt4V32GFxmgsFt7b/fVfeJrsrETMScq+iJC1UkeWPp8ZiUWj2I5seGZLV
	 20XmjwW1L9/2kvdtiF+lTxarTe0xijZj3JGFSZlSEBvWN4BcGt2MOZeCmcCHpyCv6k
	 xU58Ysusd0KjocMxHCMGrzALJYfV9AAFLPg9RGooREOVCzhTvkcb54l+RV7p70xtTm
	 Cs7rpXYVG++jg==
Date: Mon, 28 Oct 2024 14:18:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
Message-ID: <630be116-e446-4e41-856e-45b069bb619c@sirena.org.uk>
References: <20241028062306.649733554@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eiI3X02tmKrbIgIh"
Content-Disposition: inline
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--eiI3X02tmKrbIgIh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2024 at 07:23:00AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eiI3X02tmKrbIgIh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcfnTAACgkQJNaLcl1U
h9BvKAgAhOCC/T92CT1HJq8KCkUtZ5vn1xdAmJGmE+F+r+jwTvsTLLLTCBQleXMC
RXE5c4BhnuaPjh1LfKEINnT3GAMvAunEPj29PQdo7RvUSY7lay07GVSCuz5AhSQJ
C4JiMYUtAK6xxfN8fdg4Yp+wzZbXBcM6q1qv77cJ/TvOFahrTUcfld0pUa8vFElA
jZ7iB2S0i4ZQPBb+K+tX9HaAim7pSs5xWOT2kMBbC5s8fH1XyhPeW9tVeuP2zqgI
4sVaWnqmpPZ1iI5NAnPYAl6nI8MEtEwHNzM0EV/ulWgnUVyJLWk1qHZkKJvdl5I6
Xll+PBxChejoSlxX7JeJE4SHbNovWQ==
=wnbc
-----END PGP SIGNATURE-----

--eiI3X02tmKrbIgIh--
