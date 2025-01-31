Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D242D1C1F00
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738328174; cv=none; b=PA2dkBbviMgkluQfYpX4BF8/RLBkN6j8d/SoemNsT6rnAEXP7KUmTGJGQHLGqG84uaYWPERwLC/uBxlHEJ8ef5sh4fYY0gKSoaCL7S+4kTkSS9W4xhclwClldcve8D234gnyHVI6BJ+QjZVFWKl7+m0grc226LmmnNqVYJsKUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738328174; c=relaxed/simple;
	bh=V24hD1g58bppPuT+Ig5WGQP9NLvl83NYMir4LQdIK7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpJgEzEWcwYGDwDtv9ru4qV4gx1Ozhmrb9uXKVIFzwqxxI459Hbdit9dMLE5toROq1U6QSdm9o9HDvpMLA6D3LYgcwPqOPM2pdT3GGXsfnL0oct/ug9WBdMPKxe0HftdTVRQLg7vV3PgpB0riG7/9lFEpCUXlK6lsGnazpYQ6Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=eakio6ls; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="eakio6ls"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EC32210382D08;
	Fri, 31 Jan 2025 13:56:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1738328170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2/4bc3J5Dg9nPPnU5a294gfhbciU1fLnHyqjFLs3m/0=;
	b=eakio6lsJuY2jFzUKBnRE8mlbJWC/k6pv+Ici9/P7Q0qSAgThP2kqpDq7zJLY/FaElOns0
	RAYJrIw+nX2iS8WKeaBowd8iOdRgHxUJzn0+w5oOLLMijKkp+w8ysEAfpwkcHKqhGcIBuH
	pAaaSHrO/Bk9tpW8bUvUPlIHKQegA44ZVmSjwJgX4QcOLa8sMZlQvwNTvAV51WaVZJ7JFo
	n9pkjqw5DJtY1V545RdUlwjbkHUb8FzPbyW/gYMq2QQkK225+iQSUviqdRjCJ8xnHS1HVM
	q9pkVtxAKO76q6p3Iq6iu0KxB9CMJl/K9DFD5ZuzcQx6oyJWL1j7GyOcxG5SYQ==
Date: Fri, 31 Jan 2025 13:56:04 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
Message-ID: <Z5zIZHIZxuHoymof@duo.ucw.cz>
References: <20250131112114.030356568@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TT4x2xzljFrnHmUV"
Content-Disposition: inline
In-Reply-To: <20250131112114.030356568@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--TT4x2xzljFrnHmUV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.4.290 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Still not ok.

In file included from ./arch/riscv/include/asm/ptrace.h:10,
1128
                 from ./arch/riscv/include/asm/processor.h:11,
1129
                 from ./arch/riscv/include/asm/irqflags.h:10,
1130
                 from ./include/linux/irqflags.h:16,
1131
                 from ./arch/riscv/include/asm/bitops.h:14,
1132
                 from ./include/linux/bitops.h:27,
1133
                 from ./include/linux/kernel.h:12,
1134
                 from ./include/linux/list.h:9,
1135
                 from ./include/linux/kobject.h:19,
1136
                 from ./include/linux/device.h:16,
1137
                 from ./include/linux/node.h:18,
1138
                 from ./include/linux/cpu.h:17,
1139
                 from arch/riscv/kernel/traps.c:6:
1140
arch/riscv/kernel/traps.c: In function 'trap_init':
1141
arch/riscv/kernel/traps.c:164:23: error: 'handle_exception' undeclared (fir=
st use in this function)
1142
  164 |  csr_write(CSR_TVEC, &handle_exception);
1143
      |                       ^~~~~~~~~~~~~~~~
1144
=2E/arch/riscv/include/asm/csr.h:166:38: note: in definition of macro 'csr_=
write'
1145
  166 |  unsigned long __v =3D (unsigned long)(val);  \
1146
      |                                      ^~~
1147

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
650173074
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TT4x2xzljFrnHmUV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ5zIZAAKCRAw5/Bqldv6
8vxAAJ9CtTf5eZ2EZcPqW3DlSEiU/U3HqwCgq8Edh/BD59zd38f0SkgewXlOmBE=
=WgQY
-----END PGP SIGNATURE-----

--TT4x2xzljFrnHmUV--
