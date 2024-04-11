Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4048C147C87
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 12:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712836934; cv=none; b=VyYp0DQfxLNU4BQ7GZpjpAgsoK8aUKaox6OAekvVx/3DXT7GDKkYAwq+OjQYo1tKAt2plfgTp1F6CGUT8dkmHdIkIKcrjNkBA1RqOZ2YA9q1qx6BzsupwKXwvBdiapjfQTHystQeooFlbZuUvYSXpnIHLhiyPPk7YLxIy3V2Ovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712836934; c=relaxed/simple;
	bh=cEdyZiZML3dAglWfyiqQi47IoGRSkQStV6lCc9iP1co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jo9+B/VkHatQZdmNa7s1fT6lA3+HdgdJLBrJl6joJjU6Frxir+s1el7cT8nViBJtUWjcDxgPMZLlQ5DmR0Wvcd7k9qB8o3k5rhjzkISf7iikQWM432V9DV3NdDxFGHz0O0WbngSKGsWwL7QHLqN5Wv8TWUfjsUzaCcGBbK1rfxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4CFF11C0083; Thu, 11 Apr 2024 14:02:10 +0200 (CEST)
Date: Thu, 11 Apr 2024 14:02:09 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
Message-ID: <ZhfRQbT6jXBDoZi/@duo.ucw.cz>
References: <20240411095419.532012976@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M6gDgYaXGNOuSibr"
Content-Disposition: inline
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>


--M6gDgYaXGNOuSibr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.312 release.
> There are 175 patches in this series, all will be posted as a response
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

--M6gDgYaXGNOuSibr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZhfRQQAKCRAw5/Bqldv6
8g+sAJ9iVJSfJoHpvstsS+RQcxC6vPljpgCdGJHdfQO7y1ycitzCmycdH1oVZz4=
=+OYZ
-----END PGP SIGNATURE-----

--M6gDgYaXGNOuSibr--
