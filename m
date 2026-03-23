Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398B635A39F
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774293489; cv=none; b=WFi1ZvlpB1YaQTMVCcOmNeFAQntmk4/8oxANQ+69ZvUZO6xi4aWEtHW19vj0lPI4pQAzs+p/qhtglNc+GBZEYS69GZ+K54UXM846gPoAS8iIZ8ZpDSPQl9iS87O8i6gQ52SRpiypLF09bSgz6cFYD7DQLpJSiKVtjAMCpyHebvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774293489; c=relaxed/simple;
	bh=VuKHwt7LSaiEbqL95a63muO/LGnc0mYQrqDizGRYDtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwvAz2YoZ/u4/egZ4ZnsLbOfUtanecpItz7Vffspa3fk9jiov/39t8nTNOJln4R1rh7iT9ZOSFUOQoIyrxUFOYxN2hCI1Nh9yLT+VZ6FvNsv9pLx68BNx3bu4Ve4LkWkVibyaFrawEff2tgckItyUUO1w9VkCAtpsBZuTt4Hppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=byKtN6C+; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="byKtN6C+"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6980010BED6;
	Mon, 23 Mar 2026 20:18:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1774293486;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=C3eEOUiMoZgRAHCKwXqXREzkIFVOZHqNRBc3R6p9TB8=;
	b=byKtN6C+baTM6sJUs2mMW8Ms+nE1nCv21U9gA0gC4ANYB0wataCk3+eLdu90hpb1H720FC
	fflOXL1jyY8EtwrDYprZUHuzaP9GteZkNaf0zLa5d12mF/UYLhEOjv87WnEzGJ8L8+SXAa
	mrZaLsLsokksrcMQzCppUQyp12G4e6XuDeIR8UOM4m8Ld09+7/X9YdcfVFfkuaGQDnLQ/B
	9wHOWRBYUImDFEqjt5BrZF0lOvfHwVuEgdNXWiSogEtKksUlME3XL9ny73rKLIPQTECPcN
	bizYJPWLv7TGmxECAis3kHB7HeC1ODKTi4O3c2ZNm8GFWTkWXMwmPVUv79PfyQ==
Date: Mon, 23 Mar 2026 20:18:04 +0100
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
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <acGR7C1DAzRjnyD_@duo.ucw.cz>
References: <20260323134525.256603107@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kLEnyp1+YAwKCx2z"
Content-Disposition: inline
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--kLEnyp1+YAwKCx2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--kLEnyp1+YAwKCx2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCacGR7AAKCRAw5/Bqldv6
8mysAKCrDYft1rtWz536d1UERGtEnvRT+QCeIEUAzJBnjHebFbDHbf3rLDOCZeA=
=lIu/
-----END PGP SIGNATURE-----

--kLEnyp1+YAwKCx2z--
