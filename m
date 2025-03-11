Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E384E264633
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741720051; cv=none; b=TYL6McjBorl1Xpd3LSxSRnxpOr3GHsjoWEy414xedpnJQ6rOXSfpwB9lTmWyEmGrGck1YHoOUwrT6jZROn/86+OwDja/ano1cS49UtLRSpFBW0U4sBzYR+W2PJhnL6BpRIhvScshQG2Sx+GVkY+jbYPjjy4BI9/IYmB32nIyHu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741720051; c=relaxed/simple;
	bh=wwgYUWap3qI11eYVx3lJJCC2CqUY+TswSLiPdB3wCvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7xk68pm6ustWgKyEvvNzLujl69M0ixDDP1nVYRLsoqAef1IVsNDnIVoAetdm/SW1aorO02dfglz27oF900ke86H3uOoyC0ZFGNcTaz2kw1IQNcmWXbkkc9RCsLKfduNgTMC42Cqb6wqWvR6qI/A+GuZQrK6+z36RuFbnHXC5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=a/wXL/mA; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="a/wXL/mA"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AC3BF10210BC0;
	Tue, 11 Mar 2025 20:07:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741720047; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=S4Or/qiElD+4yjpKIaR7MRB2stIPkwTKh/9yZQ4u0Vw=;
	b=a/wXL/mAwNJde8QzgVtLgA27/raYba5ENOCxht2NuPTR1irW+1KhdTUCHGwWojWc05ooYO
	+hJyubKpzeOGUj2jJ/sQ63PkEUVWorUEKAj/n1YLwitthoNvSIeAT2ORwLOeLvv5wHXi5f
	+w2Vey+NFKtsVWF7zIWuFy63fFp1HSs6ZpZ9sI/4WHTrH8fD/PEmt3gNU4BQFDUUwfvRCh
	MF7IU5t95Dw4Khd08q0wn/OX6iaf3xRElxs8ZwIRsGRpthn0xaQs9u4aPgKmvHSPWz04qo
	qEpRHGM+YsbouAxJ0qfSr+wVRQaIipD451dY3NnRWt5cseHZNON6m3v1b5jmMA==
Date: Tue, 11 Mar 2025 20:07:21 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
Message-ID: <Z9CJ6eyDVC73Xwfv@duo.ucw.cz>
References: <20250310170427.529761261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mTzHy7c2Rw0yfhbY"
Content-Disposition: inline
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--mTzHy7c2Rw0yfhbY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mTzHy7c2Rw0yfhbY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ9CJ6QAKCRAw5/Bqldv6
8tTOAKCjYuxBxpGVFZv4CymMgvGMxtDluACgri5KUkXzc5pkScjU6ON3QcAvAx8=
=Rf5M
-----END PGP SIGNATURE-----

--mTzHy7c2Rw0yfhbY--
