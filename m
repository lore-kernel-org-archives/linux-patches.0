Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9486196C7C
	for <patches@lists.linux.dev>; Sat, 21 Jun 2025 07:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750492262; cv=none; b=g/Xfvhi8KMQRFPBV7hBODBBWu3h5vA8DJ+cwHnUBKM+d9xnNCixYtZGKWQ1QswDXXLtzyOTFX+XCbBfR1T602ogcm56evsr/O40XLQQTn79ncNK3zDRvFhZJW7Nwk4kUJw15sv7WPy0thUR4JYZmvXAaeBlyH9BF7ygg0nbLQkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750492262; c=relaxed/simple;
	bh=nTa/i7MJ2MrvL4RxomJQ7UKbhnywR24wr3GYSG9Uiac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYshzcrQVYpTA0vntr2C+19w0ebK6S+BKLMF0UemLVqLxR5Mw1mCCua9XTtQ50phFDF+Lf04fJMRgwq+ZMVxM7sHB05R+x9KXQVij27Vuz8/ogi2FvbrturvG+iAu0pVEqLeC3dowiP+TDr4wVKLxyVTTtUBYWWxZ5Qk+toAGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZA3l57lA; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZA3l57lA"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A25C0102A8C91;
	Sat, 21 Jun 2025 09:50:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750492258; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=2xg3VAUrOWRg2uHFF8iSc6a1gdtqUc+mRHnq/43laYU=;
	b=ZA3l57lAqw6RrGvU3eRBqDjrVmV/NrbLl1Bx8xr7sy7YC5h4vkfrN0whZxgnh/xr4VWmrZ
	rdGoDB1+Vbdh3Q6iyA6UBvaCNnWer4BHtIRZC27lIJsQLSjjOk0hUopK3sh3AsCzWD3Dfy
	XfGJBaR6qegqlJtLxtp4oYjseKWY0oC3MIxF3l+dAJlbOhhi94vmHR8wZJYdj6Iq/qyr7j
	pwwHPz7IHibls5nI7SDrGLeRG6ktbn/O/trQB4PrbJfL5Ty+G8gzlbqayajvIjFdY4hhTL
	BWpcSGAHV/ykPd509BNZxs8tQQm7YWs1uXON+A3XFKsfJFYHC7OFgIndFO2w8A==
Date: Sat, 21 Jun 2025 09:50:51 +0200
From: Pavel Machek <pavel@denx.de>
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 471/512] fs/filesystems: Fix potential unsigned
 integer underflow in fs_name()
Message-ID: <aFZkW+aCKLu92KqU@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152438.664510685@linuxfoundation.org>
 <aFVCH8CeAEDY2oEj@duo.ucw.cz>
 <59d1ae11-c132-43cd-ba88-c16e86d862f5@icloud.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnOpAXsXbPIIPvJo"
Content-Disposition: inline
In-Reply-To: <59d1ae11-c132-43cd-ba88-c16e86d862f5@icloud.com>
X-Last-TLS-Session-Version: TLSv1.3


--RnOpAXsXbPIIPvJo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > How could it underflow? for (..., index) already means we break the
> > loop. I don't see underflow possibility.
>=20
> let us assume list @file_systems has 1000 entries, and think about what
> will happen for below scenario.
>=20
> for invocation fs_name(0, ...) but the first try_module_get() fails.
>=20
>=20
> @index underflow will cause extra and unnecessary 999 cycles.

You are right, I misparsed the code.

Best regards,
								Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--RnOpAXsXbPIIPvJo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFZkWwAKCRAw5/Bqldv6
8lmwAJ43unr7lVVJ7TouzRfYOnX9Xn+ENQCfSIiKQUMGiabs49ymT0rv+gFfNaY=
=FSKv
-----END PGP SIGNATURE-----

--RnOpAXsXbPIIPvJo--
