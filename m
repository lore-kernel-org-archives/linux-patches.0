Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EDB7406D
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722423801; cv=none; b=mKhVTNTLGP5vIB+3CGk1pQc5H4w6QwR9YO2O7x8mhHiOe1dDi/ozarZI9kC0GKhm9YhgM6R4FB4XnyoSK0OE2UQ6jPLZrqzqVTMz4SnrB6FmNrJ3DoFBZF2UwJNjjdJ2ypUCOReoiF/T+j7KiFyoU533p50f9c7oNhmnQbOh/DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722423801; c=relaxed/simple;
	bh=eFGq9VlDSc6Xp8qNHNxgm+6lO0OLdLbrrnGCzxIeDUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHe14GxXEXwqChxXMvgJsnCENXlGdfZrFjSW1bDs2bUaoShhBjTaHi6j8TdraAEvbyH/9N5p0j9fkdaegNXCjRsYvboT03eSkxwN2cbWoTPCO3/RkrqliobjVTah97QhijikWm3XZrcjvV1eTx9bD3q8Oct+nQHrP1M7P7e/Tn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E72D11C0082; Wed, 31 Jul 2024 13:03:16 +0200 (CEST)
Date: Wed, 31 Jul 2024 13:03:16 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Message-ID: <ZqoZ9ES+OlAhGwLf@duo.ucw.cz>
References: <20240731095022.970699670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uhJlyNLjyCQTjA6B"
Content-Disposition: inline
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>


--uhJlyNLjyCQTjA6B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uhJlyNLjyCQTjA6B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqoZ9AAKCRAw5/Bqldv6
8jjrAKCpBA4f4n8vBR/rKG2RQbCd54JMbQCcDv4kyZ9EhuApF3HMo92khQVlDi8=
=SxOS
-----END PGP SIGNATURE-----

--uhJlyNLjyCQTjA6B--
