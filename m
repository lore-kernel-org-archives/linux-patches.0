Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C6619D896;
	Fri, 14 Jun 2024 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718374439; cv=none; b=YUPiTDYUg86ZOiNXch6h9xLLxsMsXEFWz5edr/0CENczeTnJ4sWg7Vukz+hVDZn9NeKL0NGRJr9DiaxvMS69nl/Ve9Q1db/D9OjYQ/X/iaLnREC3dZmOTSQ0D/pLVU2ehOzE6QSs1pzz7CMbBry0iakzwKWXj6wzYRmLK32hX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718374439; c=relaxed/simple;
	bh=M9p4Rb5NbOm3YqzxvoVDROrlSKzQR/iv/IbVSotVXcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQAumlzPxeGJg3ghJzfuge9ZvBtS5JW4CCBCNrxlFynRkr4XhmTMqUu0GRpWtqk7kRpUDeLObT+y9NELm0pPJYnBZxQlGp0ZzwlPsJnh21PC7dVQo7/H0fT4P11iTTocH/yqkCfh7GKd3s+CyZrSIcdmDUag/8MkOQ/w3h7n3Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiHhH8vC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiHhH8vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D62C2BD10;
	Fri, 14 Jun 2024 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718374438;
	bh=M9p4Rb5NbOm3YqzxvoVDROrlSKzQR/iv/IbVSotVXcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiHhH8vCGXqffL22JNKaALHRAiYalzgRBefc/RqF1SXYYFUEhIGAZrRaGO5tsxH2k
	 oQUIuR4BqEuw8f1uPoBmpmctxQer0omTEb9pc9nTU6LsW/6u6FVqOs4KnCR03ZNqPO
	 4scwBOhW+JDwvQhvMk9WT5dnMQVImWXf5zpOQqyN59wVVA5+qr3Uop0v+VHSvUCHkV
	 O4pJ6MVZkTbQtWM+O1HxROkoAlbyosHSojPBsb2FUaBxwifg4SIeKDKP3gj2Bgvdnn
	 2URrNlyZwO+rKZs/frcsphHIi/Q6kqr8LU0HcpiH1mp+vDS63RGp/jOjNvbFCCy7Yf
	 SaRDf8FSSgbbg==
Date: Fri, 14 Jun 2024 15:13:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
Message-ID: <ZmxQIbFFR7yjtpub@finisterre.sirena.org.uk>
References: <20240613113227.389465891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FmHvlFy3Ptj7g0+I"
Content-Disposition: inline
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--FmHvlFy3Ptj7g0+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2024 at 01:32:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FmHvlFy3Ptj7g0+I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZsUCEACgkQJNaLcl1U
h9C4hwf+MgE7nR5nSEqvUIWKa2/Q6aLzIhlWIXZ3X5VOyTN6K+skCvhTBvaQewsJ
30/U+lqWHbixdg2R5px0nggb97OQ0Stl209GxPbsmRcI20fsvjIgO5NDcFHfCHWT
0uvH3XtnynwAuVkiSTzJtrPhmbo9CXBLp4mQa+QmHccbUBt8SDLlcDiveCM6P82W
2vEIbT3iL0+03bstRt0LA+2ze7+fmortNpUJg7nsqhgy+EyrWi6M/iu93APlABL+
mJTCcQ7GvKpdUmFoYklhmkJLxJphq89SNPvVLxf2PSEg0CtXJRR+V5zkRhn+SlnI
yJKIaAx2ik/VmG+WllQoGAyLkAETbw==
=x8R1
-----END PGP SIGNATURE-----

--FmHvlFy3Ptj7g0+I--
