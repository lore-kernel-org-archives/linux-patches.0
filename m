Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F483E3C5D
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742204; cv=none; b=UceG/uhsGjLr3CLRDAF/E+cWdGltgHXChOyTag0hR/x6DTHetUAjvODmg5TqvM/ZeGqIJPEjuRRzpP2CQRg9LpnXPmGrlXHAubA8OiOQe1X6ql5ckstMnWiYPjeEjmsZ/rPofjkQiOcGQvWFv6dvVY7YuDmTCY12myugPp8cOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742204; c=relaxed/simple;
	bh=m/z3W2RoqJrWkSA2Nmm/adKZyLzyO4wFguvjWWl5b1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiFOt5m7EiMo+u9i13YEgu52FBtpozdKxTz444XJ6JmksnmigoIh5rmMs+WyjPERbRb84m2eoTx45mJqTqXO1SybYyVlCgAHdWNOKJjCb/mELpE7/ASk0tbWbi27I5UyJep8WFOp+L/EeSMW+r2WCIVY9lQIq1Rk60HXf4h81yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=SNsNSjKx; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="SNsNSjKx"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C30E411AEA7;
	Wed, 22 Jul 2026 19:43:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742194;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=a7vG+WX9VSr+zucFJUEdQjGjdXZnpAlGsiu+fpe2Bq0=;
	b=SNsNSjKxF4DrJr1Q9DLyXCudUjuDEFvabbPkbgDyU3JrYXNPNdWO2U54EU8DccMDGvQHzT
	LJlRREvvQPsZ8qjcGQttTmAJPasn+dcHwX7wlIWsrwbyEKy1vLS5PH8TSuurc9CmV2ubfV
	HQ0OZKXzIHAOHJCandqEBMr5sTisGTwWGMvVOrBVJF9D4LMp/1mA3kaQUR79ll0JtCEkwL
	hc0HLSELkOg21utCAJitASQfZGdNSn5SFusAxBJefXYykH+WW1vY9xRtq3o8+EGfwNDINZ
	wYY3iun6TX5+dF4WnTCa0YD/qeNO3FkcCQEkK8Oql2gE1WNehdsNCYfMU741kw==
Date: Wed, 22 Jul 2026 19:43:12 +0200
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
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
Message-ID: <amEBMKZPP_ypW7CI@duo.ucw.cz>
References: <20260721152441.786066624@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nzsIyVpvoh1pV3yY"
Content-Disposition: inline
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--nzsIyVpvoh1pV3yY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--nzsIyVpvoh1pV3yY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEBMAAKCRAw5/Bqldv6
8oh0AJ9YnMzp9pWG7U76B6c2VNOi0X86/ACguyMVeLhUAGT3nmWyqUwX7/45BFs=
=2RlO
-----END PGP SIGNATURE-----

--nzsIyVpvoh1pV3yY--
