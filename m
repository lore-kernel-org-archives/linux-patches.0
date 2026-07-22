Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D6A440A31
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742131; cv=none; b=DgwWsUv1p63EGxlEjx3DFtHY70/7sPnpCU4dzL/RRqMgsXIGIm8+0PqX7s41imHcgUT1XmVPfeFITIyCsDc3P0gWw4BJfnmqixfAPShrz88WKCbg9RaHxO56kLZVcjZRWQBlPHHu+CYGLpkNfozMXfu1XO/cqrNLQAs27q53LNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742131; c=relaxed/simple;
	bh=gT7MU8xFBV/NqyDTeVqDQn6quVsXfM6hviplSR6cQig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nK8Oapa9tm84BQOME1tC1oeETE0/KHwdugF9srxqyEofVZP+3s/DnffUez6hIMKwG6Smp4r9Bfh6Lw+YG6qo1a+7JJ5yhdMywEfrDJ/CDAKcY7/I4vvY0rqrIyNBfD9ddLtM63RXZ/r7mQ9t9tWsjQrWMfpwjKZXmqWg5KGuUHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=UDnoSZxI; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="UDnoSZxI"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C6EB611A4E7;
	Wed, 22 Jul 2026 19:42:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742121;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bgEIhCRaR4uaHQGGMDfXdQ+qFFIohQse6QLjDZ7sNUQ=;
	b=UDnoSZxIkw+ROnQaC7wIdiM13NPWX4srbl7y1DNVIOpNVHBn3ylpe+rTVxaYqAvBypWLhG
	X8cLcFu1gXjt8HITHA5s1JVVlHhR6oVltN1Yx2I87/juODIFMupsDJsciE6hGqPDSzAnG1
	B0FLK+Ve9jG1wc0A0EdFVYSEDQ+3mMSsRYzXM4NOjg2Y4qH3RKUeRqYtBG4210cnV3BEbc
	ONPsvod00sMci45mThjEnVhGuqto3HMcLpPmFYM3A61WJkAyqZFTRJs98mUUjL7jl62jY+
	PkER+mZWd94Jsa1nmPouDGw5qP532LNdZorV5ulaAnam8GpNNTysRfQ3NpHR4g==
Date: Wed, 22 Jul 2026 19:41:59 +0200
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
Subject: Re: [PATCH 5.15 000/843] 5.15.212-rc1 review
Message-ID: <amEA57mOKf2bAg6y@duo.ucw.cz>
References: <20260721152405.946368001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cVTOS9O9FvgLaF5J"
Content-Disposition: inline
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--cVTOS9O9FvgLaF5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.212 release.
> There are 843 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--cVTOS9O9FvgLaF5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEA5wAKCRAw5/Bqldv6
8o5pAKC4xttIIDrIGYXXjYj5tquBcJ9EFwCgvXyIfygOc12sBt4mNixBsY9eJmg=
=uUvF
-----END PGP SIGNATURE-----

--cVTOS9O9FvgLaF5J--
