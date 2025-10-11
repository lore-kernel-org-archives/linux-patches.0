Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717832609D9;
	Sat, 11 Oct 2025 10:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760180320; cv=none; b=DRgBASTh2ttzI2amIOSBK/YpK2+Extw7rzAzBLn5d8X6htGIX6im+PjYKhDO58rpL5sPbvcd/6j0ZuxuXMHOGMgFjorbwbnEq2eJxPVe2U6J3aMToFEoaspgFY4S6Itzrp843BMLgI2q8NBINPASfP+fVA9hF/ICL8g1QDuw5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760180320; c=relaxed/simple;
	bh=gKzLw5WiDHoxnaijYiNZW+6p1FnRihU6FQJfeqTadHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjJcr8+Ox8tXAp1rZxEaT/PXVCHluhoPRSrpIBQa5fVwxBl7Q2LmvRBuP2/KMStAuJxRjNhVlUZDXr3/K1IJH+ofhVygGyj1n8KyZeOuKoXS0Xe/iALwkwsAz7PkOB2qkVArnh7vaowjNcJrCIvmxBTKfBFUYyjsplvk1g4UC5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGfz06Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGfz06Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C68C4CEF4;
	Sat, 11 Oct 2025 10:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760180320;
	bh=gKzLw5WiDHoxnaijYiNZW+6p1FnRihU6FQJfeqTadHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGfz06HvWzAPKav4InSAzm/+y+awRDzM/ZWPBgQEOWFjSRffJmlWE1K0r/m6NHbJ2
	 wJT5Ir9XXqCD2GgsUvuNqMqyq9pj/h7Mp6iM0TcvN1OsOVjDe7++YPwoQebacPKOmo
	 JeUtP2OttZWw+aLOiE2rv3/Sv/bIbS/4xME5acFIRvATvdHmGQdqP4XXDJ8171gAIa
	 YrEjHStLSc+7iqiSxGtLFo4p8eQYOammEN6IRbLxXIcB6z61zCeRkjtXkhqjuGK8dk
	 nDjgjPP86WDSPuhEP5zEeaV167U0ivrI3u4lZlVt4jXvmxGVKefmfph2KF+8yTLV6O
	 kE4i7F3IvmbgA==
Date: Sat, 11 Oct 2025 11:58:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
Message-ID: <aOo4XZJKLSmbNO-8@finisterre.sirena.org.uk>
References: <20251010131331.785281312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xSGS5eN43E63Hjrv"
Content-Disposition: inline
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--xSGS5eN43E63Hjrv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2025 at 03:16:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--xSGS5eN43E63Hjrv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjqOFwACgkQJNaLcl1U
h9AK/gf/SaWj81AhU+6p/4Ne64RhrBIJUek3HH7Cb5zxgbFR/ZtVsWNo+QmhJrPY
rxl66ROHZxHOe9wFsK5Vm5ZJHbZ29KQNysGXQRsRYJPlCV4AvGN7Nj0zW0SBwPcy
DGVRhDKQRubbSHPYHZdRca3TER28OR1KPYGQpLhGwkPGlniyhdSjxL8XbHzM6Mio
dsItvxOS1S7BQM+wCESpEfcDGsR+vJJCQoASrcVX2FgiuPeam+tgIFVNPPNGuir/
enDu2CN7EZLXE2y/DXbwFEPz7yVnevavN53KJFvpOKdu4VppIsnK6OBP/jbM4Ro9
YmVBnywvTZVA6orBwfVw7JneCmbS3w==
=Bjyw
-----END PGP SIGNATURE-----

--xSGS5eN43E63Hjrv--
