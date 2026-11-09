Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217799;
	b=n51FqQ1WOvH5gu255yhLNACfCS/Yc0KhR9Rtg0Pr0cP8elKUQVrTsb4zrpLir46AS1Bx
	 Q8r8mkahCe+7Txk88S+pze/vRvPo83DPRbCEPfhlisXM0p+s3QwQw9BEZ6zPTCoIDTppm
	 0fjCDxaKfEdok8cJ+v+1m3FE/ZLFxbBzqUjrlFaiYcNLGczC98At8dK72OkfqNqT4YRnx
	 qPGt02O5olcA4jxlw/GzWXmZdd68Y11Z3ZEb9L3H45dTmInM/IfF8lDgTF14NP+9oOZk4
	 NKnEFr75tBU0NUisMTL5yLLAuPJFjDcxJ9t8IGH2VaMKqRlDhgExGmZaraZPK/6/ydg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217799;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=c4GXWVSYSmYpFiUMU+gtc8FUYDxmXLWuMYocNxP345o=;
	b=MsRUFe24xHeRK33LqEGh8u9l7jmSez2rZCccD1uDCB0V89JZy90qbb2wp1UYyNJ7SPTI
	 joA8/jfQwsz9iN6ad1UAe0Hf8vvVmwtQTLlMvKjxholXxdF5anyqod+9XzGcqEt6rOGVu
	 4cdCo3844KLOLN6JhFJ1ynViDVCOsB3XBOxHwVTqdKMf0wIUjyubth8BNAy02okyRLvK4
	 y4bLZEuhbvCJJFQSZma/zsIn1X+alAwIvJfe9RyBTLIssfquvx5uSD7fe7/2r+sY2tI+8
	 3VcgQ5jOCDM3WA3Nbxk3/rdPuRCuducUuiVroLk4gutIR00mfRMsY0lcm/Hy6CYZobQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Z3LMltX7;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427FC606A32A
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 09:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427FC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Z3LMltX7
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7166510AD31;
	Mon, 09 Nov 2026 10:49:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1794217786;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=c4GXWVSYSmYpFiUMU+gtc8FUYDxmXLWuMYocNxP345o=;
	b=Z3LMltX7+m+BJtdwBhvfCmq8iM0r9z+pDfB7oDlVa5cWn1w7D+JYaDLepVso8VK2h5JXOE
	vYUx5F2EScxfpLSYE444owXgPmrCT1zcuseOWo8ziE/FYgA1px0MS+BUyP3IJ6JNOnqf1Q
	ikMT7eZrDm/P5+Zbl+S2HUfnDAObgbL8JWRWGUftULwtLGQVdRB66QAYxi9md9kHoyRbeM
	VfNVq0qRh5h5t4crOZ6P/sdEKpk0vH8gIrnraLz7P6XMuk0x1Ot1yQBtNsZg7Tz0NYrQRN
	kNuUI4oGsRMj8KmQoUFe5NtAUv6qGsSqatwv+FwZHTolN4yXp8T6s8xZbraKGw==
Date: Mon, 9 Nov 2026 10:49:42 +0100
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
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
Message-ID: <avGXNkyWQfNqN46v@duo.ucw.cz>
References: <20261107134957.653319350@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="Mubs9s+4go83l4pA"
Content-Disposition: inline
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Mubs9s+4go83l4pA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I see build problems in -cip testing:

arch/arm/mach-imx/pm-imx6.c: In function 'imx6q_suspend_init':
618
16:02:42
arch/arm/mach-imx/pm-imx6.c:589:17: error: implicit declaration of function 'cfi_get_func_hash' [-Wimplicit-function-declaration]
619
16:02:42
  589 |                 cfi_get_func_hash((void *)((uintptr_t)&imx6_suspend & ~1UL));
620
16:02:42
      |                 ^~~~~~~~~~~~~~~~~
621

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3040183502
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Best regards,
									Pavel

--Mubs9s+4go83l4pA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCavGXNgAKCRAw5/Bqldv6
8rsqAJ45LzdoINNO5lyVKg2/Ub4hkp9kiACgtU/TOP3J4Mz66/+lyeobAmccWcY=
=Yr52
-----END PGP SIGNATURE-----

--Mubs9s+4go83l4pA--
