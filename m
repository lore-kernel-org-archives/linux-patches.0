Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CE1324B06
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319540; cv=none; b=jMD4exESmhevRrkzc0Y9N3AU4WLuk0n/vbBMv/XXALKbmltP9vaOamhfIcd1BniGxJ1t3JbiPjrZuj5M6CIFSVafYaYERm9LPxCG8WcarQb3ybI49khMgwSXWxIZSlBd3AGGGhwwyojf1m1OXKOgImWurTf6CQU40VL48UB7u0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319540; c=relaxed/simple;
	bh=wxjCODDMIIrcjWezp0iMJK+YbbZ5MXyzdZ9iVr/c/hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJrrRbcDv/A9BC7gf6wOavKUv2hhSfx5NEZBRawpiCEJ8+kC2VlNw13o7g4+b7TeiSoB873hdmteZZfq2IMUH3rhrQIxOrEZ9diKviFPC6udKY1JnHrnZKJmLU4QIR+O/CNgXbtTy/IxogLW2yVzzLKmZ14Li0NGX83lt0LsDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=MVr1yofA; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="MVr1yofA"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9AA2E119DBB;
	Fri, 17 Jul 2026 22:18:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319536;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=m+DPHexl1eEzffA4T+OCSm+dzEVMlY0pgWyJKe4DueA=;
	b=MVr1yofAza3I1sDwYFVUresQWwK+QlAECD4Cq5Gz2qA/dJMwlAGiIlAafXRhbSdPpGVr50
	vwD44S7BgIiIwwIMoTScCQTHuEfTk9lsiI7FyBPfVSfuc5ArVk0OxJH0qk2Yy+YqB6sjXK
	Z+ZWg5T6UTMaa/LhrB5EBYHHVrjcj3W1lkqraeaQyVCTGn8YcKzHIhPwFc/42/YwF7Q91h
	/yBpvm50ffgDBgmhXhZnSzwZIcDKKrpCUVIpKEsqx5GO8Ni8fFWRq8lmcGii0euecxdfI0
	fdwpVrnJqgMR7JIb3gGLl3uD+9LSrAkGdAD5qR17vmy7ovfTIGHWmHBSm83N7w==
Date: Fri, 17 Jul 2026 22:18:54 +0200
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
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
Message-ID: <alqOLscrI3PinrpH@duo.ucw.cz>
References: <20260716133033.287196923@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxecBMKvj2VPHR8b"
Content-Disposition: inline
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--HxecBMKvj2VPHR8b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--HxecBMKvj2VPHR8b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqOLgAKCRAw5/Bqldv6
8rekAJ9eWksh2OAic/IGztqQ7Y+/+oC+5wCgn4sIwnK1c1AAgQXTbWuX4BqQGho=
=QN1o
-----END PGP SIGNATURE-----

--HxecBMKvj2VPHR8b--
