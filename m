Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873144B270B
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846244; cv=none; b=ma8bG4VBa/l7oK4dq8qBl5HFLXpuTt4ILXtxLdXfzT69psYUon32HrVHbqS1XbkWm9A/jOXDqxo1vX6L9iHKvUqlFDsW4HZJnU+LgiqW6+6tS4w7cya+zm857EnpylFHmJx9SH4H/hcf370n6QTTinQys5XKeRmnsj4XM8b7br8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846244; c=relaxed/simple;
	bh=amglvlx9uWA/sR/TuhHwXEaebQyKfeVWkh7bWoHX5J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lF646UG/7AQXiRfHYA3h4FY4nJKz1DN7ULAFvl/D/Dh3cz8kfVa4JpKH2xEF2zh4LbMvlwUnwuOeLomzj6M7gp50mKsqZWCApKWTliC87MgPw59782xTcVHcN/C9AeWQKKoKX27zdHCGP7OF5k+z6ieLo3P9giPtEOISLxITPmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=IXlwQyak; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="IXlwQyak"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 63AC81072C5;
	Thu, 01 Oct 2026 11:17:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846236;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=EyaXOSRRIwHc/8qeuBbC116HBrd36iqc6VTJDFlXZrM=;
	b=IXlwQyak3BgoNl3G23lo4146RpwsJKCfNFZjwxcaH63qnmxthPEjL95xbGXYCoyEKbRo7J
	Rs+fblF2DejhYaPKDPk+UAlyAp/9P5/V3K71Q4cCwnvDLGJIMKJlDInDDSrAHg44XkiwLk
	2Nf7BH1eyLkZKxDWj0MtcnTPb7wbYaGYWeMn1P7smI7DCH45K4LyNkSW8T4X7iTAiAZNhi
	ogay5O5Zk0wYAYlhBOvev0CAEqufP3SgaUqeKpYuMe2YLZ66w2olq5RYxl/xCxGLlirM9m
	Z42R2PRjoZ+xXLW15E6lKB+23lnLHdVRFlDNhyzxhqMKwfTo0EYFmMlz5/v/mg==
Date: Thu, 1 Oct 2026 11:17:13 +0200
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
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
Message-ID: <ar4lGYD5zLqzyA55@duo.ucw.cz>
References: <20260930152414.738996857@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr+6lu+x4GKOhgLp"
Content-Disposition: inline
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--gr+6lu+x4GKOhgLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--gr+6lu+x4GKOhgLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4lGQAKCRAw5/Bqldv6
8tPJAKCaKr5e+AYB0vCXXYeWIpzJvryxGwCeOVWTbKJGscAOfUI/5ksKnCBjvJY=
=6PAv
-----END PGP SIGNATURE-----

--gr+6lu+x4GKOhgLp--
