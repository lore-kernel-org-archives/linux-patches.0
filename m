Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6A3254BC
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 20:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943185; cv=none; b=FpXEl/oPFYLA62RtjIeL/mY21qmSwqns2nsmjMnLGijK/yksbGwCCDT08hq7+dW2xt0U69ejSyTtBR/8WTDnBjP/Dd8EgOBFRnTLLdiiVuKgTmi2Mdo5I2Vlaw9NWKBb/U/0E74jng/bTX/2uO5wxxNEslzPVKS3N82IADOwMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943185; c=relaxed/simple;
	bh=cCWvpJPh66sBhL330VO5yFtZu+spzsUcQx0tPkziLWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3S24ElxB3vewtLq2JBG4qYkyy2fwShzrkg3ZzFzDyUYcaUOniGCFAvwJpobs4c2edWMA7iqefr4Gy8Bl9Vp9BXjAf4sHmJgmCTgh8hgpdrjoeQUhe2UeHQc84qrn6MxFrE05qn4FHe8fUck0HANfMQ0Bw+hXd8R4UYjtgAZYRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=B9jE9Yvg; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="B9jE9Yvg"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 514621183782E;
	Fri, 31 Oct 2025 21:39:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761943181; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=AVSa4OKKOV04Gmh4qAbUtZ9hqd0rk4TLqFOyh16EgmQ=;
	b=B9jE9YvgEDkUpL5Q6QgQXfBsvwSVeaQwrtMzJSvZYhh/UJst3aYEQGA09vNNKbdnt2dHIM
	wrxFMuDN4SoDCjWaakqJzjRTielM9C7CyjaEELgp2glO4Rhy66UArse7t1cPPxRpZHxBhv
	8KMug4TNN+2HDop44KPY15vFpk0RKWCPQqru4n4IATJ82IvY/+Yi4CEYK2nv2INQjxwqBj
	uc8TmT2cfSEed1NFYWQV14pCzOFOuq2UT1aeGYo7aLEgxgMjP0Y0m94iJ8IrwFJpM9Fr7p
	VD7yAxlKUxgRminbh5fMR7gp2CYO53CfMoDD5YAaeZ2wY/LYAiBmDACFrfReOA==
Date: Fri, 31 Oct 2025 21:39:37 +0100
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
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
Message-ID: <aQUeiXesnmZoUuLD@duo.ucw.cz>
References: <20251031140043.564670400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Im6d3rSDemiUuXa"
Content-Disposition: inline
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--6Im6d3rSDemiUuXa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
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

--6Im6d3rSDemiUuXa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQUeiQAKCRAw5/Bqldv6
8hGpAKDE4pfxpiVbjHq89z1GuxtlXxAlAACfdK4opcdTwHvinTVkH7aoGBCXnzA=
=XtwT
-----END PGP SIGNATURE-----

--6Im6d3rSDemiUuXa--
