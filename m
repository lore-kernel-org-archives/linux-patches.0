Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BE03EDE4C
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883192; cv=none; b=PdcW/VFe/ugqfqWI+Vefd/E79Blz6WbjG63XiQYIRFJMIOoVkPTHnSnqElhWD5ZsSdKL08PxVLjAqOWdJjK1X+oj2bXqwHoMraHZYRCR1fbQVu8F7kT7lszzIK57l5NzLv85eYP2iQIyDIx7Yk+j0cmavmTDe3nRJ+U+gTf43bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883192; c=relaxed/simple;
	bh=DpWPWp4lkyf4IaUgLJLMlPluzhNrWR/f+kWdZw0xSQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/UKphKR/0itLZk7UpxXO0jyL35JQGCpqThoFJnlNUGeLbKiAMrnAbal3QhfoMcTxOv8nlcu6xqhlKbnGZyiblyD/gV2qDpLTDzcD030epMzkMos1cAmcDoFiCjZ4MMgrvfLKB+83kvRQZY1IgrHLnO9gC8KCFE9dEKmbCnar9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=d4LKI/ij; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="d4LKI/ij"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C70E6115830;
	Sat, 16 May 2026 00:13:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1778883189;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=F7G3mTKzS4P0fY0hIWzYze+JkS4yffVvmvBWPNXfv/I=;
	b=d4LKI/ijzxbIKr8AJDo2eRYN/58QNTRpukUN+5Zn76xABcY5t3OwL3pmKQUQANgn5wRrFL
	4TyVsJTo/ai/uU2FLMFZ8kJeq31EpQ7HiBUEjws8PdKlVi6Q7+FPhTPZDjNgnFYnL/JltC
	hQFoFvpvmBZTIVkRkhfhITtzA9bfyHMXRtQx7JQKlaUepNcgJoOraoe9oMf3TartssOYKG
	TIfHPZyMQToojYCXqJAUrgLuVDqArK4HadOGAifwXdgvNHXa0TEBX7nyNL1/f/de1bWwd6
	m8WQPzKRfHSglj0qI/CX4m57ZnPQaVOWX8LXH7se812IkFx9PfTEczksMXUyng==
Date: Sat, 16 May 2026 00:13:04 +0200
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
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Message-ID: <ageacKxRFAqHOIAf@duo.ucw.cz>
References: <20260515154657.309489048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+MWquUqpMORT6qhF"
Content-Disposition: inline
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--+MWquUqpMORT6qhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.32 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--+MWquUqpMORT6qhF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCageacAAKCRAw5/Bqldv6
8q+GAJsFXOJ7zWFs76GT2/14d+oBMCivEQCghOoLC4ZB8/Uj9g/k4YfNcEc3Y5U=
=f6sg
-----END PGP SIGNATURE-----

--+MWquUqpMORT6qhF--
