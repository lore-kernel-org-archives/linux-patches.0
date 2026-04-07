Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B43B27F9
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 11:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775563031; cv=none; b=FQS0ooWkjQNuzH7+OQebGAzBobxnb6GyORngnixGt/EYU1eb6oDA3rjEdadbr/tluU+5bPxzsWXsHCvvwXp1kDpM3YdNnE0uLM9HVSzWFzeBPvedhRIhNGDy7ct7f2zpvpEYrehxi0ERBZwI8eeSI4Bhp2WRlQ0+1jrh/Nx1T0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775563031; c=relaxed/simple;
	bh=6aKfsK1EDAiqROLGYKIgAcSBmDDVVjEbLy4sQr15Mvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j03yQQbMOiPexb3Fz/xaaCjZrVBprzqdid4pUVTI2qd3AbGrDGmSEKJtxiDGJ71ZUDn/TmJj9Y3k42WsIvJ6/Gc8mADSK/RG30lvpx63B3Kkl8n76r6QGSE1qlu2TJRBRBPN0mgRCICL5nVhEtHVo2PQguBtAT1hWQO3BfQ6RWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=XRxaym7S; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="XRxaym7S"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8BB691123B2;
	Tue,  7 Apr 2026 13:56:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775563019;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=glQOtCeUX55wkxtDKloCXMBz1NYZCL7S6Z+mEZwoBcY=;
	b=XRxaym7SNcp0BxnAjT3Qt31hK0FzqMINtv97sxxBLIipu+gc/tvuvwnhzsleNjxE0jHKSK
	1EecBn5FPDjk4dXSs6k3dYyxpwom4uUB3lAA2HxBRp2Tymayot1n8MKv2FLqLd4U6b61mg
	odcb2z6IVQDYYDU0bcyGAPJMpRm9EXkwuW4Y3q8cOxCyHwsBBqrs0ln1T9vz4sgvFj6Jc2
	H3/zVNpdd3sj+v6r6EiV7k6Y4+zvnHUVbdFfJNzwuf69gIuf31LwtKWIbfutzoHduakpbB
	ikRAgCW5UY+J2wAc9z9g2h2aLFu1xR0/zybMHFNZW7Tt91KhQN39CGgY1VwpXQ==
Date: Tue, 7 Apr 2026 13:56:56 +0200
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
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Message-ID: <adTxCPCWMe--Uwjt@duo.ucw.cz>
References: <20260331161741.651718120@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1i/IrUFfZG96TvFI"
Content-Disposition: inline
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1i/IrUFfZG96TvFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--1i/IrUFfZG96TvFI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCadTxCAAKCRAw5/Bqldv6
8pGrAKC7PER2dLPX1J20VyoddyUKhPv2qACgk4T8rffUbCHcLqftf7aOvl+1tXg=
=R/Cl
-----END PGP SIGNATURE-----

--1i/IrUFfZG96TvFI--
