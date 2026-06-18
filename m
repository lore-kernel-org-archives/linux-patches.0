Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DD3B19AA
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772775; cv=none; b=hCeQgMPnjalK577koFfbtcLU6YSqyN5ovH0BOyVflTDL8m8W56kqWmTtW4TuIW/O2vi9J3nRO696HbbhGM4NIbuTukZE6hgpZXscdAjTyYp7SYZiEBqUTV9hM1qWT446wZY7pf692AnUHfGuwYEoPms7c3TxeLd38yv62cxQppU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772775; c=relaxed/simple;
	bh=rh92WOi187VUAfVlyGonC3v1bggN1gE4eIJc6KQg3N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+XzYRuYZZgkQjmrCpAgEYa8cgQhhzqRTDySNu2LVhrCpQj6dbEA2zsS0Ot4SF6PAPZMi2BVCmP1ifLGFc+thTHTnbVAF3f8HjlzcUAmXgskTz8a7/BVM8bb6NzjMp+RAaHXAe5GUBTu9L4mFa5BmEUev3UrPhC8JePq7HTAnBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cJWv0D9b; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cJWv0D9b"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 706A3115766;
	Thu, 18 Jun 2026 10:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772771;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bXZWyzJFzABZXVXIw/SMFFbRLEppd6sAQziz5pz7g1Q=;
	b=cJWv0D9brU6Dna4SFREif8XObStGDzpkj5KjHNepeMGtecXDL/xxrZUgQifv7w3u4PHuFJ
	V3i4MatieP/c24W6jmsT7IK3QTp0KrX4kg554UoNIgpZBsD58dxqXXcqngHFKy172at2Yj
	TCbpSK9YhYhNc4vCOrJFOsxmtwM+zTToStnyfzPJA0M/OMMSbKQeXXdgsW6LLNhB9RwsP1
	RvDm3TwZxfa+kp5RrXQf1jvn36OK2lgKthXAW1xHfU2TpGYBUt8tE5dpY5RniYjCAcUa+q
	xlg1eaK6vMrNOzIBw1kwyesINcxVJqmFxzJA+YyYg8winKngSUOZP0NCS7ehVA==
Date: Thu, 18 Jun 2026 10:52:49 +0200
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
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Message-ID: <ajOx4WkBaf6VmbSQ@duo.ucw.cz>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fyYvSxscr48+ajKX"
Content-Disposition: inline
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fyYvSxscr48+ajKX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--fyYvSxscr48+ajKX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOx4QAKCRAw5/Bqldv6
8j/9AKCHsK1vhAygk3Qun9AOWfRS+N3XJgCglZtAVYHfdRPqWXj6dQscC5Zpy1U=
=cYNA
-----END PGP SIGNATURE-----

--fyYvSxscr48+ajKX--
