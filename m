Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892650;
	b=QkbvjBYA04BBAPvNvhp3ygfp93s2w+5txjVKKfONpWBkp1SYrXoEbY07vh+sIgHTwna/
	 E9GTFvc3Hfs3IJSUhOjjnHwqhxh/54wupejvIFDmO2dHZsjVg8SUKklTJLEfV4rTQPEzp
	 PDjHTIIGz3jUJ2dtMdOg8bOEHrZKBiRB6y4ZY2CdK4oIYBwEK9C/6KWT6IVtkgY4rLjGg
	 M3rIeXDMw7kUQaHBZGvkl7x8QD+a2g/rKU7eZuxgCxvbjfAuzuTLDOzGCg2p8Qdr10Tqj
	 OQEWycc8nkyPPT8lhOO/Xvy1X80Vu0aeRDkKObAoDkUQMBa2LerjOmCSjPyqjIO6A6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892650;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=f8xh5bzAH5XQe8z9ZVc8M1CWJpyKdDV4FlFi3SYW+4w=;
	b=uijbIMNtkPB2fAET9DFdJ0Lj8WPGqhZVEEg5QDQy1r997gVQONJKTDLQ6P9yU1M4W2C5
	 wbT8dfGXFMu6pIFMV/78p7tyYgsor45fk6xPUP2lrawYnnj/seyRQoCfPEXXCwqmW7+Pp
	 PTrhQvmzPlm1MxRGvXNNPs1lZ+f5Dr5I/5Au510ldZCSQOLv/5I+gzz3W+Y9XaIB60QML
	 T9EEa+cU3c04bX7/H93lhZHfpZKj02515MiOkLvvHCu/unpkX2rKVQ9b+51Y0+7Oy2ejm
	 XuDkyERq/htpFE+UyW+8/hJWwlIwf91JrG5/7OVfwjQ8lbK92sYSGm5G3ml2eY/YVUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=RfZ5Wvdf;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA76606D816
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 15:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DA76606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=RfZ5Wvdf
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5611C109A73;
	Thu, 05 Nov 2026 16:30:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793892643;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=f8xh5bzAH5XQe8z9ZVc8M1CWJpyKdDV4FlFi3SYW+4w=;
	b=RfZ5WvdfgSXEeaS4JJxfdYOlTu0bETlMG+5AbMiQIPiFsZuMU9a0WU8oEmwLEJNwT4UFMD
	xiVT8eOcgZSXkiRMrGvEjoS5SmGoPVDJI0p2Iz17DPcejDKVV1kzqU8aJCdwOwI2EsObIG
	yP9zNE7qKOYYx5ISlI7iax8lJMQDGS0JlgUS/3mkGOsv3anS7BnEP5TYce6CeBrAw4Qi0T
	5s/0pn1K9tl6hkz3EaFe7xQ4uvXWRafmxR71Rkv7zOGnlwS0BfWD3Vt88HLt5ttHGPsTXG
	zPQ27baixfzCZ8PsV2e/0B1tkkX+6n1EnTv4V/ufoCn+niBah/9ddrgp1nWXZw==
Date: Thu, 5 Nov 2026 16:30:41 +0100
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Message-ID: <auyhIbZA7ZzTeI3J@duo.ucw.cz>
References: <20261104211038.406938024@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="BVw6sPI2AcgAIiJV"
Content-Disposition: inline
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--BVw6sPI2AcgAIiJV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.3.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--BVw6sPI2AcgAIiJV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauyhIQAKCRAw5/Bqldv6
8noqAJ9cm/wjagTcTmDTJbp8LIwX236JYACgiM9KuK5EeN5fYeHj4L27qdkc/C4=
=tqxo
-----END PGP SIGNATURE-----

--BVw6sPI2AcgAIiJV--
