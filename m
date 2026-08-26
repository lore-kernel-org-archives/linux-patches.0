Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A7B2E736F
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726324; cv=none; b=MSKmZSX9nQCU2tQ4btJXMs4HFkD1tF3QHLxAxKLLygrDInVW+xX+27UGChPRdP+ubQcD/j86PMl4DiHOdN+/2njFLBA9RYroS5aIUThP+n8kz5mcBxS+l6m7PxviWm7gtERv4V5cIdQza4UUXPk9jSJVlkk9HrQ8oYKsFg6quwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726324; c=relaxed/simple;
	bh=rnIOn4uQkuMIEAXna4wBjWXqQWLbLgxxh7vEnSFHDMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hd+WoTixBakL9A7xlv7LyUFIKhsFOKDXvW8FhEjGDZEhbJUBFjKVh4pP/9ootF7Lql5BamgEW8Swx82LyRLsZUYskmbJmeKYbjlQLnNdVRV+FSVv3jNAg18BByIN1oPrPy+qtNQNVdWMJ05LhDVy/bO8Xzyhg+Dqo6DfYYiEBF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=R+kWB8bv; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="R+kWB8bv"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B278211CE1F;
	Wed, 26 Aug 2026 08:38:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787726315;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=emJjzb6F/JRrxqvKWkA6Ax60YOkwgIzHXq7iZHdGi2o=;
	b=R+kWB8bvd4zQz2eUeoEiSVWMTOOJzGIgYKM39mUEmuKqGJK4c9dVSiGqnuSeBpbYnYyPsd
	hYAENuyrYaKRjZIWGC7k2aB3QSbWv17wTl/BURT6cPjBOzSBoiZLsWsU9k819mOu8tkEAe
	93Otzd1KJYXt9++gSKn6XJ7iwCk26MmwynrXpCrf/QnZ7S8x+bXKfqeMPt8wbRwgQ4utIG
	UGW0fBpy6iCwnW6FrRSFzgvE3vMNRyFbyJPxnwWGB+EzS8SpfdspUwoKzyB7jWGVXY3e7b
	xYuLBFR0STzMJfBKmwAByf2rU4L+Wl9GqhoVTU6wfruSyQn+2rXjJDhg4PC5pQ==
Date: Wed, 26 Aug 2026 08:38:29 +0200
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
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
Message-ID: <ao6J5XxSRnBU0Dj3@duo.ucw.cz>
References: <20260825132541.580275153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S33zMeJcvzIMGBkh"
Content-Disposition: inline
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--S33zMeJcvzIMGBkh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--S33zMeJcvzIMGBkh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao6J5QAKCRAw5/Bqldv6
8jjXAKCcY7+Iq4g8NlwmHCBnogWxCHt/oQCguzNJcXUzde3aTckLoKbObCNafvU=
=mwGE
-----END PGP SIGNATURE-----

--S33zMeJcvzIMGBkh--
