Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F857F7C7
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720554588; cv=none; b=XP7R8768aMW2OgnX4U5Nbgp9JF+EiOuuxyQSQ3yQJLmxjXJ0ZGYO3NkBowm1BQ6sX8YyUrYHTGmp6vnj/1OaLj2DtmUJ8okG6ywLji6v+mOd89pfXDBAQqdGmNGOVugqonAcjUKnkJGM1ZCVeAqUxcTnAgtB3+rpYD/yy9Tn7mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720554588; c=relaxed/simple;
	bh=BauW4h/CEpsHqiTWGKsGMhg5rGbHWXE4hJVt3SkJPFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cemBEvCBnnKc38Vj3z7PrymIPzBtVLMR/UBFHcX+9XNNRCiplVlmUR5SsQY/ITNypykE4yjEhXBdwbXLVYp84vV46Xld6aIGX0Y5XKxrSHLA0dKYsQ1SSDdVsfKIMadUnZeChNbIU+TLzpnGT9iY4KgRWRNWR716GlzLiDS+fic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 48AC61C009D; Tue,  9 Jul 2024 21:49:44 +0200 (CEST)
Date: Tue, 9 Jul 2024 21:49:43 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Message-ID: <Zo2UV1crHE6fgllK@duo.ucw.cz>
References: <20240709110708.903245467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WH9O1HQyIAgpktX6"
Content-Disposition: inline
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>


--WH9O1HQyIAgpktX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WH9O1HQyIAgpktX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZo2UVwAKCRAw5/Bqldv6
8qfWAKCOuRZSQbOnvQfSL//SFFvEUBwr2QCgw4zcd068YwroDRldBSNi/Mo0mpY=
=sQru
-----END PGP SIGNATURE-----

--WH9O1HQyIAgpktX6--
