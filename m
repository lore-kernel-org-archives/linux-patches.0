Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16EB38F25F
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250573; cv=none; b=i5Wwf2xDwe34c2dXxMr5HMEi6CPmZA+HzWKCkosdtJaswcDtqD+u6iNdkL0buD24FQSkU6AGVet2DUc3uPxL6VdNVpZ6sSDQ9Ex/YkmChjFryZdbLEFe1Ln0RJ3kdHUMhdTdWskDC/gwG1M3QzsT3Xx7CqpuKKzu6dcFi+N0/Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250573; c=relaxed/simple;
	bh=bvQqQ1Uc7kpnLVhr2wul4wlFBaA+mEgBoM4bFhaTqJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L79zdtpRDyNqBit2qSjOCsU1Kpk3G4ru7UK9tVuY1izB1SoIrH0uhO7EkTQGn6d+wRSB19Wty+emfEuJhjhSFDGSZJLtzhDqVDUFl6wdvVQWuOV2wIOOhb16dm9sLbwT7VrTm+X1Mxe8MqWxDhp8THZvkyQ8FNab+FhwqDWTxE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ijnBW5ZN; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ijnBW5ZN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 937C211C5EB;
	Thu, 20 Aug 2026 20:29:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250565;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pYYEy69aM4uXmmudfDrpegj4sjvwe4eXvJ8LgnRtmkQ=;
	b=ijnBW5ZNOxzypZ/vmAsxYFgvWWET7t3bJYQS9e6mdqagpk7dxP9hsU3NFtnKS53eEZbEhM
	Gxui5UhddWe62aa1VDbp0OgLp0GVzl1euhJUwVm0IXafSxiP1KAXLdCcREmOa2MgHgDRr5
	hsp3EaTWRiJvmG4qhj7hWuDiE3varpYQuDyLN8LGOq/vf6k/nBldraPM7Xm6aBhKvwlSAb
	gOA0u5GRI7tpkfHB3xTL7hrLfQft7V1NGrcceJSLXlPyxBA4g+BhFhCUnvapG7OcVvUAKO
	7WN5zBL6ypSbqiUHnrgeHc4HmnUOD6qb4t/KGDYCuo1x0TyBU4J1wrnpZIuk2A==
Date: Thu, 20 Aug 2026 20:29:23 +0200
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
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Message-ID: <aodHg8XQDxFP8VDp@duo.ucw.cz>
References: <20260820145253.200766705@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pBEof3F4edwrW6K2"
Content-Disposition: inline
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--pBEof3F4edwrW6K2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see failure here, too:

drivers/mmc/host/atmel-mci.c: In function 'atmci_remove':
4522
15:52:00
drivers/mmc/host/atmel-mci.c:2631:31: error: 'struct atmel_mci' has no member named 'bh_work'
4523
15:52:00
 2631 |         cancel_work_sync(&host->bh_work);
4524
15:52:00
      |                               ^~
4525
15:52:00
make[4]: *** [scripts/Makefile.build:250: drivers/mmc/host/atmel-mci.o] Error 1
4526
15:52:00
make[4]: *** Waiting for unfinished jobs....

..looks same as 5.15 problem.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776654125

Best regards,
									Pavel

--pBEof3F4edwrW6K2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodHgwAKCRAw5/Bqldv6
8r21AJ9V1jA8ZcJXbUl6KSBtuWlQT9IWqwCgkQEUz4JuPkwuJQ3Q10FVE6GW5MI=
=2aVo
-----END PGP SIGNATURE-----

--pBEof3F4edwrW6K2--
