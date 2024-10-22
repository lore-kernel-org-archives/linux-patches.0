Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F71891B8
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591187; cv=none; b=a6h7w+Afqb4NO2wv4lT7EmpTFpupERvlLqtcCzd3GqgZBrMVgk/FG1I7DlK8JFzy7na/eVqfvSPiW6kQOfppSL/nP5LVZ5HrmOCNLd3fTzEU/csc0QRgespNJutRUu5UqOv/XwIMNVY3H8ka+csc1mlrGVuIGGFb0OEMc1Rg/4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591187; c=relaxed/simple;
	bh=vsS4MVEOBSV1cLwTqh5AQA8LERhDtALRvG0vzfXjlSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG5U+/RKfPd1izE9emTS/YQJZ/vcMkL6euBurMNwBgjdZDFnj/3UuOmugmkaCcghfsxk2PovFJKzejUKlcwGNHVncFQ/tW6UMjzdVXB8n+XdyWiFKQrZYfiRhPJWmke0v/RY/A0WrZaZhzwL4J+/6KSgMWPRQmduB0HiBo9FPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id A7E161C006B; Tue, 22 Oct 2024 11:59:42 +0200 (CEST)
Date: Tue, 22 Oct 2024 11:59:42 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 00/52] 5.10.228-rc1 review
Message-ID: <Zxd3jlH//H4Nvm/5@duo.ucw.cz>
References: <20241021102241.624153108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ohojVUgNLEnTB3Hm"
Content-Disposition: inline
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>


--ohojVUgNLEnTB3Hm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.228 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ohojVUgNLEnTB3Hm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZxd3jgAKCRAw5/Bqldv6
8mz+AKCAXKZH6wv+5r7Gro0R/ATRFbwFGwCgh3FWPDDHcKjqD31SNchTvoxzArM=
=QmZE
-----END PGP SIGNATURE-----

--ohojVUgNLEnTB3Hm--
