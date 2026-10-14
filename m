Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668B190462
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014493; cv=none; b=o9b+bWhToWEaE1KYg/3Fun2Gw6KZvJGzNH5TzoPIccjAjLmI+UTWT0ypuWVPyQHDY2Be5QVdj71QGhX1FZfNIawtrgk/4X/Cq4qpwGphlrBgHxJC7EjabBC6nNWEj6GAxdt8aB+0dA+sGR7KHdQGx8kE5MMXjixng3iXNHz7FwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014493; c=relaxed/simple;
	bh=uDA4/61lKNsuBTTvzOupnnMTqjhKMI62DCWOIYtuftI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc1t49WHL4n//YO9+eJEUrsCAdHMrfpzTKl7rL7xjC7eHz4TL2FoFR3aaxGPK90GT5G7AvkQFJ78Bj/NMLmuMh60We9Ma4Ls/ldnfDdQzp5oavkPMHzYuiq2po6n5d033nBV2tYnOvep7PqNqdnxe8BoIl7t3I+EnWcXBgTJlyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cFobp1v9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cFobp1v9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8E228106B7F;
	Wed, 14 Oct 2026 23:47:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792014478;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=FX5mPvwB7tDy9/f6EGD7rUwrPbwrZzsd+j/t5C8iWsU=;
	b=cFobp1v977jFx3YguKe/zDO3jo7SkjWbpxoAY0Q7Zeb9ia1lWpg7Dy6LkDtzWRBrxJoKab
	OD1pAM7mm8+dm9jxuBIjfrwY5yIYJCjS+J2oL+ZLBCjvuIs5ga9jFyBmBA/kT1g8m02oqU
	97QtucsomEBz9wS3mYzkTNh0DgPgjMJSiHwcOo65eDvKN6SI/1uKcJVjNUoP+WUuwe1Ujx
	+WjtaTTKt+pnGsSznbak408eqW+OSfIIuYN7rAE9OTMdKJWVGwmVUcH6zVQIOC142dUZAN
	6gnxZ0NKZiQ9Aj9Ywn6MzCxPpE+lU3FqV8G2/5269oPOhKYXnFcCDwphep0t+w==
Date: Wed, 14 Oct 2026 23:47:53 +0200
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
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
Message-ID: <as_4iaBYeri2C9aW@duo.ucw.cz>
References: <20261014123758.782265692@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R91VgserZDQsxEqn"
Content-Disposition: inline
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--R91VgserZDQsxEqn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--R91VgserZDQsxEqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCas/4iQAKCRAw5/Bqldv6
8rtFAKC3aNQQ5QLJVX5LH0ULMs+A6ojLogCfTa06dBzd1nC7TLBEU5u9HW0429s=
=0eJx
-----END PGP SIGNATURE-----

--R91VgserZDQsxEqn--
