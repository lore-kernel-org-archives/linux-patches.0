Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795779484;
	b=M7pfvH3J748HVmmTTOaYwTFbmAvWnFGk4NGJ2gduqhhpAV7rvubJYs0eCdk2DQe5ACS0
	 u2f2JR90HEbKJkENOgxqxitSjA0szUSKZsrPnSIbBTKIA8vF32sT3WhYboMXa0y2+3tkr
	 h7i0Om8KhbXFTM/HN2GiigrxWfMIUVWc3/1MjMssXFigv6sXMQSROw7wL1k4J13iQBpEy
	 nh8TvIbf9S0zBP3igFimsAhSIWuUZOHrmoYF0q0D1+GY2/C1NJro/aBZDnTD56sGmp7Gh
	 VsOCsZ3rjW9ksPmksduH76dkt8yTbokcejYm7vpqt+Ur9iQ60rmbqFNfkQ2aiMV2yQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779484;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=Tq4F0Eq2vjlkwyqOn3adEAVZInM3B87MkHau2yGN/+s=;
	b=eJMCWHfV/mKMWWAXTxc/j6wGoHsF+Ug/P/ezVJYfpWcTFvyKjF7XmlllOmdTXxyPIHwe
	 m7dXF2kuAQ7Rdek+l1rP3xcP8NEvzTE5ml/LU/sFKLdf5KBxykn7YcANQXONTc0M/Iz5a
	 2Zzz7xUnyudIQe3Mqyq0cxSSdc9HPHbE0hB65ln7XXkXHwNM9eSFomNqZ3Weh3t1tJaOE
	 IoiHeoxmFSTS6HCBFcuybtwT0fI6BiWhk5HoEqw76ruS5KtlHOo9ZQ5i2EiuTShTeecri
	 pXTfeaSPntKkmR8455RqO6bt0KklXwJ0LUlmYUxTdeOpfUu08/BemA+7/IkD159G06Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=VMOVOokW;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE9B606A33E
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 11:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CE9B606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=VMOVOokW
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A47710AB1B;
	Fri, 27 Nov 2026 12:37:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795779478;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Tq4F0Eq2vjlkwyqOn3adEAVZInM3B87MkHau2yGN/+s=;
	b=VMOVOokW/GOaK6BD59DNVzcnSiEli9UqfauMiIfsA9azAWjv83LBJKnb0+qpJ3iTHQU9g4
	6OzNBpz8eI/b+TY+6G/BrmyMadbOXQ5Y1rCFcyJFZbFM5olxmqAZj29PSJwHddKNWMnrxH
	Ei36yqtnPxy87GFR5YiQdZgv7zgV1+ivxeyKc0AkXEgXQzNGuKfTyJGawyT0hJh8XPKnQf
	h0kF/92A5L3rnju7Bq/AT35juz+SFtYt0GhVmN+8DxAWkhHs7sGRs4yuo4yKIofAhXSU69
	So1NDuWNneG6qWwXEQY3YUXAGWpv9nSbrQzXh9YgoP/aa2q5dVxDF/NnIUuBog==
Date: Fri, 27 Nov 2026 12:37:55 +0100
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
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
Message-ID: <awlrk-W9w4vQ1aQU@duo.ucw.cz>
References: <20261126105709.009001842@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="JvoJi2FzZ8mnpaNP"
Content-Disposition: inline
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--JvoJi2FzZ8mnpaNP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.120 release.
> There are 815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--JvoJi2FzZ8mnpaNP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawlrkwAKCRAw5/Bqldv6
8kHWAJoD/ySmUF+M1R55RPGSfemykUDuTgCdEQJZpLlAIU5q6KBmA4c9lG4Istc=
=5C5f
-----END PGP SIGNATURE-----

--JvoJi2FzZ8mnpaNP--
