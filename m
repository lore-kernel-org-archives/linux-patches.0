Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9DE2139B1
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718787122; cv=none; b=BpfzOwF0jfnzsMLNvjmP9f4pmD87pVaJCB1869bFu9bx9rNknnAjqYoX68H7jnOQsEIEJ1D9/YUmh8hBBVQsWCpspCq3vNBDOXm3zG/Ls6QnpfM7atnhw7Z/3kyp9isaCFroBdDYIx2oO4OKRvDX4YPiy0gSEh/86EsUqTh+82w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718787122; c=relaxed/simple;
	bh=yTW84Rd3+jSNgbXyGVRddFr9tmJfm5gqMbMKa/I78l8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmBTwscmCLunqECRlSXqep6wpAY9H2tHWNojk/wdUDLjk0J4yVSNLKs/gmVCFrjUvPVE4atpRjLLTBJstmS3/dznH9bnqLreej3iPPxY8nMTw6EYBECZzgfd/1qDN0ubRlK8nYaTcpf/xJPwoHVonsrYyskdjfs3SKaZ9lRjH9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 519BC1C00A4; Wed, 19 Jun 2024 10:51:52 +0200 (CEST)
Date: Wed, 19 Jun 2024 10:51:51 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
Message-ID: <ZnKcJ0722Gn7nL1i@duo.ucw.cz>
References: <20240618123407.280171066@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8F2IxwsITKFUDXt5"
Content-Disposition: inline
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>


--8F2IxwsITKFUDXt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.220 release.
> There are 770 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Mentioning motivation behind 800 nfs patches would be welcome here.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8F2IxwsITKFUDXt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZnKcJwAKCRAw5/Bqldv6
8m/2AKCr33N3KeC1NPRzbbrsLEZFIf7uXACdGm0mhK5L9yMH68fN4CgwKNoCIqU=
=5noE
-----END PGP SIGNATURE-----

--8F2IxwsITKFUDXt5--
