Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8711494A3
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749405304; cv=none; b=LoHAIE9W5v4AFcgErCaL2/PB5NUuPtkGpcChTN2N015YrY9BJywMjpUsRLG2RpCARBzavSNEalPtYKOSEsM0g0oW2Z3FlhHhyx6ce2Mj2thb9PJtabgVmA+ao3VKloY2rHI9nybMacszo3p8WSSsrz6p6wOu/yR3irsHt3e//3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749405304; c=relaxed/simple;
	bh=uoX2DuRW1fteJOAAx0KBkfxJHyR+lhgotBks4+PS43c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/KLahjHQ5yWFKn04zm0xHw6CMjkjG+Bpu8K+FcKqkD5V+QlDWQjc1uFJ8gEZK6zjcTF8ImxShjAjD7WOaR6ADRmP2bwpMDm5S6YbFbfZvrXd63FyEnNZdxHxry1kOb9XQeR/YxGeMxOGUNXJrgqE9e2w7Z6N50GcNWlJ+F0mIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TsETMigi; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TsETMigi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B8FC510397298;
	Sun,  8 Jun 2025 19:54:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1749405300; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9HcY15vu+KVNkIemPXJdgE3BtXxnw2EJFwL2jpGDlVM=;
	b=TsETMigidVg4Y7N62V4NBEY6M23SEzDwE9vR+baMal6TmFJpHdZa+5VQBTLhYuvUVbEm3F
	Y7sewlclvyz0EExya6B9wQSvTTrqd3zExjdIHHxC8iSOlpJYqodnR3w+L0Rb8l3C5vYOM4
	gA3f6asCr3ZwuNbaVeR9mT6pB1GoH5zy+51oo8Z9AB5cWGB8AvxHD6TXcqD5dSNPZHf8PA
	mdyLnkCkQZTdFq3Er5BsG065OiB8FcScCLBl8AEkKVxWFxJWyT4ZYveJHs9OKUheMs8/qF
	ZiiFTy3bhTezW3/pikPx4lT/ERqkOOXlTbZ6/5+BNZhYOeplil6n1AdES4Pleg==
Date: Sun, 8 Jun 2025 19:54:54 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 00/24] 6.14.11-rc1 review
Message-ID: <aEXObni734dwd251@duo.ucw.cz>
References: <20250607100717.706871523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IGNC63kLIJNIKon"
Content-Disposition: inline
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1IGNC63kLIJNIKon
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.11 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.14.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1IGNC63kLIJNIKon
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaEXObgAKCRAw5/Bqldv6
8q09AJ9op2Tvr68BFh6iJNO6Z3YSW9J+BgCfe03h4VzEQw6PeVteOUPnizCUWsA=
=D355
-----END PGP SIGNATURE-----

--1IGNC63kLIJNIKon--
