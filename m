Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BD918B14
	for <patches@lists.linux.dev>; Sun,  9 Jun 2024 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717961846; cv=none; b=E6fZkxHIoEAbeoHXFvQs9TpqESWWduAgXmx14FWoUD9CoHvyi/Mt5kCcMVGc9mQkXhojVMPtmDma0bm4zro05og4FsmKUStFWlLXXElQ296qj2MfLr1IBqboCKmxo9WvR3oTGayNg67raKOYunBWDcYsUNIgYbOVLwQWU1Pe/T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717961846; c=relaxed/simple;
	bh=1AIckhDvZLb5jyJYq2SNkWavWw8DLi/8FE60TtLlIY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hnx2IzEnlZRcMhQk6woqNYguQ7U+9kVEGoo5oZrwfvTTVFrkPwxwoas84e/uKM9UhBnRapJOJqoxByOREZbXpjni/AtWeGog0VtMsUWFUAjkIKXaxr+9OVvrrqhO2jl6kr/hf1fjts7sjTCAxFsnhRBN6lxpvEFUCUSynfyd6cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4B89A1C0098; Sun,  9 Jun 2024 21:37:23 +0200 (CEST)
Date: Sun, 9 Jun 2024 21:37:22 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
Message-ID: <ZmYEcrV3+nS89qrL@duo.ucw.cz>
References: <20240609113816.092461948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ph2aN2YeD/bHqfqa"
Content-Disposition: inline
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>


--Ph2aN2YeD/bHqfqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
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

--Ph2aN2YeD/bHqfqa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmYEcgAKCRAw5/Bqldv6
8qtRAJ0Y4lGYHFV2lnziR+OgV2q6a36a8gCfRejzhEwLwGKozEFY9sbWg9CrGDY=
=NvmZ
-----END PGP SIGNATURE-----

--Ph2aN2YeD/bHqfqa--
