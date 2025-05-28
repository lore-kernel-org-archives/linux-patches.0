Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13037125DF;
	Wed, 28 May 2025 10:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429512; cv=none; b=scc3u0Bao9cjO3DhtQ1CioHkiOaKLDyO8PRwvVv4AvYQ65U4MjcUdE/BAjbA9h+iLT3VbNAuDksOrAbngmcLLhmluSumqZdGp6uQfYZuOqyiZWnC9Xhzj20AphPAYggr5hbvJiBY1Kse/cTgVOV7mOG0E/NsBfQ9W3RYXrVcfUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429512; c=relaxed/simple;
	bh=DGiD0iXP61/+ebn4lecoWs4ajZss0Gh2uuwXmxsS/DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufgKAJroVKNXBSGKceAyp4r+YOO2X38LeE48vrb4hd4UWK+XG5au9ylwIa2qA8Zx0v8Gx/C0y8ptFfHW7bpgtEImdbcKPqQx+trL2WHxY8hxoitCoIAAC3ZoRY5YscKECE2SWaCJfeIHZDBSmutstgv1fwO89PRx8d25XDapwtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kz6xq4ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kz6xq4ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080AEC4CEE7;
	Wed, 28 May 2025 10:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748429511;
	bh=DGiD0iXP61/+ebn4lecoWs4ajZss0Gh2uuwXmxsS/DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kz6xq4yeKMfNdDgKuS786STvdNcpc4G0/cFht8HK2EjLnv013A5yoR2ccVZtkbTBr
	 KBRDBCMBXBH3pb1njHwhwtrzDRSQl8sGTZ1t2oM4zUCbXOLFzCSTzTIVx1gmmPzBVu
	 lo62sfGgpt/jv1dwC5LqplNdGCCOKP6olESz8ZztFXUvw2lqnySGS4RpEUbm551fuD
	 QXsiGvBj8YXNAztUz8LxVArz70qsFvr8VAcikD/TxLknHTd65Wwt0KDiRVTfrUg2Xg
	 VuinjEiovr6THvZjhrXjIG1JFyQjNbXsnziyA+yIMBVtkXn+E9u/aYo/IbuyPHSNJL
	 DXo6oRaQI115g==
Date: Wed, 28 May 2025 11:51:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
Message-ID: <d0e76f86-487f-451f-baf5-a4fa4b53559e@sirena.org.uk>
References: <20250527162445.028718347@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dhBACiXQtjdQsg0O"
Content-Disposition: inline
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
X-Cookie: Keep away from edge.


--dhBACiXQtjdQsg0O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2025 at 06:18:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dhBACiXQtjdQsg0O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg26sAACgkQJNaLcl1U
h9Crjwf7BBcKThOMTaH+BZFU6ZAqdLX5uGU2J9r1H+uctJxZpHbhpD8Rxv2E8Oyv
SppYlOrglJTwZSA5Rt2t3xONFZLTmry5GHDa2G0e2yacOEjqhsllEXYKH5AnVOZ0
BwkUuEDr+7TUkXt1WydNP5F/f5tS/E4R+LUd4GoDEfQY976ddMF5n9d7TIV2cLju
MF0nueJoDAXE3xmxcBbo604yn+jnBN3G0+hcSpJygsXOpAI2Ph2iX79i4b/Mz2mT
S+EvZ0qxZlHrcTlrGfQ2w+ffZP4i+R50Pq6UJCg5LrFwH1YOT11D8dEkXreGeY97
4bZf75JjUEen7I5m4UCvRg+UnORTJA==
=cx/A
-----END PGP SIGNATURE-----

--dhBACiXQtjdQsg0O--
