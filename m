Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792429081;
	b=XCYWxZfTHxFbWKmTFwcuRhPlQwewczRktxyLaP2DlxST7mbwjL3nj1pWx5LMGjUaWvlo
	 3TcR9BRxboUQRoDocddQqiLTJFN5fMTEvhevWfcjSbH0iLPiTz50Kgd4H12Z89GBmkQJ/
	 zc/0fH2VLLKjfAfG/fnsXxHRm+8Kntzoq2t3zA/Xja8oNRW+QI/X2NOWY1H1Vi1UzJPD1
	 66ewZXPjT0mhR6tCRBaPxWn0fSxhrcuEFLKxz0FaNDtvMqI0mE4IyUcXc4iaMjzQec777
	 hvG6q6n2l37MtztWnVqAN8pAEOGUDVf+ajxMADRZJ3RjY2/qyzkU3uEOThc80Uckw/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792429081;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=iStW2gtmFZ94IqFADcqGvldlgQFT0UA+D8ygwsOiHws=;
	b=MaA32+6R5V3Fap6CG7F5WnDC/J4E6Eij2gqEDIH/NGb4cnpfAnoD7n5xAgb9B6H30zBA
	 e/oWJAXUV8GchQC0wnc3fTy2L9v/mCmVUVaCqdqhyZ175sBmet+xDqhIh1CpUz3yuJBYM
	 mBjp2bluozqsPelFsJdsJyuS7Qfyul6bX8L3oWbOmF2OSg//kFJusiMCpKuHmRTgkb1G1
	 jcKoP7AqWkh0+p9ePhqoqwaK6Ujy+wUBYLxcVNizDCgLqRp02VvYEScRXX5xNTB8HbJRr
	 JLVFd5rQV3ZZ97oU250Q4Gc248sngvD/oZcDBYy68O4aamdKTPv8dJcxmUxKzNstr8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YZDvRKr6;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F0606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 614F0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YZDvRKr6
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D613A106C76;
	Mon, 19 Oct 2026 18:57:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792429075;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=iStW2gtmFZ94IqFADcqGvldlgQFT0UA+D8ygwsOiHws=;
	b=YZDvRKr63J7qd3J75q3t2mTaeBa33Gf8LzM6KxogRKrLZf/X+r5jf8Yv/TZdFpKUoQlbAB
	7KOzuwgtACsHCsT+1bjX9WQi9SW1gvM1bCV97/T2W/WqGlOdoOjz0dzH+JPyXIMKwCeMh1
	dB5c3q/ZTv1d/WHfFFSAszIKkyuFeoQFxGWia/bnOftVOPZKG5zXc5kPTfk9x36py2FxLe
	ZzRuyFnVWTjrOdCmeDbw3Z+ABJpB0QP5Kw8rtA+C9t87hy3OFpLjKuxV31BJeKIiwr6oKO
	jimA1r4oaouBmK8NtV8ejflR21FvAe2x8VzVTQTqtSNxP97U672DCWBrjL5iiw==
Date: Mon, 19 Oct 2026 18:57:53 +0200
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Message-ID: <atZMEXAy1y-2_irw@duo.ucw.cz>
References: <20261017160036.979869304@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="ZdM0yZJQjbv07ct6"
Content-Disposition: inline
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ZdM0yZJQjbv07ct6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ZdM0yZJQjbv07ct6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatZMEQAKCRAw5/Bqldv6
8lQSAJ4uHtcHc8+sXe8KZxoIXXqHvN7tmgCgvZOv2/UbTnxWlXJgKCYQQgrvjuI=
=irlT
-----END PGP SIGNATURE-----

--ZdM0yZJQjbv07ct6--
