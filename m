Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB44ED183
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846340; cv=none; b=DuJ69n6qP37bNs5PMof6opBN1Y5htHCnRS7ZWZ3qijPDFPc1SfydY4vefmjkXMxJa5P3DJVfVC2YhLGsStqrNgSydQ6n0WkGXfByhvDYFwiYtWPBRbp82d4FjH4V1NPsTY1fz7QmMuwj1sKbxW2fXXAdoa8LR3iBOL+8Dkhv4Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846340; c=relaxed/simple;
	bh=OBxEGMPXOUatkpGotC3+UPol6v42aqXzDSEFdFnqZ2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m577Iv32TJ7CUhc67CSbDu2mS9AFq/BN7rzSizn3LmaUzDLz8pW79BliYuPO6G/zUSSKEiYWLj2+xgQ5Au9qxfnoCtCHxLJ9FtXGFEH/FzRaLxjYhch/rMRUvFJa7uaiNtus5/bF7SBZ/R3eTnpDeOhxmq7DHAedM9HnLF4EGnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=X1qZzZ9N; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="X1qZzZ9N"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0CA2810721E;
	Thu, 01 Oct 2026 11:18:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846332;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=vw100p9Qqf56DSEJuH9KPAVJISmkNYdbyuUkP/9q8bU=;
	b=X1qZzZ9NGNXatFmmR1703VhZVQX57aD3IDK5NHEW6786cqXHw9AWHZxcBP/7JY9yaGlDTN
	Zdw5XJRA6y4EkgFFavYy6dDiSUmo3AGIFZ0gQ+8GXmOiPfV6tHEhkvbdZAqxCK4Khhe3x2
	YIk9rAVXdCM1LV03HvomxkUvcnq55JILgW323iZSiDoo+TEwmkXXr/0V7xQhbKpKjwgcZ5
	QZDCET1NAVAV+mDaq+2VhRX7SL/JVinQWVY7Xx7dHHHAIJzrKn0kYZXdwbrYbj6T8iLQsV
	DP2G/2PsIAJ4hldkgyHwx3HaTUI8ZMhLIn7ZXE5yFn91wPbHGWt0Hygy9wgYDg==
Date: Thu, 1 Oct 2026 11:18:50 +0200
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
Subject: Re: [PATCH 5.15 000/752] 5.15.222-rc1 review
Message-ID: <ar4let9ps-O_S7yV@duo.ucw.cz>
References: <20260930152358.131179731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0YxYgXquSrN7kYwc"
Content-Disposition: inline
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0YxYgXquSrN7kYwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.222 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--0YxYgXquSrN7kYwc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4legAKCRAw5/Bqldv6
8u69AJ90AwfMMVYGl8xC33z080G5O9XfyACdGaXqa4DO7dKLCv0s8bCH3Splce0=
=yjQl
-----END PGP SIGNATURE-----

--0YxYgXquSrN7kYwc--
