Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B039A7FA;
	Thu,  5 Feb 2026 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292303; cv=none; b=kpMllL/lYS0E2haBwp8ozVz6BNnzFBEOIxj783wewGBZT3YPCubMkWQ8yQQRZ/yZWohPaJq06KVHQ0mFNaa1svbN7aME//pPG/XW6gToSavwP3TqPT/TENFkuwid+2flt9hyXpigIOvGoQaK/fS/W6xi++UIZbsgg52G2yyJlqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292303; c=relaxed/simple;
	bh=sTbAH1u0SZ3hPhQqfI0S8uvttezG93HZZxoFeqFsqiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXG3+ybu6kPkRNhg9KsURPX6fQMg3NrjUHIaQzKQIZW0rtqwFEuSKWrXVxU+yAFS5zr52+Hc6h2WwIb5f/IDIJPcn4OYYI1kmOurh3gYZXQFu8n3S4WBZ6BZl76FkjZdX/3ZgsKRL/E/Ak4+wjN/SDlrSJM5tO7MgNSGQAF4tcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvPNKQXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvPNKQXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52D2C4CEF7;
	Thu,  5 Feb 2026 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292303;
	bh=sTbAH1u0SZ3hPhQqfI0S8uvttezG93HZZxoFeqFsqiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvPNKQXDpritjGwWXwRxHqqwmG2sO1twQnNEj5jrMwunHkmHBYNiMMzfYtsncWvHp
	 7jXRiMHSg0GGGjvqz6dKQduEz3qP6Eez2ZFfErHZ1Iy1rjAK8IOSVHPsWRFl0OvpMt
	 j17R9LISW9js+LnTI+Ea79iBG1ZKkuCoZGiHWGs3ZvPKar3HQw8ocphZspY3GVtF0J
	 7UqnmsYl2r661bvLCAJtPg7kI88RNr+FqcHQZcPhXesaLWywSLMIZp+gb35ME32r4g
	 CERJD2w1zH2eZo6nVoFZZ4qXvtgdfPE+jeyKWOMQOi6UtFokoHltmakTtCHCI0hqug
	 68yzR29GwRfzQ==
Date: Thu, 5 Feb 2026 11:51:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/206] 5.15.199-rc1 review
Message-ID: <0685410b-8ed6-4a77-97db-e2160004dbb5@sirena.org.uk>
References: <20260204143858.193781818@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="X4LZtQ1rV2gPflpZ"
Content-Disposition: inline
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--X4LZtQ1rV2gPflpZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 04, 2026 at 03:37:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--X4LZtQ1rV2gPflpZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmEhEgACgkQJNaLcl1U
h9DSUQf/YxXCVHDh3B41xCMtXiOPRx6qASfd2cgW3vg7AijbMb/2yBc+zq1b/Vou
zv8iZus+lEXZ8ihiBvlWg3eJuluiKgfYCtqmvzwY+eA/fK7ybwTqLEiJ+I23snfR
4R/tqDdLyvfLq1NdU0TyeSI4ttAPsFSUpvkPWfL+njtfBgnvspLEwjuTFmiV6IlC
pbArqjfA1Js+tW6olEZZJ/thnkGtxjcJN3S7Vjq0CDDECmIihboMnrC+2r4dgKYY
h0m9ip8bjlgmNZTDPzfg8hQ1hHqejo6+y2UOo0whEUGb0EzngKJMa40Z8xa0U1NE
un2O1EzGkipfcMcJS/CuB20tp6EnPA==
=uaz5
-----END PGP SIGNATURE-----

--X4LZtQ1rV2gPflpZ--
