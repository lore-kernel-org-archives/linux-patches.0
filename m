Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3CC2E3AF1;
	Sun,  1 Mar 2026 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366732; cv=none; b=PzMqcXlylopaL4EIZcd2K3l55KPCiOVYiG9gF+xGP/ce4cUsNF0Vm8sj4FGCIm2rqJPD6Rjmj2WI1WJvciPt1+P4v3Nudpi6bN0VC4gIInE6T4xdbYo2vOmySi38iREcOMO9C0rgqIpWA2a8SvltLXeBwtWIdK2pOO5hQOMxiVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366732; c=relaxed/simple;
	bh=EmRouVNRSOD6vx06R7g6+E2Cgl/f1WeQhXfCsK69hes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCiAoTW5N623c1sf6gVGTi45iYAzcMckflt4zAPEtq7LomiEs4Yl0U8REnfz5GXlEovUy4US4LB5gyO0H3EhUS2gANcEV/feDSV2bHWa62meE7l7/YXk5bM6ZFce/GSl1nYkRBh+wXmO2MPHOPus0XJiDxl9JlejWqmxeJcVEDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ol1i0IYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ol1i0IYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B54C19422;
	Sun,  1 Mar 2026 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772366732;
	bh=EmRouVNRSOD6vx06R7g6+E2Cgl/f1WeQhXfCsK69hes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ol1i0IYUuwqzKud4Zxq9OnHzLKUbaMAp6jONufS9mlM5L4RXMaDerzNy+ISUBYt+g
	 AtRT0Q54l1vtdChQjhtsGSBjkfZ/G8bgHS3PqcxOiojx4Vn1Z88w0LXKSpo8zdr0ZB
	 JMbAvh/F5MLWfbvt+WHPkQFNmFyfHxaEGmCWXkwxaeYdjJ4QmxZj00fZfoYjPUPLaf
	 ViXXENTfe51eT2l7sDN6p9L4OW98b0s9s/lgKNaTseZ0JmXJSuW3sXy/phErcogsRH
	 kTBBACkQBapJZp3PEaBFlMRPho75Ff3bSaisoRml66dUSBADJqSrWPobvrCnvkcwnx
	 +FsXK1Tg8/5iw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 5AB8F1AC58DA; Sun, 01 Mar 2026 12:05:28 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:05:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Message-ID: <aaQriDS9IOr6tI4x@sirena.co.uk>
References: <20260228173244.1509663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hSiI+JNGU8dSV9XL"
Content-Disposition: inline
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--hSiI+JNGU8dSV9XL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 28, 2026 at 12:18:33PM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.

I've previously noted that releasing -rcs on a Friday afternoon isn't
good for ensuring coverage (this was what happened with 6.19.2 and
related releases...), the same is also true for releasing them on a
Saturday with a deadline that's very early on Monday for a lot of the
world.

--hSiI+JNGU8dSV9XL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkK4QACgkQJNaLcl1U
h9ByiQf/aymKbMpYHOH7t5kXq7VbDcqodEOAGhiTnQDqkvsgK/TN1mkS9DcCmuk5
sq+lZ18VNN0DSqcWI+65B78IR+sJGVXbsT+QRSjMYOfrJ1xnxzbiUrBQ/PvKIvYr
wscF4XnEryaTid/AGQEn8OB0fOZgu2eS07q6pYUwLDKLe+fqO1lJttpCKWPZ8SB6
wPA3yoLwe2Ra5S4txw+rU3G4VYLMWYocIrbaA2S6Fns8ZsowjOvKH0CPPz8YG2dz
DBuPhhzbMcWgfXWL3PTHfkUPcCXSjNXe3AlvxrD66ZpAD7evq6L/W1HjUpZNoQna
tRPLnD1FO7lIooZ4yDEzB+3LpWCJbA==
=KVNW
-----END PGP SIGNATURE-----

--hSiI+JNGU8dSV9XL--
