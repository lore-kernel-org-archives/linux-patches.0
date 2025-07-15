Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7CF20485B
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 20:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752610754; cv=none; b=AxGVK4pu0JIP0aTapRFBtmtrJoXmOKQIkpAMFUEHh8roFsM8ZHRd2EGq01Ezp+L6q/MMxC+xCeYl2AEk47mxoGI6msT3FxibnD0l3QJ6bom+NN4xkwCxdJZUk8ytFY6RP2615/Aq2gSNKi4GqJZ5SLjT52Os4E3McR7qTdzd6E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752610754; c=relaxed/simple;
	bh=M21qr5y7Z0Wl+XEBa90r3aQQQKQmisfjLJQLPvhdlaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFfdUtQ1P73CRAa9gKUs660nmK8lRNA6H/F5EwvGLVwq1tnf9oEX8cxSZkJfrJ46pLpD2JYEN2L+qZWr4kZP43O+pkZrJJVlKWPd9IMrSL49fQw1PlogocCZ+btIGKrXwPLCK0iJw4d0asIEEtqsqihLGaWXWV8axxdW4FfJMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Vq4TlHUz; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Vq4TlHUz"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 66EF210397286;
	Tue, 15 Jul 2025 22:18:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752610744; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=VJAfMqyjyX37znxXL4xbV0iHrWclS8WxWXqLLY0rogU=;
	b=Vq4TlHUz6f83RIH3m8HunDZ28nACuUQ7nKqUOPGohRnlADznGxgY8rgTLL1FCOv+dkwKAE
	DdId97hPzk7lg1bbP+ke3dOj5MSGzoaD5FjAuzaHFhgqVZwR0GNzZ4ls3ROiX8zXpcDYCs
	RW3lRQjYE9qIpaKcwEEzNWkrJ01Bm05M5mt+RO1cIyeNvZwozAWtPxaDeuiS2e7VtZb2V+
	FVw/p7Q2ExUxpb5e0ZrjuSGajSlQRUdRb1Pg1ZUQ/vdvEFUndNhsBEcpJ3TV2MqegTDYzd
	3fLqyB3GhZqISnpsj3FhSXuGmElllkh+vmxOcuczxtYN/mP/8Z2TV0t6eI7hWQ==
Date: Tue, 15 Jul 2025 22:18:55 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
Message-ID: <aHa3r7rPD+Yllze4@duo.ucw.cz>
References: <20250715163613.640534312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ge5yhp2dN5KI9qRk"
Content-Disposition: inline
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Ge5yhp2dN5KI9qRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Ge5yhp2dN5KI9qRk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaHa3rwAKCRAw5/Bqldv6
8sDrAJ9FZUwMs5GHEIkZWPg8AgBNI/dm1QCgi9N1KUrswml1w/1yQjQlvlkN6X0=
=aj6C
-----END PGP SIGNATURE-----

--Ge5yhp2dN5KI9qRk--
