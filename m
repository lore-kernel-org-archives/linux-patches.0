Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B581199FC1;
	Fri,  4 Apr 2025 12:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743768119; cv=none; b=TCkrpk5himdOxo7cgTStAJOVDs+Xf8wF25mMdugSYG6vs2d57lnDp5n0Fng1Cf41pjdTOefuofa8MT6LK+CGuK09Mg6zs/353MqbOsMkx5GYFGFSL0M0BEcIVZe0lu3agvV4ljP2kfVRxVaYoeoAYMQB+4YrScVfhWTuWweVh64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743768119; c=relaxed/simple;
	bh=dv/CplDo9vNXhBqxBlkWDQ5GwazpbgFRv8Qt6GdjCS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pz3mZYwZNQh4C4kUa0jlkZUQC5jiIm8wbMu/oQUxSLeVbMuN/XsXnydsrA41UoDtH+wU8qCtO5oP41zsWP9LpV5yNtj+zGtFGNKFdVkvYihBWJXudvfsft76xIzxG5KpGFrHi47D4Q9lLSrRqKuzDyXuNzU0rTOcuAKBvW5AQ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNSuaz/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNSuaz/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E489C4CEDD;
	Fri,  4 Apr 2025 12:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743768118;
	bh=dv/CplDo9vNXhBqxBlkWDQ5GwazpbgFRv8Qt6GdjCS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cNSuaz/quXCcyL0N4/L/wwQPhwBp5xhj1UqGtpsRBDnSH+yQgXyaIpSrJHLxnKv5u
	 9m2oi1v7n1+/HNF/dkKAc+V8mh17OpE4MPY+2VqB9IDChEm2CzgjBW4c35njmkpOaV
	 refU+biN3J4kLDLbtQMs1OusEyJQbpn+h2qGtqPbMNBW+kDRmJRnGxCLcZY7GA80VY
	 Zrt5w/84N3uwVad3eBiYHy6HyuZjpnW+oDWZFnjejCZEZSUOeotBvdwYsZ4ZJ6zHcU
	 pK5kvxBtgLspNyRYAzP/6GzlSzk7KPpXTaZJeJgS4f/n/d6ktPlu6tYMzwE5X8ziJ5
	 KTEHY6zveOROQ==
Date: Fri, 4 Apr 2025 13:01:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
Message-ID: <3aa766cc-5db3-4ce9-a2a8-e4ec105ff77e@sirena.org.uk>
References: <20250403151621.130541515@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VmLIId/CJTwHolHU"
Content-Disposition: inline
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
X-Cookie: You will soon forget this.


--VmLIId/CJTwHolHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2025 at 04:20:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VmLIId/CJTwHolHU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfvyi8ACgkQJNaLcl1U
h9DVpAf9FcDroptnly+IOT4XrEO/Iwina2Arv34KCwvPEvvZ38rS7LIeboLGveza
jDgmd5JIs41xREhD8Lt8eM7n49x4UBqUk3AY6iPTwFam2XgzjeVhaqTGCDEMk4F9
xxp0km74vf0u/Qu+ZqQAsQEwQC6D3nN4VSkC1AA60KfcQXLHXxb9gTZvvVjkjgMo
JtwVG7FqXItNQrQGC0G0BGrZzyRT7fX7Clil6urJIbE/iQIJd//bf6qVdA6cCGn2
U0hWme3X2b4gBsmbhMWAkTX2p1OGIHZP8JqtXDqYneJgOvnPlICJQucT+CdSVX+2
sqjH6d+28/p7ujru0p51vOLI/Dntmg==
=l+bO
-----END PGP SIGNATURE-----

--VmLIId/CJTwHolHU--
