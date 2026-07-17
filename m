Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2873A2F6560
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319630; cv=none; b=ghBPYZ65qo4/yDH4A/XTJmj1+Iy49rfi8mR+ouxgKKN+ju/fnLAWAdqMzCWdpOrL2NfRZvYEIw/ne7GW7M8/NokFF7lyYKUoTN+JYrKMbRfQvAYT8Yg+xVfqpJTLncpE+7kkCdzk3zgkuxevR0l0zsyO63zBHbDLXTA9TmQAe4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319630; c=relaxed/simple;
	bh=O8E7/GwDst0gznNOALOTuGCOHvYoFDbtUqO1htFvOV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd8RKVE4Odr+bnXQzgztM4IAMEjCfbJVE0pOphK9kBfiewvtjjqr74edNHPocvMG/VmQuo7x7vtXXz6jRl0RjkhbbnJ351ViEAr+dB+GoYF2l4SmLTPg/bDH3G/Z8z0h0CPOg/YFlLiUSMJljHpTsr2jOhSbu5busgjv/Us4VHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=TFV48aNA; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="TFV48aNA"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A451C119DBB;
	Fri, 17 Jul 2026 22:20:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319627;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=vxwS/bOGT9BnsBgbofsOILQ35cSAAJblKztSvkOCDDU=;
	b=TFV48aNA6gV2SRvxnzjasRVoxrWcdL1TQ4ZRe1yo9or5Fcrv0d+3NgffFz9+1am+Km+h+t
	Q1VVGzxN/T/2zb3mEM+MiQ6SvL4iokOIVsSCwsRgxNDKPBqkoAoGB4vyGaM0rJKVGX0RtJ
	mS4vVrWnc4Y6seA5PgwRlhESmtuYWlnKC95vnhzJxNVFdRsbJQwTOURq5m410CzNLlZ4Dw
	1HJNtHsDj1LIprfyWK9mYMWlXIZ1+BFV021CAtWqYoL5CJOBUQF76OnLZOsttrO3hdplTe
	3rpnrz81Tf2NLmLIvnPhO6uXEcMI9xzFEs9D9HcE9cMyyxB8sx0GaSNDu4uStA==
Date: Fri, 17 Jul 2026 22:20:24 +0200
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
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
Message-ID: <alqOiPCutw8OqpjW@duo.ucw.cz>
References: <20260717101912.682013354@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WFtlr7MJQ/PPfSvM"
Content-Disposition: inline
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--WFtlr7MJQ/PPfSvM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--WFtlr7MJQ/PPfSvM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqOiAAKCRAw5/Bqldv6
8lhPAJwJLzwAxgvUywVDtYOUX8mS4wBYsQCfY2Yq2zLM+iL9WoQ0O5KZBSO1uJI=
=/jKF
-----END PGP SIGNATURE-----

--WFtlr7MJQ/PPfSvM--
