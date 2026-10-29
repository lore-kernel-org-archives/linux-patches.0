Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268654;
	b=A5QWlo1SCO28n9kMF0OdqO5cNChELb6E+E7KNguySZDg0oCCvdc2JywmfaqvqdonRXDR
	 vBorpovpnvntZoIbD84p0drSN+3cNhyF2EcaeXm/+5CTR9m06217QNv3f+4YMo0RlFJ34
	 Q9Zxt/BEm0gLFXvgyhXrwOc7CLi9zwLNZj5qamXf+vR4MU9dq2REcibusxAaOF840vFGs
	 JPWlp/KoUqNJ8jiAuguEUQZZ6CwUJbhneAXllR3NKZV5AH+hjovp6ExqlIoJGcWwOs7or
	 4KyDKWppS7kxek9dzoO+YCd4oAD0DqamotQb5JX5Xu5CRrPO6xfxfBppCIgjGPezB+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268654;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=7S7aeD29u+uvo9xWL5r0KzXNTY/J81vdo5wrgo2brgM=;
	b=jyi8SHYJBqlSSn8aODly5D06m7YxAlJudJGbYJPO0zO6Pl3mjF/syce3/LK6Jc0aGCTy
	 GF3q7obSDNJQe/2Mm30LRUJQe4ucQDKDrXYrK8axZR882q+aBVqa8cYzEdpWYV+o+9ZG5
	 SG8Rvqjasdk/D4Acow8raDVZdQlvALK3Nl3mlUDc/RSAVQ49Pp4qu8UwvvhrwRQegY23U
	 mGaOFOA8/2p4sBeLzsyazfvdAHNFb1Wfs7oFhe2ikHGhEDa4TH5el2G4+f8uAHF0AkGyA
	 sxwCEWWRbGmsghPe3mT8HqcDSKxySSE0nt4XX0u5xItrxkVWiufTinB4IOb7bV2tlXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=HHjucqyh;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F3606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 330F3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=HHjucqyh
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C578810A890;
	Thu, 29 Oct 2026 11:10:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268648;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=7S7aeD29u+uvo9xWL5r0KzXNTY/J81vdo5wrgo2brgM=;
	b=HHjucqyhckwic7V7CaO7vH/g4Ef2YKxvX5/FHehD7g1BiMHjq+lqNBAHCXYUL0m8rlLzeg
	UtQMI4/aZFOz/sZ1gpkLEIS5eKMgjuSKEiSnyIerVAcm4IZ/KhJhm4ozG2PgRDvNWOrWN4
	4NJd8DxQ9rc8+HX3YX2gNXmALxfRLd2S9+AcyAggr1QZhrq2j02bGE7JHTAYAgDSBFNkby
	U2rLG7w4oICHi3fOfrPRwqZVuu1C24G+l7f+A1eU1PcIam/BcqPn/wPH+C+sUwZpYUU+hF
	o4R/1EpXZbpVFBVWI00CZ3Dv4DyTixaxz33tfivNh2IjsUuxS4U1yF7Lfabjqg==
Date: Thu, 29 Oct 2026 11:10:45 +0100
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
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Message-ID: <auMbpZNWZ4roHz7u@duo.ucw.cz>
References: <20261029073135.159947193@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="UNC18e+Z0tHnZCLI"
Content-Disposition: inline
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--UNC18e+Z0tHnZCLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--UNC18e+Z0tHnZCLI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMbpQAKCRAw5/Bqldv6
8vh2AJ4tNZLSIc+81XxnUjyjAP0vo5OvwQCdF38o7EgWj8WBUp9/uVryGdPyud8=
=aTnf
-----END PGP SIGNATURE-----

--UNC18e+Z0tHnZCLI--
