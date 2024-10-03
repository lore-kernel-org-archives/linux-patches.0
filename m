Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50DD1422C7;
	Thu,  3 Oct 2024 11:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727953509; cv=none; b=ClwyMICExtw2jUZ/vXoObexgL8EFKhABnc+PdeUhDCBkc3L6VS4FWuCwmUF8t7p+CNoXZC7KTzG5dPdouigXKmSAUtbv+TJzWq3tCQeCdRRRywwywpsEH5GkkyC0fV4aM2XhJS/SGLWAUfJ2V9HEJmqc5hHdC1xccSXKd7HMf6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727953509; c=relaxed/simple;
	bh=inqNoSkPcvkRXDKsDtUbLE/zIjvuZbNwrJ5HJj3BkH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViNUtv00wWH7KEeT/LVn6L/Ak2inRGsv8wZMk+CkjBh0/2V9joyBY+1EfTRfXqVQGfRsdiJeaYrhl8yahhmlcCjEkLWPnNF1INyDE/Rubw8FA+EgjXUWvPnEiFwUxtXZzoRExZilHE2ZEAhFLdv+OdTspvLps9lPVyoFj6VkOgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+G9ewNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+G9ewNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D94C4CEC5;
	Thu,  3 Oct 2024 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727953509;
	bh=inqNoSkPcvkRXDKsDtUbLE/zIjvuZbNwrJ5HJj3BkH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+G9ewNylJUFFggWuenTBOuQhAklcjhldm9GAjgCBSIUlxh0i6PEEluHrGXRE2c+m
	 fvn3ZQsGyMuj9x6G2S5nVoLYIforUr2ULN7gdVjo7Jg6wqKBbaKDN3jl4MHc8Ij2lk
	 eI763trT8JuQx61D0UPVWEPZMCanXytmYklAZU/4ujo/g8y3iVP3S5PHovobbNn7ET
	 nQPsDQ5gScscCmMt/DS6AEEXZuZf3XthkNhSPdgwVlcaaObcHTlktm+D8HlKkFYbmB
	 whZmtNbQ/ld+dyyD2KHb1tgBhUbDc0FR0caOjpi+9Jc+qhx9+HdceJYTfG9Z3KYkz9
	 VUhCZCNoi1HTg==
Date: Thu, 3 Oct 2024 12:05:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
Message-ID: <895b9f24-695c-4c09-bae5-e1c430e45b43@sirena.org.uk>
References: <20241002125822.467776898@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XfPa4J5xEKYRl01N"
Content-Disposition: inline
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
X-Cookie: I'm into SOFTWARE!


--XfPa4J5xEKYRl01N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 02, 2024 at 02:49:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XfPa4J5xEKYRl01N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb+el4ACgkQJNaLcl1U
h9AGWwf+JyBqfegiYJJBrNxtdtdrpim0D24EQKJua3+LSRuH1qLyGqwCaqlVKws4
wNxD7h9WB2ftA7pI7ERtGbN4qudaPMRfnQxFLsaMSd5AgkBcmhe1Y3w54EPwgqc4
nlg+kxq97wXy+3g/r0Eu7ywkyAO+5k6laOCJOEjhm4irMt5oTjHjUT06S6yH/y2G
CTA6yjYuXhS6uXhRjQEfVaa5Zll75ZlAdENosOnCSow3MQ/y8RvBdxTmy6O7W5mW
LevRw2+rdrZer/YPvCyXjK/22/0ZCc8ymSoXsO/xtsiZ/J8/Zs1QbKzS2cSr6eWh
xvTn9ctj9CelM6qhJrgz0i0ZAzm2Dg==
=vEqa
-----END PGP SIGNATURE-----

--XfPa4J5xEKYRl01N--
