Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98A4DEC28
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846390; cv=none; b=fv77cZFgdO4dvQwNYyQBYn0PMXCZcl17meXnfZTbqllvA1gYjxaMWDvd1GkuPq9UI8u1UspXW92TJPrFnYQ4TZy2KjPePyEZod9Xd2fVSMD9f3Y5VeYXwfQ53hTSPfS2evLh0xjRz9NIQirQzLjGUQbbH7NJGQOBHmVxNAxZC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846390; c=relaxed/simple;
	bh=ueDCokzGdRQI9NFHfM+BrFdBkLHfXYfSU3xqoWcJEJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bV6ghBF3OvdYy6qyhcZmVvg2bn7PAyuTk6uZSXudeWNr9gFj8aPyDFfa+I4tznLmriv0ov9FxCgyRcUWqRH/d0Ad7K7bCerpX6vIJYJV3l0kWT9sMm/07Z+6FRaLIfF1451LeicOL4cD+mdGDem03HcHrA0cIhxkbL3Sff9giz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=AmgEY82K; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="AmgEY82K"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C6B0A1072C5;
	Thu, 01 Oct 2026 11:19:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846382;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=al8yYmNzgfo44B2CbppMCS2FYI+o8KH/af9OxWoWssQ=;
	b=AmgEY82KUNHfXO9ia/8uokGIUrKuxZxMVYg/kjq2YY8thA+HBHgRq0Lc+kAi0PNYd2rHd7
	wQgVGGElPF2455JM94O6AlFFdiH7scgL4sbMtnqE6yC4up1HbC/BlYf5HUjm6j0jnsVmUC
	kVAfvRQ02K+UXTCGN4SMQd5YdXzNgJn/5Q4Xss0lF8aKQZGWZi8xE6afWRxIcbTu7sZIox
	XakSNN8TdniwbeyYiiWKKiHWap0X2ResxFlwu83rlaDrSm8Ui1Vwv7npr0LP0vRTQHhP8N
	gGEK+YqoKIm6UuASFZf8X5eiZitczNU/427Me3f6OwbivMvpzLSPceFcB9nFDA==
Date: Thu, 1 Oct 2026 11:19:40 +0200
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
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
Message-ID: <ar4lrAAUaCn0Y7Je@duo.ucw.cz>
References: <20260930152346.024115587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wt1fC7oSeOJDf3OH"
Content-Disposition: inline
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Wt1fC7oSeOJDf3OH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Wt1fC7oSeOJDf3OH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4lrAAKCRAw5/Bqldv6
8kP5AJ0Qe2EN7lLKZ2r2M8Z88haelfG7zwCdHsEUHG5h3BQPar+Gi8soZ49cZec=
=G/hk
-----END PGP SIGNATURE-----

--Wt1fC7oSeOJDf3OH--
