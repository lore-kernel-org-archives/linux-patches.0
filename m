Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C28825A33B;
	Thu,  6 Mar 2025 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284633; cv=none; b=P4sc0HwWB8XEtAkAxiy+8wlcbv4uxnp0N/WxGVOXYcwS6gkTHYzBkFeFksQztIx1mWrlM4S9dOxBBIOky8fJAPkU69d7ZcJ3Gb6Rivifj/wDqaABqHQBji/FQGknow+t5KU5UYmRxmFAZnKsTieBL9FDMf+sQ2Ug07FsWYj0goA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284633; c=relaxed/simple;
	bh=0+t0/Wiubl18NtyqggOBMGD38rStK0UA2rq7DuHecmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnENP8h/sqclt/0ThRa4PLRh4KYchqHx/j8VdlajA8rkBrM24NIgH0k4HWrC32LMqhGZq+I8l6E7YJFA0q8na865W3/6vWI958Gkrr3+BypoENpXqQ2PsGjDs5iU3CtAV1Vmorlll2UdEEAPxFeORHKv7k/BvtZyZ5AEcPBkoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL76sZxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL76sZxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87C5C4CEE0;
	Thu,  6 Mar 2025 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741284632;
	bh=0+t0/Wiubl18NtyqggOBMGD38rStK0UA2rq7DuHecmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DL76sZxYRMFsRk/RxqjEh/Hoe2pN54nK0XfS+TvXIcGNcdd3rU3mXurFFamwm+eh9
	 Ekzh2SqomNlM1wkzeVcT/1VQ2KIHEH9ResA24dCNOJdM2tBlAA2jfMFsSJ2lvu96ZR
	 gtl1h8gcmOCwJ3lp33VM6m/YZa+Jtz+IjtLls5abTDFG09R7AW2TqU7XtWlQzql/gj
	 GGnQanZfHL5lYewmTp32cp7xs+GWz8iqQ+ul9APLScK2ktaDcaL6yI+kCWpQzYZ1KS
	 AjgauOru3YPZGUTv9v6uEREqUWe5Q9XZqbBA8xeU/ibLqwPZnAfNWFe4kXFc58DFjP
	 8IuusdSN65Jkg==
Date: Thu, 6 Mar 2025 18:10:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <ff2afd31-8414-406f-a48f-58e333c6b60b@sirena.org.uk>
References: <20250306151412.957725234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lVSxottm/NrMV6nv"
Content-Disposition: inline
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--lVSxottm/NrMV6nv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2025 at 04:20:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--lVSxottm/NrMV6nv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJ5REACgkQJNaLcl1U
h9AugAf9E6wqgsJ2Kaf2o8gH2g2sYdQ+qDsAZ6mdq7CxNN+PEHz0Sk/ILZEaPkNU
XNowHbaK9vUVbOAr3YebZzZPuCQb0j13Ebn5bi+MmxWkitgTre5cRHHhksqy1590
0UGcC/mwhLEg0a4Gd57jz+WatHM3fbyUNNogEV0zlaL3uKwYmmL2nNZedqBjS4zG
LaCpI184erbGaCvzelVkyMczlWCIYCQz1f7i8vkshFSbR0QbrR6zb6Vnsdj+h9RJ
BjBCRYBtfQpa9AAgme16EOMloqRW7uZBkcLQcz8AxJGFeeAa30s9zfbE8bMGqNZq
ee5yZHAeR5DTqA55z6HvuUYhxsT9fw==
=rSsV
-----END PGP SIGNATURE-----

--lVSxottm/NrMV6nv--
