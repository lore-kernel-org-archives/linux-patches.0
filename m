Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C738AC83
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250780; cv=none; b=KV96HlRwvgJf112bvV9Pr7uSd5NTjSJkG5ofMEe5KaFVhudQXiKpMIugEiOGJZVJCqWES4KFBMEjGZ3ewLBOZOHJ4vEHs1bq7utcgTfdRC298NsqZUWgGoUfyilYfjXLEr86nx/6VeRmoU6g+lp808gVA/G+Z+wDARAno0qTeoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250780; c=relaxed/simple;
	bh=AEmRE1MgsNUHOfS4DKZJrt6gFh3NpALCdBDeQ7U7RZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmoU1YWRueGe+0PgZVu3WMnppNGPtXxv0kmpo7PzzCoWLfdQOHfE2PrlFAyRxpdKnhGIpRviG3JzMZ8Nd34glRdbXetMHl4t41GGR3MaLEAS4sHt2YHCP+aHTjpilSAiHSG25m5CupTa2pcXwi7Ql/w3EbdAeZb+/aicFbBzDWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ajYGYpHw; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ajYGYpHw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2313711C60D;
	Thu, 20 Aug 2026 20:32:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250772;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=efesCreyeXVaQgRX4ZVL4KdLHiNaH4ORIRPrU9aBzog=;
	b=ajYGYpHwEDE0FI3ebE1xw1pL0eu0lI7FWVUnzKIP1+7DCt1qof29Yxrc/Yv2TXp4aT62Pn
	AG+ScgkslUlVTo859GdvE7zzWufKDpD2KYWJHiiJCztyWgbEyjAHIA1P2jF2IWB3UOyK0n
	tjCUDk8PTbjppfUiLbgji192kdVQ1D/5CMzalws2rDzcvUlbuEsi+KMpF50dhMIagFTOK5
	QFKutLMg+2wSEy8fL6W1N82PQMwQzw+qA8RuW9D/bNoeMzdXmnrgpYvI5dLmmc0OJ2Pcuh
	A8Z5RxCtEsE4rzRpi9P9QEU7UkVwpvKuxkzeDLKSGRE4cFniObSWXL71Ox1InQ==
Date: Thu, 20 Aug 2026 20:32:49 +0200
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
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
Message-ID: <aodIUZbMn0ifxXBf@duo.ucw.cz>
References: <20260820145244.450574346@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gAmigGtmMvqKMNPQ"
Content-Disposition: inline
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--gAmigGtmMvqKMNPQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--gAmigGtmMvqKMNPQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodIUQAKCRAw5/Bqldv6
8tc3AJ9k6eXHKf4I8VkqliUH0ySbAQ5e9wCgg0EGzHGxgXVMMfwTGfEboEjPB04=
=eKxA
-----END PGP SIGNATURE-----

--gAmigGtmMvqKMNPQ--
