Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390731B14EF
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 20:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726086064; cv=none; b=uNAr1Loqxd2HvaqID1XcK4pBQZiu1Km3rJY3wcstQXfzdUaOivFMuc6UGsAs275MIkmvL2LxtqKyk4pF7wFj+wOmLRt5e08Tnn0hDprxaP7Bcr0eWSj9wVwy+e2/KghgiO5EZtzDcKaJYrQCbEOFrt9HG88oZiLFjjhHWMh0uXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726086064; c=relaxed/simple;
	bh=CaPeacl2zDWy/kE/59CEfmEEax5t+lIAaDNQ2/iiUyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKiHsHt7/u0/n1mNjXS9qbeOYK5BIYRNy+gXo2EXzJwE3XDpeOU6OyJJvAkpLpj+YrCiABw1ADZMjnpv3KEv5vF3sdhGa6yvGeIWkfM4I/R33P20DGCernVC6kE1rPlsqJIvyM9kNu/idSD1P5RZaBye2OWYbfKvxNwGfUSu6fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id BA31E1C009C; Wed, 11 Sep 2024 22:21:01 +0200 (CEST)
Date: Wed, 11 Sep 2024 22:21:01 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
Message-ID: <ZuH7rbNCmPJu1OYI@duo.ucw.cz>
References: <20240910092622.245959861@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="heaY3bz+RXfM+4OZ"
Content-Disposition: inline
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>


--heaY3bz+RXfM+4OZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--heaY3bz+RXfM+4OZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuH7rQAKCRAw5/Bqldv6
8tcbAJ9B/Q+5RXVGBx7LyQZh9pR1Hg7y2ACePmE3PD+1VOWudZOUE7BZo6Y7r/c=
=Qbf2
-----END PGP SIGNATURE-----

--heaY3bz+RXfM+4OZ--
