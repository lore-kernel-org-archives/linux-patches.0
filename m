Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921641E51D;
	Fri,  4 Apr 2025 13:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773720; cv=none; b=EFsZh6/xv+9oCnK6E/+OvdukTjhYKzIx9oMdvUezMZOS2M70p7vDUgAK2OHidfAz2+eKV8inHDSsL/YFLcD9bMv8K/MY8Z0WbrabarWNdzFCX0YnaSmIotqAXEAZwwzU3VYtjPMV1SMxQ8TNy1XR7odOryz85G58FsNPL2G7W2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773720; c=relaxed/simple;
	bh=McFXFBO/fjaDyv2VgvFFP7wpZIRQBKaa3MLg4Pg8mzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1ywo6GKbun+ZYED334t7rew+JSeeOdv1w8XNAFI1SM2ahjRI+j1RDuGHgX/Eb/I+mfmE2aP3iYeDtzzASnDF6S+W5z29INBuRaCX4xyJ3eSBlosvTMy9tDdsSrri7KSM9Y5+V1fl3ZDhtj7dZyToIMsd5VP6cJjcVCAcfzbBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7W53F98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7W53F98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A158C4CEE8;
	Fri,  4 Apr 2025 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773718;
	bh=McFXFBO/fjaDyv2VgvFFP7wpZIRQBKaa3MLg4Pg8mzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F7W53F98kKrEVxHnhCkdKGehtL0NxVufY2IG9hVFvxCT9qULiJAJcY1Ld46WZ8FpP
	 k5Rq0IOJaWlnxxLZYST6ycQqs7KdtUiHtDiCIoJhbgObcWyiRJVbu8yJh2r6Yhu5KO
	 TWr+7tbbuJWq9Uy6SuqvgibF7ld1h/RzkpbCMjoEX4C9q//HEddBrh+kK3dr/jUrmY
	 fQb7PAdpNGyoquGPh9PV5x9o2DIGTOIYt9da2WS69SJDfD8QthKM6RwvodNitO5PYN
	 VDledQwYF61oAEt/ZXXmzp9rQruUyE1O9hfe9hXMulNkIkQa3ZlnNAs8hDmKrCvbQm
	 kW4uW15CEaTWA==
Date: Fri, 4 Apr 2025 14:35:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
Message-ID: <cedb1d73-2cb7-487d-839d-709c345565cb@sirena.org.uk>
References: <20250403151622.415201055@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NFQBCl0Oo0ogATBK"
Content-Disposition: inline
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
X-Cookie: You will soon forget this.


--NFQBCl0Oo0ogATBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2025 at 04:20:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--NFQBCl0Oo0ogATBK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfv4A4ACgkQJNaLcl1U
h9AemAf/STabfAFB6Q522b04PetWgK3vAtWQVb2xGUJmg/B3BLsWqkpTCC/ipkZL
W5uwYlzMQBhW7LQj8A3NB6WmHnkjwy5EIYzU0B9wyIMCU+vaVaRR7sO4W4DC7lNA
3fftj5kRtzWRdw7zhoCU61Fw7ELuLBKk+Vnr8liyyr5LbS63L/iwAx6+mDMXJoks
zVJFqlp+xQO5hjxFq4uuMR+PRFhPueCxFyzoEcJugbv9gMMogwV2GN6nFEOcO98i
XVVpXBlvNMkU3mEDS9CrtG4LgavMbcdr0Nt4CJpfKmoeV+M1AR3ixTtjS+gY5Cfi
mLKmECn5cn5c6v2GN7Aj1UW+m/xfAQ==
=iybp
-----END PGP SIGNATURE-----

--NFQBCl0Oo0ogATBK--
