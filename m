Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D07339E198
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154812; cv=none; b=tlOLShO5PM2cT1m+tt9UFzkIpgp3vRB721etKGGB6XCbpu5UVsfhNFsxbwgvVopKxohXncL6Mp0xqcDB9f+e6rUi4C3yTOPtjRrPwIb1L+xBYDkSAdtQWbxPit43M5YrUm4liv+lX4ZjTslkV6S9rDl5N8yDDCtBtxrvPaBp5gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154812; c=relaxed/simple;
	bh=oykHXkpjROeyIB1neFhOSiBFwyB0JQ5MRgug3dnx6Cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6IbIQJ2Lbt89gbPLv8mb2hlWNohXyMHHJoqo+wJBD9qsTEISb6Qn/2MkgvhrJaBN2YB7n6C1asNOIyh+bGvvlAm8Mv8vEcpL5A0Q0FnC51V7iMClZ9sU/3OVXVLdBt3u3w5XKvxWNZwjlzLA6IxDHDrBQD+HpxoXgMAvhhxAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=j4N+rUvo; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="j4N+rUvo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A0E071058FA;
	Tue, 14 Apr 2026 10:20:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154808;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=llJPZZ83E1q0kMIBn6Sh1qcdCsI4+Icrr2Epz1J1pCs=;
	b=j4N+rUvoWwiJTyxCLVZGJOH0MVgk+aqCDBkBo6aT07cKGV+d6NqCYlYe8CDEHwNbyRYK5R
	B/5qsRRU3Ay3RkGuAwDmpWkfFPWtQw1zIl46djeV51zdIcosz/l8wtCPdNkxXpGFu25602
	Gijxg5g6AlG2jcrmCjbAS0a13dlk+6NsEOG6A8xKwDsS5th+D762BIJTij/mb+ZPXv2SqO
	QwkmtzymREu6XGnulCkPDY32/z8t3eDZG6+Z7erP0yaMIiA37mfKzZapftWJEhf3Zkq96l
	Og3N9LiBUHEcqJUH0Pawnvcxk9b6PG+wulqvtxfJ8ya7UPYJBT+RuuQO0O+tew==
Date: Tue, 14 Apr 2026 10:20:04 +0200
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
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
Message-ID: <ad34tP_TcEYadIsu@duo.ucw.cz>
References: <20260413155724.820472494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e6A9JHHX0cMICXD0"
Content-Disposition: inline
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--e6A9JHHX0cMICXD0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.19.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--e6A9JHHX0cMICXD0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad34tAAKCRAw5/Bqldv6
8loHAJ0bYnXf6orETPe7AWatbrnRcs1N5QCbB90wICPoITpbetflraY9cfwB+ts=
=UVxO
-----END PGP SIGNATURE-----

--e6A9JHHX0cMICXD0--
