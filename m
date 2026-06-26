Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AA73F6C28;
	Fri, 26 Jun 2026 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782479804; cv=none; b=Osmvfv8Lj1ipXsCYstgaiDOPKzqZ4Ttpy3LrOIp6OyRN+JqSjuinl1N3nUJpyIYd4l1vsfGno9Xld+dRBPjdFOQLTT8axCsq12oP0EwtxYhBt3alUYoFy/QDRWVFVbzM4aMR5tkqxc/9lHaVgymCsEUE9ZAkPjTUZiEgy8e2M8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782479804; c=relaxed/simple;
	bh=SigNeLzgNrk/4Fh2Jx2/cAarVHdI6A2fV23uey3gxJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoCglby3wI1qxJvwD3VnKmyNIGAt4LzOCkNOIaJIHeez8JChQCABTta+S6r+uiQdISK0EVVfBFi1lvRk5lcm6iypawcWzyTrssygIefPCmykaZ387kFtXiO/Q4OgyJ5DR0j1e3W/IBLBRswaREIogsIdu/BQP2FgIgqyA+lMZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkJbzAjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkJbzAjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A71F000E9;
	Fri, 26 Jun 2026 13:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782479802;
	bh=c8Kr0T9oqPhT+EW/GmEoxqqv6yH9I9L8iO0R8jW7+fU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VkJbzAjf4d4DcHbOrD+5GlrebGkvSKYgNlvBW0YDS9AgimzNhyWvbtbtP4ewi8Pyx
	 HilBd/LWMzssg/r3J+fS4ldv+YRKRf3xfPVUxwhI6oo6TWWmMKOt3Lsy+2jDz3rwbz
	 AG77Q7WuQaf/4z4Bv4J7y8rfeaPZWBJYk5glz3SUV5GediL8uCtu2+kBZQHjVXyAM+
	 +lAB8RiMTwkAKZcpJJxVkwJBoUA/mPfTkWpL+3ddoDJPOeHcurkeOPiqk8AWoAEmSe
	 C5LLqiUeoQ8B1w/WhR0ilzyv/1uVyewVlxFww5knRZD27et+CrKvqmeNbAFicM7/vT
	 QjFANqtQNUSeA==
Date: Fri, 26 Jun 2026 14:16:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
Message-ID: <2b5f5b83-8b3e-462b-a0be-5c3431f135be@sirena.org.uk>
References: <20260625125637.527552689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+jDoadYkaqS2kqgM"
Content-Disposition: inline
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
X-Cookie: A company is known by the men it keeps.


--+jDoadYkaqS2kqgM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 25, 2026 at 02:03:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+jDoadYkaqS2kqgM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmo+e7IACgkQJNaLcl1U
h9D/Cwf/dD5viWc0bXm5K6THkXurpXdiflXI3zelGApLoLO6N4jWYAWpg8OjyV+T
AvpD7oWddipjnrz/lYeybBPyU9j52lp+Bny6Lw5VXVdFSWZnWz5je+KKJKyUS2Yb
brCUe4UjiX+Ncz66kXD0IXoCVHG0Bwm2hSoJ46bh43zN6DhS23klV5wsWuIz3MK1
Obzquszrxv79eTgeUSYgKwEV4+EDvms3CX6H1l00DER0iRKtcEtQH7TlAesT9/Y7
5vYTysyagNKI83k05v6cERMF7IggWznxF2dONaF3SNvFdwuaAf9whpKISLH0B5Rm
xCCmSfDSszx01hBQ6VI38TDXMVMx5Q==
=WleN
-----END PGP SIGNATURE-----

--+jDoadYkaqS2kqgM--
