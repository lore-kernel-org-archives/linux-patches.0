Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790D36AB61
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 08:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783066338; cv=none; b=RLoLKZcFyxw5CnmDg2GK0Ni5MwTiMkgeUe41DAgPRcPiw1+GQPhp92w5o+zl7sM+7jaKGO1NkLznJ1NB8aESOGvv/od8IZK54AnOGVHZ+2sSxDJjLBlisHO+SPPEDuzzh4L0/1O1ohWUINfCzy9bq19/J5WwVQPBBQ60fN05omw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783066338; c=relaxed/simple;
	bh=DGy4flH25VXMiKCsIgEegcwD6RqmMUEhC319grkQUv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ceqsKdl4aP0KnIe0tY9yIWbjTzP4q9R+xCGodPZlKqmGll0h/mJ4iQm0xmRSge3HxyNo6k0EMUaF6rsezSLo1vsQKs+3HCQGNlYYZBCCXY0ijzsNK1RxjZuCK/jaUos/sm2a1J8seH2jfk2EMMwWw8zW245OUsDjAQivQHzYmzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Dmg3b8Q5; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Dmg3b8Q5"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D3E03118B69;
	Fri,  3 Jul 2026 10:12:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783066327;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=+30KoiDN0n4qlGlim7ciE6Rnij5Frat/7Wyk1wvTAE8=;
	b=Dmg3b8Q5fSjt+RUsgA2CtUqlvEZaYW7fZs4W8pspf2YILgZ4d2c5QDmEDC39q4RZ3JxXmf
	2Zt4I8U6T6BZLvrfRoaIs6ytLQrlZGV52wKoAAzocYa98KDxDvPtKD7WyU3kiRZzR7BM8x
	EEbai8nr5xRjKl4IOR78Nyl/Jz3TCMpu+yGfjHic2pvrHU8olZb2eWemC237iB/88JIuRQ
	EzGyODsbsPlbEri8ZnWwY4AFlas58PuhWR888CYIFzWu1bdVSdhgB5Q3oefPpKIG+X1D9v
	gZpn++QLJXYPcKkRmdMiXGyGr2d5fvnYMoUMAaknTxhBAvfE32xpEkl1W9D4RQ==
Date: Fri, 3 Jul 2026 10:12:00 +0200
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
Message-ID: <akdu0Cxu84Yr0qXQ@duo.ucw.cz>
References: <20260702155118.667618796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4cJqBhJU+Cw9SW5"
Content-Disposition: inline
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--I4cJqBhJU+Cw9SW5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

I see -rc2 is out, but I don't have results for that ATM.

Best regards,
                                                                Pavel

--I4cJqBhJU+Cw9SW5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakdu0AAKCRAw5/Bqldv6
8k8pAJYlm0qlnkTuifTgyCy1VbvZCvvsAJ96UE8/TVhSRbUunv1jtl2ESQi9qA==
=Al5U
-----END PGP SIGNATURE-----

--I4cJqBhJU+Cw9SW5--
