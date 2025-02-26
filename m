Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C1123815F
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 10:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740564887; cv=none; b=lCSu/iXsG1iRPMJpWSG6JySrzmRLftuyBTBxvAAZXHXTFBrMMWkoS9QsQu8wMSdqsz1PM+EFH7K4JHW+jEAGil3L18Ol9hlHr4PV4k2n2MKZxp0SBgwNbIKJ0n7EsnOG/fTq3WXNmsL0paMNXbMgbeHvegbig1grNz2xjjzeDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740564887; c=relaxed/simple;
	bh=FG9HEH37ejEz2PMsrXdh/tIzU2XkG5MKx8b1kjL0n9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJqxFH7Qd9oH1oNHQWsyLKFYWjBLhlwvgzJEb5138qZL3bK7igrjSYuTAika/9UKvOpFa8Rd8TKnRjotKP3b6AugzQqz/Gs/a1WCaV2ObPKe2/ZbKYNLW6enhZFA9Q9gN0zVLYobFzZvui7JFm4/pFe7vjQ1DHK98JgiPxZ+Dkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZE8aq+Mp; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZE8aq+Mp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 95AC610382F09;
	Wed, 26 Feb 2025 11:14:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740564876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5K7X/VeRrYr1fVy6pp2dNORRAK7lJe1oeIlcNT/7St4=;
	b=ZE8aq+MpMKeKJ0d3E13KKHcPTOVtjfkApr145qI7qNwMuhl1QSC0bQ2xgZVjdemL/uzWUe
	ZgXPx9sr6wzArwaeNWuYtSOX58UAcjuweJv9TvNmAcA7TBbuqDk+X8+uD1HO+sJeu+kJe3
	d0Ow+PPd8U8rc0KCfZgRtoX3cP8KfpUWBWL3IGq5WTgeodI/cyuwso6mJ0yM0tpUQP47W5
	BLElELLZ+SAHGou5ivrpDttMSZWx6MaxvFLWbn7kXohXQ4akL68RfEiuV+iP4KYNPNqlqU
	ZMGX7dfS9xQ7He3JwluuSCu5/KnAwJK6O6b3UWVkw+Sf98ZzOSRU5v9dhTAZ/A==
Date: Wed, 26 Feb 2025 11:14:28 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
Message-ID: <Z77phGUkfIuOCikC@duo.ucw.cz>
References: <20250225064750.953124108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1o7EVEPHhNeoFG6k"
Content-Disposition: inline
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1o7EVEPHhNeoFG6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

6.12 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1o7EVEPHhNeoFG6k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ77phAAKCRAw5/Bqldv6
8mDSAJ42EyYaFz1K1budFqDuZCB2XkFnQACfY4HcD0p2mTMQnAXSs6yDyBU2dtM=
=KLRt
-----END PGP SIGNATURE-----

--1o7EVEPHhNeoFG6k--
