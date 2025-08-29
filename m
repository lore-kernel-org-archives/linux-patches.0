Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FF323D2BF
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 06:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756448422; cv=none; b=tfeAIIdH0prpSi0vdd8zPEopZzD2X3rql0XD/iOdnpUKtq0yVEme341+OX9BjJ5ife9XMQUTQhFDEkSZRKiQeLpXmB0X5cqCm6gr2Ssqh6dFIptqiP2ZtIR0xMK8EuTPHYZXHKQT5vJXbrqiaBoxLiWt+sXEh/CKoNGgBcKH81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756448422; c=relaxed/simple;
	bh=v/unp1wJZ4wt+gtb9URTeY7e1rqk+cPr8/4lwrZYSPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DS1gNwfyyGL3hD+Z+cGPCL5dJ93axwpBLQVE64TNwn1miBPfDDGo8Ohgw9zMcbDOgj/w4elS06UQEDMmyK550LBkQX3wpPv9ttILjEUTr/ii6EcHoN8lcA+8a4KOdf7RHankCovn7HrrKYN50ZYe+8ehXed7Q/9u5YdA3oXQSBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SHjMXgt1; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SHjMXgt1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 14C8B1038C106;
	Fri, 29 Aug 2025 08:20:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756448410; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=O4EneYV/MWd5kppnSN7M1ImvbKtg1wmaX2ZgzX2GRiQ=;
	b=SHjMXgt1q6JM1uubm5z6LxjBMQiuamt6gO0jwlRmq24/i7CrOwufA2z31jniNe2FzN5fRi
	Zcc+gsmFWrWb69fTQ3lMV32ZKnjLxmKsLTPGlWR6439kIFS+5OAwKnj5XGejwFf3QYJi0S
	PVC6jB8XNUqGjtpEQKqUwlmHxjQfHsEM2B2iSWLbUh2c/ILy73CddT8WlrJbhvBXTVfzZd
	vuC+TQIjwUJRTnrIsL+bwnZMU8d7X5d8qrbuaADsEELIQemiTekzfllBd0mX400K40CBAO
	gaUrhBXpgO1hKBZuOOkDbVir7InOCUe1pHPonP5faa/l61qRFbk2/Ha3gtLAig==
Date: Fri, 29 Aug 2025 08:20:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
Message-ID: <aLFGkFLgDL3Z9AU7@duo.ucw.cz>
References: <20250826110930.769259449@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uwNqM38krSEe0hUZ"
Content-Disposition: inline
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--uwNqM38krSEe0hUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uwNqM38krSEe0hUZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLFGkAAKCRAw5/Bqldv6
8ujxAJ9qV01dDwiSlTE/esbsJ10RA/t2VQCeIG5Yx/KEtRgaQv5y8KHiw1opWeE=
=CX2c
-----END PGP SIGNATURE-----

--uwNqM38krSEe0hUZ--
