Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1438C351C14
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354393; cv=none; b=fAPEckzNoZTbfX9u0oPT+wd75rezjbHDMp8q06qJHVcngbinNHB+Zw5lk24evtLIhD89xbQZ2OC4VgBzp2F+KKb9ysxwp1ATBK9bQegBK0qD+Acw3gaFDPKQHSoqelmIHopsyKJTURZji7cxrrThWOo2HNCFqKB46idaCI3/6cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354393; c=relaxed/simple;
	bh=00/U4Ree3agmZgHvXDWPdSeFpZ7m+UU+St6wRnjjXp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MFWSw0gI2IDErvkMq5j0bGLQ6Jyh//HWUtpNWPFQZ99JQzlfr+xx+OqzIGnMg2kgRnaDbQYFTufXZFOmHu+oSxhrJAFrCS5XYvI3RtT516cUyOErDjOaKW6RYYHxxE9GLmEkM+GEaWwFVxpempaU5Acyd6InJTrGlgnw0UxMy70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=WaCnbBoh; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="WaCnbBoh"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5094810BE06;
	Thu, 21 May 2026 11:06:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1779354390;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=lTdXZEbBAufSAAi0gzG5idX66FJCyatCIwyZVheG5EQ=;
	b=WaCnbBoh8yVf2m4aNWsrjIfMHz+bkaOKiYcD0VQb673RNLAGI3+SA8kxgescPVSd/OL+5I
	MlgD9FcjivHB62omKpRe6P/m+7nBzTIFL214/A454GHWcqIWDcPsblOETA3dgW9ANQYK/t
	K6rasujf8Q+KtZJfY4yyv/zy+qBtOrFJWc+MMTbL+aLXQzXAAmPGT3bgIc0eU0Mb1SKey/
	kccms9ayVYIsd/MSuIlor4RgzFsxN7dN4B9UtiTqven2dNjnOGu2l10NClI7rn/0wozANw
	qru2BcEca6AZU6anr/jynm4yg1HiuYUznA+wuGK39CvI/sEk6duQAhkpNtIwJw==
Date: Thu, 21 May 2026 11:06:28 +0200
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
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
Message-ID: <ag7LFLA9ahWbVaU1@duo.ucw.cz>
References: <20260520162134.554764788@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuVLjmHbNV9ZmnOD"
Content-Disposition: inline
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--BuVLjmHbNV9ZmnOD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--BuVLjmHbNV9ZmnOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCag7LFAAKCRAw5/Bqldv6
8sTPAKC3Q/ZjAglOZyhP8d5f+kCfwU1TtwCdE4/SKEK3BM5VIZ+cOywD/Oz1Aio=
=lhkV
-----END PGP SIGNATURE-----

--BuVLjmHbNV9ZmnOD--
