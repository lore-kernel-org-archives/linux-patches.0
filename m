Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB0D253932
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762850842; cv=none; b=FY3YNRSDoKbB1XHNgGku2VRitTDEDHmyNhHhipOaeY+SfU/ZrszbQ5ozXQw8VjOh9LEbwLcaL7TD/V7rGWEwS+WDXal8/j/TGzrt6x+n27YXq8E+X2A2NYDNq57mGUUoLIog++/BZ0A1zrNPETU1omkE7X1qdpzZBxjqpMm1f9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762850842; c=relaxed/simple;
	bh=iyY5A7dTBmfuZ64oKQXSAcXtQZreFHvu67kAK8Uc1tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8UoKw/yI5IC+XnVJnesMOjw9jqYrYSGye7vBV/sv3b9MmbKEFoWkt0+Tc/DRs+2nYN2F1Ieu8lyIpDJtCj2kUmMmrRRghJRQtOIn5l9FFsf/xW7KHBW+JEN7pw87hK4m2Y7WgTuIjqOYj1gtAh9ZOfT0AfeMoAA/pAdLuEVGlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=R/u5Vua9; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="R/u5Vua9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6766110036B4D;
	Tue, 11 Nov 2025 09:47:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1762850838; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=6gighiBAHtXMYlkhOu8YsF6h2cr4baq1BOxdNvnS0KY=;
	b=R/u5Vua9N+Zh+dhFb23JmODXyro6+kX5uZ5VLnp/FvbRiA+MUNiusNZ+8cMjJZKGZHR14m
	O2Hs5Uwx8F1I7szcn0946Hwlg0Q41iipqsklUgXey4WqQUIdUIL1Tjsnlr3L05FPQPqH5h
	R/b99zl25QetAMtWH7ng1JYB5z1UZHwWZGyYCM61CzI+TolY/XaF89fgvS7A7K7ruMcOil
	jEUonFhiS09xpOXIGvUVX/9HSyXdMLec4/JUn909pVXnyqrSZMsiL9h7IkiKIc9EsdN2CF
	7vsEjOaeGoTeg37i+HrI4UnSzK+SM1VSiWD6k9tgr8jEETw2uteOaDdazwe4Aw==
Date: Tue, 11 Nov 2025 09:47:14 +0100
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
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Message-ID: <aRL4Ehd0NNjCMImH@duo.ucw.cz>
References: <20251111004536.460310036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fgXRYoZTGsS6uwBV"
Content-Disposition: inline
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fgXRYoZTGsS6uwBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.17.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--fgXRYoZTGsS6uwBV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaRL4EgAKCRAw5/Bqldv6
8vepAKDBETLBWx/r4++hK7tq4BtW+KMIQgCggvoTChXWkdZVEvJZBi+77bPSkAI=
=JUJi
-----END PGP SIGNATURE-----

--fgXRYoZTGsS6uwBV--
