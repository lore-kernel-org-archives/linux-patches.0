Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2812C08D0
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250440; cv=none; b=TkLDTTynKN4ugY7z6cIiw/R/tKx8AXlGJsrtu53iF+I9GG7lp2B2/gKYiL4BmsCFrjXzVVAp8to2nHfOosSyYR3AvHNFaTErIDjp2LhYxHaLx6RiB8nrZBnSaV5BFfAYVEA5vNYd/JqfTtfzVja2i39p1UxfANsDfRKpggnxFXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250440; c=relaxed/simple;
	bh=eyfwwUQo75Trv+5itSRRsqcLK9ATrq8Bjwigtv69HUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zxc5PYbS7nZ+aSSWUr36FlrAAj0Emf8RjApgqHFvB3K4WAuq2D23rcCeTcROakkqu5PkSRm0pldGSNErHoSJxtdSilHYrAro1bn1mfYks2W7Kk7KzC/kNtmJSctlGHm4UQm/hR+4E3RfhoEoPAyKlphRelExlVZOu27U/LRh4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ITvny3As; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ITvny3As"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5647211C608;
	Thu, 20 Aug 2026 20:27:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250432;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=rmZ1etAo3CHNlB0RM3eH2/2NdsnLEf4UXCwuhcMk/dA=;
	b=ITvny3AsOgHUpGI3ThOtAY8yCljJnZ3NN/WgwCBVpHZlOTFwVLdNn94T2uDopFwPQgdEjt
	f4SORG7HJEnPnynrgvKdbsAZ3tMWO3F0JODKyWGjf0P6ZHWnSfrmBRmuvlWoNSbimBblfM
	RaSIjlrgylXTb48q+2Yb9gHW1+jOmGdmNh3Iw+Z69Af3ageUuRjAf56WD2QBZAsnwhW322
	LJf6yVmwOS/YuMwp63XmsyS7Jjl38mWEWAXo/H6lP2HE+0IOHz/Sb8CEcx4/Y7V6VlYqxr
	HAYwuCLoSRiLb5fb0k1pNN69WwqjobEKHHIej1a3WhielUAZXTaiowtI7v0Gzg==
Date: Thu, 20 Aug 2026 20:27:09 +0200
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
Subject: Re: [PATCH 5.10 000/235] 5.10.266-rc1 review
Message-ID: <aodG_dzanEjlYfue@duo.ucw.cz>
References: <20260820145216.426568665@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TQ03sT/v0TPk95ns"
Content-Disposition: inline
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--TQ03sT/v0TPk95ns
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.266 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Similar failure to 5.15:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776649189

Best regards,
									Pavel

--TQ03sT/v0TPk95ns
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodG/QAKCRAw5/Bqldv6
8nJoAJ9NmdQuebaok5OIQEWRADOXIdopvQCfat5HBJx31sPzgZVuVbv5iqRpr/k=
=kbm5
-----END PGP SIGNATURE-----

--TQ03sT/v0TPk95ns--
