Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35C6B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 13:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347C2C4E680;
	Thu, 21 Sep 2023 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695301481;
	bh=sF9o/NyGOVf1W8ekbso4gsf86PdFO99KgIVvRixT3wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMkjlRhs4NLnMmHDMpQ89vcCo9fQVWoEWCpJUt38hUyeaeEUzewua8ILzpOQOaBtM
	 Jibt3UNIIkzQbmDz2WoG9PTcLbeCXBhKI3tfcXX0tbm2uNuX1jq9cCU3hXV8x0PU4y
	 cmMzKo/aWG+axhC1O68g2pNydDJhCIYVty0jMGrgogRB3Uf2SNe+PzN0Ejz1RmPv6o
	 ASuNu2YMIIvZsZsjSznrbvpHeQYjWuCtXpiSjArfYfGOW8OfNSmNiRpLEADde9rOJo
	 mkxR5rIWKDBxixxDcx4tqhwAjjakunZk3rmgj72aiwfHiz5AQmldH/pGMa9L/Wtu1k
	 8HKKgdbT9o0Gw==
Date: Thu, 21 Sep 2023 14:04:35 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Message-ID: <20230921-slinging-sudoku-e19ec7c43607@spud>
References: <20230917191040.964416434@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9D8MFrlllA4ootk5"
Content-Disposition: inline
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>


--9D8MFrlllA4ootk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 17, 2023 at 09:12:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--9D8MFrlllA4ootk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZQw/XwAKCRB4tDGHoIJi
0uzfAQCFmfBn9x8aEMJxdtm1ZV/Y7rk00WPIWNdEP57X/9k/JgEAiThMIQ829IjL
4CxjO0hUgdGFd+yk5ks9AzmrezYlqwk=
=SMjH
-----END PGP SIGNATURE-----

--9D8MFrlllA4ootk5--
