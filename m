Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23B53E31
	for <patches@lists.linux.dev>; Fri, 24 May 2024 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716549936; cv=none; b=FtAZrweCV+dhY27MDm+j57ay3FhkdzekN36X/JC0sDHFiiktWanRYhIFfTS7jTe46XoIixVco7MvO87Y85uCjn/tJhut3k+83zWhguDwG59HHY+yArK8YVdmG7v+n+7eHpeUIa+UEu5lpydORP9ySZ6j3x1d2cmr0KqNt3MEkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716549936; c=relaxed/simple;
	bh=PrpWk3jp2AvwvAowQPTKXjwg9ei48L4Q8K5vqVQrmnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9+iwMxQ5M90PCJMHlOM60beyXJsVsq+3ltZNiONbl8rP+ywuFVIsKalC7q6tn5s83PuPgMDJQG6hlrXJ3t8eWXHOqmFr8YVNie5qa7gNzSN6I1/cbdoTkKIUCGQAOAZ3Dg4UkHfErla+lgCtfofNicmYg8NTCyI6l2Z4wDyWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0507C1C0094; Fri, 24 May 2024 13:25:33 +0200 (CEST)
Date: Fri, 24 May 2024 13:25:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
Message-ID: <ZlB5LO+JTbeaCatD@duo.ucw.cz>
References: <20240523130329.745905823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GXaZT0HN9OY27mfA"
Content-Disposition: inline
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>


--GXaZT0HN9OY27mfA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.8.y

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

--GXaZT0HN9OY27mfA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZlB5LAAKCRAw5/Bqldv6
8qv3AKCGpz833WdM76DUbKGXBpIhOUalogCgwQ8Gs2ucWgDgrVy7wkVYKm4IaBY=
=x/fR
-----END PGP SIGNATURE-----

--GXaZT0HN9OY27mfA--
