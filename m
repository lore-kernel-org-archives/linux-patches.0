Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F33282F23
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772866; cv=none; b=DtFxv8xol9jUWvvj+PLRTdtT+Kg2pBITaNcVQk1LKwZrTThvOe1Be0waFh6uAHx9CDaREk7WleG+ejGkuWv5nVqH5sOG12gIK74+QELJxeMqdYmoS9FLcVUlIk28kBNQNzVXgr5SWiqQ5X2SO8PWPAu4XYZ7VQiFTno4yNDVaK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772866; c=relaxed/simple;
	bh=CXDovrKLWXpFb9RhLaZ19hplmNOSYzP8B3WqDngP5QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsjQPj99qt3HdTkTGKYCvTULJBqo8AaTGmhrwetW6InEb+mzus1Dcg2DyqcXAE7/xmzHUAKRRh2kjbDS0wJ8LJvB2Sl77c/EvssXX99D9vRb2VJEQwAOcnMatgrmHgSsKs6QJKuxeRpC+2lUs0GKg/9bAdciSW/ngvHq1fRtneI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=asa2VmcW; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="asa2VmcW"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 09E33115766;
	Thu, 18 Jun 2026 10:54:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772863;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=VJXxJ86vD+JpO0nqjQbhlvHBng89MJ3yZ4l4+Eao8bo=;
	b=asa2VmcWk3UMTCwPAWm9UV8jMFbSRuBvVTUAR2habFr+FSlQoOW6GlD6MpLjV14v5Kc5V8
	jDlaf/0/kV6meEfrc5YUTlKWeFFtIC1nbZUes7zh/H7R/+s8ziV3R4gc3APUewaEO/3EtE
	O1AZjyOUjTIpTx0YIh+sp/Vel1E9R5UJ60mapd7jEEwfdIKwu5DHFcpmeMSao81qjOR/I4
	GDfho6vpEsjSAUzPMByJXaYotC8Ush98RJ5mwA0GJz5QmPh9MD14zuhU2uTHukPMr/lGwr
	zMkOOSN/sxHW4D5L4HseTZGZZytOTzl5/sJM9uZw4Uthm0mdfXmelkPj27CEig==
Date: Thu, 18 Jun 2026 10:54:20 +0200
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
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
Message-ID: <ajOyPAs6Y1qrayXH@duo.ucw.cz>
References: <20260616145125.307082728@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YnWuvEqgZWT2FkqU"
Content-Disposition: inline
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YnWuvEqgZWT2FkqU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--YnWuvEqgZWT2FkqU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOyPAAKCRAw5/Bqldv6
8ubNAJ9yLreqth2DKAU7I/Lv2jdz1bok3QCgiGfE1YOAGceqWdL+nycF+IdS3RA=
=B5mM
-----END PGP SIGNATURE-----

--YnWuvEqgZWT2FkqU--
