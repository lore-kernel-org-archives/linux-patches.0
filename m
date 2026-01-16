Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFDF33A9F0;
	Fri, 16 Jan 2026 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577962; cv=none; b=UUWWfje4R9ZmqXAchKJIdaSwzpDYnesp7gMuP6aGKetTg+RX7Rjx+EyBXJzJK2Zf0GZL47129p7axXtcVQXuq1wpWpcQz+55dVJYTcNfBB+pYdE3BliGKTWg2j1ZmFn0qHrUXNPq/XQvGwaSWSTOAh7EqDL5+iPk0f1ovkrt+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577962; c=relaxed/simple;
	bh=FvF/2PJ7bRiECtfJFpCjuI49E9TjvDHwmwfc8cnUg5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSkFsSxbHohnyWWKHCDtcu4/CPrvnGIwVszR+9MrInvKqDpZWvpCioRYITDGjXp4nXrfqXsLHX1QxRibVbFSNdg7jjyakUesjMRL5mg9wXwVNcsRso7NP4pv6/e1pOO4D2xrazyba6ZatC1uHULlgqxkLV3OyiEhH6DA5FzCJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jscOWApC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jscOWApC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC53CC116C6;
	Fri, 16 Jan 2026 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768577962;
	bh=FvF/2PJ7bRiECtfJFpCjuI49E9TjvDHwmwfc8cnUg5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jscOWApCAB1Dpg52vPVnTS5DJ1hu/cAzSoMuIuorrwn+xRt3L9SAmcjL3GfTV91Hj
	 HpFUp/eK37RuBQ2N03ercAULlMNzUfKaLODQZJYHyt9ZVamqa8jWYNnk1Wawk/fQts
	 Ku11dQZN64+hJpSuP95QRRM70HpfEd3mXupTdT0+VDTBsOj91EcPQTlh+Jz0HoJrkZ
	 SJyyqOb9+/m9Zf+MBQyABJ1VqPiubFot1hYHJimBT1j7ej8QBz4VoK7VFj0/K0D4dq
	 GPDS5sttbHQKkEZHBm0nCYxQiTCYeWgYlQXpiCPxIzpWcA5lkm80TlynD/bWVSh4dc
	 ENpjRmRWHRhjg==
Date: Fri, 16 Jan 2026 15:39:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
Message-ID: <4417a56b-bc8f-4119-b5aa-dcfb892c748e@sirena.org.uk>
References: <20260115164143.482647486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/eBiwyASYJnGEDF8"
Content-Disposition: inline
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--/eBiwyASYJnGEDF8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2026 at 05:48:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/eBiwyASYJnGEDF8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqW6MACgkQJNaLcl1U
h9DjZgf9EjtgbjDgD/5Mmitfx4Ye67djk6nB15g2owS6rDGKPznmd9Hd8VYC+8Nh
R/0tj08W0fCH2r6iwIeZSgUcReZFpeRKsQ50ri7GIGY06t6DdiRSkD75ryCju0kH
80/I3D18J647HbUcG/cssFvCBQvoY8QOgdYPsPt6hEMvfHDSwGHP7b4FhOXQTkcN
X96VMkImx80ACCh1SSsnt8E9KR+J2h0mBpIu0X4uKn9fbkjECaK8mAaGHKIsVqKp
hWQSEwj4IQd6HbIqT4ceymhyiXENs97LXGmpWGvcNQA0pq84hAeBHJpkqzusSW4E
hJO01+rw/9sYqxTQcuQlO5+RIJbmLg==
=JFLZ
-----END PGP SIGNATURE-----

--/eBiwyASYJnGEDF8--
