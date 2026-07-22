Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4263655E9
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744800; cv=none; b=sZOOJs/LAt8qOwgCIHIen47yCwqWaGpNEsWnc4LxVFsLLciVAWnS2Zas/LDKZohaT8l8kAm+qERUldQJ1RVSA2VeWa86gLoWHsKogyJmBubhW4YlnVFB6Sg7YSplyx5uhiK7QRt1iabwB0gqQ9AAvdva7BOZfEY3xHFPwJANWTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744800; c=relaxed/simple;
	bh=pM7boIvykI+Cthh3a74dYvXguDbKwpvfZw3MT1nkRWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnUqn8YdkH4WAEp/To+zIo8FZ4y2gzZb1A3aTwM+xu4TH4ktJpAhiUmk7MZ0ORxFU0R0hIoN93dWYBPL5dTXLWBYu32ea2DPqYqzPY9j6MQoq5jzQCPKc8hWg7TBw0ip20UGjbHmzFLdisTAVCmJ/diNVuaHiPDtO3PFm96YLOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=JLRoaUSb; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="JLRoaUSb"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C1FBD11AC8C;
	Wed, 22 Jul 2026 20:26:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784744795;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=kmCz/ImPLWoMR9IHenF41FP6VQfRZ//uGYEa8zTZPeM=;
	b=JLRoaUSbcO6jd9osiF7qgDcvYLoFocK1yqs0AuwfTu4Zq+OdX8jcbhe04KPhl5pWhCfIdK
	ZBPnIqDoDZo9+9y7rTX7AAbsn/JsZQJb6+q5L8p4Booco/Z3ZI4PWdPqGm4ZsxAR/xEPc9
	NTYrESyrdNF8JOKgf0FkTevfcP8skNL71IDRiObfG2TzgGo9I80ObQ/t49ra8JM1O3mXbA
	VWPm8swPkfskPyI6n4YXo5o1UMapWrUBrvVyEK6UkEjuH1q20TEvqHjNx2s3qymIDtGS1Z
	WGdjyKM1IH+EtZl2t86HpSjIZDC8T0UCBZ+TzGHkm4yhkGFysiORdAXQt3y0tQ==
Date: Wed, 22 Jul 2026 20:26:30 +0200
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
Subject: Re: [PATCH 5.10 000/674] 5.10.261-rc2 review
Message-ID: <amELVicPib8n14Vz@duo.ucw.cz>
References: <20260722142749.280611149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4jSYTQBaPU7C0LF"
Content-Disposition: inline
In-Reply-To: <20260722142749.280611149@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--z4jSYTQBaPU7C0LF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.261 release.
> There are 674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--z4jSYTQBaPU7C0LF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamELVgAKCRAw5/Bqldv6
8pGwAJ9fF5K5seOIRJEjek1fzv/0vkdkZQCeNFI1n9ePcpVTUq8dUBnncCSLUmw=
=h49V
-----END PGP SIGNATURE-----

--z4jSYTQBaPU7C0LF--
