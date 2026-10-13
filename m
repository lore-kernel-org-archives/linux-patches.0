Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3E65172F3
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898466; cv=none; b=rvJXjZYTs2LTbp4E4+I7yOyZ4pS7638OxBE24RAffGwPZOhY8DSa+VdAmcac8hIcUKgl2RGekIMLENMsWmkmh5nIJZcsqF6UCZwq2vmz7t/HDb33iwHIeAlbLhD92DQnOqhDJagVtdToxWlZixAKwa2ktzLmffctjAeK6m3dPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898466; c=relaxed/simple;
	bh=LSXJqaEfNhoKn4Y8icI9Y0OhipJ0KE6t7s7Cr2RDBGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWMW13Iz+NXBhH5bFXM818aV6r++1zOifeQvo5kXyMViqkjtovdJDktf7m7iRURJirsLEZufxu+lauJgEO98dIUDchCwOmnEB1OuCkRQ3mfIrffanh9Plvx9EWUFxvx1ZkG2UYBBi9EK3J6Y3UYxuluF4hUpnlGHDky1Nb17m/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=W6z4sD5p; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="W6z4sD5p"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2974D10920A;
	Tue, 13 Oct 2026 15:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1791898458;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ogj3MdZsbQuJ47Ycv02IMxQMigFdazGxRlb0UPCgRmk=;
	b=W6z4sD5paFCQZqEt8x6Emy9p4jK+7rl1SEmw21wTDux7cxNx1faaLjPFI9wCC4UeY+Wkpa
	qLQvpzbAtLf3eOjVxMfJ+/PXnLx2s/ivWfO2eHkHMWIWPmQTkpYtpkQYxqHkki8MfPikFs
	3bDnZ4i8f684eLPyA6NYBw9qDY96auNSwUf/kzLb4+9yPiYz7x6LTM5Qdb3PKR2Bw0GZeL
	w3Iw4FbQcE0WQ8SKhPnrgfd4dGYbVIbdHb/TkcAHXnyCzu5CiOlVD/qtejfXXiOctSwBGP
	8Ky7ZQeVvKvZYNCFdHfQ3I2MfHOkGFioA29m57EoaZtFlLIkY4l7kPXm03AtmQ==
Date: Tue, 13 Oct 2026 15:34:14 +0200
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
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Message-ID: <as4zVj-VpU6nrqpm@duo.ucw.cz>
References: <20261013112907.864180619@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HYNdXmOeU0tPpXJ1"
Content-Disposition: inline
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--HYNdXmOeU0tPpXJ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--HYNdXmOeU0tPpXJ1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCas4zVgAKCRAw5/Bqldv6
8ki9AKCNVE/3L4RuAWVJD1fqqMt4XjJtkACdEqDQ34RsanHYL9JIxGY8q2pRtWE=
=IhXv
-----END PGP SIGNATURE-----

--HYNdXmOeU0tPpXJ1--
