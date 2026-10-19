Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792429032;
	b=I7pUpr77yR0fDZP6s73SucC4KQt/4F+ZeHxFMncH9YDAYwyRHl0IK+Nb6e8CDPgd8cca
	 iAyUJfJ63gQaiQBOtcBOUMeFR03XsZRUp4kk0VW0FHHitfx4DV0jj0Iv17qvvgxARma7m
	 h9gw2yfcCUNGx4mTeHlHePuaFAwh+CgoHSdmU4BCMJd+/9SnAZ6fbFSHwIo/syMMIH+XM
	 Jhc3j1gxJgXOLnlAcgoGf06LEUe+RGAZSK4CRa4lpNtLWJE7XK/i/nav/oGhFW/UhxZ8v
	 f5IWqJilKi1I8drCGHcSvys4fRr+t5cpL4z44Vi6gnRrIEt0jGzUzXIG6s3bKf29Nlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792429032;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=UZITaddrP21giufc1kS4sSfUIiVpWl6pa7LTpWKgpJc=;
	b=d2A/Oh5ybu1+J0SkCKzwVmWIUQbgoks2V49QM9feyI7kRk+st5+nrvYUPtc7iDB/IxrJ
	 tg0LDEpXchkU44uxXrX4D9frZLF5bwrr+/vQCoyRg8SbM+X0Lv1Iis6npOt+i6SldhSwb
	 EALtqr3wkRTftwWXa7n9WN8hQUX0kukEAdXyjzMseM37T6ea/IS0MZgeux5BPoQdGEhI6
	 dTM4aBYpyb/E9AvCfNtZ0ig4VQ2cl36T5IFNFa1ewXTHD0hztn5/cIKkTNeWY0/p3lvR+
	 L/e9tzYv6PCHG/l74bAOZI8Xi6LZThAULiMBl6pWYemQgE+cz387IFex4SR8bSjznGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=bouxNA5B;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D01606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35D01606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=bouxNA5B
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0F8191074C6;
	Mon, 19 Oct 2026 18:57:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792429026;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UZITaddrP21giufc1kS4sSfUIiVpWl6pa7LTpWKgpJc=;
	b=bouxNA5Bx+tYJ/3H1Z5iY/9t902VWE+lz84R8i3GMopRow5nK8O8s2SMY9Ojquncd0WQ+X
	Ld3jMdKvcu/Mweqktef5ddRPz5EWsPPmRFzZHzUsH2rvtxNb/7BrHgq0FDn37fR6g79k4H
	v9wpmbK7Ao06tmBt3+aJl+h7uwHXm8z1dI2FS+iIAlKkYcewG1a2xMWDxTxGRAP/8LLkAE
	t/Km2PPJLbUUgosAnK31w1HIemwyhmua3TMIYqMKje8NAh/wUWul1ar5v+4fi33tOqTgpL
	4UyAaFnH4kn9BpmwOggkz/QlI43WpWRqPWsnZquYPxiSOA5VQPHInwofvyno2A==
Date: Mon, 19 Oct 2026 18:57:03 +0200
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
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
Message-ID: <atZL34R_sN6TMWgj@duo.ucw.cz>
References: <20261017155059.698368299@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="7NjjSEwWa6QMji15"
Content-Disposition: inline
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7NjjSEwWa6QMji15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--7NjjSEwWa6QMji15
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatZL3wAKCRAw5/Bqldv6
8qZ/AKCWO9YiGQmEkuVz6C1QI4NuYPumxwCcDLwxZ7/nYQPXlyCateFhGs3VNEA=
=J7Le
-----END PGP SIGNATURE-----

--7NjjSEwWa6QMji15--
