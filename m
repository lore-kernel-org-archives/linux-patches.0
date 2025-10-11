Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8C19CC27
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 07:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760167846; cv=none; b=KnBGCkLvkb15QZBqEExpGqSzXA0iBndJxTjZTD+uMg99FSBBc5O+m3p0COn71n7Tkspx7e+S5WR9Lk406KyFSfrLGVYXg7l44nvq3q7kBlmWhdG8APVh2pSBIXZnlGFg792S3hPZFyJ6kqZYD8GzKztN+Jr7d3PJVEJI/fOIrr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760167846; c=relaxed/simple;
	bh=RSOg22dd6J+zFoSV+Us8Dfi7/aDUJS8G1pF79oHQx30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwolBE04/8WBw6Ey52DX7+CDydaRqPw0oZhGETHS8ZwdA/HCkmuDiv629G4vRzWRTOUDrJTzAOkzuX/3Kz4XYDQT65tTRTRx0eDJjL2rleTqQKH6LuOzevM/OU4pgrcpypk2SoYfxDTlbbMfulEOTOd/zUBROvb97km6hwFwErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=AL6oPeWt; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="AL6oPeWt"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 042D0103F5654;
	Sat, 11 Oct 2025 09:30:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760167840; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ljdK9FvkSnO0rejZasnav5c5/v+w48zplSX/X7O254g=;
	b=AL6oPeWtlkgiUlYT0oxK0dZcgR3ZpSlHDCVDgZqDEGikV25tmZxf/EPO0jPF/A0AE6QlWb
	cr3DZaW9lLIRyOCxj7LYTxipTw0lRlzfoQP2eSopUCACkIcSaHU9Jwl10pMYIpkteTU7pH
	x9w2Y1LamFMGOuU1IVXnfN/Fdcq/sAJo0S+PrFiv6qNLlyHs/Nj3JF9Qk6rkqh8ivHluX4
	OvanClY3B1cbN0Md+i7vPyFtmH/tB8DQpasBeneOkWMA9aVWFu/JgCwrntCWg/xjtx14cG
	b/x75smTDKGnp+jnr4L+XvnoBZL+m0eWHW1AvKXklzorShntNsV+xVLMnddOUw==
Date: Sat, 11 Oct 2025 09:30:35 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
Message-ID: <aOoHm/I+W4vpd/0X@duo.ucw.cz>
References: <20251010131331.785281312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7rcESwphP0agS1J"
Content-Disposition: inline
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--p7rcESwphP0agS1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--p7rcESwphP0agS1J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaOoHmwAKCRAw5/Bqldv6
8h/1AKCSIDH6JvxjLiq2uWRkMrOfP5He4wCfaDlBUMc/dk+CF3cYwjL6jUF7lXA=
=kWBZ
-----END PGP SIGNATURE-----

--p7rcESwphP0agS1J--
