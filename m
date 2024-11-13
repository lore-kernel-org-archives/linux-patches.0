Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B071A1EF0BB;
	Wed, 13 Nov 2024 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504566; cv=none; b=HqN3bSAV8mr77Bmq+DfU22U9m7DioAdJ6iXGIVEjHJVL0OwOnpUTqA/I/MQZeyBQFptYN26bjT7B3ZsScVq/fzJXZYFLtLoBYIe/pEkeo4PH8/fVWMwKz9lnxMkjsJz2vQde09bUfUNvVu3XWhb+vyYDx0/eWydJnTCNZARkMds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504566; c=relaxed/simple;
	bh=Kg2D/HB6TJVjDcijyhjnF1iSTGrnedl2hiLL6wZVgxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCVo5De13t0OpTWsItfKTmWO+tmYi/L8fVXO9P29VRuer98iKvY6SspHRSMeZux2uj3eDrye0dTRWlAyIlswAAcYJjytIJRFnDnmb9zBrzEqBX9fPr4uKvjeuCvuI1wCTMdlQBQ3fd6T3dD/zgh//wcPIK1IPq5VfUbKXe0CbBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxSuCEvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxSuCEvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AB4C4CECD;
	Wed, 13 Nov 2024 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731504565;
	bh=Kg2D/HB6TJVjDcijyhjnF1iSTGrnedl2hiLL6wZVgxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jxSuCEvBDq806+HIDleHEWepKliDD0cLjEwhm6skqPE0VJmcHGc0zO+9a1przRF9P
	 9Bu5x/iEvx+EIZQm6GzJKra/mBCJ25F61K6ys26Ip5pIcd1ZHLh2RnzjT0tfiU1+On
	 zpRDWHzND+dyT6OT9swLeD9hi12Us17O4rRCFQjF5LFMQEiAzWWgykn0P+t9yZbUfQ
	 W9J+wVnzf7wXlh01qaeaBx/AZRwAUqkF2XQ0de5vlbxZIYgsLjw5MoepjV7TgvyjU7
	 CvgPxYmQDi2G+C8tVEDoXL1SdSAQm5jRdUBEumFso9SpM5t0XiHkjll1ELM4Rrh+Cc
	 thIDuKjOutFpQ==
Date: Wed, 13 Nov 2024 13:29:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
Message-ID: <ZzSpsdfK_k6QfSIe@finisterre.sirena.org.uk>
References: <20241112101848.708153352@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wRbSEROwaiO9qY6X"
Content-Disposition: inline
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--wRbSEROwaiO9qY6X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 11:20:08AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wRbSEROwaiO9qY6X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc0qbEACgkQJNaLcl1U
h9COGwf/ZbxlUNmegMDDZ2CMimbKOP06P5PZiBdBQ9rz34s3AQ5xW9wHazCaSuvN
r6tHSK4sR5t+GLrzCl3FT+CywrxIH1HJXE0XVQYp3ibO9pufKzlXzkrxlotYeYj3
z/GL/zHvTSKk8fHipKooeIMxyFjt5RnKGiYvZA4WzlAJcT0DtKB+3BQLdHbH3Ha9
5JCqYbwPVCcyJC4BBAGPRSVt3ow+ZbCK2tFVCmfAhhO9X5M1qCL4BoShC0WOD/an
hXW7L9lPHyYC6EvkdmIIAc9iCz8d2RqSn4gwF8M5wvYAjuhx5KQQhw28FR3NU29S
lZbyw4lIXBtKzkX2GH50IxASUFCQOw==
=KqwZ
-----END PGP SIGNATURE-----

--wRbSEROwaiO9qY6X--
