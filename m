Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B96F282F23
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772805; cv=none; b=nvKZmLHVVbNQyuEhzLX6LtCFkRBczad3Lht84Zxd5KCFMtWwkofLEN4WWO03AjYPvuHxcw3UQSG2U5YG4afgy16V3hWW5pMZd5Sn+n1KsNBT21SxsuvJ6wD1Z8w1umIxkhgk0be2dR7wnDMlpxox6VDq1MseoPy72K5jstkutZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772805; c=relaxed/simple;
	bh=1ZFv1nhBTPQWNuX7Ot+xgbs9fCzS+/3n26vad8yZP00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iN7yrP299QAMju4LaCjQhwIpIwZHh2Qs+lG6E8Kr1nYV3vPwTcJwCy6OnZZ3QAtlrHw0c+QxBIpn3Tu9FVBzQqeC0BSQO70EltBnhVO14Hd0J09Qg/NmiRTnsiw4zDL9ejkHBnUOdGCdC0d8xJzSIi9yptxEcUt6bhTEpDqF2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=RQJrUmAs; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="RQJrUmAs"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4E8F5115853;
	Thu, 18 Jun 2026 10:53:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772802;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=iZnAskoFx4V0iPabmnepZDLwJ/my1HGaopxdKH9yMfg=;
	b=RQJrUmAsLg4GzH/UAKSQNjz1lRhsCYtTn6fdTq93xaIDUgZ0cPWPX7Z2KXgXbBgedeZHmQ
	dC6TosZa9udOeNVvKZX/3T7XGNb/n6y+jvrMwRhmmp7ZIbpv8qWNZuykSOyCx3po0chgt0
	58J0+SxukowMsHOk9SsWcda4yKIa31/HLybUSD55ycdgebR16tUHlHbKZG/uuWy8MHgL5K
	ZM4mh398tP/oMxm+veXulOQIBtAIgJdtGOE2S1GTFM2ihguNP22mig/ljSz/EJvRsxfcHf
	z6mcVQiboe00FbeR7A9QFR6sEyUPCOOzSQYiy0KU8iNz2uyyLx7J72V/ASr5RQ==
Date: Thu, 18 Jun 2026 10:53:19 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
Message-ID: <ajOx__VhG7HN1-sP@duo.ucw.cz>
References: <20260616145117.796205997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tIxaxChvFOuO59Eq"
Content-Disposition: inline
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--tIxaxChvFOuO59Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--tIxaxChvFOuO59Eq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOx/wAKCRAw5/Bqldv6
8oZOAJ93xGz/csdmTR+irzYP5i80FpEJxwCdGi4eIJcQwNDJkmBXw1h4moWNXfU=
=/2Mn
-----END PGP SIGNATURE-----

--tIxaxChvFOuO59Eq--
