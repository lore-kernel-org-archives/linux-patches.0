Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB014B08E
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470873; cv=none; b=Sc0LhJWcjFYDf7OAA7iiIdhAkv2/B0NOi6aADpl6bl4C+2jMsBNaguZ3TUhtSLz8LvdM6O7yR12tuywDM7dsKw8/x5EH+uPftVc51I+5QkvpMRDhJwzXCh/X9hEN1T3Vm4kcpUsZw3RYVgavYEX0pDoLlp5Wrd86/Vam+gEWzTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470873; c=relaxed/simple;
	bh=f83wCTT1wpK425tjdbaFLHHtomQLC4Ai+losaizQJTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVVgt6neUCckqFsDajSdkaAxfMwhckMLRD2Go1QKK+RVAI/xKQGAe2NIq7EAVkN6VGwAxpOkliFKuq+5PJkL8soshG36LNiLEwCra5o6rXVzYJopRYD+TZ/WexCM0K7S/UaqczMeK2N6BdhSDvNEZWKaZHDfIt/6Z0spGsRX+QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=XPJ20hPz; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="XPJ20hPz"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 49A271047DC0C;
	Tue, 17 Dec 2024 22:27:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1734470868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ulZWFdUfedMYggmMJehvBZS59d3toO4ILEWn/Eq076o=;
	b=XPJ20hPz+E0RKD8NmavdyCVsYucrWqTvteBxiurCTahmpCZFGdHfCj7UaY4DsDnK/9U+4t
	WolkTan1iZ58E0NplWf961LqtRxXOdRXXXkthX3wQJiJKFfwuL6Nunp0dgwvcplflyIbYB
	nVubTYz1R/kUDWbLNXvlANlm+25N8mXLsTrBRbpPKhBD0EWIGgCoyaAadcTIDXU6dWBztD
	njT1hBU6X+4tDzmgin+1IkpSPxsFrFrPKHAf6juk5kkmzV3QQejsKNC/uNlw3FcJ3N+J59
	PKJzW2kdCjpJneLsf96BSUSu5MuLWQQge22bg+mIaX1wdlPyR96ImlmsQKHhUw==
Date: Tue, 17 Dec 2024 22:27:44 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
Message-ID: <Z2Hs0PV9R07G8Up1@duo.ucw.cz>
References: <20241217170526.232803729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsb8EpWmWNcWWTTc"
Content-Disposition: inline
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Xsb8EpWmWNcWWTTc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Xsb8EpWmWNcWWTTc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ2Hs0AAKCRAw5/Bqldv6
8o5rAJ4+mi1iwwMO8eb+DqfcO6MYCOQWTgCffBm83LoadGZZUIZzAjZ0XGbH+5U=
=IuSd
-----END PGP SIGNATURE-----

--Xsb8EpWmWNcWWTTc--
