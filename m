Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB11547CA
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119724; cv=none; b=FRifqb1rh8gHQoFdhja8XpJMwNWya3jkUHNupk/2Kgdnyz/JJKahJ37kz9ek6gduDUU8fBqOHOPhLyY639o6ALiEphYsTxMrr4Fx3ekAGBOEH1DB9Bpm1+46CycNXi3f/yiHCCs6SkCC7Ioe54gLQwiG/EueqGZXxdgrh7T76Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119724; c=relaxed/simple;
	bh=MWeZXz+WHS+SBcdJ0J01hU90ePoRY+3LOS96ZdiEjw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ms9kkGpRv7whg8+6ldQ3sVE0zKrflYcwXzQ8/YVXiyYCHyV9cKsFH+YqPNFB+0dF9y29w5qoqAYKqEIHRBdCM+roMrvIT+YaJWLPpRB6JtrMIomtBX9dgt2Dw/CMVQ38+BrgMpXRgnIGcGyua7giotlWYUzADVX6S3BUI4qHBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Ngl40o2n; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Ngl40o2n"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F3C88103B8FD5;
	Fri, 13 Dec 2024 20:55:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1734119720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dkmDjUEQjZQsbmClsuHBWLcnT4LwaVF9ScdDW3hTOVA=;
	b=Ngl40o2n9aHCF9deKecsdvAk/hGuXEHlfAteryxxd3kHLoCDuG1g3gocQzYA9dKXUZva+d
	Ewp4yBpsa9wwTHz4mIcZno0FpkvwvbplyBQ5WcQH07pkQh/6j6pEL+5GIWVvEZ/zkN3qbe
	X9eX4utio/jH3ZJDa4tQAVQw+wlYG7pTlFFxLvNYz5ikQ7amqxiOxj/ZgnOm0pjgCLn37I
	Ao9i9v6U6E/4ZK5bnIY285b2TGh/YRS2LYqz6747LkhYsL3Pe/gcasDZ0coIOfaJ7SYKzH
	dmvkY/wiJva+UeljV7KbMBOPJan/uo/Ag1hs1KKE4AebCl0mQ/adApFc2tmD0w==
Date: Fri, 13 Dec 2024 20:55:17 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
Message-ID: <Z1yRJZkgDhsKyUAo@duo.ucw.cz>
References: <20241212144253.511169641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mnnnKu816GsNI+HX"
Content-Disposition: inline
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--mnnnKu816GsNI+HX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
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

--mnnnKu816GsNI+HX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ1yRJQAKCRAw5/Bqldv6
8tVvAJ4n9rBYPINNSbdO7pCI/z4Oq241+ACfbFd6GjLmnO3dByxo5kv40mnUo0U=
=qGkP
-----END PGP SIGNATURE-----

--mnnnKu816GsNI+HX--
