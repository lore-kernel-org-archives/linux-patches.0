Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D251DF268;
	Fri, 13 Dec 2024 13:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734095880; cv=none; b=lCLS0ZgYSfHJpETKnvZhx3nvvqsKLR+RT1+TRfqMM/TqNhfSP+pLnKujY70xMRgojGxmmn6UqPqmkxmFZCcOPer80UOEAcHymyrkkc1gJbpH7Q5gOIjBMYlrKXQIkIGHlBdOA7ObFXL3OknxQLsXL9lwMWMq3yQ84X+NttOrYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734095880; c=relaxed/simple;
	bh=fudyOq/MGATlRGtTkG7LBWuM+AyYQy/r5L4TX4UjKNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qz+O/w7nFspWFF6aLI8VIoJjjwTHpKxxSPT4OnaqopN3cgYoTTn+4aCjarOIIh1+7TWXgJsTw8AFnXwEA3oMXElyUw8KAF0Y6P5LSVq27dODJaD88QyV05A1W0DdACaCETaWQc8HcKPoroYyBFsF5JrsIW/ZZhKDdrfMdzXKuZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjRsjTM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjRsjTM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D97C4CED2;
	Fri, 13 Dec 2024 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734095880;
	bh=fudyOq/MGATlRGtTkG7LBWuM+AyYQy/r5L4TX4UjKNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pjRsjTM+isYF1WWm66/ilscRrjiPmr+9NkoJCTwggo1pG66aBicM+4dTADvof9kS6
	 qJ5zzjHzDcN2QZeGBvrzLqHRZOxKGpC0H6kFX8z2fIvOCl+9rkClMPXJrDpbZIzuB1
	 fqBD0LQ3bVD+OVEom9Yp/s6AD0+YyFBivXIeJrAlC9mUfxcfKIvUKCKucCrsb9g8dA
	 0OuGGKivAumu8qpoAAqsh8MC56RL2v6uTcGMJ/PNzv/m+DVDFyBtS7smKBkiGwllpc
	 GIOC9NUHxuDGjF1cLxR+IL//fQXYfN2jfaBEh0tkey3IAny+e1ksxWCXYMWUsglk5j
	 On4BfaZllJTNA==
Date: Fri, 13 Dec 2024 13:17:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
Message-ID: <1b9afed6-ba3d-4ce2-bf8b-0524ee6c4804@sirena.org.uk>
References: <20241212144253.511169641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fkDtrbxChaCBgThG"
Content-Disposition: inline
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
X-Cookie: Not for human consumption.


--fkDtrbxChaCBgThG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2024 at 03:55:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--fkDtrbxChaCBgThG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdcNAEACgkQJNaLcl1U
h9A8Rwf/T5P6IvFYmvGKKBqY49luehqujJn9Co84m0qUhRR4DaaMW5tM2K/pnwit
2FtY1iz9n+48EY64KCqHpYcI0ykAByg/+EoaZFI5p1HehfyhLXLlbq3IXP/rBxa6
Em+THoI6KDSwjtN9aTP6+r9BbS6ScF+Z/habTGY5+73B6oTZHm6c9fKH+wuluuos
Ook8ALpj7qJrnLnqvU/h89Hs5y3j3DurFKREgud8oEdyUnAg/hPLqD4pYlNbR7+Z
NW3w+/zmoBerSqf7zMwZiuClqtUw3Wn6x1FfNpdriyRrSHjGw0kplKx7abfS+I+4
y++eST8xMUNXVfu9kxXCsOgFJxAUQQ==
=tOJQ
-----END PGP SIGNATURE-----

--fkDtrbxChaCBgThG--
