Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B503C3D75C9;
	Tue, 21 Apr 2026 13:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779152; cv=none; b=tEWVaddsGOPrL3c+JHtmkF6mx44bIVeizucOwnAPrNUkN+aywFWjcYfIlWMe7FVOsqLLvstPofhaA3z0NNOb0fabRBrPZ3RW+CjwJz8d10BlmSKwbGVK/CmWWz2irRNjYp9zoM+LHH4+Y0j6H2kvDVm2ZrGfqDWQdUKfpwkttTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779152; c=relaxed/simple;
	bh=uzTDJQorJr4cAMNvg+wAtiFxbfmYeLzX118J09k+FbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSmEIIV/3fg17gNxzviwOfTLqqkbWWUx2B2OqIyf20YdZ83ond3GUUTe4vBdUoJ1dqpNTSFl1Ml/67Kep5QfA8T5TqX80ZrtjxDBAXAqZ0KUi/YlgXEK0FOewuXzRcz0hmV44ho6h58Kf2TqTYBepKU59dE+ryENOez9aqCTrok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=squ5tW+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="squ5tW+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA61C2BCB0;
	Tue, 21 Apr 2026 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776779152;
	bh=uzTDJQorJr4cAMNvg+wAtiFxbfmYeLzX118J09k+FbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=squ5tW+9iVUCxOaxM/Irgm3n1hZzOgMNVr2XwdRW94XK6qKyz/5fiN3YclGDoe8Fa
	 EYStinKTFLI1PQ2l9JBBwzk7P3SA7igZbUBsXWGyVB4VvVfSE1k/E7NwGwdqC02P5L
	 9KwwwKxW0ScWTBLeVdHRgRJub11L9OiI/B/ImZUBo45e57Lwm4DDt1EEoQA3jrMF9r
	 3I2Dzb2+r89CtjK6PQHSL8WvWg73vELssU0ay2npUS4SL7VoYf95Au7YlGDHm+DhuG
	 SefVAvxSZhBUlaTrZiHe/x0jJgTZEAomrl2XaLAUDpyXK12eIKZfSujmv1tV/syxGC
	 hA0oV2CJ1YP5w==
Date: Tue, 21 Apr 2026 14:45:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Message-ID: <494799f0-be34-4e9c-a85c-b52d35736312@sirena.org.uk>
References: <20260420153934.013228280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5zhTPF6VYEHRCxzw"
Content-Disposition: inline
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
X-Cookie: Jenkinson's Law:


--5zhTPF6VYEHRCxzw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 20, 2026 at 05:39:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--5zhTPF6VYEHRCxzw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnnf4kACgkQJNaLcl1U
h9AG3Qf/eQtPQcy3mGt60yNZDUHidUPg4ypAHGS2NrgZwGPcFtC8/Ev51/TvRCuQ
MWJxPaPJIINRMyTOJovAvhnaM1KQx8uBDjgdqg742336xJGPuL7vYKGrxQjIti6z
N211ocyoHbRi9SLpa5ClPDsuTsrrUimnMTBhBdAf7x00n3k8tRd3NYHt35rJPUbd
8FJX1yp7IHXm3ke+sxiB2vyYRh75v7jue2aKL40aSUGjaJG6bwVM1O5zHEJEmf7k
XP/iVxFtgvVLzljndQ5FoYnni6NybhIvdPBUnOF0Hxf5tMLPDwuez3Xt1PdM2gV5
nA8+g+Jt3axeg6ZSwdOf048GSJhkBg==
=2Ke6
-----END PGP SIGNATURE-----

--5zhTPF6VYEHRCxzw--
