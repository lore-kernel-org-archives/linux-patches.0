Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BDC8C1F
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 12:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764938163; cv=none; b=mRlxo/EUOYjgEmPTnLWr3QzEErvfMKFqUYewxxrhSnLxAaDgZpwveHsxb5CLN61GOeqCQHeNkIGVzMTRSwtnqGO/y5zcWSTaL4Mfx3xJuMSODkjLFHdCdz5ARsDxN3LYGM9eWCcvm21YprqA4pHSD+G2juxV4S3IUWMvsQQm0tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764938163; c=relaxed/simple;
	bh=8qoJXojtFPCb1M+oWQ5Zy1uKgZHQFpAhbFkFwgUEN+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uA9S19Q9YCGf+BQihFN12t4x2WP3YbCp8iLQP79hOysaK9qkdEJvfkJkn2Qyr/FGgIhW2MRc/Zivf40s3sU6R77NCXGhFAhSq6MYwcZjK8aCpHkLD+PEgpb9nElEByODwwX1t4lRK+mZJeHJq4Vy3BTJy6tIGs5E/UWK6EBn9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SWYAuHFN; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SWYAuHFN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E623D100694A0;
	Fri,  5 Dec 2025 13:35:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764938158; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=HhpchWU2kEL0WkXX+GiY9Lxhg7zw0TN6pVoSwU+TbAQ=;
	b=SWYAuHFNBtOU8Lje4oFiUmEcbSCxrTSSqq2LnFcUg9HJEgBfj85Lls7tt63MipKVPR2c5X
	gjoNgnLqJvTN2scgoVXt7Y5rBZeBiRVSA+eFa7VWLNH44cKicV7UXSPpPLxcc3oGS5YizS
	3QGKSdOhTRwK+W+nazvNUD42t7ZL3yegnrrwTJBM8DagigJW/v9seX/UMvXFxGRY7vAqkq
	kOpgxVwXLVNli5gN1IH45s6nBNsJCILADylDF+BEU5mIE9L3iOSGHhRnO1qZzCJzYGVEla
	n/3LO4q4ttWPTepIPZhvzFDFPNn2mtbcmAdL18dmXMWgs0/0jGW3OBIFsN/Khw==
Date: Fri, 5 Dec 2025 13:35:54 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Message-ID: <aTLRqvqBGc9LU3IW@duo.ucw.cz>
References: <20251203152343.285859633@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qeOJVLPSAn8+A+30"
Content-Disposition: inline
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qeOJVLPSAn8+A+30
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qeOJVLPSAn8+A+30
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaTLRqgAKCRAw5/Bqldv6
8mQvAKCrh+lxcg2CqMOyjQFj9y5fT1vEswCgojDDKN2RNcPp647DGdUqwWzZHxk=
=BQwj
-----END PGP SIGNATURE-----

--qeOJVLPSAn8+A+30--
