Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC57D19066F
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136303; cv=none; b=TXuSzMUcS/q3kzaMaqHOCQcDKFZZItKLkRh1Es6M2TGelR7X1l8Nm6RVRiOn31mwuA+xSkSCLjmBjv0Bji1OgVzQ2iTJ3jpPH2RVyT8lRtvMGwHNLTC2f/377g8sU9QCzYplff94jdFK3kr4A1iKc04VgJbrZgZUyg+gjGIEsFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136303; c=relaxed/simple;
	bh=Mpy5IB/tQ+rRu38v6ifYh3PWH+mfPYLFlshMGkg5KWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phmW2IHgVbJlP8xqBvstuZhgNOiJpkT/E9KiIr18BrdLcPed2MQk2KYo9vTbONXs6W3doQKSWKnkj6rlWq3vysLIDUqflSpY+oxkH7DowYcaAK+pbj23KUwdXqGpHDP0AdAbI5kLmLvYzTXd6YVfFlnnlp69MAWihnX/PWpIdwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EB1BC1C0082; Thu,  8 Aug 2024 18:58:18 +0200 (CEST)
Date: Thu, 8 Aug 2024 18:58:15 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
Message-ID: <ZrT5J9qfccU0zGfg@duo.ucw.cz>
References: <20240808091131.014292134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ybSA1hQRYJFfxdOk"
Content-Disposition: inline
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>


--ybSA1hQRYJFfxdOk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ybSA1hQRYJFfxdOk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrT5JwAKCRAw5/Bqldv6
8j6dAJwO6D7iXe+7GkwaOM5XCSvkaqCmHwCggg3OXL2MgsrnFnJuF80tmi+YV5c=
=Ct8o
-----END PGP SIGNATURE-----

--ybSA1hQRYJFfxdOk--
