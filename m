Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C49460
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723927602; cv=none; b=LZwgdMiek+1uVChQc4UuAIA2TNdZjzZ9wU5dlM/8okMAJFfNnFeV1uYNQdTXlG41PQeNp8igTJLZpUcchDHddP1IqLjzv5ZaTCwscjzMgvO9M8qII+mRGtf0m7ns34NxKVHGaVD8pD2wNSFTnLQLJ6bnt3iQdcQZf57ePnQTWUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723927602; c=relaxed/simple;
	bh=bw69ETzI30aZaB9RSjz29tXXnp/6ZNRtoqHFmCY2eY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovz9E1IybEHktICtkHe7PLZq8shCVTHLvKQ8bbiNqZtgI3QIGHHjmOC9V7oRcmSTIhlcupqGdhYOD9XJoX1OnTK/VcCqmz1a95rf6frk/JonxL9EyDcG3j/Mzk60w6fI+7z/HcIePM/HVszfjEsaBW0t8kISxxnMZQncbnL6pXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 574131C00A4; Sat, 17 Aug 2024 22:46:32 +0200 (CEST)
Date: Sat, 17 Aug 2024 22:46:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, krisman@collabora.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Adding sample code in -stable? was Re: [PATCH 5.10 000/345]
 5.10.224-rc3 review
Message-ID: <ZsEMJzot9kAjXW/d@duo.ucw.cz>
References: <20240817074737.217182940@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QHYSVCXSQSQOs18j"
Content-Disposition: inline
In-Reply-To: <20240817074737.217182940@linuxfoundation.org>


--QHYSVCXSQSQOs18j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2024-08-17 09:51:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 345 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Linus Torvalds <torvalds@linux-foundation.org>
>     Add gitignore file for samples/fanotify/ subdirectory
>=20
> Gabriel Krisman Bertazi <krisman@collabora.com>
>     samples: Make fs-monitor depend on libc and headers
>=20
> Gabriel Krisman Bertazi <krisman@collabora.com>
>     samples: Add fs error monitoring example

I don't know why this was queued for stable, but I don't believe it
should be there. This adds sample code, does not fix a bug.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QHYSVCXSQSQOs18j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZsEMJwAKCRAw5/Bqldv6
8meEAKCuJDJYiJIrn8Dy/28tBxfq5IvzSwCfaBLyUMU5kCfEc1ZQgEhWLnbPb0c=
=FWLl
-----END PGP SIGNATURE-----

--QHYSVCXSQSQOs18j--
