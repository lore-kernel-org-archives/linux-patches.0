Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E484C340D9A
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071608; cv=none; b=iyGnGzkUEF2MAE0blK8XXxC7oqNDnRfljbCruWHkVe6mzqdoKp27+EGcJ7EyTToV51EIMzaDa/RR/PvfmBDQs7aHSQHL+lDlTLcfsr5/3mGrgP4UMjL5WNGV7FY8CZh0TGE/sMVYioOSITtum2WSWjLE3c3wKQNLMApmJ/UaKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071608; c=relaxed/simple;
	bh=J3zWaYBy1pcr7mFMIh2AFdAWZjvCtvW1iW3GDj+EXMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkgFy5e4ulR0io50b0m7tCNkj78i54fPuuWFNzgF+sLh0MsVTH/IfH/+aOJUkQVYlVzwNU/CrO/puztBDxNTrZ0G2M8M5K9h/p1ag696XZM45UZIQ+pItUmj6QJC+wS2D5wKdyOGqOJEBsbF6koSXN8RvWseDHOcL/aelc3Gjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=NDccvaKV; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="NDccvaKV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D5A3A118B59;
	Fri,  3 Jul 2026 11:39:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783071603;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=naAGozw/a+JNc9B0bhH8xHlbw8DID9aIqdkn81lgb9g=;
	b=NDccvaKVZTeUcTx57d0a/zDuEsv/bdZU0WePGiwwy4V3pLSWh5QJzhwjvLAZ/Ec4bvdiiH
	0hW9UNlHYyPg9lEW3Ae6bIKwA6uvNW3E/dI11Xc76K2IUunaPCXEO8iJWP2QvgkwDX2j8q
	4wxn4f0KMZyM54vKWElmEGhPaF2BkamLY3XyC2gLNHgLrWLfF/coWklax4OSB8YMwn25Ep
	bgnQIFo33wKavmIABj0OQWKe2ogrczhBgKjDaf1iAuUgEhUhKVdzbKdd8uaEfuvv1X3bcz
	fZXyz8eDW/BYT4STUOZNT+6nbxifi4g8a/x/XjJvxDfeiMWRHUzo0soB0jIZCQ==
Date: Fri, 3 Jul 2026 11:39:58 +0200
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
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
Message-ID: <akeDbvGSk_8AE1L_@duo.ucw.cz>
References: <20260703072822.817328079@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/XY9VzDDoHJ9tPGa"
Content-Disposition: inline
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/XY9VzDDoHJ9tPGa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--/XY9VzDDoHJ9tPGa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakeDbgAKCRAw5/Bqldv6
8jwZAJ93dt8L10bLJBfq/pm3BQhpu38TtgCfdVogUu/8CK6AuVt76xoI3RBZQzQ=
=i3ld
-----END PGP SIGNATURE-----

--/XY9VzDDoHJ9tPGa--
