Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9003B27DE
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 09:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071635; cv=none; b=h/N7zIGhKOH8Z8B633UrfY8LmLG4yZO8ZOnV9mFqnBNDvgBxR+/vMTaBhLC8BbMln/CMy72I8F5HKDI8Kbz9TdQJ/gBSrJonMrUh1E9IMDC6QyZuEg2Rh4xsFZvXOdj96O0QEWXnBeuIjQtx5KAd7KHrYDT3XRGEBbKAn0OzaQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071635; c=relaxed/simple;
	bh=WMs/Z2BcyOzs4IM33pH/dVrSZTX638SGx8tiY+3dOKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khE9vLQQxRl6n/bj9ENHHIqhpOTNl7KNBJ8gIw5jVlLP9xIgD7QM1XH66f5/OTIdscL+tk9ZKP4eJvnjyg9p9TEeJToCxk9CRMgbnrLG83C9GgUwcvUHlCfqLdBDgFOu5kxxFZ7dSDgJn6kVUsv7RIfF7YcozyfWUppvdSmsoAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ddYq7SAG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ddYq7SAG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 635C5118B53;
	Fri,  3 Jul 2026 11:40:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783071632;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=baQKgIuEfMQXRWG+d3XndYNvgGlsNbDb5nlTlZXE9bY=;
	b=ddYq7SAG2BPYjTFjOWpoD7s6RPgp6uD2k1rtzy6f84Scyelrg9T3Dj8Ohw3stkfKPdauUG
	FJlbqMcj4/oClMf+0WDZwgauMpIS8IMrRmVeCvlv9LhAAIPJeAElZdwbTp8TRpYj3eREtE
	DzlldhC1L+HYf2MncengP/Hjgzqmh7cIhilN2PU9Ej0zOisRUqfg/44jNziQwancfR4cCb
	K3QbCQ1pZar3pIGgO8JmzkVozVGIUn3qlt+hzoYuKMQP6hNG6ezBt0jcBYyHbgCop/tPJN
	572N7CiIjs+QkXsfWu/yLclSQpCXhDgPZk72kvL2P+zS9MImiVN0yPqAep3iHQ==
Date: Fri, 3 Jul 2026 11:40:30 +0200
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
Message-ID: <akeDjkTN7AA20Yq8@duo.ucw.cz>
References: <20260703072825.068705122@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ld6WXU7ZgRhej5hW"
Content-Disposition: inline
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ld6WXU7ZgRhej5hW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--ld6WXU7ZgRhej5hW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakeDjgAKCRAw5/Bqldv6
8lc6AKCxPn6oLG4ktvd5cfRg7WRuRsyqtQCgntzMOWQDyeN9bWlUuchW6N6+Psc=
=uGpa
-----END PGP SIGNATURE-----

--ld6WXU7ZgRhej5hW--
