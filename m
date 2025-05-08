Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C334A33
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746696214; cv=none; b=K9Ax0nISV+r6Rrzonj5qu1vhUYMvD9cM9vUUiz4oyXyaPRZBoW5OwxxpaKU/MB+U/05/vfPTint7kdL5IlQDBQE6jzmp3HDGT39Qx0IpBdaodqhXSO96FR45u/1lh2jYqI10I09qGHpliG6D8sLnziOOM6WRiVZ23HQm1ecuQYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746696214; c=relaxed/simple;
	bh=GUc7gYjkerEdhsbv+K2NUANsKGml+3kQcoR+yDCdq1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxWA7KLZaiLCiVPQiNNNGqNfOo5uBrbaULuWt8pkzHOG4YED3Tyh3sh5VePNZBr8lf82AgKnAAGGbVDmz5LwHES26x0zRSAIjdATh/8Bt9wEhQU6PDC/wPh3IprLDJAXo+B5S7FGX87TlKnToTrGwF3Zo18a6hS7DB2QQbueAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Ykpc0+no; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Ykpc0+no"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2225110252B0F;
	Thu,  8 May 2025 11:23:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1746696210; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=EggUkAffEfLEMaqrvbBO4xOZ8AI0dThMXTPapqVuaQc=;
	b=Ykpc0+noE4ONvS3XOjs3DW3EQYTQhemG4+FYgQeFIW+4FfOr8OnPoQuJ3EhwuFSiH5S5W3
	USm1O4ghDNP6oM7qiKLv/XOHchl1jZOKVj48o6c+6Cojacx/pE3qBRX/yjCdXvMj0xzmV+
	23iJmQBHJn+c/rtrrxaWzuP6KOKeAaamryoODFMnP1yH/sIz9vjlHWrzvvVXy1MpyIVFWo
	mcqf1fSIWlY830VoYJz1OEusDDV1pxaW7eH6cbn1nbeMrLa839YGyjNe1rvU5hYukxAXVM
	8riJ/M2gPskbJtnfSSkqzuZQP3i94TVybrzhOzTiRACSmJijIjvezXorDl1JRA==
Date: Thu, 8 May 2025 11:23:21 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc1 review
Message-ID: <aBx4CYJjarOpHgfR@duo.ucw.cz>
References: <20250507183759.048732653@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wi5YgRcV+P0KyU9V"
Content-Disposition: inline
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Wi5YgRcV+P0KyU9V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build errors here:

  CC      drivers/scsi/libsas/sas_port.o
4415
drivers/tty/serial/msm_serial.c: In function 'msm_serial_early_console_setu=
p_dm':
4416
drivers/tty/serial/msm_serial.c:1737:27: error: 'MSM_UART_CR_CMD_RESET_RX' =
undeclared (first use in this function); did you mean 'UART_CR_CMD_RESET_RX=
'?
4417
 1737 |  msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
4418
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~
4419
      |                           UART_CR_CMD_RESET_RX

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/996713=
1728
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
806176894

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Wi5YgRcV+P0KyU9V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaBx4CQAKCRAw5/Bqldv6
8vGpAJ9GjaXoqubgx+3Fj0NDFr/xALZEtQCfcRiuGVaKCh9K+fM57c1Q09OVncs=
=11ai
-----END PGP SIGNATURE-----

--Wi5YgRcV+P0KyU9V--
