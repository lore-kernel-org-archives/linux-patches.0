Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC7500950;
	Sat, 10 Jan 2026 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768044776; cv=none; b=oChfeott31QbOzdiJ/KOMAeRqD2q0GsFttWUFg2VzmU5brFtOYUtwCE42U1rlNbnuWT+/neF01I1bFb8EdqYZCd/uvBDQISFNCRee+QvVKymtsG3gkBn6BqrV6xJif4frAFWeLo5Pe4bjyThSJjgdJPJ3BbkOO9eC/UcPEjHDkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768044776; c=relaxed/simple;
	bh=ImviBO1gzgh84TQ/0QMHAi8B0EevpuI0v2ZZua5MrOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDOEr1Q9u+b7+I4yzjqZBZYQ5UoRt3wTgk8joQ5T2LQRFRv+PKMeBaw+t01NLlG+GJbUA7X0IvS17nh8KaBBdzTESQVt9qip624KklHBi932kYtBFLsJFA03PC1gh8Fj3sHJsdOOSL1Ihs2PwrTjgPqVrFmvlK013c6sGDUuFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+PG7DwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+PG7DwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C24C4CEF1;
	Sat, 10 Jan 2026 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768044775;
	bh=ImviBO1gzgh84TQ/0QMHAi8B0EevpuI0v2ZZua5MrOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k+PG7DwHHHdq3GbjM5M18WXikwSm1VO/DvOhgLTcdpR8nTZs1pRnfz7wcPM3Su/yc
	 4TFtsk+NHUhnjK67hC08ExCihul559fC/wECNxeQ0Q/nSn9fLcTanzDznIes3ar+Z0
	 ZEmWmwoxnTQSn57nMxF9oyRd+/ICPUXB7b9CHo8q9GrIFOHgdCKCz/SbIJM0riaW4P
	 o0P60L7nvmrlKjJJf1vXB/qNN+cjJruoWccKYQuUrasER7WfgYmnnT0c+ABC/xqeZB
	 jNrv9/JarxZpdOOjUCgVabn1UwuMPeKEXZp2m+VVT0JVLw/NkR+FgD06iFAJPhvqus
	 3igHnmMcq95sA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id E1A221AC5681; Sat, 10 Jan 2026 20:32:46 +0900 (JST)
Date: Sat, 10 Jan 2026 11:32:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Message-ID: <aWI43lUAfpKZWSx3@sirena.co.uk>
References: <20260109112117.407257400@linuxfoundation.org>
 <20260110084142.GA6242@francesco-nb>
 <2026011010-parasitic-delicacy-ef5e@gregkh>
 <aWI2qATUQXAW-Bxx@sirena.co.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="K1BZqasimeJ/7DZu"
Content-Disposition: inline
In-Reply-To: <aWI2qATUQXAW-Bxx@sirena.co.uk>
X-Cookie: Save gas, don't use the shell.


--K1BZqasimeJ/7DZu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 10, 2026 at 11:23:20AM +0000, Mark Brown wrote:

> I'm also seeing bisects of similar boot failures pointing to the same
> commit on at least i.MX8MP-EVK and Libretech Potato.  Bisect log for the
> board Francesco originally reported, the others all look the same:

Pine64 Plus, Aveneger 96 and Libretech Tritium are also affected.

--K1BZqasimeJ/7DZu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmliON4ACgkQJNaLcl1U
h9BxvQf/ZnwARKESIoywaVF9tL6hpX2P2oeHyaZR6fbN65V3fBwevgmy8kCdnfoN
WYYEQFPVeGwVdiZCcbwxuLfAP1aRSCmU9p2NE5IklRP+Jx5MRJv2MyGu2hffiZWf
BDORUWUBQwQ4t+9zlEvGuunSIhR1HKJCj/w16MRdxslGs8uMdZa2lmaDxMYvujry
ai4jgeCeHaCo2RH5h5trAXH1avytG052YRVcjtV8aplq6zkcyL2pYYRVrTD7jQRZ
XfrTDUQUkKgts5jU7ca8HJKbADi2HD7WKQcWPb2ZPLCIxfqiH57647ndQYc8xxc/
Rchm83DQnTphtNbKUiaGCaVPlc0h3Q==
=kcoy
-----END PGP SIGNATURE-----

--K1BZqasimeJ/7DZu--
