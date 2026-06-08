Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CE37AA9E
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780925449; cv=none; b=FLJgiMXnedEGWaXKtepMWB0Bp1DKAq24hoPYYyO4qFPn6swqYbYpyALX7JSQAWq5SqL+x4m/Nagb141jc0TCt4oWLhpZcyx9bc8S+8G4xO8lZW1USoqBfF+9d0Go4iGVit1aU5GFj5LNk1/YNAGAlPeTDQr2LECo84iFgOhYUEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780925449; c=relaxed/simple;
	bh=HoVxJrmNdNyKuTfgfkUcnzVzitIsrz0sFkGlO1oPAt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlkwzR+5DwYYbw5RUWnGUZMFfLPGFB2IgJNVBtzY5C08AayoLKAEZW4QcIGto5Hsvj05e1dsuV/ZToEWqbatPC7xuYZ3vtqqGb+MwbtSldYJyB9hZjSd7lH/Hc5TTCSJwTcBVz8aUD685Ds8EFOn5OE6w78uLdQVPF9ab/MAoRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=gMAXgbv4; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="gMAXgbv4"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3A6A811587E;
	Mon,  8 Jun 2026 15:30:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780925444;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=5HwpKJ/UIYyOBqZ/ZTusFSBPHXp/ne8z0sYRp/3RNGk=;
	b=gMAXgbv4aIYLrqsPZX0pyFHkG8u7Z2YF7QNCA0wWGkJok5gTkoExNiDpTHrE5BeXQCQz/4
	3x+tMhfUhhUywZ6ZljRclr796Y41qSyU5HtUfz9FSMLpD681kPkFqO1Wl7UY0MBSjlU76m
	lzFbEAP8nfQ9jpWAJwD/XAF5jWBWQ2RDZp0iSnGENm+x9mR1h9BCnMYPkbbYG02duB/9rU
	Az8Z942RQd2tpknQ+yVIOjoLcObFlE+dZiXi5J9om1B6EKVtr6rBZrLEXmfosKjLxPNr22
	XH3Y1fg/odvlW9QQRsVe1FddinHzs1emjmkJWoTh1RwKvFAfVfiQzZqsSUbySA==
Date: Mon, 8 Jun 2026 15:30:38 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Pavel Machek <pavel@nabladev.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
Message-ID: <aibD_iqWXoarE_Yn@duo.ucw.cz>
References: <20260607095727.528828913@linuxfoundation.org>
 <aiWjTGe7fRnSvIl4@duo.ucw.cz>
 <c56becbe-aabe-4c27-9324-7119ccc68d6d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ODYpK5TG9lXt+gsS"
Content-Disposition: inline
In-Reply-To: <c56becbe-aabe-4c27-9324-7119ccc68d6d@nvidia.com>
X-Last-TLS-Session-Version: TLSv1.3


--ODYpK5TG9lXt+gsS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 6.18.35 release.
> > > There are 315 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > We see build problem here:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/14=
732223960
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelin=
es/2582906697
>=20
> I am seeing the same build error for ARM64.

Thanks for confirmation.

There are more details in Message-ID:
<20260607170440.90814-1-ojeda@kernel.org> .

Best regards,
									Pavel

--ODYpK5TG9lXt+gsS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaibD/gAKCRAw5/Bqldv6
8tmjAJ9INLpyBDjuDOrCySvQ7DTBRZpoqACeNArckBC5CRzuOQKYUtAZCdK9Vdo=
=Hkp2
-----END PGP SIGNATURE-----

--ODYpK5TG9lXt+gsS--
