Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB0D3AA1B2
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 09:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071765; cv=none; b=GV4uQ9Ri27gFJRS1LmZpyVRNyysharkYwhhM6juxLEDeof+3Ng3zjiswo7vXMQAEWgtfcpyS0VAEgChImHxdU7fKdwIuSG22MToQZaGJVhmy9OFpu4GhNJvSShVYtDG2FV/4IiljLCcXLBUU4CQQNAYQ0KZCwW33MjIoCQY5BIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071765; c=relaxed/simple;
	bh=WYG3QkKuDJe7oULK5s+xV48hi0UwhANCZaAN42EFhew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtOhaupvQX9YhSuq7azz4aoBEHWhJadhoIZ6TqpQIbyHnWxAru8bIwwigSrKUDAW2FTtNC4SXZsIbI9/geXvwWIHwgBkwWd05XIuwAHbPxOyrfDr6zjGd8lrQRxD6QwHKvsXst72aceoRvHBmgIfID6wS07IDrVC//uNEM/Rw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=EVrGDvoh; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="EVrGDvoh"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C01441129B7;
	Fri,  3 Jul 2026 11:42:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783071761;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=HchLe0MxhTfYAtstdRTMefB2zyFRbQAeTHRW0gJIEdI=;
	b=EVrGDvohU6gNRb07l1bVkuveWxYhEvXiEmOlwupIuy56q2LZOK0K8FSqmTB2S3lF57goNh
	vn29D7t9wtKThuwcCueybJwxfWZPgTHSoS0fY13YvVTdonEnhRb5kktIxShkx2B1WTobLT
	wpqQPNUROugxrSfrMZGtBEY8GEOkBVEinjQm+9At0Ds/9o3bgXWuVz7DL59WQ5SehCSNju
	OBex1T7LbuQjcS7Bj64aWibloDowpGAWT9gEx3pj3PRDVTUdWJaaEgP8R8rF5hLuh0YUGc
	y0VqT/4T7qy6yxHa/iGKTgj3xriCDe4l17XYu1RmOSlIcXesN8PXKam+Ginbdg==
Date: Fri, 3 Jul 2026 11:42:39 +0200
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
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Message-ID: <akeED2eVLfXHlR3N@duo.ucw.cz>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iaSDq0czJr3T16Nc"
Content-Disposition: inline
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--iaSDq0czJr3T16Nc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--iaSDq0czJr3T16Nc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakeEDwAKCRAw5/Bqldv6
8hG0AKCENkauXcNrvGQhNqw0F2XMMMLx5wCfYof1S2IAUZV90A4biS5gfUDzu7k=
=gFMd
-----END PGP SIGNATURE-----

--iaSDq0czJr3T16Nc--
