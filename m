Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BEA3D5259
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448711; cv=none; b=FHoMqbsboorKodrXi2oBNx2ECkuYJMeQjimMruJpMcsJnJ5QSvERYq2KclPcEvXXO/RiEppxUzNtYqZkUSMoF6t8aAsyL6/nidr897KhtKKmTOOFWR3WnSJS2vYsVm4v/EjF8z+38Mtp33m76IvlC911nsZHfFNNNpzqm/4uryo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448711; c=relaxed/simple;
	bh=TrqakJHLtXCti7Sp64OWNBOCoHQaJ0vR4nvtAxn30y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ku8J1Tsf2LrYJx6m8q9aQkMHeQkhlSYFZf81FSE0xmswmAnmSng3j4kk4WSlFzUhigekEO8MDgckvQ3kKZz3xX0xVzkzvNzWTimfAWuXTgKAEtyZba31CLyKEcrwG8TTgoWijFmADjidYVycIgbgqJTxaoQSX4bi6oB6S+/ZXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=FISFRvjw; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="FISFRvjw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0828811B8F9;
	Thu, 30 Jul 2026 23:58:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1785448702;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3YBJNmJyPshIDasrRQC4bdJLtYIf3IdjGxIJY3om32o=;
	b=FISFRvjw9PtECme+UMVeQsePtyhZuurqD3O75zUPCF9WHE625O5cJ6+m2dJ9ueCVnM6xNj
	MvPVXA0Q3yGDvLsq9cKBzt0RO4eLkjPNE4K1tOt2u689IxBUHF0m8vGtNOgnmdr1GQCM9T
	Y3M/mc1tkqxJIPIDfKw+cL3hK6nKBRaytSoP72p1jhT11IVmb970cNlDtfNnV0F14cRZGI
	fnSgKXeF57HTEFfzxkFPdcOwG4M/d9k4d56Rrxwv4y555eZeEapNMPRjOycpiFoACQNOY3
	FixaPQsCdXSujV3mQDc1BwoBGewH97i1yL3QHTJqiudEf5GyFYgZ7cWaXKqgZQ==
Date: Thu, 30 Jul 2026 23:58:19 +0200
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
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Message-ID: <amvI-_idM7gtzlNK@duo.ucw.cz>
References: <20260730141444.267951807@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s+3OZsm67aeWb3a0"
Content-Disposition: inline
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--s+3OZsm67aeWb3a0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--s+3OZsm67aeWb3a0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamvI+wAKCRAw5/Bqldv6
8n/TAJ9gSICzQNPnYnT5ZQy7kpXnrti4NgCdEXCTQuIIbe5uvTwJFUQ56Z5Sm74=
=mP36
-----END PGP SIGNATURE-----

--s+3OZsm67aeWb3a0--
