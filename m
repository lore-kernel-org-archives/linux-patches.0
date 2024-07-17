Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1881617C213
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721209609; cv=none; b=FzLi4Et3o8HCPf5d5ZQ8sosNX0r4z35ys6EXKsyapNHPooF0hDntO88zkjoJu5EujzFMY7oJku4dOgJF4kowYWUNJkBqAKRjovj92N3pvNU9bcW53KlTKiKHjwaS7ohyQFr1AxObV0C43WsLpRr/4yk9PDvo0I5xH6ESt/a95wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721209609; c=relaxed/simple;
	bh=tX6udcistYtbSvcTiZAfsRDcNI0YYgXMD7ooFitslbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cF0YfteJ76eaRpMo7DErprm5pCcJ6i8F+XNXphxQO+FVSkL0e/+7J/Q8xEBNGzkKYfQPPTw37qCaBgZ+VMX9cdmKmgPZcD7R+tm4KkX1P4K2bTe9VuGuFCwABL+hBYoA4gNAv7s4RerL0TM6YxIQXPEh/c9NegXoITICE7r1Pd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 67B4D1C009C; Wed, 17 Jul 2024 11:46:45 +0200 (CEST)
Date: Wed, 17 Jul 2024 11:46:44 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/65] 4.19.318-rc2 review
Message-ID: <ZpeTBKXdu09hpB13@duo.ucw.cz>
References: <20240717063749.349549112@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5HcsdIB5slL4hqjX"
Content-Disposition: inline
In-Reply-To: <20240717063749.349549112@linuxfoundation.org>


--5HcsdIB5slL4hqjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.318 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5HcsdIB5slL4hqjX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpeTBAAKCRAw5/Bqldv6
8nl/AJ9Wi9rVccbTx7BAeGrCj8ms3ybxXACfW2a5BIJyzwAejZuQlqVbBHm8bFo=
=d9wR
-----END PGP SIGNATURE-----

--5HcsdIB5slL4hqjX--
