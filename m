Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EC01F4E37;
	Thu, 20 Feb 2025 12:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740056133; cv=none; b=vAbK/J+pwyk6p/KS8tcLwrSQP4hUTsnQ2+964Dt/8MpW0UhH/+62/6rkql1rQMhGaZUabM7+Zk/iFWQSo8+lucPS+Qq3S5eU1GkM5CeVSncZoCu6P75r/QN9ttCfbF0pbMeWdjtYEfU68puYy+lqDmPCc/GfAEP8l97kwcHK794=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740056133; c=relaxed/simple;
	bh=Ki1S5Wm5Lpi3mF5gV4M1NUKLNMD5/yyfIqIWEyP1NBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2pDg9TRjCRgYSNACTDbqUAjjmoSAaqfgKaF9fCZfe0Nq9dzn/L5RRlrBhRzQLiChpegStcar820oKdeJVibvJYj9gW7KWFy6TA/whYGtrjJ8Oa7zPHlioPEG139knuJj+Q2lkJ71AHIESif/QEuu2GySPrzw237d9JFHxPjTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UicTgL8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UicTgL8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE316C4CED1;
	Thu, 20 Feb 2025 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740056133;
	bh=Ki1S5Wm5Lpi3mF5gV4M1NUKLNMD5/yyfIqIWEyP1NBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UicTgL8UlZ+H/Oz4R8KF69TxSKeXVcXZarN/U4ddOONtcClp/w5TdVFt4Wug8K2Sq
	 PGTuOBECPSHbk2clTrnqZMdCz2i2L4Qk7lKIliWTb0qVZ3Z+ApupU+oovWuyHY0Q6y
	 wJBLM1iVKSXqjn3LBqvGucMHV/pz7dcZ8wGhszhlxF0Jlt0fI3up65fgwR/kjsUbWa
	 sgJmt76WRkObjj23iWczzwdhXc2kfOLMBPG+bUYDjcLpnIaMgvIYKYkiEtt2vIm42f
	 diXkyJ90Eg5S9caXKbccmzg1hapr/IG+qQ8faJN7a9UPssvI5Z+c9AFMwBruKcLBr5
	 Jy400wiY/BfWA==
Date: Thu, 20 Feb 2025 12:55:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
Message-ID: <Z7cmQRwYhbCYG7Zt@finisterre.sirena.org.uk>
References: <20250220104454.293283301@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LMOhex+tqeyGJ4Mh"
Content-Disposition: inline
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--LMOhex+tqeyGJ4Mh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2025 at 11:58:09AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--LMOhex+tqeyGJ4Mh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme3Jj4ACgkQJNaLcl1U
h9AxSAf/UB750crjTKHWIRF939HiB6PWUTrHkgF6GQawgJIudj++blI9vgsvxrEj
bzywDTzA7oKtJtsLoerb4wPlTF4NvI5UBBbwv6CkkYXh+5fbagG20g10hggHhJ3a
vl9TUcNkjVhHIXBZD5olrxuYWLsbE7hKVyfD9zzG0FGpAuHWsQdb1rShCg2y6sha
NGPmdSvFKwHj4VgKRA/0yS0slUcYFv5aaTHmTMxcf8GQ+vbi67IPSecU/yIy8SCr
l652Rrg+8wpHlu2h7m8VNKHTzvhkruecsLG8ZLbO/J/brYM399aacpgvjEMgn0dZ
yN5z5pvZHwXfCQiAdVb3aMsR3vqqYQ==
=6oEc
-----END PGP SIGNATURE-----

--LMOhex+tqeyGJ4Mh--
