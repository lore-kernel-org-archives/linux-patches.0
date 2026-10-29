Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268476;
	b=PUdjKq2qGpjJ+s23G3t6ITqdLpSkX+3tF7KadW34H9mbnUrNy4f9Tfs89nvePAjHE6h8
	 mcTYLKJ7NS0sompRnRxHSejo8Qv5ZwecpLClktBECRV8pAA3Rs4LKL2g+u+pOtpBbZw3H
	 QDS5KD+ws6HNHNwfkeP8BsbkcYiwGvU9MsYOXz7wczaBjRWKLp7D4blQ74p3PlFI+/Tzi
	 pzgcC/q62/MiBobEfKTIp0/7VCKfpO47ZulChpH/ysSpQkz8DwHkUXfX1cZyirgTQ7wWc
	 FEHkyohDn9Bt3PqfYuN077yK9fajQ91diP0lsxezbA3uH4SpsrardHr2Ztphibt7QJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268476;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=TI6AalHVhi+Sio82id/sg3uxeFVtKbdYDGvmlopGcDQ=;
	b=i4ht+S08m5QFq6QACDHxFaw6RdrG253780ozeoyVU4cCPGqF+SfF6aKFtfXydPsBDD2Y
	 1d4fevm0H7jn7+QiE6RzQP4nXe0c1cdA8OjPZfSIlS/Or8UeWCrjOtI4OMth14KefRV9r
	 6zoRwI8p7GMO27T/1skoMmql0x5i5eZl7x3TfvGpsMATJ6+ZLxL2LIWyI7XlBqI/J92wT
	 O1jd+v26fdQTFOvMwWcSA2P33zS32YSLFG7h9quz+VZ0V6580NisQKuF0imz4WY+2W6Bd
	 s1KmXLwcvPVnbqtvyLQLwtBPqggh0riK/8NG+/OjsW2ESMkXIiGRILxUUI3GMpR+MLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YeAqWATW;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F80D606A32D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F80D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YeAqWATW
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4A41E10A856;
	Thu, 29 Oct 2026 11:07:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268469;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=TI6AalHVhi+Sio82id/sg3uxeFVtKbdYDGvmlopGcDQ=;
	b=YeAqWATW5x+ozeqPviFcbl6txm4WF3dK1vVehInyHY94wyELsCfFMdREi9sbayaaMGZ2ID
	SjRZvZZdXGa9TtbM4FV4oe5SohRA0ZtbJJ63gvJ54QRyFyzmtkGKp+iJtcV0DvkbMcV5lG
	3fz5OpLBGIBdzaVPV4rSv/znlQpRE7YBOFMZmbwkLs4s3/4SEIZUizaKa/D7s+7QvGV8KV
	1Vr9GMBcQpLZg+NRTt4QD7RGBrE+He7fC8FSk9PnXKGVpR8eXsWZmko0YpAu7MHzcSniAo
	bowa+t8oAC4poCaylzAyaclL6J1X2tuQaU6rWEO1uBr8CS0tMwXMU4y9q1Uaeg==
Date: Thu, 29 Oct 2026 11:07:48 +0100
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
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
Message-ID: <auMa9BlVHbrVCngs@duo.ucw.cz>
References: <20261028170008.009143722@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8eRNLd0ea63Myaw"
Content-Disposition: inline
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--O8eRNLd0ea63Myaw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.224 release.
> There are 571 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--O8eRNLd0ea63Myaw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMa9AAKCRAw5/Bqldv6
8hQxAKCxcrv+Q4w8p6n/jDV/2gJCVM7IHQCfUahCvMGVdP8pMB4A+cLg0LLd1+I=
=gRZT
-----END PGP SIGNATURE-----

--O8eRNLd0ea63Myaw--
