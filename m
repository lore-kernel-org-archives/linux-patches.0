Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBDF3264E7
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772836; cv=none; b=jWGXpuLVBXt37YDf6bSRnqzPvlhtR+f9PNYZa14quOOmAj2VDwZG+cAIdxqibqipfHFlLCPZmjdOoK22BYb2f8+/9tNycxVrc6l34W63IJ+KSTTwlhQFSGIMbGNg6F9eNhEQ37gO82rt8MKIOiCdOVL7YNyNpfmjV5Hsm8GzIKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772836; c=relaxed/simple;
	bh=316ffcrYuyW4rpYyme6FZim02q9C2a1qYaddQRoaZH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoTlaLm60/Bc8d1Dk/7XR/1BJUDH6rp+440slRSfRePABmXCP3CR7YwXwnNoQjD85r0i76Dghw2tTzKB08Oc8iomaJ1SrLolBnqHD0ajUW1TT5kP/spivQj5YEFZD2btNGK5aPX9cv/YV6aWqdYcJfNouhTAp9RFioqSQoxWEpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=QVQOEqKi; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="QVQOEqKi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B382C115853;
	Thu, 18 Jun 2026 10:53:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772833;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=8uEgNaW+MwQp06z9J11yQNIcY+46IRq/158TjOog/v4=;
	b=QVQOEqKiw5AZsAjKXBRdex+iDOTNMqujizjB2YQlEnu/QrbcUBZy0e7dgKBWEYbocl5yN6
	SGNKTtFcxhBQ3kNR/cV6PfsvX53BrEgeBCAR+Z3FqYCeb9sKJ22GSMtrcI2i7jC5DsMqq7
	fV7sP1hHm299Rff99zAoYepG73RLv+LaNcygbWpEdphahANJtOutrB8LOwMzUeLYr45eJ6
	n9+pnmTCS8OKu5rPhImaHmbv2a20AEp2He1iYkxf6KEtIo/PNiBjdLYorbVNVid3I8/4Xr
	3wNQELX19C3pkZu42MxNtQqB4EKPF82GtogPRZh4gXzVsWy/BTnUO0CnODQeKw==
Date: Thu, 18 Jun 2026 10:53:51 +0200
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
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Message-ID: <ajOyH1zyefzV11vc@duo.ucw.cz>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVX21nwd5ehirv4F"
Content-Disposition: inline
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qVX21nwd5ehirv4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--qVX21nwd5ehirv4F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOyHwAKCRAw5/Bqldv6
8iupAJ4l/n1wBsKHGDWLWKiBPhEAem3TmACgj673gu6gphZUWPpc0UtUqDAJoos=
=HyhR
-----END PGP SIGNATURE-----

--qVX21nwd5ehirv4F--
