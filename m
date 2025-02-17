Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CF2C9D;
	Mon, 17 Feb 2025 00:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739750513; cv=none; b=mRcGwuf4K5D75SMEK6S0Ii9w6KpFNXmO0gb5zO3XMLEm/Yr2gqpcW+XOreFL89fYL55NcicW0Z1jgGQ2Yx126QAuDfL5+tj1ewA56m0uLeGsZJyd39//6AlVWnIMCnruddBgqD4NrLsooPBlHgJuDB6qxbfBr3zEy1Ig9AxgYx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739750513; c=relaxed/simple;
	bh=usGdHPl3WlcwuoBQ1gfOOsCpw1tlvxcC/mZQnEk12rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAci8+qUuHASdxoedsyyfEPGMKq5j3yhSCBcbIHWkpaG6irl+2J116/UpHphth4HJlx6oXpIWkInl2RFTU+BYKRpv7bA3ZEdr1mQCBx8GI+aXrASHwm6rvQiOx1Zwswu/lKAXxe1It/ZlhQ7T9+Ddp4cNRhReYxCQNv1MDD17Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orkfcCyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orkfcCyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C94C4CEDD;
	Mon, 17 Feb 2025 00:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739750513;
	bh=usGdHPl3WlcwuoBQ1gfOOsCpw1tlvxcC/mZQnEk12rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=orkfcCyl3ZctI8M0FYDl93FYz2f8cGsTwqlS+firT37MoM7c749/oJnFmpP6y166z
	 +O46REFH+xADHdM1/1wjbA9sGnJLQ1EaFqTeSaWsAfTUaw32inxV6/roeDtsyXK5JJ
	 aVBcKjnv2ZnQv+r5uUvKCg91/etiIvbeDRZqjwAigR7jHQJYJXP10Nfi6OnRo2h+ib
	 TFoQmYaCIFBWZ9ULmJWRFSZ2B3OXnro9SXUnLNm1xXmU6BYzfB/PlYmAqo1Z0AF2xH
	 M3oQnHmW04fTUdqDCd2/nZhZ2I9k38f7VDlS+l9DXzxur8u3id/QD7BD1p+YNtVqL6
	 6jZUH7vm1DfQw==
Date: Mon, 17 Feb 2025 00:01:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
Message-ID: <cbe97f72-d9c3-4bbf-b025-8766f9b6dca4@sirena.org.uk>
References: <20250215075925.888236411@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6t2Qta+oZtImKEW7"
Content-Disposition: inline
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
X-Cookie: This is a good time to punt work.


--6t2Qta+oZtImKEW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 15, 2025 at 09:00:06AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6t2Qta+oZtImKEW7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeyfGoACgkQJNaLcl1U
h9CYVgf/Uy7S2iq6WzPc7x/8dxcU9al2YPQseglVxN8RNxmBtaJkM0vzQcYse9Bo
UXktHVXGJP/F7FpttjGDFeDPdXkiC5sN4tfX/Mm1YtuXpfw2pU3IRrFSNeK1sH8q
f7kt/X5Ylx9c5HI3N6aCEhms5I6mRWJSt7StCKGLpBt/JxML4Ef/UL9/tMvHX3nC
N+M5TnwTEhkTYU5E1UXlsJaeNPNDGj9aXVAxw5TI57lEie9hh80dWvAdYbrEkBjE
uUqQ41Sx+WWCJkEG05MR/+dsOj+QojfbNyJthrlf13zwnrY42Nr5H8AiCrfaLTbx
AxQVB5eP5qg4lxUfKnZ5Y1qltJTz/g==
=lQ4t
-----END PGP SIGNATURE-----

--6t2Qta+oZtImKEW7--
