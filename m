Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497691E883E
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740081522; cv=none; b=bb2ffPAnYOdu2vh1EgFeTRtmVzmTfvGL9z8ERtH+LR3tEzK+UCjj5nIpDYRhdUfqEcfgnfsjUnVyBAusmjDh0T3ry3yut4Qv6R+NZ5ByQXW3T1rTvUW2KVT8qOCRwrj6BrV4GHB1fIbuTRqAx7xhYmk0z7+TT/BqDqxD5arvClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740081522; c=relaxed/simple;
	bh=TlcvZn5XC5I4nPPa90kPdD34vCu9DivAg2T/YIvbv8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHQDyuJoHk33x9aJNpl1hM0G5apGyZSWOjxhbs6mwoSwPTOBnt/8v8Ilb5hRhQ0xtzhlezbZc46VavTPLPhYrE0CmtF+T7bYWJTH4ImCjeKktCaG66ibb+jai9Jvs/lbr3XoEYlmHYbIIbOLR36W81SP6yVJj52MLdDEaIV1Klc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SAPd+HgN; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SAPd+HgN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 541CC10382D3C;
	Thu, 20 Feb 2025 20:58:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740081519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5zb7f8fNkeR0C3ZgFUNMaPL929Yx+Ynb8OoginAe70=;
	b=SAPd+HgNPqX4iV++eUiB5pR0m0CGaqrIfRnFXE8IP5mKROTe83wXsO19cVxJPv7dEuTsGA
	mmhTtuCIWkHUyQucy+tTMKZ2JdY17NFia1ERv2+IpX7kHh1Z7sQPJ95C/NT7Et0zINEkdy
	YxnQBljeHRFvIK/KrNy7wmHLdAO+xzqz+RFx8mUoIbDTLEemHE6hTfHjr48miJe0zKZF1P
	Q5UKmJsctfUqaBjHMzNFItPo2wttLZ2iIRP+DQqoufBMkQXHYqzQUdTY8A7MLNRQX23Z0s
	MBKItbEzSiF7tO9/NwzGywIM0ssKzsAzLNnTq5HvN4Q7p0VccqUyVFsug9/txw==
Date: Thu, 20 Feb 2025 20:58:31 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
Message-ID: <Z7eJZxx+1zpeROvm@duo.ucw.cz>
References: <20250220104500.178420129@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U6URlS9z6NO3JthT"
Content-Disposition: inline
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--U6URlS9z6NO3JthT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
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

--U6URlS9z6NO3JthT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7eJZwAKCRAw5/Bqldv6
8ie5AJsEYnjiuYadC49y74j8h76534ov9QCghnkdX14ga5lKn6d1A2AW7ULj3C0=
=WWlf
-----END PGP SIGNATURE-----

--U6URlS9z6NO3JthT--
