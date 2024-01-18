Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B7241E2
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705577791; cv=none; b=dg6Vg33BosYW/eSY8Tiaz67NIpvU+ytsa+5AfbDcHym4Wz/d9R9iuEHwHOwBPGZQ43WRKxpos4iAq3aWRaPyDrZYjsngkUR+KyQumoiQZ6l3SgiSyKL+HspmHxTL8HD7yKnZq2lP3tE5gphTP7ur5wzwPWNdY+ZiN4fxMUWilbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705577791; c=relaxed/simple;
	bh=M7EAn7R7Qzkjp1pLVtrjmJ8cFDKmactEzIq7QW5zduA=;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To; b=DQJ8/MKsvAIX56+EqsDJjMMNS7uRgLIFABhs0OV3zpP+vkEqJ2GakSJ5bHwSiM60iYPa1nckDsohNPASUEbMXTxHnJPsjZccjMJgF5PSTQcTw+6sbLXXkpNAoiV+CakIZNwRHYgKcKFQ7sjrV5jHGfHnUjnhdlf9p99GGH7KF4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 3D15B1C0071; Thu, 18 Jan 2024 12:36:22 +0100 (CET)
Date: Thu, 18 Jan 2024 12:36:21 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
Message-ID: <ZakNNSaezSvgWSvv@duo.ucw.cz>
References: <20240118104310.892180084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JiSdNXSbHFccVNUj"
Content-Disposition: inline
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>


--JiSdNXSbHFccVNUj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.74 release.
> There are 100 patches in this series, all will be posted as a response
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

--JiSdNXSbHFccVNUj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZakNNQAKCRAw5/Bqldv6
8qv/AJ9RMEDyA3LDTlsFrG6LKCpK6hznDQCgvcivROelW8n9Iqskhi0PxNHSOeY=
=FF9/
-----END PGP SIGNATURE-----

--JiSdNXSbHFccVNUj--
