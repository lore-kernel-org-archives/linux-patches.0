Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63926F066;
	Tue, 22 Oct 2024 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602042; cv=none; b=qQhiaV2geBVxIgEWwd9b7J8KsYNrMvtXtmi5wIKnWZYVJeBGm8ZdqIpvvq5t+jI373+cJFHvOZ67s+du8MbWKi1Wjqfu4lADQ1dag71LWL/uOOaVR/QFTQHPRK2PQvf87wKv7R0gC3CtMyaFdyt22vDvN5QRFISFzLFQoXwjQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602042; c=relaxed/simple;
	bh=cSdkSjb+LQw9JPvIfjMENz0bxB5APQ0+GFPJqXXHRPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3HeF/zspCWFOHbf+0/la+rQt2d1B08rCkNLMBTELgSIEXBOo21dRsa8q0Wx1d+h221hh9fe2OSLkdBL0CLUepWfz9owRXQLMk6QsjTDwNdemMxWp0pKHU79KYf82WoqRH1ctn8fcCY2M1Q6HBz6TLBHoXxC/6KJx98LOXFtJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnCWsjhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnCWsjhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C9DC4CEC7;
	Tue, 22 Oct 2024 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729602042;
	bh=cSdkSjb+LQw9JPvIfjMENz0bxB5APQ0+GFPJqXXHRPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bnCWsjhADgb8yopgg3j6QYKsKC0nca6GIrTep3rBX753IygsKe450Gfshes1BcEBS
	 fiIFNU7vu/MYZYBJNZpC1YLCHiLCh+vmNDG851X/goYj6GqIbHiTo/MJoOrSVGya2+
	 rn+w9vpi68uEcuU52OCRfcahGQBZTJoxCzsqk5BqtjfUVr5zY8YGhNRuaiCiCnmgQE
	 OthPuxEvY2u/d5AMTsrCN76sSXCMeebN3AOQG/KUMjRQEGE99JucReomXC/q7fPr3q
	 8trXkDay7220UEFhpb1+rxgz8jHxpdVctVEFaAE1rBowS23djB/LkY9+6U92O8SHdP
	 patJFVoyUJ8SQ==
Date: Tue, 22 Oct 2024 14:00:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/52] 5.10.228-rc1 review
Message-ID: <1f96b5e8-e1db-4672-89fc-9be36ebaa7e9@sirena.org.uk>
References: <20241021102241.624153108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r5fVu7GuxFspCQns"
Content-Disposition: inline
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
X-Cookie: Surprise due today.  Also the rent.


--r5fVu7GuxFspCQns
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2024 at 12:25:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.228 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--r5fVu7GuxFspCQns
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcXofMACgkQJNaLcl1U
h9AyDgf/RZIbyzMFSofAQzaHM4EfEWnk1mDAfQwP8Ma7k2i1ur+GzzIcxdm4yvSP
h7mlGL8XzbJiHV1EZz1ID3BIhetAJ2dx3p2LzONA9zrLHtXvYKq3oZDWlSd3BgWv
hFTgXRethmTfnV8ep6Ys6t8UG283LEfkT7srpXZfarBLvgQLcUI4albHeORwhM1W
UCfQS3RS6rCltCV5R9KGwGIZJPp1BnJAV/7IfXiqczQQh/RfjLJQZYjPg9E1SThq
WJbtjVky7Ak2gQ3jpmqCc1lzrWnKBa3IPWm6DtB02QRyjnT2HAJQexoakuWGqNwK
ZLqYMZ2VX2T0+5zcltGVIQsHv/t2KQ==
=3VtP
-----END PGP SIGNATURE-----

--r5fVu7GuxFspCQns--
