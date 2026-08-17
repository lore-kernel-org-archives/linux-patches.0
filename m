Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223C378D6B
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989388; cv=none; b=GJXHow8p3Ylf4aSBZHYGLOSW0q8/p5Hirckq9cn/5l7VE79ivC59chsda3CFnLf3a/5VZg4L+glzmNGwmYb/UewkIXHEtIAY0lsCtptUYsV6P0UVDkaXKSAU9Yvz2hAqpEio+1c47xNNZmwS7FVL2/Di+ptYEWBELVINBFB18Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989388; c=relaxed/simple;
	bh=6br/TWURthFk8mMZqqRA9TH9jiwYy3+zOe2pO31eWpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A354oHfrRuSqywHHXhko2xex0GeFNNs143fnd/OQFVHN2XFy5gaumpNoODYa82bKp5RKsdES77Wtl5/chMgZXI1RxdBeOj2gOzn+qFIoUkgXd+YBb8oYKKQc1Agy6Lntyf/vJhclkoGD+qejmXNHig9O9fltysrwaY92ync0198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=LAX0hQo9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="LAX0hQo9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 40A4511C27B;
	Mon, 17 Aug 2026 19:56:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786989380;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=aoa3bo+wDuNMPYbaGeHj+Vg7j9JcXWHCudJuhlSZMNI=;
	b=LAX0hQo97k/bZgUZEsaH1v2ZBgsvffqK0qbYzVkLLENWkJNtxNgndYApxLEV/chHuQ5Iee
	3r6W+ha2loX0Fz1m//EDgX3FFMEl4JUfXSEWdBwmS1lyGZkO/8XDQ35xM598d0DQCMD3Xn
	Q1JJ1/rOqOMhRBlILPAR7IK5jNHD8fAm/t+g5ewerA6cW7NXhNoQDEwCjj3HuPOXY0rjJV
	Q4HY6Y96BYoBHBX7vZuA+J9KFqJElZx/9eJEOmQwrcx6sFzBvONDs/Eu9ZLzWBkZcx+4a+
	qQWuvHDplAg59VQ2GrRPuuDWimNPHxg04sPocx7ngm4mr4asG6807ZeQedQsiw==
Date: Mon, 17 Aug 2026 19:56:18 +0200
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
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
Message-ID: <aoNLQh7NuOkaUyLD@duo.ucw.cz>
References: <20260817132535.394764707@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZBum+VqYIwHdaIyD"
Content-Disposition: inline
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ZBum+VqYIwHdaIyD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ZBum+VqYIwHdaIyD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoNLQgAKCRAw5/Bqldv6
8n83AKC2SQ0JGUVI9lxRpPYO3r+jB/EhVgCfczpYfU9kbOGGbPvNWxwwz0zD/lM=
=fO+o
-----END PGP SIGNATURE-----

--ZBum+VqYIwHdaIyD--
