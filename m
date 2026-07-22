Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD6329373
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742088; cv=none; b=oPEENB4Kx/in43GPqXzbbhKxQXjfiQaYEkPsO3/bIuSqwZI+zwvSraqVEZQ+/+CjFrcL8MK2trexdRwZvORp4AXx4jIA/pAM3JILRFdyz4B971Fs5+I7xAILn208cSw30jLxe9aLBTsB1DEqWxKcDIxgge0nZsc2k0ZaptZWf/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742088; c=relaxed/simple;
	bh=mLSObJioLUjUr+F1V9EvIHtaWSGVLRiy4hAvhRwMMkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGjkuA2gJaFzkslVXXiE+FDBYCgBLMXWl0thKado26AzSx0/9rLdK4WvmddpN8XyubRy+Nz+neGT5VEZurnkrJW0n94V9ddblYG2yWSZS/jwgRt29Y/DAecj4tmeyjWaU/OM80l8rVBLG+c2GzITxmxsUyBPi4voutEQS2jBpk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Dlnf++Dk; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Dlnf++Dk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 658A811AEA2;
	Wed, 22 Jul 2026 19:41:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742082;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UsksA4ETwLMsR5cvipsu4wsalFxlBqaTGcsniswUpDM=;
	b=Dlnf++DkD93004wXl72Owsn0PGr54FoVKmVili2C474QK2k8zkxcxOsFUv4YovGFCuT8ag
	Dp2YMF2ZLYb/lJLkm9A2S/ZHez5OR/B6ou4SibZj0oOPeTrixEQe3sT/wDCMXIF/zxyAhy
	q16G00NG3qFrKyA+N/vEZPlBL7X4FsdpOpAxrbDvti30IBD0kr3sCQ1ZCcYAAe8tNf+qwR
	PzVhJujMO7yIBWiDeP4NmnpRkV/hBWQp3ltmb8v23f291Zs8eMWrFfcxnpsnEP1Mo1UZtF
	qGaanSxjVMeL3EOLl2pTAqDuq+6odkp2Sm6vSib4E8u7LOyo3l4hfJM0bEKCNw==
Date: Wed, 22 Jul 2026 19:41:16 +0200
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
Subject: Re: [PATCH 5.15 000/812] 5.15.212-rc2 review
Message-ID: <amEAvEitacSnn36u@duo.ucw.cz>
References: <20260722142759.100285390@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QG7pB2SmbKh5sShf"
Content-Disposition: inline
In-Reply-To: <20260722142759.100285390@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--QG7pB2SmbKh5sShf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.212 release.
> There are 812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--QG7pB2SmbKh5sShf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEAvAAKCRAw5/Bqldv6
8tReAJ0cYYvAStNs1qGXY2HkW/rk1nx4/ACglWybr/bhWzTCrKQf5qMgAyAFMHE=
=q1Mm
-----END PGP SIGNATURE-----

--QG7pB2SmbKh5sShf--
