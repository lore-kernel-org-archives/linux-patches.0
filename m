Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821378;
	b=PImYTqe/yOvSjUKjcUKl3SuTyrzIejDU73+wpDmtBF4Ag63OZTZVBdzA6AKPazHsOqdm
	 /PswkixUOgnkZf+C6HRUvCEaXXSv+zA093baNE1JJTUcJlLKjjwi6V9BGQF2YSNEY0nGn
	 +RdKs8eLLPSTBcqlZ9G8j3t6+f8ojPkoZI8N55F1OS/u2P6wvdkMF6tYUsZB8QQCDERYr
	 xe3h0beYS9aDVWBzRKAkEO2qwmL2quKAOs9P4NZfvTH+XT/UXyeb7UAI5NiTMonH7vu9b
	 fcXKvRu01zzelxR79wEEUwPVBf/awnbnMYsRl+voJPAD8quZkDmGwSaDPWmPdjViDyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821378;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=srNT1g0/2GJ2jSCDD9SJhNktnNEDWVkT3KkNi8KVEMs=;
	b=zgGnrbBiaXr/6p4MbKGcyfreq3Icqe5SwPqsgyRGc+fwHOXZ7k3/uUedirsgYXKkxsTN
	 wJx4Dddci9FXKQUQ/EKN9WmHK9kgh0kC1KtBVQq6HczfPd+hxBkXSyMGJJSeWaictwrUz
	 b8Zuf4PHXS/0WuIT3ZTH6eqc5v6+4XJTisNgOLDGx8Vt96CeoPmfv4AcTKeV+vrCw45Od
	 EWorSz9jXX126gpz9vK6UZ1dvt3b3NbBOL08QQIT778MI1PC9WRBnCAXqAtSjNb5b9tN3
	 AHRz9E9lBnX8OtEK0YQcvJ1Rqy/E73ijBrRuHvYkk7sXe+cmaj6AfgqbkCyPgWRDstg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=dfn4Aai8;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF92F606A31C
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 09:29:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF92F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=dfn4Aai8
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2940810EF2A;
	Mon, 16 Nov 2026 10:29:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1794821371;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=srNT1g0/2GJ2jSCDD9SJhNktnNEDWVkT3KkNi8KVEMs=;
	b=dfn4Aai8KxAEY/hOWnVRFeZOTvLtVaSyfYtShvT2x7CgGN32/ZClwNyojlJEmP/iY55DOl
	+8fCEq3KLtOAl9mkPK7lp3UMC+bVEEUBBsE+yjMbZCDrNOBx4TMlt0GMTf3wML5GfSS+mv
	glf+qcTD57ASYybYtCkTCNtdP96ZASBRFxh+0DSJpkTHlPMxtP41xKXSv2Bwz/4OqIBl7q
	SkmjzxUP/cW8VBhJruhtwbiVCEVfM89CMs2e+PnjrXnvLkr47BGM3rYkKbm0kIQS3ZxLbV
	NnJkf6EQMEdMjt01jnAEfXNXRWu8TyfnPhwmEaNp11Ps0BweT5FiSqjAJGVd2Q==
Date: Mon, 16 Nov 2026 10:29:27 +0100
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
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
Message-ID: <avrM9wu4dDhQm65_@duo.ucw.cz>
References: <20261113153811.177190860@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="Aey5mxOHeVp4SQ0v"
Content-Disposition: inline
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Aey5mxOHeVp4SQ0v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Aey5mxOHeVp4SQ0v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCavrM9wAKCRAw5/Bqldv6
8hh7AJ9ZkOhA3vDbv8IMtSrUp4UijQifEACeIjguJe4qn3cN5iP/FQ8qLm+kwOA=
=mavu
-----END PGP SIGNATURE-----

--Aey5mxOHeVp4SQ0v--
