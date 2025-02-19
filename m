Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7DB1DE4D4
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739962442; cv=none; b=BhR+bb3bOVN2y4qXQMfeM3RFQGSVu5LHLMHvP7FaogfYsQFUcAISgqRLGZbHvd/iNFZ8jrXwt3EhmL+PtZk9uiibQ6VcamWEyhLPBpi6qiveeHEmQ2ffjbUuHVh5rmqMm0oyanrLN9ieYG4n+QiOPRtoxqRh8ljIhcPe1z/7lvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739962442; c=relaxed/simple;
	bh=FS5c044GOvtJA0CHCsroMUDBYsKjUX/26+DQ82WJeCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFttsasmMPuMa+bVAg4iLqe457xm54fyhmVchUYNoArPkWN/fshdXeUU0DPxYbvIKD02qpbHANyty611VCiJtqAh3wfFUFPX0jj8ldOg2MZcEDBuXiD2vDJ3NOgr4seV4yuyXtgxCLddUy5jGci83MhZyM5GUROn3vfqUe4fAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=hli61M9a; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="hli61M9a"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EB7C110382D3C;
	Wed, 19 Feb 2025 11:53:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1739962438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kzcUYWIaf80Rg9I01wi9Vc9nCziWIzsO4F5q4wZKtH0=;
	b=hli61M9aCL3h0czLbYtBov6cr5Ej4ceCyAe3nN39gmTzGkzXwOtLT76LeDUm13frGqa5IN
	e4O3PpQ/hrr9nuepEsfLOxQs/Xh4eYQgBwcTHakNcU+dQeXVzmY/uXwnc6NvzBYoMTabMQ
	w5DFdUfHfPscKA29PZsLeqTpE8NzQVWypZPuTPC+Rz3GERXDqD3Nlm2D86WhY6Br+x7yiF
	UwOfnjYgSPw+hepLmnp5N1RhVo64sBAmE9YTXKispF6HEHomjfSRgjQF0bQ/3jdE07JY4k
	C4ESEIDOnn6TRKYLOGNCoPGlnQZW7k9cU7lRfNF1KF6U725ADfYmUrx1RZ5zkA==
Date: Wed, 19 Feb 2025 11:53:51 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
Message-ID: <Z7W4Px3OROK92rPs@duo.ucw.cz>
References: <20250219082601.683263930@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TFKyZd67W91iEsDI"
Content-Disposition: inline
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--TFKyZd67W91iEsDI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

6.13, 6.6 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TFKyZd67W91iEsDI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7W4PwAKCRAw5/Bqldv6
8nGlAKCNY4p+GuMWswulQqPVDFUFYrMsPQCgu+BkmLca5alOADLJFT3R1Puq0+E=
=Jrlr
-----END PGP SIGNATURE-----

--TFKyZd67W91iEsDI--
