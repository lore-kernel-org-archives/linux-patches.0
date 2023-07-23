Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494F17F
	for <patches@lists.linux.dev>; Sun, 23 Jul 2023 10:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB07C433C8;
	Sun, 23 Jul 2023 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690108912;
	bh=6pfhjlPTOh6AOzRsJbAp4eRsQEhZQt7xA0hkoqbQ1Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BEa+xR13lmIu8EJRQUQjKqCDCGJv3scr1Mo85p1UgRRd0j0mOuMgZE7II8qVsLiM8
	 MMYN/bQZCKmAoWNyr9n36EaHRjBjlwPh+UKufXwkqA5zg4mevkT+ay5K7erd3zWdBX
	 xVMH2BOO6h9g+bO21+TFIyckaqp7QMgtryL6AwtrgkJmOA2FjHxp2I9v+AlsLmk4ys
	 Ffu17WQXZ8KqXFiUy/l6ZrHbMsHJjvJnKW/Rp/rgkJZRrteAtjMwBZTrIVpI4F8ePi
	 2ud+seIAlKqG9Yu0gCgllpFpLB3fl/NgQvLpYD55W93ivF4rrG3cle/oHZ6aES90DD
	 RzaSg8/Jy3xsg==
Date: Sun, 23 Jul 2023 11:41:47 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.4 000/292] 6.4.5-rc1 review
Message-ID: <20230723-antics-disliking-e51f5f376820@spud>
References: <20230721160528.800311148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Y23Encm58GYXonbN"
Content-Disposition: inline
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>


--Y23Encm58GYXonbN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2023 at 06:01:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.5 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--Y23Encm58GYXonbN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZL0D6wAKCRB4tDGHoIJi
0nVYAQDmgO+AR8ya6jXYh0BedeWoIedGUWJHT3jqLbDuAiz1DQEAyP6dqAllOe8G
tJ4PLfA7lJHSEZesgf0NmvY8o75i+wY=
=AP5S
-----END PGP SIGNATURE-----

--Y23Encm58GYXonbN--
