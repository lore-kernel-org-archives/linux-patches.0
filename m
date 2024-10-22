Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7951E495;
	Tue, 22 Oct 2024 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602018; cv=none; b=cDSFfZKWAwh//KALQes1IxWFZNZnKZBn+n0g16oCn6kVg8y0ZPFxUSIGYcVz8NZODs4Bsq5QDIWJxDQsAt7+bOKRgmeR1aWZ0BoATLKOTWP/SnNFIw592rv8rV+AnOvJToQAy8zaHt9kUQoPX3EA/nNoTq55ryuvKmPKUlfQDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602018; c=relaxed/simple;
	bh=uKzXMbe16KIWZmSnFoGuwAShNPx9d/wxSSovv5czmoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQ/RHk2S98ethAUX/GuNoRJaBiQrEW1SX1ZH0fxLLW/lP/DKdJJb+W9SNyPECyX4aDYiR5AIFb6gF3nTuA4Sp/77YvmVbsyUav49QqnGlzmvxHU5Ocrrd4P71yh1YwhkjV2qDbI8NOUTkgTkUCD/opko2iu8DpBPRd+dKHIfOMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtyRy38/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtyRy38/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFDAC4CEC3;
	Tue, 22 Oct 2024 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729602018;
	bh=uKzXMbe16KIWZmSnFoGuwAShNPx9d/wxSSovv5czmoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EtyRy38/92geNhBA2md1zSRasGQLIbFykDeiOnhkZV+OIqj+ls8FJ/KxlwpvQutu5
	 RKBmLcHN6P7EVrEa/gSxW23YMeJWPIvM4cd5Jhc1PAj9YBefdPF4GriiMtpSD3XirP
	 KABztTUHrDonrO+Fd2C0kE+eX3C247mi05CYJVCi1T4NkTtsfw2gXIkdGTNsWCotG/
	 6vVtqjvUd4rkBvuZCxzLvruKENzA7fjapUHKBmePGecCFa7bCZfFg8hXBP1y2sy77i
	 GCEmwEY/VW/hBm/5RgCm2NtL7nj34rcU8i5DCdJv1ZbvuFswSfIyJc6R0HpdC8Fgc7
	 i8wcJk0KNRd8A==
Date: Tue, 22 Oct 2024 14:00:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
Message-ID: <13cd399b-3e50-4b86-989b-169584f80f15@sirena.org.uk>
References: <20241021102247.209765070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mJ1x2vjxfxXkt1ad"
Content-Disposition: inline
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
X-Cookie: Surprise due today.  Also the rent.


--mJ1x2vjxfxXkt1ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2024 at 12:24:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mJ1x2vjxfxXkt1ad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcXodgACgkQJNaLcl1U
h9AB4Qf9ERZ/7tCP54oKOYgWKbM2JLWl2aKO2Cgrr5iBR+LGSz1g9uJk3k0vhZAD
OF71pbwVDBGespHGVCb7Qf9NeI3SYgAvHVCrh4v2iUzHMy82K/k0dwQj0Hviygmn
LRNGQVcML2ScBVpxOEeT3zEb4bAkQ8dz9xSJz0chCx/HLIh+eWxXq7MeYtCUL0mi
kfyt4mHPxvLRsWqxhI2GBGKJueCHlP+Lm/2WXxNYzFZ6+ksKQS4cKUyAr6MU5Zxr
VJtt4pRvk8FF27dV1kGAIjcvtGe6S5BfgcfM6ct4P02U0wxpXVs+x3ff2u0H3dto
/OfYzUad5U0nfQu98TFR9SFaDD/0dg==
=6+59
-----END PGP SIGNATURE-----

--mJ1x2vjxfxXkt1ad--
