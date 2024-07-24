Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F013A3FD;
	Wed, 24 Jul 2024 11:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819522; cv=none; b=FVBRL56IjioCRUWajCGsGu7dVuH0BKjrbRsjXncz6wZJe8C5G+oW3xBBQOoyAFCjdO8kIctcGihwQbar5qRJd/Pkt5cdkjQ4hu2QdkfSAyDnaPOCr7w3JSqvupbSOXw4RE0x6xFt1jNmmyv2Oy0AntL0cfdKR2/+2ODkpA4nm2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819522; c=relaxed/simple;
	bh=m/By7NBPp8Ww0usTSJyr0DDXbtD16pvELqXDGLhBXKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BukcN0cy9L56Bkw3OpBwqULEKY6WOkl5Vqipw33Z4ukbkmzbi1ESuk66U7BdDMum/Q49iTpsONSGYolZ4P+6Om5RLWLHEECYESumd4bQ0uE6PZ13MAsTClw8KJfxfjmmnEL/jwNrWZhZ09d6SQ790XkBojNzvQEpEuohDAVEhcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIh3/Omk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIh3/Omk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B76C32782;
	Wed, 24 Jul 2024 11:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721819521;
	bh=m/By7NBPp8Ww0usTSJyr0DDXbtD16pvELqXDGLhBXKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIh3/Omkmc4Qw0kj7dL2ZPhA4v23tHCH0wHPGXgC37GysoE4OOuJtHLiV37lxG7FP
	 bmeY0WKOqAQ7ZeDoleRShSrrEUM9tjg65B7iWgh0c/aEcdQ1sMlFP+wwZey6I8uq3o
	 R5Fvpo6LKF+SpfDdAJ5/UQZqLvD3O1gIhnJEiWCkApLWmX3xPmM6Z27qHI5P8t77BQ
	 HZBqr4bfx/uTFjKdUQurkiX+ZQDnL/vX44zBETNvywfPHw8/Q5VZ6pohKyMhJiKEtI
	 EGNSrKv8EZWEL5BViHOJeKg4zUz/R2D+ZfivrR7JdjpjLOkQN3cHYA3Lf/SpUC0q3Q
	 EaSQoBo6OgUSw==
Date: Wed, 24 Jul 2024 12:11:56 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
Message-ID: <20240724-carrot-mothproof-e76f9c968a2c@spud>
References: <20240723180143.461739294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="efgonpDskNONkdVG"
Content-Disposition: inline
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>


--efgonpDskNONkdVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 08:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

--efgonpDskNONkdVG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZqDhfAAKCRB4tDGHoIJi
0qI/APwIJTco0jWm5pcF9BKmvZWxVHgSVd5Cdli5qXGW0LRzuQEA2pwUgaICIowe
ls/4F0cpky24JkUldRHajZ9sMI+jDgM=
=0qy/
-----END PGP SIGNATURE-----

--efgonpDskNONkdVG--
