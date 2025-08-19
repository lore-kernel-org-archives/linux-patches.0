Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E5631A057
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755596989; cv=none; b=AzAf8KQ/oHN8qGxO1WbHi8ruUsvfgWUEt46LBc2ptsQhDYzj3LtQIG4YhUuZrdI4RzfbaF4jKNcNOUCj+otz0kikNLo/zjS2khFjgoWI8LCuzHWK+HDraL/QTVRkN8A1VXPlOSWW9sCiIOvo2q9NbHoUZqyxROpHaq/kt+gi/T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755596989; c=relaxed/simple;
	bh=NgjT3AXJmNHpYMtXwReAJY+YxZrl6WWlSuco2/rbpJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxrG5hb/m7JT7mzFoUp2UuYuMZHf/sKPcI8tTa5a2+YZOMqSilCOL7v3UMZRZ5ASbSFHT88tgKM1e62GfeQOfhLENQmDdPAeJY2F3PGgA15XE696LqRyRX9YJKGlLYB98EjewEQzvOM5as9XPsVXiMMJJsTbjLPlGQuif9KbSE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YTOVqOfZ; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YTOVqOfZ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4F8811038C11E;
	Tue, 19 Aug 2025 11:49:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1755596984; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=v00EVxp2f9cvCwEcte1cbk+FFRccPtGzRkdO+es/Ltg=;
	b=YTOVqOfZtK3/0JLLGrEtAiBWEzfvym6j+klakS5Mzysv2lNZpS/OGnD1SFXJZqiUwr1X3y
	v5sP8pAKiILCATI3vA5UhMY+uKTStZCRRHbWqHR991MfuDexXCJPuP5RrHUw3rFMSuQF/L
	4aAjWDgJDQkfewUccc5Xd4HwtL5ORCtYQfoLxq2qbMsFlDvhozG3J1WDUr/FwZ78Zi5BDu
	Zym1ppfGU+a0yI9KKaSncyseEw95DrPlmpVUplv4Wo8PO5RS5j0sBYOkC4NKV87lfCGMZ+
	HrwM4797Osw4t3Rg3iMlQ2ktfy9dqdolHn3wg8wbBzy7DeS5RunKx1kCp5jp+Q==
Date: Tue, 19 Aug 2025 11:49:38 +0200
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
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
Message-ID: <aKRIsm1+w5DJqebA@duo.ucw.cz>
References: <20250818124505.781598737@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4O2b2Ns1yAeYfOm5"
Content-Disposition: inline
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--4O2b2Ns1yAeYfOm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.16.y

6.15 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4O2b2Ns1yAeYfOm5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaKRIsgAKCRAw5/Bqldv6
8lLDAKCv5kwy81x5drhS6S4eac+kSohwCQCfZzZ53klyVulWsJCYW4ufPe/8vbg=
=vkPc
-----END PGP SIGNATURE-----

--4O2b2Ns1yAeYfOm5--
