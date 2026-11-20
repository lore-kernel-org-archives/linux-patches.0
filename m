Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172967;
	b=AUIxrHPn0jzVLe1yahhULH5IM7pgQlmbcaAYMbif7Xe71f0DIxB+y60fE4o2J2FF85z9
	 jFdOKmKpY9OHY9sMOcz5G+bN72tbhDeakiddlwiSvfCNLniHRSmsqXzIp5SUbrxL3f8ow
	 SirZfqdIACAoxEJiv8JsltC4dwKxCv6bTkeQ5OElQfrqvZ0v4u1oR33047/fRch11h9TK
	 1xTer62kWb2LBHIuLySkaCPiP92FOi4u4wyR8uIdEZwyXjt0OiLHe83yODqIebdHEcR3X
	 CFWguTuERyUkjkw69up3PSvnz5HWNN3Lov+8UiyTUDMmEbVwPFfyGTlmH7v2WcmZ+5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172967;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=WC5BXVHskQrd/cZEjgDgnsY3tu9geBYXj3pSkofB/nc=;
	b=e1KffQFk/fZ7bxbwgJ/Kl9icinf+ZbLxj25f9BgTYaEBFmSuk6Qw4EilEkjo/jU3JoD1
	 mqfEQX2NBddP0tVxSW2ybJ9iNnTT4LsLsSQ9ckKDyqPXR6ZhWvcs5jCsAs+BZqODKlat3
	 cSEAhdKAFHHVS19DkDuI8bzSthKUcex0UKf+FkcLXoipnQmdY49E6dPb5dfv4jJdLqbs7
	 /CCASdZfX2J/QePpkP9TnkQSpm5iWLy1/UbniXmmgX0QiPAephvPG37oXwgQWsx8YsmoI
	 myulnvZjABU/n8FnMIEEBEVW/uTRfDRHuEesbubgW4jFQmkq9PBA3tHLwBlP+orTrXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFB7606AA3B
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CFB7606AA3B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 759AF10E482;
	Fri, 20 Nov 2026 12:09:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795172950;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=WC5BXVHskQrd/cZEjgDgnsY3tu9geBYXj3pSkofB/nc=;
	b=jckqfYdVw0szIG41xYqB4Ro1aJyZEOLhR07JfNfhBpN5SOC/78yvQ7gbSVLQBqcSQCABUu
	eC36abgQo/9KfhT/A/ogsNYGfZUBViao88K6sS1aCinOrM9WOFKxy6Py4aMu2qy/vqOQEM
	4N7e1TEyMKx1Wh5Mxh6SinU7K3kX5BkCZqi2DmkcNSY9+imSpDAESmRjw8GEWLNEstKD8b
	/3OSUebqJ+RXpp9+vxKinbvPhGzmXw+ypo6/qlFesVzHml2Ul0vEfhptcEy0W7YcVxIHkK
	xou4YXFBzUt+ZBd1/Bq18MJbZWP8QoYenUahTHMhLeE2nxiYByAQmykwExsHEw==
Date: Fri, 20 Nov 2026 12:09:05 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Pavel Machek <pavel@nabladev.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Message-ID: <awAqUdjqspPSlb9g@duo.ucw.cz>
References: <20261118145911.150052362@linuxfoundation.org>
 <av3a38u7mlLN6yJL@duo.ucw.cz>
 <20261120020908.2320910-3-sashal@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UQupFZjTLHTtcclT"
Content-Disposition: inline
In-Reply-To: <20261120020908.2320910-3-sashal@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3


--UQupFZjTLHTtcclT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > We get build failures here:
>=20
> Dropped the whole queued ste_dma40 series from the 5.10, 5.15 and 6.1
> queues.
>=20
> 6.6 and newer keep the series.

Thank you, I see -rc2's are out, and I no longer see build failures.

Best regards,
								Pavel

--UQupFZjTLHTtcclT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawAqUQAKCRAw5/Bqldv6
8tXuAJkB+vaoBfSY7WtrhOzLIABOJJr8PwCfeb8r85ZbQyW+Gqs46myalO70okw=
=bhun
-----END PGP SIGNATURE-----

--UQupFZjTLHTtcclT--
