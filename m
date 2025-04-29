Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429B52472B0
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745957806; cv=none; b=ZXtOTq19t5WrdbYPlDj7hyokQsJmTsawXyJLc5+2ZKVXB9MnJoUYP+BwU5bVSmu1MPsiFUGFS5jfxxfwYktge3ILkEG5ozCAdWs1Dleemskbv3imYOz2ByT65mgXbgyAZMvP73b2T12QEsi6TZHhvm0mhOH3+ggu7HjhujLCblk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745957806; c=relaxed/simple;
	bh=DUFoO2rYo5F6ljzwBNYDBPpUH4E6uDyjIyl7I8SGm4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLhUaedAKHG/bBwHXX3i+9z9IJWl6PZlJleeAMG17gdHMOZbZGFpQ3BYu2HlOW6PyYqPdif5kXikE4Uus4zwq+2R/7Z0+ttoijP7PpFaJDk87YydTvKD7Il4aGA7Uw/9VC4ARXtvoNEAAkAFxazm7cl3t6SkAsgl38CfEZZCF4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=StR7MMZ3; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="StR7MMZ3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F0BC810273DB0;
	Tue, 29 Apr 2025 22:16:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1745957801; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=aaXCqH75cRZcAs9jx/fX+VP5beI5S+LVKAXr6kRJsqE=;
	b=StR7MMZ3yhIuDJ9yFr1Ny/TfIAlWVR74QyB2tC1LdoMwXhHJ6rAB4eVQcOiC2fiYamMib8
	w+dfJZJlR7xo8eYJKGMb/28Iep9Yc6S/n95AX/f5bPB1gJU14pgP7hrxXo006vUlszM3qg
	3yYptPCYbbvm9RK0D13I1j35HgRzh6By5FBBJCs5g9cngdI0rBaWg7n0Dunel8DqLRZnJl
	HODItECtwCmtjmHgSlq197v41PWGkAm1CCKZ78YBvq2r8KkuEQnlOVcOKqMG3nrOXV+Vk0
	swUeS+qS5BLlj0M4/ZNAV5EIzu98LMIxoCXtVpD+slkxbYQF/iZ+qUvieRxDeQ==
Date: Tue, 29 Apr 2025 22:16:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/286] 5.10.237-rc1 review
Message-ID: <aBEzoCYDD/khRDa7@duo.ucw.cz>
References: <20250429161107.848008295@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kr+I0pty0qVfaSEg"
Content-Disposition: inline
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Kr+I0pty0qVfaSEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.237 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Kr+I0pty0qVfaSEg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaBEzoAAKCRAw5/Bqldv6
8m/sAJ9eXZzJ34C9gG3GThtXfGO/Wsl6ZgCeO0tsQVPKsj5lJbkWRngNaNGD09s=
=zPZz
-----END PGP SIGNATURE-----

--Kr+I0pty0qVfaSEg--
