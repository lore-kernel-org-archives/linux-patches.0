Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268359;
	b=feFh/RlG0ntVAmVgv2HYy/5DjxSSVUG8BY17pyfyqlm/FYt5Ts2aPJCCn1zEhbSvoNAj
	 bLQD6X6XD6jDoKFJ/nllReVG5sH5Ae5bCCpt95UcL4h2EwY+6RDubELcBlAyh6i0TBnFg
	 atkLtcHMHoyFMGd9RHqbeFMp7DuG4cQvDVDYbrh8l2Gkq5Wl9sBd/EHjWh4Gk1C7KWL57
	 7uHQA5dKhlO5/UN2GuhhnFuArYh4yjjd+ls5y+cs57EaCF6Ql/gUskQ+XSG7xqBinVK5j
	 vL7n18oUXvoHyHeHlqHyR6WDbMtduJCvsggxZFTcdfq6amkPZT0qwLB7TK9CTKCHjFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268359;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=vSf/TFs90nJ8hh1K9ZfFZCv44cpy7CMohpwPUpwVGTA=;
	b=e5J0F5dJKuTckmmWFEnaz1qlUZFgcSCrzmzeudilbL8KUWK6TfWtDLyqw0kftkPaizIK
	 KADMMJmun+3a6Yd2ddO29REjUSxYvA/6Gkft5WI15fTaNMz8sa9jqN7ZNBxVSoGPU/8w7
	 lQEBYuqi4ljLPadcQe0vJ1V+O661deLK0n/lFcmFca1jNnzmhphOnQJze/nPkLlZrIk/9
	 GPTY4mCrzby3Ma3VjGKLdxP2txoXZBACsjxgT7nAbtreW3GWMud4yo0SrNJu3TxiuYzr9
	 2CDm7R76XjQnOFRbtJZ2l5rLxZj0UaBUFai3yq6iPx18VY42GFaIsuhxzWOuoNUKjdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ar0OxHEn;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D8D606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60D8D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ar0OxHEn
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 55B8E10A8E1;
	Thu, 29 Oct 2026 11:05:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268352;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=vSf/TFs90nJ8hh1K9ZfFZCv44cpy7CMohpwPUpwVGTA=;
	b=ar0OxHEnVyZ5h5LO6s0ZmRz7SiwkgLnWlk23XHqsXhaJ5WAXn1EyAiTgp5B9OJ2mz1HVmk
	boPBJoVe8jiEYMlXrlRwkhdCHJcS039MLfZz8UGHNIhgkU3JdA1sKJqx+imfwGjnpAiuOr
	ypQWtVq0WP2Df7jlCNANTRDn3ghlaQDMfhQjcbYos2y6uai+0razYedYsBvDXH4mAZIzHt
	4gdcyVmeivEXv9uzEnz9gdZOt4nv3Jx69SHSPBO040X2PED+ArUw0ZhpcEydAcwNnuUp+1
	MlT0xbaiza0dInF6qRnbWVAkdDFrza399V//hHHus3ThZopnt1eJJWPtN1qTsw==
Date: Thu, 29 Oct 2026 11:05:49 +0100
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Message-ID: <auMafQ1EpeM9HWqo@duo.ucw.cz>
References: <20261028165947.349197979@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="A8Yy2UZsFVrdCZ7D"
Content-Disposition: inline
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--A8Yy2UZsFVrdCZ7D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--A8Yy2UZsFVrdCZ7D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMafQAKCRAw5/Bqldv6
8nnFAJ4/ixpBy5wO3NrW+lJpP9xjU2oS0wCdGq3z8t99E6at+Hn5RrmoEShce8A=
=6BFR
-----END PGP SIGNATURE-----

--A8Yy2UZsFVrdCZ7D--
