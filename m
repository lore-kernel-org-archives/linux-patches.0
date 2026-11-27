Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795779405;
	b=eLmn5hVidCXpBTzfkTR26lsAGtxd7lhy56sbkZ3kPDHrCmg22OX5oXI2cbzYvfzyiqp9
	 eSv5u/4mbHiMATBH4jqU+TrHClMZdsn86lt296g4rh3tJM7hT3HZfCKUfvfNPdQud1MOB
	 15bWKrHAsFArErkaXUc2ZIp427aISiEQAh1BnZDR3DDCBJuaslGepf3w4KYgXF2aRfr8N
	 V40Tp1x8sWVkTa9L5FEF5WYTo4RDfx3QfRI2WgZHgrGgB5S6FJmhXKivyhf6M2VEnyCCB
	 raHEoNTaD8tCB0SOmOqkIOBozJBEqJpPCRH5GhAMznRkK3UVIrJ7acH5U4dEMWxgcqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779405;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=HBUFziVfNSMx3ydlT4B8ObE1k22rGp9asUzUB07kF2A=;
	b=c6SZyYsa2sNFoazjsDSI6/GAUzCcJ8ntHfk/b0PHyeLDyWt7G+spEOHOHvhxrMDEpZD/
	 +W9qIlYpl2wq6k3zeymudbgOEs8eNmpwwZFO+DyDM/QhvHtKpjSgqdkVJoo7m3m7NM73D
	 D/J07hvEMuubJX96W6yOPYbb7IiYBvpb+HEQZxTnrara8Xf7y599U7Ft584fP76iIInvW
	 dhf0tT22m3hYvFYl0DC1FtDt0b5L8ceTq62ZKxW/74+a6IR43NOjmnUqU2UlksNtt/mrD
	 sdCpjyztwyY21eNnBYJnG6UwEyEHkzsSta5mWaMVHvPfCZLVU0HFdIbxh7BdSWVMhUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ggO6Yjs4;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47CC606A32F
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 11:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C47CC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ggO6Yjs4
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 428F510AE74;
	Fri, 27 Nov 2026 12:36:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795779391;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=HBUFziVfNSMx3ydlT4B8ObE1k22rGp9asUzUB07kF2A=;
	b=ggO6Yjs4qJI2elurMaMm/zUD5Oxa6yQGhE4460tNuh5JuFYmJOXyv4IHEqeNLG5dn2whH+
	FTuwHM/X96nIB7XSIT3Ij1tta7OB2U7t5dNleulsEs4e3icHbjn8j3XrbiMlPRLrn7LkEn
	4azOPMccahIH0IzKdOZD/guASDb8T4hzxyZY6taw3aDCOyn53sxs9ykapLMA20U6lDler9
	jh0FMA3uEAumijZtLlj1/ZTFdDTi3l0s3Zw2eRGwSFUpbktnOCQrnG49sBiZMTHPe2Lx5G
	5aiWFTxO6U5x64IpOpfyxCaD/96XSDv3pR7Egv/Hc3tMZ75wwEgDS6mt6fcScA==
Date: Fri, 27 Nov 2026 12:36:26 +0100
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
Subject: Re: [PATCH 5.10 000/264] 5.10.276-rc2 review
Message-ID: <awlrOlEJuhnf5HPb@duo.ucw.cz>
References: <20261127052100.671985356@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="0kFjwl2D0pxk0A5e"
Content-Disposition: inline
In-Reply-To: <20261127052100.671985356@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0kFjwl2D0pxk0A5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.276 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--0kFjwl2D0pxk0A5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawlrOgAKCRAw5/Bqldv6
8lfLAKC1+c2fmExtNSnNELebIwalCPTo2wCfX0bMcywvBz/Rz1ckf5pF+QzomTk=
=Xc8p
-----END PGP SIGNATURE-----

--0kFjwl2D0pxk0A5e--
