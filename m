Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A853910957
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745435903; cv=none; b=lYn7huV/92nrJyFTQcNHurNAyXtm5L77+8uxRdqmaTVayTWgt4zupe3g1OZDUJ7flgHa/RjvvJW2rEXGpoQ7BfSUqWWQRpjO9h8ysM0ngf9SNGAsrGcpe61hYLolKFx3URfG4oVz9PYl9AyAIk9UJ7cKwbNfzkLRGuvFOVz0zyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745435903; c=relaxed/simple;
	bh=NrDTKxq+kport6sfFGIa/K63zZXAOmmsE67KiG/ZZYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBn5gNZJ0lzFT2KBshWMSZWfqATqQyOaGP3tO/9fp+H4GH4nPJ4Z2kFIYBpFXxRaoNHLz5yKv2oaaLGWDBrQ0FJSfNH92QktYTgcNH3/NK62BdS7NY0sSqMRnUnaIuh+dMmkt0d2pBo5ERpXJuoT6zxImMZcNZHuxrJMrMce5Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=HE+mStIi; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="HE+mStIi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id ECD73102A8CAA;
	Wed, 23 Apr 2025 21:18:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1745435897; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=7KQILhxJ2UDK/yRhaZvlRLLaZy9BTW61t1P1gT/EP1A=;
	b=HE+mStIibZEBc3CyIPUshxQzeVd57WPPXm8o1lQ4W+y9NQYEr08Tys7MmhcJCyMSDvMaYg
	J56PEAfQh0UskFQgJ3Rxp057lnvcnWiSLk53xa1vEaZ+ye765qejr5GqWkxao6zwK1mN2S
	khru+xoCQqh2v8FYx+yrAyMuZqk2GGTutRm9RMiS38dP58I1ryQqjBe1YTD2DvbVO7oRsR
	eaUJW4xWdTo3m6n4EmlWOsNnxFLvaPU3WE3O62xgQXa6ASAbWZxXMQZKWOeHQP73lPmZ3B
	dl+2hxIfXuhbGKagFvzFlbT8usPgVgko5JdapJdos9W/zGjzLIY5GVqCKr8ZbQ==
Date: Wed, 23 Apr 2025 21:18:10 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
Message-ID: <aAk88jOujaPAFT+q@duo.ucw.cz>
References: <20250423142624.409452181@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdoIn1ZTv/arL+Ed"
Content-Disposition: inline
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--SdoIn1ZTv/arL+Ed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
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

--SdoIn1ZTv/arL+Ed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaAk88gAKCRAw5/Bqldv6
8iWCAKCPncQ1OEBuGcRwlz1gHltf43qzxgCglN4ezYYZiB+NhMKj9z13H8CKxNo=
=tw93
-----END PGP SIGNATURE-----

--SdoIn1ZTv/arL+Ed--
