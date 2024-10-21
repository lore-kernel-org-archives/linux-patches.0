Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859F137750
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528178; cv=none; b=nN3nJZCoy4vMOF51Rm5I41h5LHefTt2LDQHuKqmXzNg6exIwP6s1byIXcjL3d11j9x2lnfp24+wakEqB4ZkU8wvy956ptC1Dc5DzLpfOQivupjYHg1dg5I79FbsOSNaDKBvUSEP62eyPr8q5P76atwr6MgnoCEVFuz+wblg7jNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528178; c=relaxed/simple;
	bh=WZHTYHf+LQjJZi4Vq2sTO5SCLoWHTXWW4eydbVA8m9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+lwylM9SV4y7vZJT1JGM6uyYEpTmR7TlMCkNFHOee7Gj/xyeLodv9c2+dM2CJSbjI6u375LGqb3uXhCA/UZsPvPmLSXmSwMIsa1lK9ONKfZyeqeYCr6sK1Uuv6A5vaRixGKpgxOc0gtriRxhhMf2Ve2BaQUb2D1CB0Q6b1bSvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=KuMzZBW0; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="KuMzZBW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=h5BU
	UOZKlL8+fKDy2XIpjtStZODLfDkNQWHc7fkq2ao=; b=KuMzZBW01Hua5r5hPeOq
	DeMgJpbwoXFF5NbUsRXpBN/FmhD4JSk7yzGu0E5Dd2+Xe1IUZw0B4LV9GAyD+4OJ
	919IzcC0miMiLl/gPSLM9/b6NeGOGLNH7686KkXE9ShK+gpapGwtZauRTk8pk62l
	XCYdSGH53BifBkuzQlpHGkUSW24tMz9ECqkJsu0Ay5mIwRwfLDPIjtVSxu4gT972
	0AwZEzVIT0dDNNcNn5tp7IE1+HuIfm+Iyt8C5iqticUsGMEuGoDSyIM5tQBjj50L
	7Cbmmkw8S5jMKXVR9Kd7lvlQpW2bBdU1iVGktg0zhF3gSGoBF/bi/r1d4QAzktcd
	nQ==
Received: (qmail 275883 invoked from network); 21 Oct 2024 18:29:26 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Oct 2024 18:29:26 +0200
X-UD-Smtp-Session: l3s3148p1@F631J/8kaC5dtTCq
Date: Mon, 21 Oct 2024 18:29:24 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
Message-ID: <ZxaBZHJcZ768Qg1o@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <2024101835-tiptop-blip-09ed@gregkh>
 <a520d1f5-8273-d67e-97fe-67f73edce9f1@linux-m68k.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Yl+L//SofObhi9wx"
Content-Disposition: inline
In-Reply-To: <a520d1f5-8273-d67e-97fe-67f73edce9f1@linux-m68k.org>


--Yl+L//SofObhi9wx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Remove some entries due to various compliance requirements. They can co=
me
> > back in the future if sufficient documentation is provided.
>=20
> This is very vague...
> What are "various compliance requirements"?
> What does "sufficient documentation" mean?
>=20
> I can guess, but I think it's better to spell out the rules, as Linux
> kernel development is done "in the open".  I am also afraid this is
> opening the door for further (ab)use...

I agree.


--Yl+L//SofObhi9wx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmcWgWAACgkQFA3kzBSg
KbZbRA/+KmyVE7THE67LHd2bsDBSiZkwVv9kPwQNcCd86SzwnBN87/CeOhZxoI0F
e5X+lZIXevQvSJkqu8I1ZZNY9xV50GUncndawqL5mSS/GW+WMXPNIu8osTV8gg25
WHD9cJysiD7WT50vSOncqESU5WA8OAQrv/9VC3bCQBfXEuYd8GNZaW1DLVBAcsek
e5sGupyYJBcMJYmIfpPkbKpN7oAkuD4q/ysCqkUe+Quzg6IxoKplPgIjxcJsgdLS
JkNTq29ZiS0QrziugUI03SvnXO/MMJEbhDPPZNInEKEhxy3tjsAfUcsP20G+TeiX
R248SgmUekBfjAZ0gDRjPZfKJc7snBKURUK1B0E2+1qrbi52fX/RfslNn0gHO8Tl
9nf6YlLjgLCd5092qAIngqdMIsudeAK4QPNKAmTkwgtDdRduAiyrjCMox8ldLuJJ
tTHUJlxFOeRLEVN7Z6rtGGSrKsQyGdF9ff/Oe6FYuKlJiP/iwAfFQ7moKTt8FGLX
GNdfYhujZNl/dP06BxDxec+y/B2Gg0H3fVF0P3P1GY/SRgxgA7nsqjCuxAttSG6y
IKOjNyRcQ2knNFq2q4OlzoH0k0zSHBvbN+bZ7kg48THKKWx+YT1/eri0sdXCxaKY
Kv1vM/3t9Kencw7T9chtP1QAbU6bAXiXOytcS/RGPJVkkeTXccE=
=8I/w
-----END PGP SIGNATURE-----

--Yl+L//SofObhi9wx--
