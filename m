Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E217FBA2;
	Sat, 10 May 2025 01:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746841334; cv=none; b=Of3iGyNg5LESzMO5BGAeDwKKFFzmLrhjJcUE6V/eSa3p87OT92ComMTZOzQbZQMtHIwJpCldIbnEX+yDBKcQWt6M7sPZ499aWLm351jKJ1aXgRn69ygfxjphzhDxhyBnI7iPyuggBqz2ufGd/Y7s6mkLBHYQDBexit5v20vuuL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746841334; c=relaxed/simple;
	bh=rvu1QkRjTpDPxS57Chc9+LRRg46EXpraadaKbzaVBCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sx0rPIr9akygWuUMGaOgnVOxIWKl3fyhQ4UC5bn6crNMgHFvJ+gn+G4AO4qyRZ+6H1ojgkjiZIQ4IzdISBUGSRydnn4yyKrjreG6Lk/PMgSJ8LpceMeTJL7usNU0STuKxhsU3G24aneree5gHOlrCNv7q8qbBbCgXdq7D9xGhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGd2oK6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGd2oK6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D24C4CEE4;
	Sat, 10 May 2025 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746841333;
	bh=rvu1QkRjTpDPxS57Chc9+LRRg46EXpraadaKbzaVBCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZGd2oK6y7UpQRSPG3zAP9Q1/9H2osHBn0Z9R6putfml9yjmR8gzdu6iACNM60hiXZ
	 z6YOygM6oTJhsubLgLHdWqiYiWwP1GII2VaURGDhKwVGj/q6r8OGEyKmnssGA6UX/z
	 uuu03mtLZkNaZTJatY6LrCQZAG7HUcLQ9W06nBBz9wBqkjsjNj1Rwo3darokrAG7l4
	 +o4VpBR2Ln5Tn527vSm+KwDhz7NQUPNjCx6YimOwDaKAYjSj4mV4b1RtwbdrJsDu1E
	 sWPAInMdeSx78y2aoTIP+YGUJ3ujYbWSCb1lIwRW/HdmAlDE44QbiN1hNf9Iz9+cJi
	 sTg8czzuC+mYg==
Date: Sat, 10 May 2025 10:42:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc2 review
Message-ID: <aB6u8hP5nbNKBBeH@finisterre.sirena.org.uk>
References: <20250508112559.173535641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2hdR6E368yeM8axJ"
Content-Disposition: inline
In-Reply-To: <20250508112559.173535641@linuxfoundation.org>
X-Cookie: Well begun is half done.


--2hdR6E368yeM8axJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2025 at 01:30:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

As mentioned in reply to v6.1 this breaks NFS boot on Raspberry Pi 3B

--2hdR6E368yeM8axJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgervIACgkQJNaLcl1U
h9BNGwf7BE7dJQV6IfhGwK4pj/49aoENm4cYEhQy7vxevYDKG8uBVXPJDfP10n4t
aEFjmj7EL7/KQ4dZyRtxuZ3hmSaV08WTgGZTBluSwnB1SKgx+h7MgNOvmMjFQ0YX
immW6D8FmgkZ01ABaALzn0Xni4xVbwRxOv262Hesh6PTVtl6wUWNQIZDqYC6KTEx
HPNdDZt61nrLuhefI5Y8myZQ8I3k9BgTSXyw23fMsWHgFikNwAB6WbxfErKgymJD
XTzFkoT3FsSR6Xqu9yji2CkPUGJM1ec8jlaLNNWoXPX2KOinlzip4eAeRATWYtTB
dFVc7WFpbiFZasNeTxrhJ8oYK1xA4Q==
=/Mws
-----END PGP SIGNATURE-----

--2hdR6E368yeM8axJ--
