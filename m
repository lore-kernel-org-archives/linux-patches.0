Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6B3F1656
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 11:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473099; cv=none; b=n/QxfRLGihJaJyxQ5v3+L2VlJIag5GqyL3Tatc40077Y67G6PKmPv3kc6oxVgXO8Z+MTQ9g1eosrFQkv1UTU3qko7p9UYWybY9ZiFyEe1+CdQVQLXYRP7tIlol1EHJtBWXg/Qboi9z0wHzNipSgwg1E6Lezotxy5I5PMut5RDOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473099; c=relaxed/simple;
	bh=6GdPrW7ZIBvjwaCNgfnAgcM59mBI+Ygg6qq1MFNxKiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWyi4PBCVGwRN4J9stWronQIqs+nUujw0xVAMpaojLZ8ajbAiV6BgmsWp6GEzO9W5e0sY4xpj7jrSMeUQytdpfdly/30NpzjkPFVot4GtgykDmFaYw735q2ueM7zBH/NYEXH65p82MwPkq6qjF+evC+Tciqyr9mcijyribv77xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=egTfvEA1; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="egTfvEA1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 14FE5117956;
	Fri, 26 Jun 2026 13:24:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1782473089;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=v4dXydw18kP0Tdpxxs9TmPJXNIrlVp67JEsAHBC2ryM=;
	b=egTfvEA1VREJZK0rGsiIDNEOCAHkUnAquaiZigh/wXeUsddonC87o/kl83JRouJ/J/4LCy
	nsY0UnM/2LqlDLNCw4l+5gXBhlkusl/kbCXqojnHNw8wrU4GquYLcw+ioCqXeLPNb+WHXK
	NLM6dCxNoxODL1m+flCiJ34OSUdxPIJRH4gp5WYesktj2WDnKVRUXsmqCorJ+ThMkCxRbM
	4NDsl5m3CeUcUHwF9ZFT3Dd4u0cHUX2ResyhQU59mwM2DzNqhK16zwPrt8c86/0vtrkxry
	HGnAM1fVsbx++bw7slj6V2kt1i6qm6tgfq933mpAwrglUHMwIkcynNdJGzdiFw==
Date: Fri, 26 Jun 2026 13:24:42 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <aj5hen7qThm9X7LU@duo.ucw.cz>
References: <20260625125613.243729608@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SJ3ccNs6oOxM2Sr/"
Content-Disposition: inline
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--SJ3ccNs6oOxM2Sr/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--SJ3ccNs6oOxM2Sr/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaj5hegAKCRAw5/Bqldv6
8g8BAJ0d80vRuMUslkY9MSnOfgVOL4teMgCeKHKDG2RBDpo0TryY3lld2EsDyEI=
=CpTJ
-----END PGP SIGNATURE-----

--SJ3ccNs6oOxM2Sr/--
