Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE473368A8;
	Wed, 15 Apr 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248004; cv=none; b=uRqQTyochOMpLxTyAtekH6znN0770Ww+xLya8U8bF3u4cq2HVwFcNZ2/mom7ENvBTXg8M+/qNJ5fuSnkFZBq2q+ugykvdo02/myOQUv3pSB7B1qFTJXl+Ah7GruXrrfWy+hdp4K4zK+BlhLkCpf+XtsROXAIlE+Bj4xwWCrnIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248004; c=relaxed/simple;
	bh=Nc434+V8OPsdB8zDuCz9G8ghXlaobto2+nC6xonsDhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTiaLVNIVtpTWosH+mPP6NvBrCnSjpwmPttgBMokF7071OdHlaJ/zbq63VxbzdxprJzOF2HCBvJ04oTKOJZlWz9VP4wwroom2ETw88U7Kd2yMTvx1/CDW9kzc/7tMaobmMokJ7+73wEhFGW4oaD+X9gAtZjck0eMffbMAu1+6Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoP0qbmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoP0qbmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BFBC19424;
	Wed, 15 Apr 2026 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776248003;
	bh=Nc434+V8OPsdB8zDuCz9G8ghXlaobto2+nC6xonsDhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LoP0qbmF7tkwN/iRqIJoxAOd5nljjwR92aPThR6HO376mAYLFttoFS432FsmD8jty
	 K3n0deTZQUs8M1pA5dMvwE1HjnXyFkgnNJM6LdxdFjEde++e/VYo+hSP2BQgUa/K1B
	 GWsgbALzve2s9RjLgZ4Pf8ssHvwO1Ddl4utJvVd/njhBdMKZceYnD2r64fIF9wwoyL
	 UVt0jPp0C1+u5aOvE4mnArccADEKjYrNsiszYjBsk5cu40aGbtZihVTxJtmrTRjqVl
	 /msGSUD+kveAe30aY5soRf8Ar4k33XW1ln45i8muMd9btUA7oSqf9n0ynFSkpDZdm6
	 dkgJfVsR1xtfw==
Date: Wed, 15 Apr 2026 11:13:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Message-ID: <286134df-e28c-43e0-859f-bc2076395960@sirena.org.uk>
References: <20260413155731.019638460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6DWqVR1nLamoZeyS"
Content-Disposition: inline
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--6DWqVR1nLamoZeyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 13, 2026 at 05:59:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6DWqVR1nLamoZeyS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnfZLwACgkQJNaLcl1U
h9DmwAf/WG8i7XvVyfdRQ2nkaITuTtwXK6M0uO03TseI3ydOPX/hdHbStB16GdwE
sDmeIG3W9UJQt75s86Qn49hD9Hr1j37Awkm5dt7m3wWpFkgQ8kQx+4iO5xM+mBVl
5aOUndB8I5HDfZz85JlE3r1l+nGxjJwYUaeTSgZeIUMJffSFIqUBn3A3aiWfslOx
x7fzc5NDk6t4cNI24Rj+39+8t3om0DzGgjBbxmbXBUstodfuHSsQjRZ93RwFd4Tb
m/9s0nqJGmhPRzYsld7Ibr83DQuwL4OnjTJDI8HYeo1nsgea6WZEeDtMz2Gk2i/E
p9GzRyVmRlrTS6dEft+TkYPuAC5bIg==
=006D
-----END PGP SIGNATURE-----

--6DWqVR1nLamoZeyS--
