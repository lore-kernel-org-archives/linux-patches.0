Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF1337FF7A
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319670; cv=none; b=pkYMltNvVeUk0pHAbX7jPH4496Fn2+xkkTUeqYaZ9b2x5wg/sRFpJW6Ue+8/xPwZDO7Rg1YcXYIT8CC6Oz3BU0OnEl4G/vEaQeIizJeyufxkylZS59ftFlBcPv19cYA9Nk/yZKfh2ivV6Ggj5PNhEe8GMDzVgHJ/1hTcsF0bSF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319670; c=relaxed/simple;
	bh=x6hA8QKDC+rrs1zGl+e+kuFFuYO4s5i+RYuS/TTINJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozs09TuBj6B6YWBv9Y7TdcgIjbbRaDKwDHGEzxvLJSypKldroGAKs6aNsbMcRyxJaeQ7a5xt71wx1+lbI5rQoOznRmU7H/vjSxAdUnk599sAoe/3MmT118kqiFiAcmwVv90sof0pDPeNkpa+xCCD6VVAUEK9TLzTFMOyutdmhS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Ow9Ghiux; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Ow9Ghiux"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 949B611A325;
	Fri, 17 Jul 2026 22:21:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319666;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=oJShpbMz2n55xAwkKTaajE1FM1hznPBEbvTDokGsaz8=;
	b=Ow9GhiuxKDMoJc2X7F7LTBf/VL7gL249ZOwb/T42fgI9K+sWJpBwT8Zg/AW93aqHm/ab+S
	UL3zYokOHJIXA49Z4/3VnciHunA5O42DafP7R7CgTuhfAOBEzMRw6dnSRVBKO6W9LVqcbA
	qglcjr9manYvaHCUTqAE2FynLqe5bWnNEbZcchh/9A41ItVA3/kuJJDmpae7hoiB8CHI9l
	FsvqX5hF6vfp234bB9jz9ZbKE5FToI7P6/UombHT0y9nd1G+FynL/QzuFKCWYV86q3XzsB
	s5LWPVx84DvDZ7R9CvGFOlNWO8sHqLrJSVPf4ArvgqEmUV1fdlqBbYWEkE85Ag==
Date: Fri, 17 Jul 2026 22:21:03 +0200
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
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
Message-ID: <alqOr4hsZWx5HRy-@duo.ucw.cz>
References: <20260717101904.922623678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="irfo1LXdDKRKRdMB"
Content-Disposition: inline
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--irfo1LXdDKRKRdMB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.39 release.
> There are 495 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--irfo1LXdDKRKRdMB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqOrwAKCRAw5/Bqldv6
8sgJAJ0QfNsrm8bLkR110XsUwcOOHWCHngCgnheUfbxgmwnwONG+1Rkd8QrITUA=
=9m8D
-----END PGP SIGNATURE-----

--irfo1LXdDKRKRdMB--
