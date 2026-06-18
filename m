Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD635AC18
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772730; cv=none; b=A3JcvKFMICRsFOlhufphjS79G8P8Qxd+puRw5ixQsUuEAeFgxLOEfdIbT9ve8RQWT+w6uszZskvNfEE37VLo8hZbeaAF0aoblMB3jZSpnUDwnRoYbhjRsOeZ04HRK08YN5r/rJ1wD1P/LRwe89EFHmQI6R7Q3SKGnSShDxZQGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772730; c=relaxed/simple;
	bh=90KWqU4Gselgr0o4GuzKDDc6/YB4yETNbdgCVZeqcTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHubO312pjYFO6KOKeFzpwgLDr30kflUMlI9rXpCzmxgVDrD9CL1EU4z1ml5RGzLrflhnm4BBnd3/cIriX5n1Df6gvJfgdnvnCw1sbkSh72Y4l61tzkHxC2PeQHUzsUS4/UQcvq0IR+1j0cTBFJE7MIqfUdwST1112n+8FWq0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=R8Y/nGMU; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="R8Y/nGMU"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6308E115887;
	Thu, 18 Jun 2026 10:52:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772725;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=i5j9yPVtVClI5tQHlab3HT06RJSIKdom9arDpKDr9Nw=;
	b=R8Y/nGMUKg+EPgCmBgD//9EcaTV8UA8sm22oZQOHoqYwGgoMWzXJrBD+njJBlkQPE+G9zX
	AQg0+c3LEAftNQfxWlyLDqJJpPPGMvzV+gj2GDMO4aJNzKsQfUD4GCwm7AAZtbhMIQL2u9
	HN2Pt175OaYDRq7C7rFOebg1tz7yHYNAngnrs8OtRHK82ZdPzSUMJVydGi1aGBBIpWtggA
	bkF8ib8QshKWQRZuZ4t9zjScHMwa6ekT2KeCduUpjv867n4Q0OI6Gj69hGWEMfhC1xBv+/
	cXKsyHQy113rZXI9e2drsDj+DI1IWIg6Ccgxbl5qWeL1mnGQNOQvCw8e7NfkdA==
Date: Thu, 18 Jun 2026 10:52:01 +0200
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
Subject: Re: [PATCH 5.15 000/411] 5.15.210-rc1 review
Message-ID: <ajOxsfscfFtNDX-2@duo.ucw.cz>
References: <20260616145100.376842714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gtBZuYCWPI/4gzGU"
Content-Disposition: inline
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--gtBZuYCWPI/4gzGU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.210 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--gtBZuYCWPI/4gzGU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOxsQAKCRAw5/Bqldv6
8m60AJ4kVYoFZHWOm4EzVkHz/KKwITb6mwCfaisqgbq9zHvKiKqjC6RdJdVgxCY=
=LUiN
-----END PGP SIGNATURE-----

--gtBZuYCWPI/4gzGU--
