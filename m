Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B1427726
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736949362; cv=none; b=cwmHph8JErvtHKsktHwFlZhWF/CzA9178ovCV1P3CzNt4Tsm5q5f/WjlXSdtapO7KvMs++hHWBxrI+IqIeonbwYs+i/+IW/2ZQyex+7CEtQ/bugxm3jd/Wa3oaxjMlsEv9bFZ9RUADqpY2fAeheZcUKQ/b0sihKUdCgsoFFNUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736949362; c=relaxed/simple;
	bh=KVj1KnpnNe6cLN0SmqOei/pthK5+tk6d+q4SfQm5t5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQn555qBx4+GtJByUBv+DJ9JYXi5lPGxEy2HIcxXgy027Te3PAXKhYvujeyQ+vf7hmCBlf6egwwdgKp+6ky5itZJPrEYwHXGCcjZZpitC9s0Yc9t3e8ZzoCkUPN+HTUY06HcvleKnSp4g1vyfDkOcdd7FWfUsVlvosjb5Dmuu5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ioNbz8eR; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ioNbz8eR"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A7AF8108882E2;
	Wed, 15 Jan 2025 14:55:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736949357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4n5hX1gsB/gh+pvk8nLscWUZBOO1+jecUYsLIxcGiA=;
	b=ioNbz8eRGOzIWMImHq7S91eRlalqdaNUApCCI9H2R/UpcXIfULz9x/OG9njhVUIWNU1qLj
	AigYYwlvM547pN9aetbCeCbcgaLFKbc1jXli2lJc4yGgJBe7Z41yH9YDyMb8zHh1Ctdq0F
	FMEKTUne2ZLgTPSE5EZ0SGNUbL3yhj+zXIQOfjmEbkBYZ07hTu9+X2i61McIwQK+FNGsYI
	NzQ0zMk0xFCRio33uWgf1dNUrNI0v90ASFJcnw/RuS4a5Z3Eu77ovv6SzyqnQypQmzOdQA
	LKLRDjQ2lRFykIxOjhPA4hDHQ/rIZGdYcKWlhN4Y6+QLaIizmROn0FpINeQlFw==
Date: Wed, 15 Jan 2025 14:55:52 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/129] 6.6.72-rc1 review
Message-ID: <Z4e+aEY3X/OMceB1@duo.ucw.cz>
References: <20250115103554.357917208@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JOkRP9v+S5W2By61"
Content-Disposition: inline
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--JOkRP9v+S5W2By61
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.72 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

6.12 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--JOkRP9v+S5W2By61
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ4e+aAAKCRAw5/Bqldv6
8sTyAJ9eH+si4Xr25nWXDbsv6H0vbuQ7xgCcDs+/kep31KFIBIgSlIJcAHfecWA=
=Igze
-----END PGP SIGNATURE-----

--JOkRP9v+S5W2By61--
