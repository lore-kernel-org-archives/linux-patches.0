Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23133304BB3;
	Fri, 31 Jul 2026 23:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785540214; cv=none; b=Mci+cvvJjSMgCnzKjNCHy9bEfG6oc5hrxzULp88ugqtbffBr0Ce0+jWeBuM7GcmGQ8b7nq19DmuuKr4YPGTHO2m9WSBLLu7ubFsIwon/Cqqmmq85hDtb8MAZ6aamnUvlMBxp4yUOrYRcXTz/sT+1YW29tJHEvozf9GNOYozIZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785540214; c=relaxed/simple;
	bh=gVPrxFuTGVoR19OA4svlEIPYd1As7Dg6EkKYQP0Yal0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uM7ooiEmoY5b3FLtMm6EjXCKzVCuOl/x0GxFZBdDUlDOCtgr/oVAbmyH0mgaXP2neTNJkfFXXQ8MFd/cGj3RqUZf14PvgSX+dGHIlatWcdOgo95W4gtaPjD9wfsHZNOqby2K7XQhtED+x9GtZiJqVWjCa9IpiSW+1Xshfg46q/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJsiHeIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJsiHeIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2341F00AC4;
	Fri, 31 Jul 2026 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785540212;
	bh=5peeIH16uvR7qe70gyY+wzWnhBHDvyXPw1Xb125GXiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZJsiHeIhMbJvZcuyjH41FGKIRJSP8uqNqDHTvW0h3/JB/bweCGBwcOP8xhQubc+3J
	 yVMM9qxocw//Z/BCyDIMGPlnWHkNoLAlqKRuZAkOCHc5L77StefiebW6yFbY4BdQVx
	 UK6I2AknVe0DN2dRAkkuFqR6mTrnBRy9j0SYslWKW5U7BIr2fHV4MPJDt+UzPn+o1c
	 XMexOpiYiMC00uTng2Zg077FhH03LNqP/AgNTQuyQFpkFSFpPnPPunml4ZbzMH5Wlj
	 fdQUFp4Ab5L+ReXqo8w9mYfDbDr5Q7ACuvdEMFqjpd7nNZM8JlvaqVQ+w91Asmvm2C
	 20OwHHQsVa7Hw==
Date: Sat, 1 Aug 2026 00:23:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Message-ID: <ac8e7aff-db48-4d50-ac1d-cc8a099f5a6c@sirena.org.uk>
References: <20260730141423.392222816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0TXoGDT0rxagdzBS"
Content-Disposition: inline
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--0TXoGDT0rxagdzBS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 30, 2026 at 04:08:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0TXoGDT0rxagdzBS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmptLm4ACgkQJNaLcl1U
h9BcJQf8DYsr+/kjHZttgg8NTInTRijfT/uVc/LHa20iYlhe5Wm15zhUszlef627
O3IOD8dhLRXPMXHHXxFoHcEg1USuogGaEuOP7mU0xzAofKJNpogRfmsKtpj/FkO0
4ZTkRJHmLkySgjjAHbvfrgVqbIcj6vKhwzgB0gDQQta/HBoUuV8dixn/9uNnmD31
5gLz1RoFYoMilvE+o+9uEvNfUQ5Ec/WlnR5FVyV49Ei34sDONH0Rji13rrlzFWNk
ugFBHaSfBZDLQ/3ckBV6qht54m7m9Q+qevwvviDL5dA5muJFGbKvKJZX0bPvvkRC
uUutBdz5ePyLF+QGfFJVCQAwgqyFlA==
=1bo0
-----END PGP SIGNATURE-----

--0TXoGDT0rxagdzBS--
