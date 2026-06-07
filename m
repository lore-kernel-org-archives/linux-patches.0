Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CDA30EF90
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780851608; cv=none; b=LL0ldH+TqyBTFJdZrpTlSIQEFGkg/ruXebidVf+bwRZC+iT/941opVWTPSMDsYiJZW77NqVFf+6wJT6k8l2sKTXi4YyrZ3D4Jql/R6evIK86JLXMzI0zlTHtIkeULIfwvcGbnFXtnSziQpQxDcmC5eMwrgpQwFZuPScS3jQtkvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780851608; c=relaxed/simple;
	bh=ps9q5BNg9VwKF8h/7KIfNNEgXn7qC8bVkMNDHBYrxNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iH5fVpWc0657uX1T3hztDHsQKKAMPYwat5TR2wtiqTal2aX/DZWlGOriRH3ASiPjk4KGLM49eLeYB2DcJoQpsi+P5EypHXagkgfKcICHRr4GPZv5z5OYI3Ax90Dx9+K/0uJ/RisExWB2aM1k1tP1GF52B0i+zd0K6+rZkhO2De4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Ke1QPpkV; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Ke1QPpkV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 62E061173A8;
	Sun,  7 Jun 2026 19:00:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780851604;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=jzbISFJolo6I35oD2UXv3ZLCRz6RpQbXMF301klwkp8=;
	b=Ke1QPpkVOaHSWkhIcwPk9g5Vzpyejz6x39EuIprBY4i941VMRf/mNhJivG9XI3HnOA6pLj
	4l6U0Ek15DQtfWqqlyUmQt85WeVRCKyCbR36lOQAZ/o4hYalrv+91Aue5ZGX4GbhIKxOfz
	rd78gqW47J5mIhkjqzdKjoeyZZCt8B+B99/H0/7pf8tVqy8FqxWfA9ch9NPpVt8s7vCWX5
	GcgF/eWRa/2B/mpChO2hIfgSxSuIztzd/P3cZC+CSd8SLLNOJtouq+m8sb08/bYakTnvhu
	/wdsydIAammH9epXTL1RgG4aWyEYWZ0kJ6LOJfcRiq9IQL+Kt7lJa/wGdnKsxA==
Date: Sun, 7 Jun 2026 19:00:01 +0200
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
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
Message-ID: <aiWjkUnwaU5I1KMu@duo.ucw.cz>
References: <20260607095727.647295505@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K2nZwyHPBGHSHSr/"
Content-Disposition: inline
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--K2nZwyHPBGHSHSr/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--K2nZwyHPBGHSHSr/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaiWjkQAKCRAw5/Bqldv6
8pkiAJ4myiBD2gNyJLLlv5p8S+k0T3JqugCgj7/p73cxC6mwECVvIy9dybwgNGg=
=J1Ql
-----END PGP SIGNATURE-----

--K2nZwyHPBGHSHSr/--
