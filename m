Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B291D7E21
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 10:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743157256; cv=none; b=fvH1A+tCYp3cOaCoMGbjIsg07u778KPCRVhADn/g0Zm3vs4jZk/tp7xYyNw8qYJwOKMt6LK73Dyi8gAQvA9kX+Qe/J+nYgMJQQBFbGvnVfAKBBHhnLJoU4h88yS2NNDlrYrFEOqQ5AmSPkhA4LJM+Xb6/Bg1RXocnbswKLeto6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743157256; c=relaxed/simple;
	bh=G37Rpxj9artpzjHdH9Kk80lSjQKgVboLMMZFWLJA/YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAFAgoU10EnKQQHJnMfFZT/6NsjxFQO27Ke+HV4lVbIcMadgun0JYgL3oWKfU0aI3PpHQuB/6CqfjknHf+OfwXP1E9EJMTQiYjdddk/osF2toJyr1QyruBxRY5+KhQWSPNxUAAa0fNM9hIz2gS9kVDdt+dy30tLewGDI8cckvx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZCIgt/Sn; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZCIgt/Sn"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 84E34101D4409;
	Fri, 28 Mar 2025 11:20:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1743157252; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=WpjA+IwZTQ3hDj6knG5UpwdBfRtzOJ7yh3/1OQNgpWk=;
	b=ZCIgt/Sn2A3J4Qbw6/w5TT8J5sG4z1Vcd7s68vS5boYUw/wVWe533s0vL0+haSfwT/hvwq
	KC7D1VRUKbHOJS3Skd0ZLMiYlmVyyyRqbH5JiOeKIcDCb2NeegD4twjEmXOa/DSI8/QftM
	7lAjIbCYgRKfXzJRg4ySzKQohzgNFadBZIH3jglOj7ZgktJQgmkUHt+Gg3Qn4baqt5UOi6
	k+xEf0TFlL0sk0qA7RbFGjA9D8UmM++jCLLOgnUPH5oX3wJWd/aeuTyCpTBC70LnbvxeNJ
	MoH3XZKmiWG1/9jblABjm1ye+kAIzUXSvlb6i01qO/86sJ76OFUTmac5xuKNZg==
Date: Fri, 28 Mar 2025 11:20:46 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
Message-ID: <Z+Z3/hhNoBemgSYS@duo.ucw.cz>
References: <20250326154546.724728617@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69CeavOzPm4brp6y"
Content-Disposition: inline
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--69CeavOzPm4brp6y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

I believe 6.6 will pass the testing, too, with enough retries; bbb is
doing that for some reason.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--69CeavOzPm4brp6y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ+Z3/gAKCRAw5/Bqldv6
8k/cAJ9WmK/AMr2bwLBaTMbLAv92XoplNACglOAunu5RUzKAJ7kpAEK6YffjKks=
=/nV5
-----END PGP SIGNATURE-----

--69CeavOzPm4brp6y--
