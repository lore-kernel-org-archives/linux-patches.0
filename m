Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF052DAFD5
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 22:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765923622; cv=none; b=c+IHfmpgZKAPsQcL+pscGRu2oWx2ufIL3G1r2TfGjb180qyKmJAg4n3lfmHuxHFiXmLYXxR67zcSq0mkqf5DA2OoKxKGOpu68l6Kp7+w+tMCJxZWqeCOBPWtR3ZwBMXgnpSMvSS44GRBMttx9wTpd77RTdKcr4wE5PWl+iMIz1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765923622; c=relaxed/simple;
	bh=2T01Isb4boRwL7+FtI8oJWi4b4OOYyDmHv4uGvcOYd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvsUNUo8lJevSaZEYop3FecrsYciWV0kbwYwwGJ1F98Tfold98q45j9M52j/+6Cc9Zqq13CcV2TXFYH/xuEosO6CYDo1cpnLn09HV/pCvnzA3j5NWdfW39eQRhccizv/xw59WfIj8Jm84tovlgK5cSNSx84IN/8w2KGNHB+uBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=WIjgVXH3; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="WIjgVXH3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 39B4B1007D74A;
	Tue, 16 Dec 2025 23:20:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1765923615; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=/zIgaMsLoHK//ga2NDK7Mn0EbI662Khfn4gTg9y9xNc=;
	b=WIjgVXH3EsEgY8E54CZ4bwC11CtKNYzg5xKgnb3L2hvnF9wXiZcXDpsTS039Y/EK/kvAHw
	Gc0X12a2/QPBBvuSfY+70ctZO/a3XNpczdS+BN6e1FwDZMEFTLHgXY3578lAiUvcPJOMGO
	N7TvY5VP900JMQ48qMeRlTHzLWGj9ABCpiH+6vXvF2G2GetSqCPw8C1cUh+JSDv7JU579i
	y4yMJNNUVqFIWF07H6vsmtTWxbljH+DNKuMwqquFx7T8cMDfOlyGfjLUkU9XtN3BOnYgQ3
	UMnHqiabYr0zFBOM9noJ7VGdVux/4F5B+yxWSIrUTwtiV6xYBpT7wZJygcUj5A==
Date: Tue, 16 Dec 2025 23:20:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
Message-ID: <aUHbG6JfqLTxAJL2@duo.ucw.cz>
References: <20251216111947.723989795@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jJALGVGZJ5jEPgQg"
Content-Disposition: inline
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--jJALGVGZJ5jEPgQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.17.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jJALGVGZJ5jEPgQg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaUHbGwAKCRAw5/Bqldv6
8oyyAKCciLUlX5vlC6n6RdaBOgXb4qbf7ACgi8y02vGrub5sEaX8QT4V7FEJe4Q=
=plSS
-----END PGP SIGNATURE-----

--jJALGVGZJ5jEPgQg--
