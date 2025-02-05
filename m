Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA2421773D;
	Wed,  5 Feb 2025 22:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738793605; cv=none; b=nD6NeWIDLJ+LppflM5BOumQgiKBGEtdPZKYIhxx3bomBCGhm008LdJPzDkzkjklqhsYLpmAdx3iR2BOLETSnyyIf1s9+ZyilOcSwvhWQICHS3KE9FKDe5qih1UuTptkEVEX8uf6/zEjSoB8cDdntKYZ+H68ZIYXd2q+aZLAxzlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738793605; c=relaxed/simple;
	bh=fKqU6t3xfMtBaiYlVeeCQ6y8NmC6vQ0DoLtKSLtTbLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtPmX7fXRu46LUvHzH1ttvYEGrkBqsCU8gP5DVgMsLAuR8BMlGwYHyHDF8w8AssooHnluZbIxLPE89MOKfTw4S8euJ7i++J/Apw4Bjo5hluhv1NPywDOxfRa7uJaMI8BrhG0FftVPHWqUuve+LMW9+sp6IePbqTvyozHU6/a8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvEFWAwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvEFWAwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF8C4CED1;
	Wed,  5 Feb 2025 22:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738793604;
	bh=fKqU6t3xfMtBaiYlVeeCQ6y8NmC6vQ0DoLtKSLtTbLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cvEFWAwX9RNNFHfnZOLz/jpjjY93zlmJSxV9MqbHiN3c8A6VBT3h+ELoRRyga7Ovj
	 RVGhdm6FFU92Grp7LTTn8XP1eAmPNMb09qIfljYOT4Hha7fe3eTPg7kN7nvuT8TsIO
	 iRXOZN3qdOLPcgmo95P2xY+vcXlRw6NyyfrsGmSypDC25feevs9osvCONNZ2i2fQ0n
	 YRApkzuLk5uq+T+8E73urgVmh5Mex1ETT080Vx7Q0veBnLjh0vNCD0v42PyQivx928
	 wh34IHe4xHHUvs6KC/E6W9VjUf5l4cPMYZZT5WO8u3tMCqYL4Fz3AkKwyJVAaHe3VD
	 Nreg4+4r1UQSw==
Date: Wed, 5 Feb 2025 22:13:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
Message-ID: <42879ad5-a1d7-4fd0-98a0-9b8b635a4eed@sirena.org.uk>
References: <20250205134420.279368572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i5ohF/d3k1buxbG1"
Content-Disposition: inline
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
X-Cookie: Earth is a beta site.


--i5ohF/d3k1buxbG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2025 at 02:38:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--i5ohF/d3k1buxbG1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmej4n4ACgkQJNaLcl1U
h9Cr2Qf+OLovu27PIDWI3U2eNah4cgNcS0HSufcNATYtqL21entd5NKZtsbPzB11
Ee5GiGKO8EOW0aSPlLO2DSt1TMC1vGunLUiC2Ju76jMZjfklFgaECeYmGwycCDUE
RnF5ybsgy0zy4Tq0Ey35Z/5MWH/1bLpgAoS4ZJYh7XwmnhhETlyHr7Qa3CKhlc/C
JMrVdHAlGK6NUjdc+lOl4DJIug/U0gint4aC3ANmu0FfAG2AOmsHDC9ZddY4xh6i
GixbEmuhsYf+WLRoMmA1ZY5p6im/UEnypD0kuPN1kmyYyu7aIQXxTdHezv3Ra1jY
qtotFhi7KPmi59oXc+ZuSfIyMMqVFQ==
=e/h0
-----END PGP SIGNATURE-----

--i5ohF/d3k1buxbG1--
