Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC287347C7;
	Fri, 24 Apr 2026 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777065743; cv=none; b=njTg9eFSlSI9abrdQLtfnysGASi6zejvYn5z/6X9wVRlWh0grJ7QA7AG8hH1iZswpZu0QEH92QlhKUrNLd3TyAd8H1DOe5Rt5Ge7FKc+c7aWU2qQjdqBWQOmJCvOg4+pcp4KzL5VmPZuNRgcNub+K/10boKw4LtdNRj4/ttuzyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777065743; c=relaxed/simple;
	bh=EyXINw+76BiI0JNnogv63NSRHE6y9aqu0HoFEDwZtAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAI858KhxrK3jON0AiIoRyfnqgCrivfj4n8uG5bB5H433uf6u+7SMp2N5/XnM+DloBva599xX51JvNPVM8wpwwU7f+Jzk8X+a+ghn1hw+93eFop0rSM3UpB/1vfXlvuLiShzXOh23nXtwoAYdOElfNCv+XE6GP5VUFiycOGl2Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnDMfUiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnDMfUiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EBAC19425;
	Fri, 24 Apr 2026 21:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777065743;
	bh=EyXINw+76BiI0JNnogv63NSRHE6y9aqu0HoFEDwZtAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EnDMfUiIusrgmnI+WQiaXKpwcpADhRLWXjzaFL+qLNENYPH17AwSJnEoMsO+zYrwi
	 5J1BUq6VUzBxXU1ngj7zxWSzdxfhugUfebAp+rnXUNaJyUPxXwguEReBdzjIgqOitS
	 IJLr5z6BCiWi6XFC/ZUcrJV4VHMtxqcBAkorfKIL+E2tdSiDjPYShGXdjnHugu6UVO
	 OmVwFddEG8m93PNE1BtXWANIMA6zibft3EnlB9x1TSQvC1Fwx1lWIU7W6VLdoLmrH/
	 Q4DzbXv0tqTtEjSBOlgMjNWQrqElzM8eqIwpwW2XC7vjURavr2iv65vGFlO9Ps1dDT
	 fEsdbbZ34hu1A==
Date: Fri, 24 Apr 2026 22:22:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
Message-ID: <06c2bc1d-54b3-44d0-9cc0-a8db18ab6fe1@sirena.org.uk>
References: <20260424132420.410310336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZdD1jUhrsxH7vxba"
Content-Disposition: inline
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
X-Cookie: 1 bulls, 3 cows.


--ZdD1jUhrsxH7vxba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2026 at 03:30:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ZdD1jUhrsxH7vxba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnr3wgACgkQJNaLcl1U
h9CewAf9HrFTcjmVlqHJ/6kM/RAefkSYxP2t9xvXtcn730f+f9ABySkT7ymaHQHW
MiK9dFCEpFZrhDr8pOmXerzpLjpIFz3OPTlnXlO5tsBI2qofOq6LCRp4vgiRZ/dW
h8C1NZQHKmI6E4Hj16DSRGytbMwFGbrCRTkKhaDFHwLx0A3oYEcDTtGFrasdKhKI
zpHZ5tRpUEpAVfgJ1cDaLLI2YOSvfnptA811OKYNXtowa9QthzSt6W54jznI8AuC
0Fz0ewhPRBY5Cnf1/1HcKvOvVdzOIoufwj+0iq4pvDV6f6nMocrWdO94k5z0yBra
GUG+vHLZzvC40YJ3ldvOku/HFcmE5g==
=Wjr9
-----END PGP SIGNATURE-----

--ZdD1jUhrsxH7vxba--
