Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F52C2749E0;
	Thu, 29 Jan 2026 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769693110; cv=none; b=jXUq9OJxMI0X9EyeqyJrxNJgdqOunC+uceXJ2EJncCQWt+X4bs728Ivl9JWJ0U6si+whcm4hKSImeBmASTu9alyVjSN53lJH2tW5KqxyIsxuiaLYZ93224ZzPUme1hqTmXww6MH9MzGBAAFkbhU1DAM39Zd+NzS9fob0IR07CRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769693110; c=relaxed/simple;
	bh=UJc7W0rSKjG1HH182YpZFctSb5yKFUYMvFMq4UEpWzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWibB0cv/H33uTelFn9uziRI/EqwkEbYSXd2RZilqcVWaKNsQ93Fg/TyEg+TMDvKuVJB9vLWgWrSoHaTsUJE4cf1PvtpbEm8rYW0HHS7uLoBySENugDASLt4JM6oj3eN0qQyzN1idVVjKPcHPqtOYoLO6gzwIVHk/vQ9x2PZyqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAzecf9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAzecf9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60F2C4CEF7;
	Thu, 29 Jan 2026 13:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769693110;
	bh=UJc7W0rSKjG1HH182YpZFctSb5yKFUYMvFMq4UEpWzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAzecf9VOMcevT9n7spAOAEuxG3kIyiT5xPBZtlEmVbuWNmZhmgkf7tVOaZdddImn
	 EO4WZWhgbOnixHilMM06E54aT890aGVAnUxr396y0bLXsUvQDti9Rwl0Ob93lm10Co
	 uK9ahDjNswr1w4TfHhhkzNZ//jcj1QgTFaYQZQrrJSeTEqEc3yZT8e9OmCED/kpShi
	 AYbXzNkLHADyheA5jjC5Evk/gCoSL5jWXbVo+qqoOuJ0GXoGQiUbzhymGiK/77NHwt
	 TNwWZ+9g85yk7kPZ0/YdvykVtPHzg5ZswepjhEmcEPg7clJ7pkllAcRsny0NHHYl5n
	 CXJhofYXGAa1A==
Date: Thu, 29 Jan 2026 13:25:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Message-ID: <f5a961cc-82dd-4b59-baf1-53a116db6cf6@sirena.org.uk>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="P5fqAE329sMLrlGf"
Content-Disposition: inline
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
X-Cookie: You have taken yourself too seriously.


--P5fqAE329sMLrlGf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2026 at 04:21:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--P5fqAE329sMLrlGf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml7X68ACgkQJNaLcl1U
h9CWEQf+N8XE+NVT/ZzglYnmEKEs8i4+Vv4GO3HM11tOMuHRGo+ZVX6CfZWz0XYa
vaBfp+7XJC/ZsOvVJyFaCwft2LI4uzz6TCOlf+hMfISKho9JOT97bJ2c8JmYneir
33/OTO3QPMSWQuCLajTtJmZh5U+LFyBe2KK5ya3YYRQU2GC4Cn6PbOEuX7TCNGIk
whHPttn7Hysd+Jg4FvLeY7wdp5czUUZ0lf8qb4780z7iO+/uWbHy3g/drV1rqyPk
6IzwakqCIL2eXwJKV+fAoRjYNBHC6rxBRKvEwrLsfae1G3UDijpNA1byCHlb2oh4
5rpOBZzRyQZCvcKjFX9SopFTXMX03w==
=gEmw
-----END PGP SIGNATURE-----

--P5fqAE329sMLrlGf--
