Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6949B28CF40;
	Wed, 16 Jul 2025 11:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664030; cv=none; b=p9pMoZzMXxBJ3ppLqrJzlFIMF0P9ZcXJ+ZdSmWDUWD5XFXZPVsjs29pIAIfZuteFwnXk+NlkfPJttbBd6bLg62g5ohKrzyXzWNCl/UKgHZXJAbzYCy+LA91/ecLxpTsYtGC+sn2OVNI5qeTPm/+lcAxapfLvpeZ1DiC3a8X4txA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664030; c=relaxed/simple;
	bh=7NSpoqakXrR2xpBagzxriXFs5hctx5GvgCdBRzFbstE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRug8bBcw8GAGELx+S1Rlxmj0skO6CIGpgbZlABrdul/TEAZu3RWtcr93CppuFuAcL/ZCBCfRl8LlTX0eYKp6rhE0+4yFYfFMXBNuhsgYJe4uN7Y+oNUwkYrayS1XyL3ka5Ltp6REbH7DgZbRIs4vWNf8x1qJXukp9ZMetkumDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9h+yu86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9h+yu86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B195C4CEF0;
	Wed, 16 Jul 2025 11:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752664029;
	bh=7NSpoqakXrR2xpBagzxriXFs5hctx5GvgCdBRzFbstE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L9h+yu86VFKbge0dQt2PeKkup+A39pfh1TAlgjW3PnswudrVo5PI7QwPfKP1Wls/8
	 H1UM5+5R4magySqYBoPDi1vYIkQ2qlIISGh8qFWS5eyhst4I/MfaTFdgYcIXMcP6yA
	 p1F23hy1clSC87J26HnblYmgH64HFEpDFZhPvvFpTAgOSYSxZ2Y6Dfzi0dXZrz/Cta
	 bW//owyTdl3XYpgmFDu+PIM1+CrL9K/aaf601FEep0a5kaGHe3bqas/A4j3da1g08A
	 UtuygH4muSgkea+eZeeCTqc5yDhsP+bily8Bw7F0X3FtFue9ZgAPvE7KLeN5j2YdHN
	 cOXjBhmiotPRA==
Date: Wed, 16 Jul 2025 12:07:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
Message-ID: <78acc44e-54be-4cea-b429-3768a07ae24f@sirena.org.uk>
References: <20250715163613.640534312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5V+6o/RPda7jPhaq"
Content-Disposition: inline
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
X-Cookie: osteopornosis:


--5V+6o/RPda7jPhaq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 06:36:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This started failing for me on the Raspberry Pi 3B+, I'm not 100% sure
but it looks like it might be an infrastructure issue though it did fail
three times in a row.  The boot just grinds to a halt in userspace:

    https://lava.sirena.org.uk/scheduler/job/1576221#L1381

but a bisect came out at

[e2e48a330876c82c72215fb9e880c6c3a7055af4] Input: xpad - add support for Amazon Game Controller

which isn't at all credible - it looks like it's just running very
slowly, I'm tempted to ignore the result.  Otherwise

Tested-by: Mark Brown <broonie@kernel.org>

--5V+6o/RPda7jPhaq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3h9cACgkQJNaLcl1U
h9CeFAf/ZgQPNdjgxY/26Naz6jAMXKqCwhOqfP+rESWFaazYH/vmFyBRqUGFvhxc
ePVhxa41BSUcKnYf6VeC5Biix1r5JfmjTI/5PfhUQZ6YAQ/nHFdpAgYSIm4SRMbN
bmqR0KuztwhZ/1kFZuZNQeX4f47vm2uialJN2sXaVU+jC4QJULF6xPkz2ZEw8Gnq
6HX8Pqxvoil/jorTTUnhWla+h9jjQc7OGO5lM0//1ovGCayfqQxvhsPK4HkQSTq/
7Qz/yv8otdPLnRhJdpRPzn7HKq9s5XOaMqjFlIaHJXoHoVl/QTopJqppjaKGXXuW
wNDsRKelmJ4gzowe+9g1JaFNDrBXkA==
=HArI
-----END PGP SIGNATURE-----

--5V+6o/RPda7jPhaq--
