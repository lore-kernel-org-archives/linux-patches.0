Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0331A42C2;
	Tue,  3 Sep 2024 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725364285; cv=none; b=eq+7wC0DszoJo6pBVRXkTrMlgC3ZXBDh+5z2iW4hS7OF73tObGEo2ZhUmeI0W7DXfT+NYwOU1k7fFI3ahAPCqG9xbLU0SPY5UnlyO7MClHC/tW3OxjhRvq8ACiL9Hf/yA0t24nH9jxkT4QTNba5UT1ZMXBHUhgdcZk3u0/mCP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725364285; c=relaxed/simple;
	bh=RzB6YC4thRbWllGcX/ESUcoHvfzT8kbLenTRs0/mh8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOePFOZ6HlO/PUsbH4yZRiI/CBgspJ7s4rZAX9POtZ7Y10QokWmYBxHB2ZEOqGbQuUTmEs/itKhkhCOtxLI6AYwhJ8OdQgiuLhlmuaa/WuVdQs6466eFULEWU/V+wNEAQTfimHVLbWH6T3D/9EHoPrVcexs873EkC3ZNvQsDriU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwwYuWKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwwYuWKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97766C4CEC4;
	Tue,  3 Sep 2024 11:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725364284;
	bh=RzB6YC4thRbWllGcX/ESUcoHvfzT8kbLenTRs0/mh8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nwwYuWKCicwK42VHzZEm0U0j0nq056rRrPh0STwHLbdc7fTd2xbpPbAFarbMXSmsx
	 HEKwUXVQ/izX2Srosl8iL6GrkKJuu9LtugIlsvQXef9MeCDzICIs6K/UfyHX6VTged
	 PuqD1DUkzl5fbcmmKrz1svHhtACBER6jJuhwqTRIMXTOVL1t2fUT3p2HWqaFL6i8Sf
	 XNOyQlFpJ7MPm2RLgSli59T+xeFDAMgyfwXEiP4/F+mecZOQl28+PlPCqsxJPJy8yR
	 lM+7PzvgKeNSgJGk9za1MIt3YFTqq7+P4jpi5n3JIH9me88Y09PU6DGuIrgF1iZESC
	 UanpIuzwhRhLg==
Date: Tue, 3 Sep 2024 12:51:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/215] 5.15.166-rc1 review
Message-ID: <84ca0eb4-6f09-42c0-a27a-8f1765977a1e@sirena.org.uk>
References: <20240901160823.230213148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0b5zt7XZsA0lZcED"
Content-Disposition: inline
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--0b5zt7XZsA0lZcED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2024 at 06:15:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.166 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0b5zt7XZsA0lZcED
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbW+DQACgkQJNaLcl1U
h9D11gf/dsArFwbKy1DHDFQbQIAFBTgM3q5UdOwMJ2WHkaciyZFmRsM2VawoSwcj
kQv6T1iAsViSZA1Rqd0S4da0/NFvt69ou+Gy6dGOOu/L1lcMyfC72JO6g8RLB9In
yZAs9rK0kCWIds9tx7447GFdRWEznJoXLjzIMTiZNbha/Q3spZCNYh+2MaNnAF91
D1bAvM3rf6lnTJ+bq53tGx7fnI3mLqF2Gi1fYf33yIfHGEE4+KlRdOTvpS/pGiQ9
AL4Mq4r9dsZ6StYWYCqg9VE74M26x91htNtU3kAVLKlR7Wn725pf4KNbAHcsR7Or
66vR2IlJ591WAHvNrhALRCtP+60oIw==
=q78k
-----END PGP SIGNATURE-----

--0b5zt7XZsA0lZcED--
