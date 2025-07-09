Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557FF225397
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752049094; cv=none; b=YyHVxbZaB943CsjgnsUzRmV9Hgy/7GRxf32/KpB8GxMI5rXYPfSyaknd/SRvosgN/9j3kxrQ4O4UNM4yjSFl1DIIjDFbFd7RckIjFP9aPh7xIkAdcHdPhBFMBGiAM/geDAeWta04epIE6zDedYC9i/w6Pdkw0zOS9CNruoKe5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752049094; c=relaxed/simple;
	bh=9f/r6c0nBHbv8Dl8S+J8eeQaQPACDkzTRLiALBmX67g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ii5SoPCo3c9vspucqPRDqxEhmaaclvJjaHgMY7HMMBRk1k7NuTTC7eQyRlMsuyC/BYHLEQEbboueS93W5FE527cmy9whwe8SirP8Gx3eV2K3wZZEPeh8WNxv4waLw4gUzgc0I2p3IZSnlV/Ho4Lec4GJRso12DjvDMx+gfMO5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TrccRNe4; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TrccRNe4"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E9B5A103972A7;
	Wed,  9 Jul 2025 10:18:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752049089; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=cedKP5FELDjAWzwANcQdCs0mQOvaolg+wrJ11dvqRbU=;
	b=TrccRNe4QeZECDf4jTL5oJQpYyrnh3/iIC0a9/2dz0cjd6sBLed6rgcPj/T0BLWtlCINJ/
	A+XnJLY0FHKzGTXzG73y0Uy9Vc1xRqFmkuOcMuLCpSV7CcaWVz7OWYpf3HETUkJcVLb0i+
	gcUs//3GkqWxKGGrP4ysp+XSbZVkOBFVQ6/hmTPwJi2COY7bmIjHwh4LC4ACKsELIoaNbf
	kRebEz8HQsvEdBYHSpIEiBcOnBURyZ3H3PCNfvA6FymIGn5Rl2OddWaqisRHaOvjSgsUSv
	OLQKluWVUpbynoZRAT/uLEJ381sxbgXROhB1R33vOsbhO9TgWOmsUf7xvaYXmg==
Date: Wed, 9 Jul 2025 10:18:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <aG4lussFC45kuFAD@duo.ucw.cz>
References: <20250708162236.549307806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PU+46YvjpyCCLK9V"
Content-Disposition: inline
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--PU+46YvjpyCCLK9V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PU+46YvjpyCCLK9V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaG4lugAKCRAw5/Bqldv6
8gKKAJ9sHeCAAZfqZwE6K5CerdwSK5UKrACgoLgVS19oYrMr5BDH2FbDJPAOwhs=
=m83F
-----END PGP SIGNATURE-----

--PU+46YvjpyCCLK9V--
