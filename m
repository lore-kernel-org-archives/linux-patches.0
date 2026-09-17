Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227AF4ED196
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675583; cv=none; b=ucu2HHVMqAHf2zY/i7v1SLtdpICNCVKg7HqU9nIPZSNrwD6DD6YwRSWOHO10cIIqGP/rhx+eR7ekVwMUsEU5t1uxZvTKWMopmTYTYpaqsF8Anq05Eve/Os4q/RhVueL6JVqN9Tl84Maljh9YLqCnkX8guZS/6I83gxgrjQVR5/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675583; c=relaxed/simple;
	bh=rXqOrBzH+IpO/T9r5pYGLtHXHgZqd6dQVDwK7JGlgOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/9ybzIBr356auOIJqEYH6i3YS7Sx1bb+VzPcFRdtmtbs738ZM5tF09NmSuU0kMroEULWDxKsmG0hOPLch0ZXfpM9vQzw3qn+WHmN+u58CoZF6ITCkqmPoJnpkiqGchWGax/9tcQ4gmTH+EsQR4ykv9ol9bzDESgY1ZchEpOfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=GzlgwMys; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="GzlgwMys"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A746A10194D;
	Thu, 17 Sep 2026 22:06:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1789675570;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=mqPcUB1khjYQ1hJGnWqfia0CXyzKOVdpspPXxD3fg9Y=;
	b=GzlgwMysH5PNLpFEBiRGT3YzjFFVhCueBI3cIud3cUf8NKCZF+nVyjZ+jZs2CgHjx0HgW+
	Dal1o0DehzK9QXXw/rmBNKKBX8ugW8mWBypNLP2JqZ7mlNd5awTo8OR5NQU59ruthEGDub
	GM2c4Oqn2WD52SK5XBxt2VA4XIiWRnNH4sorwP6Gnhn0JqrmFnfFuRz4Y9zKOUNLJcoiu4
	CTdJuCZqeorzXrKgmfEatR0/WhwTaMtD9jA3el9NKd1BsDUafoKwgOMXSjKl6Voltm6tbd
	1TZ0HA1mmiK7K90jLp3nBTNOaV6785GQ1c9RiLrIu3LkzZ6olJZr2kag59sUJg==
Date: Thu, 17 Sep 2026 22:06:04 +0200
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
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
Message-ID: <aqxILAWpEUT0dDvf@duo.ucw.cz>
References: <20260917151551.901433442@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Hsi6LWReVhcSLhh"
Content-Disposition: inline
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/Hsi6LWReVhcSLhh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.53 release.
> There are 1250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--/Hsi6LWReVhcSLhh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqxILAAKCRAw5/Bqldv6
8ggYAJ9Kn6007QsLCz3CSxWzg2iCRMiBKwCgqx2hvYD8SvkRLMipJoWI7UAI/Hc=
=jzlm
-----END PGP SIGNATURE-----

--/Hsi6LWReVhcSLhh--
