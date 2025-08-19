Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6A220F2A
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 09:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597388; cv=none; b=QECLB2RRXxgMnZW6lOcwaTePiz3BCjSHB6LqLP7TWKyAtvwRgxyOFNmi/PDTOzf0gTy3TXD67ao5LFDehekiGJK1bXkylIR0C0PM6yc+2E3d5QthBmTiUjwNP5C5JbOihaX7LMmY75MP+WkGEdOfL/Qt4ACmKycJAPmWjPADM48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597388; c=relaxed/simple;
	bh=biH66giG4wTihuxZsPXlllDi58nCHzO2QRSB6toaXtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbRymXZ076WSrvVnVagyYAvGybKwoq/bxDFb9Cd2PtOXDPHBJjtsFpYrB3rqpkIQ3AEB1HOjm7Jw0y4+jXa1XKC8xBzB25NMUgo5ZHXSr5qfbUblKJFLBO81wcb9i0p2+/6jEBfAThMClmpO8xQvsGfDtA+W1w1wVeT+0RLMWys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Z5G5gj+X; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Z5G5gj+X"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 207F21038C11C;
	Tue, 19 Aug 2025 11:47:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1755596876; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9kkrBDEXFPlexT3SgwlJlE175M7wW1ROEp3OEerholk=;
	b=Z5G5gj+Xk7utCczOyW+DXmb1sJrwI83pCinrooRW7cxPCVXiY4PfFey3PSyzK1Mn4vxZHS
	XABvS1kRuCZHJ4QBHLQD0eIc+glmf4bjfpCdJKzNeWMlbxifwRpFWnA6rF4XQww+i8OGD9
	mxJZlDdSTtnihWbXpjZ128FLqbCJEkHx85CG0/bhAzUlwYfqxuIKU5/J5j3Z1Raoc8bToc
	dPVhu6b7Umc1pK9WfeJXwhduUUQzs6QbFBwWflehFxsDsL7eHcHRclydN+wFquafVIc6H6
	Hd97e8DeVQfK9L+SABYrybnfUF3Z8OBLE0dZQArxuJ/Wus9LBBbsvYsP3EURVg==
Date: Tue, 19 Aug 2025 11:47:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.12 000/444] 6.12.43-rc1 review
Message-ID: <aKRIRGAupjlxZFiF@duo.ucw.cz>
References: <20250818124448.879659024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I9Ul8A7hnuVMw6fg"
Content-Disposition: inline
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--I9Ul8A7hnuVMw6fg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.43 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--I9Ul8A7hnuVMw6fg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaKRIRAAKCRAw5/Bqldv6
8hBKAJ4r9B5r5rm9v7E3CbVwkMJvwCgvDwCgxIpc7nR/VTr4Dcilvz1cz2ga8HQ=
=9i6F
-----END PGP SIGNATURE-----

--I9Ul8A7hnuVMw6fg--
