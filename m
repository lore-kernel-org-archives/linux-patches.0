Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50A837B3F7
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775719426; cv=none; b=o2+sjnTo7CnSJywlvhBi1tmEZBDjXQRCxf/qmJzJ2AVSYu/51giDiOdLkCYd0TY2oUoS3Sp5DuHCWL/vq8v0p54zHht+hszVF6u3AECW49GNVIR4mNsH3OcDjqDCCbts9H2RatgzUXqPYJXYjlq1oAq3l1Kr9dIgKiXv+Te0Ufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775719426; c=relaxed/simple;
	bh=qJAyJQnE4GoBVHMZMuGyPRuXIskJ7dDdl6jqPbc/B3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0qrd4/M0CS34Yu9zmfjURZArpV40V0tfLZrZzDFT/J0QfUUFHJiejkAH6ra62Zg+MQufpxZC/40pFSmjMdaK5cdtyDaxVQqsjJsp8x25coHDbS3QE+JQpavSkiBjVRaCUKsH8SwLXbuDPkKjcTZekfEmdLcT1YaO+efW9+YVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=B3FphoSl; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="B3FphoSl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6455910DDDA;
	Thu,  9 Apr 2026 09:23:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775719423;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=5j0hR6XQUCb42SoCQHo5rOLfwdvI6n6GdV1EjgQr0gY=;
	b=B3FphoSlEZ+dq0p7sMEFsOiT9k9tHeZH752xp87eSqYIOGU8c8rliLyeT6Ibm3RXTk/s9r
	gbROdkamRuvU0BcoRhnVwP/AltPHu12+cN5Y2ArBJMrkWbIdhs62AIuzEl3Nr4fIkgg5Ia
	JKgZo7U4tSbPOcz9omCm+3/RcsUOK1Qd7yJodf93SM2Y7+lvoZZ/kmXGUnE/okJeB56d4a
	AvX29rz6GGrkWyTCn3iFfUmIc6NUwcNzU7Lh1oHcJUFhxPC2W7KXF3sxoALJI/YrIH0C3A
	BuW6x9DuzmNtkTeyTzxyy9p6hozSa9FaMeBXQSMEp3Q2MuUd3ji3R3VQUvjSzg==
Date: Thu, 9 Apr 2026 09:23:41 +0200
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
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
Message-ID: <addT_XArASAs1uGp@duo.ucw.cz>
References: <20260408175933.836769063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7odyUTW3wAw+L2qp"
Content-Disposition: inline
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7odyUTW3wAw+L2qp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--7odyUTW3wAw+L2qp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaddT/QAKCRAw5/Bqldv6
8tXhAJ9VQhEBmgLYbfS/W6+yi1Dgu7BUGgCeK7rMh7k/B/oI3xnOMx17zCI5KKU=
=JVsF
-----END PGP SIGNATURE-----

--7odyUTW3wAw+L2qp--
