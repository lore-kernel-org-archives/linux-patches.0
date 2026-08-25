Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B23CB2D9
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685976; cv=none; b=bvuYTbADXO9SHcKnBWgg3csWfabVOCeUzGlRwK9lmvYOmixqzxkXdMgPegGXSNL+v50mFzzSZf8KbYovaYUDD9A13EK9vXxE60uF3fdKiB+AcLrGd3vV7te68yrkdtklzRmw52ZZF7Lm0HxWXX85kmEIjacbGkT+kOAsSAVSwUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685976; c=relaxed/simple;
	bh=XmH3jneozTflejoWrChXqinHV2ZowSWDzGDkcPw1UBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2mKj6G81gGEeXYZe3ko/pFnlHx0hIMHb1RF+EUdK8pmzGxI1ePRiSEAZnpMKlkz576nxanb5qsI+9ihFktwHiBB4mYuwBgUh8U3U7GlwbNgItZJbxMFIxuNWrJYQr/EYhNYiGvDQ9+G/A+iNmWoDysQpF+cm0s8ObaA11427SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=SWZgiCJy; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="SWZgiCJy"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7629511CD41;
	Tue, 25 Aug 2026 21:26:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787685967;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3E+DvxtSXWQT62lxgL5+u/fNgNp/Oz6AouO2T1yqXSk=;
	b=SWZgiCJyW88vDlXnhinDWemZ9u+JLMEB+Q5rqzrzZtbxEzLJJeG2g4I8/j/LYeDKBaFtTs
	bd88vxW59fhar9L970R2K6eSqCmdche3/NMSDS0rrsWYb7jw4pt+xZT0/ZOR8wsKgaY0aV
	jkBFG8tPAhHkvx/z2hd9nZSwPTj3OgbSXtbobRyZ9V+i0ZsId4rJ/VUh4xzu/55B/9bURC
	96YnUoOzBb2EbhJ5TXHKQiUeBGCaLy9j0afeCquWhfnzHiww4UdxGkEcCpWy/ecanwfp5m
	M62KZgZCd7TT5oMy0iJ45CXlkACc764p0Khn1iFc4coMS8uHsdIqfqAWecbk5w==
Date: Tue, 25 Aug 2026 21:26:01 +0200
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
Subject: Re: [PATCH 5.10 00/57] 5.10.267-rc1 review
Message-ID: <ao3sSQ8raDtC-S1b@duo.ucw.cz>
References: <20260825132541.342390421@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o+dFAqIbDqrs4aAg"
Content-Disposition: inline
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--o+dFAqIbDqrs4aAg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.267 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--o+dFAqIbDqrs4aAg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3sSQAKCRAw5/Bqldv6
8sVKAJ9m3lwO3Z9d+bIUIsxgZExZEPyj1ACgkhisV3+S5+esClGXzMKn/t/4SeE=
=hCph
-----END PGP SIGNATURE-----

--o+dFAqIbDqrs4aAg--
