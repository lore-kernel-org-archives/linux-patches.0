Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD49381EB4;
	Sun,  9 Aug 2026 11:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786276277; cv=none; b=AWBwshS+W8d2dRdoSXexNlbteW4K2QA2C6JzhBN86WJz5Wc4G2tbV15hVYRSlzR8pQMXTGSS/DUn0ZJa0t4zTxLuGo6BFEAO5SyEt0pZ13lNBTxgmpIQzR43QYZUXEU/69HYuCc9ZpJMG27tOy4qeplLvZXBvnyQGP5lnrVEYK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786276277; c=relaxed/simple;
	bh=vgOEMxGWDiCw9nl/6ASTc7nNnCDUCjGvZ8Uw0m2fimI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMVxJsTEOVix5ZA9RMXWMVhlEMeZJHCTZhpcRv7OatRmoyFmHLsd+ZAPmzLJxEIqVZjGDANO/3+7ICfpcu15e08PesNPU351UmXeSoPmpiuS+Mi4QdSJSDXxfohhpSAS8uzP0lW5jTVlzqrnOR2MtO6Bqh5tWpdx9H3x70zGNeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N08wqo6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N08wqo6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D1F1F000E9;
	Sun,  9 Aug 2026 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786276276;
	bh=U5yTIIUpGq+88y1qiJoFNb6bo9jKftl0yJe3qpI/2l0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N08wqo6z6soJtVsPjiPifkjReUUHvTPRgYq771Cphn48AdL/P7W/rZe10t/Ss+W3E
	 2w+voVlXvvDRhZ2Xgn4UaBK8Qsg+Xt3u8NkJEdn+cOqa/cmfWmplFnBPch8CHInyKe
	 mNDtS71Mx6V0Db62gkdfiPT2PoI0VHwMqF6KM4Znjqi+8qdCwxQ/6LdB5NMxFy74hf
	 hBYf7QZF8rvx5x0KXUz892yNNX01xQ7/YOVNtuDCC4dRXSQNwGq2ZV+s3sFLYv83LR
	 evnrQhAAEghxAwiwADB/7CzB+QxAor3XcLDKHowzGJFhG2IZAWTOsAza1ii0XqeY8G
	 49eYauP2oXZYA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 414C51AC56E2; Sun, 09 Aug 2026 12:51:12 +0100 (BST)
Date: Sun, 9 Aug 2026 12:51:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Message-ID: <anhpsOlwB87dmM2K@sirena.co.uk>
References: <20260807143428.008222056@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z20pwzfp6zkGxgMn"
Content-Disposition: inline
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--z20pwzfp6zkGxgMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 07, 2026 at 04:33:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--z20pwzfp6zkGxgMn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp4aa0ACgkQJNaLcl1U
h9BaPQf/bZvh2hSOE42LEsZ+UcK64poIcb0gXKGBiNbT2RrWpgxpUSo6FWwgHpas
1fTP5Dcgbx0wUcTJgkoOOn5dOIGaFISJzD3nktFUKAHif2hVUUi8DJQQ22+FGtzZ
S7CLBAbSydMC20qzAcoQUsDCXuQBdvpwCEK5uxqqcrVpqeKEDOTE/NP0SQq4ku68
62G+MQJJGuKl9a910HzEH36PEUOROQP0VmQleYx1rXh86sjhWj2jItEzyA15Lzdb
O9GNZiC+aaAVsh4C3usU5W5RY6S9oIYjVNHFSxH+HgmK2pTaBrSlqDQcL6+qHjRF
V/G95U7HkmamAgtF7uZTpyTNuBwcmg==
=kumX
-----END PGP SIGNATURE-----

--z20pwzfp6zkGxgMn--
