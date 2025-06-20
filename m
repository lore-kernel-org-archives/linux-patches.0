Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E418255250
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417402; cv=none; b=Fe3Pdw5He2xnWaZjzoF68+snwDFo2rZ1rxo9d2tENqQuHMfjlw1+j2/xwW8WqNeauj8IXjD4leMTNjI9A6Va9cWQpgSEsQAZJJ5UYzsgO6aUsMcllzzL2MQcgoMy3atSGbwAuqskCsDG60mCXBZPpjmXKCGsVZSruagt0LCe0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417402; c=relaxed/simple;
	bh=ow9pmBGoOWDd2bUZiXrTq/Ixw5bb6fPeBsL557mCQ+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9GpN0BNZWuHxS3FKoDMeMhrO8oUOG+yv7kSvxqjjs+NGkvGB2bA3x0no9KeijhSH7Xk9r+BSVB52Pgkyr/84ljkhv5TU3UctJ+MobO2Wx8HaPQa+SMH0Gr9UobVnpIUwLF16KGtVCRGtshC0zmtCj2OnIVoJguORQNBAoKVUOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZlyTbrFp; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZlyTbrFp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 41B12104884A8;
	Fri, 20 Jun 2025 13:03:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417398; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=H83VpY+EaGjGzuA1F89Ga9UMsJ8CojiDiLGi6caqOcE=;
	b=ZlyTbrFpJRrGIz2kyL0yPAZ4hZq/ok5wtMU192PehHzlp+L07729xYQkssjsL3lDUGIWNG
	MNdte9I2gsKM9HKj2mVTYUD70QKYwHZ744gRG9l+5AWEzXCb79b51qKL8qgTtjdHzNRUHJ
	5OCseZ1VGgGNqppf6i4i7CuaSur5jSK+JKjKn2UV4YjPtHKAdqk4W1z0DI/h97MLYL/OZ7
	Lu8LEbon3KiBywXfzsqxXmP9NbH5DjO2SKpWJ0Zfslx0AF+0QsWkhMiXV4H+rCKQOfFipr
	GmclK6YpcGZi0gbXndidxcyqeJucnL/Zj4g035inpLQ9pEebT1ar/rXsF05n6w==
Date: Fri, 20 Jun 2025 13:03:14 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 417/512] serial: sh-sci: Move runtime PM enable to
 sci_probe_single()
Message-ID: <aFU/8ioRP6x1LqTk@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152436.474113766@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IIaTlm/Ug1U37WZl"
Content-Disposition: inline
In-Reply-To: <20250617152436.474113766@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--IIaTlm/Ug1U37WZl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>=20
> [ Upstream commit 239f11209e5f282e16f5241b99256e25dd0614b6 ]
>=20
> Relocate the runtime PM enable operation to sci_probe_single(). This chan=
ge
> prepares the codebase for upcoming fixes.

Preparation. We don't need it in -stable.

BR,
							Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--IIaTlm/Ug1U37WZl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFU/8gAKCRAw5/Bqldv6
8s2rAJ9x2zF36xxZGy3bmbATSUfjyiQsswCbBDKyzvZGXOvg7cWivAvIUXjxEhg=
=EPG+
-----END PGP SIGNATURE-----

--IIaTlm/Ug1U37WZl--
