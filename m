Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA8A85933
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709644566; cv=none; b=ETCm4IUJZ3ifKapNgeHDzYnh1zqjIDwHJRd4jCCNDuCGuSPLq0UZlp73cfqSux/M4uFhv6EWwc2NekSbfTNxtNk/8AsnE/mXeVrxkQg3KlVaZ/POPpyF/EqehK7zS9GKnsqjMN0KFQnTWXyIM6hWuA1BQMJ1w+xGmNvu5RMgAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709644566; c=relaxed/simple;
	bh=JrOn8v/tFG1tuyd+KlzQ2N7IWUKWMCvSln/lXECSltE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0vfLdWqMrymbqrl82xPfKWheyuswPkwwPgGS1rNHBDZaAXRJFFWOC+fsJ4spZ6EqkVkULd2LhN8UFLoJ5jbHgfU9B7xxDhDEJPVKsQYC8Qk/+zOHGDuQGbSIdokpHXFmfpEruRFxrqN/rZ/QibzImkuzf3ClkVRLrQto0RP1Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id F27451C006B; Tue,  5 Mar 2024 14:16:01 +0100 (CET)
Date: Tue, 5 Mar 2024 14:16:01 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/41] 5.10.212-rc2 review
Message-ID: <ZecbEfXRqD5kBLmM@duo.ucw.cz>
References: <20240305113119.020328586@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8tvfEa0ydwhPPFtN"
Content-Disposition: inline
In-Reply-To: <20240305113119.020328586@linuxfoundation.org>


--8tvfEa0ydwhPPFtN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.212 release.
> There are 41 patches in this series, all will be posted as a response
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

--8tvfEa0ydwhPPFtN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZecbEQAKCRAw5/Bqldv6
8l5vAKCYZSr82wz519l5l0G7qOFcWFSN1QCgsskBNFqLmsNIMs1EfUvdEPV+7rc=
=ixEc
-----END PGP SIGNATURE-----

--8tvfEa0ydwhPPFtN--
