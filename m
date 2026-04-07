Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F13ACEF2
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 11:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775563128; cv=none; b=DeIK1LnE1wR2wp7LVcqcIpVE3HPxy4Wb01izdd8XA6/sHSxd5o3MU68krwmFj/DBY9sw2hDNG2ZahRNbmMiFxv3R5Xzup8+UrK26QsCLXCUawDrxhCgZ2kZ8cKaJ+ZQzDRZvmE5TPHa2MDLaIby4DzoR04sXgEv7eYJovY1/DB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775563128; c=relaxed/simple;
	bh=krQ+qmx41QUi+SNdzh1GDVRv9d2J8WV8wjPP8wPmb6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cl4rK/lZt3OEEoehhXYfAZb0HYhw+lKHFkIUoJrKDn331tIa2p1sQEp6yeBrLAHmqIbirXOufX3Wh2DFo2SvisrZz4niIU4QlYfUKE31FlGBB1DQeQztEUK5Fx6KlEf1/BlPbLUmejw9tHUqv+GeJRcxBcz1v7r+xv5YRTAxw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=UwgXmvMo; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="UwgXmvMo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5506F111730;
	Tue,  7 Apr 2026 13:58:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775563125;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=oQXbDh/K2K0BfE2ojLdy23TU/VVRdqMSNRWkn8uwc54=;
	b=UwgXmvMoMU1sz3a2oU4yrlmo+lurgIStOWAH/uLGONrdKwpVPoWMYiVq0UmVsU3dp0FPGr
	+RfJ9WdDoj4j3L8rattwNRNSXQARSkYfPWL8QwHMj4l1QdaD1eoiL2AsGgzN1X/Ahmgsac
	UvYeLm/Od6EYIDxV3DHOd1iAkUFsg275VknYiS639uPexJwHNLDPpMUNJqm3UiapkQnoEw
	PLxFY/DE4j95ojsmFTI9mgjKLQElbmfba8St58DqDFvlx8HSzLzsaYgTHNI9Eq3h3+uOsl
	Y9f6LkaFId2KbpYKwu7lAsrvT0hqqGAPqSzyB6zHzTLQcII2uqO08SR0DOJcQw==
Date: Tue, 7 Apr 2026 13:58:43 +0200
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
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Message-ID: <adTxc7s44iS8kbRO@duo.ucw.cz>
References: <20260331161753.468533260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G+cfJLa5gZn45coF"
Content-Disposition: inline
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--G+cfJLa5gZn45coF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--G+cfJLa5gZn45coF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCadTxcwAKCRAw5/Bqldv6
8oO/AKCoHqozrGumppY89qBFbcAhjkU+MQCggRJMVvWz67v6bwamXAULa35bzaI=
=iljz
-----END PGP SIGNATURE-----

--G+cfJLa5gZn45coF--
