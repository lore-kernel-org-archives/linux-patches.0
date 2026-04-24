Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87EA27FD74;
	Fri, 24 Apr 2026 21:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067535; cv=none; b=atctxRUlagoSvvNC3+NgeeI0vFt9sIIaCDzZNTHQraFfhwd7mjASHFdSXFQkV5K/otYrpkMm+6/QNGaWb7TUVS2p3R8CalHM9IESV9MtyDPbs/D/UgGbvnfxqohu0wDBI+60tF0ckL94kxhUbivtNEGpnJBfR6/4SuBBPCkeAH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067535; c=relaxed/simple;
	bh=9ay+fTvV3IwyByZ9616uuMUpcqn1ClTzkHwYb4hki/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=foKMOixnEI7uY94kFgMYG5WjJxKMGsobkXyB3sBaT+a85wgwryP2eKgNf92/1p1sZwX9P/TTaey1ezEP0ILaXHCOY2ktjoypbCn7MX7ilxuxEoGEHS4ADKBgfdMMw/INTGweRlB94umYJYaLYAzROmVt0stUfACEx4L4qw5idXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWqE2xNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWqE2xNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6A8C19425;
	Fri, 24 Apr 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067534;
	bh=9ay+fTvV3IwyByZ9616uuMUpcqn1ClTzkHwYb4hki/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWqE2xNIWqApK05Z8P8yc6I5YGcfdIwfOalDjSYsKJ/cWz1nRdQxhtqjtnw6E5Bbm
	 oDN6y7zTZDR0BSJRrbnaMoOGLbxPcqsqjhoGICzzvHvFir6d4cI9izqdOTgrUmZbUj
	 6ab+nhrj7Nq8bitLWYTyr2EoM98nn64Jo6ktZXaixSqeEbxfZer+GbXokngaT1fs/z
	 L094GwGbMxrvx++mQPxfBASqH2eegf8itplnPFqd+eDf+BYBQ/dJMDixphqmIyiWg8
	 lQTvs6+kmjvf/ulU65KR/mU5izCrp71iS9DocKBe80JDissuJat0g784iawJJGJI8j
	 H/eluPLT+eZZw==
Date: Fri, 24 Apr 2026 22:52:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
Message-ID: <5d112dc8-f133-4deb-8af7-804f56079aea@sirena.org.uk>
References: <20260424132411.427029259@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="il8DkikK2iiI94jo"
Content-Disposition: inline
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
X-Cookie: 1 bulls, 3 cows.


--il8DkikK2iiI94jo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2026 at 03:31:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--il8DkikK2iiI94jo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnr5gcACgkQJNaLcl1U
h9BU3Qf+JGJv0Dow/Ffy1ZRPEO29XKB9rR/TTCI1R51aRpGbDY60HxGouEjuBPTN
ZRB/CypmTXHC00ZR6hIINuGtP5sQQdTq0NNbHGISRRzkra6RuXNzAjih6eBRMIS+
ujS2tkvovME0Uxu7XtLDHqNbom/aAEjMoCcBtDo/qSYg/shSofh06lMsZXrFzNou
nCDDtbiQdOTddWbkm3FXK9Ar8nd8OOKoy77x70zoEE9jyIC6uIsniG8Hp+0Gg8Hu
/bRZeabKcsmH/M23L58NqA98GqfqOBMIzHnzO9zJdAxzIJ7bWb33TprGtAeGgQcF
pIla8azkvMOsPZHKGqNNns3CKrqY5A==
=I4oW
-----END PGP SIGNATURE-----

--il8DkikK2iiI94jo--
