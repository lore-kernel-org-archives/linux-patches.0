Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841D021D3F0
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763801835; cv=none; b=EWxrRlTeoT8HGDw1uMkKFsSHKlHxcTMfvDEc92QxQC9mgTjv+jCKTKJyxy9enf+wv9NpLVb+dlQtIm3MFoHISFvzjFLJREGJP+if0YhrUS+VTRTSAu18azX0V9/65klbwsml24wLxZfJu5vWahq0ZTWQ8ZruRUwZ1IXz8sAMtn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763801835; c=relaxed/simple;
	bh=dvVFcJhSF+nsS2ad6iVjZNp7yRGIf9JJJ/AJ1ifTyWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUexVj2DWHKOfZFB31pYShwzRZQDC5LXhbTwrJIj+2VedLb+v168qxGAj3XyxNtWSFKEcbLsDDAbMJkIDwwUfUjiLy2qtUoMGuTOO2LV4eqSrfwYf/frcn3OIDtfUBPbiDmDR6zURylYFhTVaZao95qmdD7uQ7Fhk0JKCqJyeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=QFJaE+gw; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="QFJaE+gw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 50D431007D75A;
	Sat, 22 Nov 2025 09:57:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1763801830; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=p3V/C7IBujZPYN0SVeoi9w75qXJdYKFot40LPvSZ2u8=;
	b=QFJaE+gwOd3MpT9wAUvRKb79jWx2v54aMQUwLHzsxJMQ3pScBtljrRpIXfVHMchhEKYimT
	jyN6ZxLSQw3Ut+JQQX9cq2CaVzEj40qqIbihdODXRt4aKGgQ0jqFAQBnmfq90NCJSd7apq
	9RxEFocqHRjADUQlgqfNUXM4kdT8+Y7F87Ovx3+gfLQFL4iZfyZ7pE0koZ0ZHHB6WQMXF3
	oFqsH99w4eej1VOADOTmkpp186JonrBN+yUIXhsxGdAadnndqtRbOB2ZwnJMq1B8T9494X
	oIPBIunzhZyePSHH3YR3MFsmg0p2NP03XmYjasjX/a5iMi1uFSPIAJZ0ts92DA==
Date: Sat, 22 Nov 2025 09:57:03 +0100
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
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Message-ID: <aSF634A8ISWTFFsP@duo.ucw.cz>
References: <20251121160640.254872094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/oSBxSWRLhCd1WvV"
Content-Disposition: inline
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/oSBxSWRLhCd1WvV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.17.y

6.6 passes our testing,	too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/oSBxSWRLhCd1WvV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSF63wAKCRAw5/Bqldv6
8jUjAKDEl7soeBKZnWf5+O4Y/UBowLFANwCgjCTfonbDJwmIm4bFAX50PHYuF8A=
=EATp
-----END PGP SIGNATURE-----

--/oSBxSWRLhCd1WvV--
