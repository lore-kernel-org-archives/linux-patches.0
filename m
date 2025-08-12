Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F62D0611
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 20:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030168; cv=none; b=APlv78AiT4FsroeiKwtr1aFetysPJzEPQCYoEgGd9WoVe32RJzuarCwIDecyl+g0J/4P+S3l3c6pi9s99akWHWzH474lXGdMbjqrNhF8aoZKW/2UyyLCoqkYY/oGXZ+et7AfWiqIfr3yq2fOMy3xq/FQA9cG8ffTKIDfVeK4e0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030168; c=relaxed/simple;
	bh=3ZLVNIPZknH6xE/O18dL51v7xcqk+GTu+1PLDI35s7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRPKttce6qnAZPyUan4dKTXOM1HixRbL5sslwCQzfBAgCRsIlHoxcN+/6HsTPipqBEkWVvwLOXm17pZshyaIztQUXNLcaCJiHCC+JqOIeOojgjF1xGkeralKf0FIA5VpFDxGgJFX2wxD7jYMoarjxZRWTxhGfQRiRPhmHr/z2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=EB+EpUxX; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="EB+EpUxX"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4BF001038C11C;
	Tue, 12 Aug 2025 22:22:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1755030164; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=guGyo4crm5Pm+IRKfIYVBTbQlB37VOD5LVHd/0CVvUM=;
	b=EB+EpUxXvoJJ1xIs9qZ3Auu1kSjEbrh1HILdHwO/w30YOr6Z+Qeh6MBdlJWHbq64nnEitz
	HJ0lh8FEsYwUklBW47OL1x+10ltBzUFEWq0wnEJDyjBZ3iCQBbXBj2WoxQMaMX5+EscNdv
	hEat06oXmqGztAm0Rjgkgt+6OvPtWBww43dy6YLssZ3FIAbjl2JHS/qryGeRln4V9ToJLC
	0j8qsl4KiF1IWQgnHdWlI4/5UCZHibEPY6yUN0n7MGL5Td4JgIyrs3JRVD+ZMC5rciOqXd
	pQgw6Lur8gXo9j8zbogKRtZRGPe9bVWK6oDd2eSnLe659Y8yLUqyJ8kVQk2M9Q==
Date: Tue, 12 Aug 2025 22:22:36 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
Message-ID: <aJuijKhZeT7c8bOw@duo.ucw.cz>
References: <20250812174357.281828096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Iv9mjVfxKa14wEGP"
Content-Disposition: inline
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Iv9mjVfxKa14wEGP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Iv9mjVfxKa14wEGP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaJuijAAKCRAw5/Bqldv6
8srVAJ48e2YST4geeh7RZiaZnSes6el9twCgo/W7s6p4TxE9BS2O/gBQvSg4WjQ=
=maAb
-----END PGP SIGNATURE-----

--Iv9mjVfxKa14wEGP--
