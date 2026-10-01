Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38453F788F
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846281; cv=none; b=MC/CpSWiUivvyL3hjrI8Ham88fNZQLQgrKs6EUSaBOQpE7ouQJmz0jd4+fJClTCShghL78+0VO5Gzvby18zhnbG44zyObUbOEBza+al5fP2eM5Si+dHuKgK0LZe8TX7EAyBgVGgno+cCp4+SwA+LUOBlJB6pCoNFpFLTC0rP654=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846281; c=relaxed/simple;
	bh=uk1pJjMlazDTYZUE4/NZdLSQCEGe7SdhLpwX9G1qgAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtCCxTi+m/7+jh1rsLbAkAuie57eqhEi2T4MzO4zKycpko1Qx/z5ve+dMMPG0gMyHnAcuoZ2Bmdv3hXrOjTu7dI3spi/fL0xD6JZyPMitFeUBOLYRCAWAWnVD8Lqq/4IWHr5VW3ryKq9oU+Ih3KstCjlayI8Kd6P8W//hZ3i29o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ScdUcLav; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ScdUcLav"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 16F27106F65;
	Thu, 01 Oct 2026 11:17:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846273;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=o9/GClkKkEiFPI4+Eb3IBAAB+J43FBkXha+AlUx2gN8=;
	b=ScdUcLav/t4Kc8gdWkL2L3YGmYLV/ykQY8Z8c12eNeED12wNGsx8wZqybodb4uK05RddyM
	Mz/sOJ2qUAS/t6VujcY5kJP3fA0g/qEC4PTtowPKVMv2g//OIFBNdL9wOJhYn5OLDWuAxh
	4BVJmOpaSooFTSFNwQqta7oZhqMiZRc4qKupLSmDUxhaUS03xeoQPZ8bJOnEtqX8YiIBJK
	ND/YRgWSgxmPPiRrd8ZJTNOGC1QwMKm+pM8uZekWvXxw90op0EsghGB2Dq/Ig1frGUD1hi
	mGYPFDUauqYpo6TzJ+rCdBCf4gLwKdjpp+C/nBGtm1HmJROjGGOv9VzF+fcSeA==
Date: Thu, 1 Oct 2026 11:17:51 +0200
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
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
Message-ID: <ar4lP3J4WVTFRUXE@duo.ucw.cz>
References: <20260930152434.301151190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XR9tqsgKmFTNfWsU"
Content-Disposition: inline
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--XR9tqsgKmFTNfWsU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.158 release.
> There are 1193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--XR9tqsgKmFTNfWsU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4lPwAKCRAw5/Bqldv6
8ug0AJwPOeSmQpt0EpJ7KpTrxvPmWthZQwCcDyLffj39N6PP2cEZPdEJJCF6jsk=
=noUv
-----END PGP SIGNATURE-----

--XR9tqsgKmFTNfWsU--
