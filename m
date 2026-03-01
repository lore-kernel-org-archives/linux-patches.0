Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F62E3AF1;
	Sun,  1 Mar 2026 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366881; cv=none; b=oqNMbxqIs6T6lyBX5Ni1W4Fhc4zL7DVdTkcSdnAsIaBILnYc/pDTa+majGZWRWt3xNl8Z+J06EY3G3f2bhTp/5KKQ1kZDIFBF0nxU5gC3LMoHp1qkA1JP/Eg2Qb8HRhKYEx33advhAoPGj25aCrHjjO8sxPAdFQe1+CCn0wxWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366881; c=relaxed/simple;
	bh=2jefnet1D0nqNRiCML+UazHasL+K6GoacUwWhUkt8wI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onc5Ki0HnvXrqc/z1+ZapJYtNDHwiB0pbtdVYjGxPfbmHA2+EOUSSMxK8P7i9599Hcv33duLqfyw2UcuGa4a+rYiRKoem+e1iV8oPA8P8t8bEXpv+bp1tsIfN+P2rezRYTNfRlihvXYV+se3l90bJSyijWhtQF34NuQr5TTsUAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apeiXLIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apeiXLIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EDDC116C6;
	Sun,  1 Mar 2026 12:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772366880;
	bh=2jefnet1D0nqNRiCML+UazHasL+K6GoacUwWhUkt8wI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=apeiXLItGM3a6587inyfgB2lq357rKxAoh8Ou4Js1FV8uazHBryBVSY0EX9vdqctN
	 YVBSCwzCD4ZilKq02EzM9ME9ycU+X3Yn5eA+jD6F02UkaAPIgSgBb8Plfj0qf/mt6G
	 JfM0XY/akoHAnF4uDzgs41kccxCkhulF+VvNTYBrCR3nwTp0drvLS9nLvtmyhr97Sp
	 0qDbm82qUzdJQoYphvwVWOOGvt6e6E4DW5+qW1lrdob1d61sHH5g3Yh+XDtR4y85jl
	 L/V89LDGLyueZhAj9bj52r0GKEGeb6EtjSgnxFGAxgQnEcD95dmZ3svBJTNJ0ULvr5
	 Ob1ivtLgvAw5Q==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id B677D1AC58DB; Sun, 01 Mar 2026 12:07:57 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:07:57 +0000
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
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Message-ID: <aaQsHfE8GKbM-DfY@sirena.co.uk>
References: <20260228180001.1567994-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DWjrPwctpIGgpco7"
Content-Disposition: inline
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--DWjrPwctpIGgpco7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 28, 2026 at 01:00:01PM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--DWjrPwctpIGgpco7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkLBwACgkQJNaLcl1U
h9Di2gf/fPScudjGdjsJq9dl7cX84NtVWGdgfW08pA3OFr3MPgMg8kOQGND0WWFt
zEPIztjhhcVE9XdZjItPAVqDOMm/DHNpA0HCyF9nROhg99yws8UF25uLas2iZmMm
REEFm8Px1PXTLkqSd4bWOHNrlt9TEtxEyrchy59WKzDCNHXtd5oOHkj3BwFil5kP
n7MJQaLOZnQr7+/ym0P+e4iGZJMKQ0m+oH/6IySZ0yrLHgqHfMf+tpleaPY0AIJ7
+6lPxkWtqOSXPxjFJikNUpjSs1veYoBFkMI+6AgVR0HeRwNbmOoD7QJN7Wy+xPeH
NPDw+lnNC6/bFA/Y8MQg03eJIT18lQ==
=voXj
-----END PGP SIGNATURE-----

--DWjrPwctpIGgpco7--
