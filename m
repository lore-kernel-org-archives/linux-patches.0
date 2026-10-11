Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3D305660
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791752908; cv=none; b=WkeGw+VNjqO6nspbfhhXQ4aXsaILL3OJYiy5lp25DImSzOFhatbWHQFTend6goHkVyH0Tab9bz9BHtFea8boSEaqjTxXpBveuF7CtwErEv7fbQl/5S2517dlj/Fj6eZ62jflO0J/u3L4dn2GYNRvP2pZrLH+eq0YGJYLV66Uwbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791752908; c=relaxed/simple;
	bh=IQg9oh2LnA+yKKSr0zheC0T41BXq4kFKgbxcDlb7/Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeLyIMgMhfrokLlaMaUSJD+/9vu6sfSQnix0988XKv6TKhXKFXtyc47ukR0ibEga1mFsrPTyEDOjawOD03/vv3TEpRM6NpGA7Eqh8jGaT+u858pLub87maSvitW8PEP2U1N7ZVvhiq/Jya1oIWjiGp8abr4LHIw1Odw5Q8rOFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=WVtB1du0; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="WVtB1du0"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E265D106E4A;
	Sun, 11 Oct 2026 23:08:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1791752899;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=zNiGng+6U4NV7UMYDURHxyc0LkdRBarcaWyKPu4nhTk=;
	b=WVtB1du0xYiVv9qZOoYmJvkiSMt0GQF6AzBCcbY22qvskVF7qJ/luJWnSoRHyvroL/BQHN
	5oDwe886u+W00fEZBU/DHdjnN31Ji8/kXtH/3zz9Dt6KKzPFB/1omy0JlioYYgy4SEHm/8
	GxiLL1gLPOflDXtSHkQWxBiqVJNVXzhQtxKw7AUED+k1Sghb8mfsbU5/LlsGT53kBO3mNx
	y50LmVENrcC/QEGBnKqCr9INEs56BVE8BMR9usUB7vOM28N5EoQo0U8ym/xAcee5G9PNTl
	xrhBeVMlEJUHkkkNbc70utd3O10dXfBMBusi+loFmYbvthn1HtyIVsyexdlmfQ==
Date: Sun, 11 Oct 2026 23:08:17 +0200
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
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
Message-ID: <asv6wbKJkNbt0QPE@duo.ucw.cz>
References: <20261009140952.119038291@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofHhmPEdEv6yZYDQ"
Content-Disposition: inline
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ofHhmPEdEv6yZYDQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ofHhmPEdEv6yZYDQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCasv6wQAKCRAw5/Bqldv6
8jp7AKCpXrz1lemKDaIL2XnQQvS6aMQ6agCfb9z08+0TZl1A04Ha8+jjpOP9RN8=
=rF2u
-----END PGP SIGNATURE-----

--ofHhmPEdEv6yZYDQ--
