Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500B611E
	for <patches@lists.linux.dev>; Mon, 12 Jan 2026 10:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768213428; cv=none; b=q+Lpnnru8BXabb3zpTg4Pm+3Bvhe2v9MmVPRUhR5gUP2QNnokVu+DI6nZpjCDFWS1axj+Xc4TqgqYoT38hBpIkghE+z4oV9R9jSYSJFh5Ff1z+UTKQAN76aMX4Ot4BBHMOwz+7YJX6ce6Noa/UFz+9wMDW1QIAAPrH60vBCXYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768213428; c=relaxed/simple;
	bh=oq/dBq+sMVyQsnQ8soreeBF/WRBQ5XFG6Iu5BXSJuRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyuWcUlEys7dLvzqC7QEzAYl6Qcdn67iSXJyMHv2JKcqDL5fo2wtRuLeVAma8Rwt6fCFnIt7SWInyC+4pQpqM2LEZIEnrIczkybEKqki2tUBBYGx1kgCnjZURnOFMIcS4U1uHhIXhdQ15XWWude9y9bpa1CAJ8TzKY5lLrAAJGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=JLqXmkhd; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="JLqXmkhd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5FE9E107EC8;
	Mon, 12 Jan 2026 11:23:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1768213418;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=oBlmPUXB26Mx6VEtRz8Z2TblJ6BO6m/Tan7ORdyIoVI=;
	b=JLqXmkhdfzPNRMYIu3tmZ50P08K6Gv0mN7QjVfOxTtQylVZujQTAX8znmAD4DO7rafaF7H
	K/TPkY2pth6sSOpg1Ldcat2wdq8suFqFbhIN/EeMpiYQ0u6MMYIrEujWVHZv58rr07F+eg
	4RXC91moHwxUaipc0LgXWplSubmOi84o5YMd9JBE2d6BVqqcexs2TvN0KTy02k+OLbd/Wh
	dTYditZOcO9fZ8l2BmPv9S2IRNcMNlv4XA7WtEDaqRtIWJ6V28Td24FX6RvenQvixYk6HC
	C7Hz4SEDRmf1JXbPuN+zAeqDaBZlFvaEkgyIKWWsTF2x4JGbbNB7Fkfn92OdEg==
Date: Mon, 12 Jan 2026 11:23:32 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris.Paterson2@renesas.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
Message-ID: <aWTLpOLK4xCjfjtO@duo.ucw.cz>
References: <20260109111950.344681501@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0j/mh8o68GrT0swL"
Content-Disposition: inline
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0j/mh8o68GrT0swL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

My denx address may no longer be available, please switch to
pavel@nabladev.com .

> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We are getting failures on qemu:
https://lava.ciplatform.org/scheduler/job/1377239
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/126711=
90285
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
253660286

Not sure if it is real problem or just something wrong with test
configuration. 6.18.4 had similar problem iirc.

I'm cc-ing our testing people, maybe they'll help.

Best regards,
								Pavel
--=20
In cooperation with Nabla.

--0j/mh8o68GrT0swL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaWTLpAAKCRAw5/Bqldv6
8r7uAKCUBmcX7N/3YQcICbPgLgdUuGz70wCcCxXBgHtCNu9iS6UFDJOk7/KOXtw=
=7fcV
-----END PGP SIGNATURE-----

--0j/mh8o68GrT0swL--
