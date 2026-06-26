Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9381A36C9CC
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473128; cv=none; b=jU4ecZMpn93SGRNqnsgOXNkcJh8iyjJl6r9s03PoIHNBvqjTZIM4RVwy0bESVPkVTCXq8Ro/mkdGHzPekYaYiVHSW7deqmjGwzTDN/nSYfNE4l/ijPypahGWIbCSnA/YmTvnvW2XOhDnfdQPp2VQPQO+wZwQL2A3ZkLnZJ8bMQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473128; c=relaxed/simple;
	bh=Uyv7V9A/l020WAX9I0bkxDPFA5QbD8uvnGMlCkJDBCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GItAYJz9kGSyOATP9R02zjwvAJPg+hS5FrsZ1eaqxd3rcgPdUM7Wmss3uqxUciaVoqsFCnm5Yw2ugAthRZ0NP2wZhg7BdCgVppB9B3TfZMRX0BIs0eXvyxtB+qJ/sSlzVtpDhHdDJbks+2iapByRjpSrZfnaa6OaQFmTmNHw3Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=XTVXloIW; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="XTVXloIW"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7E6E2114A02;
	Fri, 26 Jun 2026 13:25:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1782473125;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=OfX0yMqFKMshUhXNS5bmLdr9xnUsZMBUvV9xEkPqUcs=;
	b=XTVXloIWoqhNrjc0zrxnj2vEOSPDyNroZPtRWeDG9eDDGVCf9sZ03Xyzpnndt8v+Cqb1OA
	iyDIpDOZ+UGYMtTxakKhQWTTWszayh45r4gK8984ZbZZwRu3bY8xE0XcH67lVPKP87D7jl
	5KReYlENBNr+w1STGapvEmMMfHHH0AwlBC0y9u8Pf2Rx5D6V/sGJCcV/U+e8Y6Ry9BbEe9
	VtCEwmqSM244Tc05/5hmpTThzcr4YbiUakl81oM6cU98F+4KmQw1tzqQda7gTDNhSTJvEy
	fhMAw2Uc2BXggNOGbHCjNzAoSy7m6QbUiNjrYHydutVWbdeT5irfvi06KGwSiQ==
Date: Fri, 26 Jun 2026 13:25:23 +0200
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
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
Message-ID: <aj5ho8stx819px0w@duo.ucw.cz>
References: <20260625125637.527552689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xnouCD2RAq1IFLb2"
Content-Disposition: inline
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--xnouCD2RAq1IFLb2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.0.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--xnouCD2RAq1IFLb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaj5howAKCRAw5/Bqldv6
8qVCAJ9cm8ZBPWVWlzwGnkTTwutWe3tz7QCfa1s68g+73FoC0n+TW19rD7TtPqI=
=Hzyl
-----END PGP SIGNATURE-----

--xnouCD2RAq1IFLb2--
