Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23B6155731
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723927674; cv=none; b=bJR0rRChkdCVGMgfeeooMlKxateOzLscJ7utLXA0UXtMp3GspEhnios5+TmKQ0i04cG/eXxfukcyYJuDvw6RG1+GCjqMbXLffQyE3NZ7YIT0vRupGp+7pB8O3ddxwyL1ckTusHocPI2Cro9PpabLGGRAfYtRLvTnBtyvSYSqozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723927674; c=relaxed/simple;
	bh=8xU3yuwdgNGZT8AeiDfAnKCwyGL2vZAMkGqY8jLtla0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2pZ6fp+LXcgwK/jyrR1yfGjgEmmHBdAsPeVmzoV7XTQHmvtOSTV4fMnbcWhg0H1PEHse/v4/q9oa6VODAXT8MQrAmLjWsm5rlag1xWvSQX1Cm76ODDkFQ7BnHzRj+Ka/cqFhEgo+ma4LubAmhvOMsGnC/aXL8MX0ThrTZnvrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 435721C00A4; Sat, 17 Aug 2024 22:47:51 +0200 (CEST)
Date: Sat, 17 Aug 2024 22:47:50 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/345] 5.10.224-rc3 review
Message-ID: <ZsEMdlHU6SYvz8wl@duo.ucw.cz>
References: <20240817074737.217182940@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E2NJT776ii5jaby9"
Content-Disposition: inline
In-Reply-To: <20240817074737.217182940@linuxfoundation.org>


--E2NJT776ii5jaby9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.224 release.
> There are 345 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

No problems detected in Linux 5.15.165-rc3 (2a66d0cb3772), either.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel



--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--E2NJT776ii5jaby9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZsEMdgAKCRAw5/Bqldv6
8rCBAJ9gfuyaJB086EBZ+ACKMFqyYu1XVgCfWic3FKxN1CHSyCwguFSYoe2F1+s=
=W5YA
-----END PGP SIGNATURE-----

--E2NJT776ii5jaby9--
