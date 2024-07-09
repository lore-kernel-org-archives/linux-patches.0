Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B271C18003A
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720553933; cv=none; b=N6N3dD3oPJNggGnCuzGZFem7Lv2vsSjFIZUC66EvwbX24rVZbk/IQKbOxeuRsKAksEK4Gh330wWou9Ewlgkisp0/UNC8RhdeOo99DTQLtv3FLhNTYpIMcr1cLc9MtpdkfzcRfearr+VN8NuDouPjclGDzhqpbU7psCEclxZzfrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720553933; c=relaxed/simple;
	bh=lo7sEVE3TEhT1/nSP2gcFQtCHYoJVudZ/wqd5dP9yYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXo58FOuIq6yRlozTBjWZkzZPeMLBu6JLipfoM4+5dlTrTUJzS755il5U9j5VDZHaYphJ+4Bk6cySu6C1vsalm2fGpnzwgx00ThjBIPUlZPoe/KykV4niIMyDTNCMmhTLZE4fjNa1gAxmu9ICsM6hrKEr8R63yu2b2IVL3PSXzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2F43F1C009D; Tue,  9 Jul 2024 21:38:42 +0200 (CEST)
Date: Tue, 9 Jul 2024 21:38:41 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Message-ID: <Zo2RwT9eihvecoVM@duo.ucw.cz>
References: <20240709110651.353707001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AXhY6W4bbqpr7N3i"
Content-Disposition: inline
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>


--AXhY6W4bbqpr7N3i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
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

--AXhY6W4bbqpr7N3i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZo2RwQAKCRAw5/Bqldv6
8oY5AKCh9V/1thNPsXVDBg21ygrLpdOaPgCgwhunc2ukVGmFzDxisE9Qq4NwjWg=
=y9Nj
-----END PGP SIGNATURE-----

--AXhY6W4bbqpr7N3i--
