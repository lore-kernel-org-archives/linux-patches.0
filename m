Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CBC15ECD5;
	Tue, 17 Sep 2024 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726567018; cv=none; b=bHg7FNiDC73qAI3MKnYu7cYy7QDTeC9/BTpvL/80Ol3ExD/QY1eblpCrQJY9HAG78qfaBruAJClMHUAtVW6pPQgwMYMpFYnWrP25u86XwWSkxw9TUpQdt/gga3FhQqwOipOXJehYkI+QqLr1i2dbS0KARl19qI60aIdtocDUY/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726567018; c=relaxed/simple;
	bh=dweB9mTwdkZRtIVkRq21Qmr3NVEzRHLPPKUPEExBesQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDvly5aX5ejLegxsLQAiX/T3n8ZHV+0mH/iB7FOjqLqEPowAiFtDxiTWaFjdh1xNB+mIFoMRXTPf6/dAhjIbhjuvoT3S9qWIflyQx7bBMCTlZ3ZckpHNrIpYwKdvNXrNP2aFJiGsvPawQN+rD+dHtDYHmLSvVzOfRvabJveAyZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZXzsKWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZXzsKWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB79C4CEC5;
	Tue, 17 Sep 2024 09:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726567018;
	bh=dweB9mTwdkZRtIVkRq21Qmr3NVEzRHLPPKUPEExBesQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZXzsKWTV5ZYGLHoDYza00Jy0ABfiIVTj3UdhccUV77HuzBoa6GrCbAFfnjGSfQw7
	 C8QYs009jCOJgDe9+oaEj9SlR0BlaGPv7y0kRcfASROVzx4j8yjYffeGtnaFOVJDwW
	 jccOPuwDWuHrmFbNU47PGUAZRi5KkIbOtGus+uQLmDg5kNpwuTlRYDtvtQSxrpbtpR
	 eyP2DrfQOAbk42YoLtqasg1C+K88GOzS6dl/nu98sLj6rsW05vDSHG52VTIB5bYx2Q
	 nKqUtqPsmqY5FukpviU0yMVZssTrv3qh/WtSEa9v8TzkBYkr1qOd9488CFp3KUb4kI
	 aT60Qxi+8NwAw==
Date: Tue, 17 Sep 2024 11:56:53 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
Message-ID: <ZulSZQ0IKTK1Bed4@finisterre.sirena.org.uk>
References: <20240916114221.021192667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UfKMFtHYzGto6sVT"
Content-Disposition: inline
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--UfKMFtHYzGto6sVT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2024 at 01:43:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--UfKMFtHYzGto6sVT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbpUmUACgkQJNaLcl1U
h9DteAf/TWmZcy44yIfU/rlTH8gvy1l1O93VuyvytaIOX0CnYWr5mDvX64LtPrRG
B30rWJPZfFd6JTd6aTHZNjcZzouUQrcPuOLUhHfQt7z3yG+KUC6ZQ88Z3PqxEyQh
ReG4vbo/prsEm7VEU9iHDcGELINRelHtG58C4EzmI2sLN6pW3pLnRFFA1t5yNe7B
WhvHHwDEOuHXZI7dC5aV4VVw+wR5Tt15pyKdB1mj6bhP1jJQ3BeMNfwmsuN6h9DX
DlXYVWVY3caKtWJGVZ4p8mhCAXRKykQW0eOejS/umFs0vfIi4PmY5DsSw9Enigak
q+d8KiNdiXrARIhzOr8ilJQ7NQyxlA==
=aVHb
-----END PGP SIGNATURE-----

--UfKMFtHYzGto6sVT--
