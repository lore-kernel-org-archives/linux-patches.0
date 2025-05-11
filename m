Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFEE14A09C
	for <patches@lists.linux.dev>; Sun, 11 May 2025 08:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746950666; cv=none; b=cS50G0zj7QBg6AzU5Ug0KLtt/XwxXZ3Itl4dHnIkZH0APU3q/wKHaeqm2gjDmogu6U1/rkyHKzqGsoo6ATq2oXkqaoWG5Bvf0AbT0JDkRiFX9lNW62vGueuuCN4UdxFZl0G+oHMqdK42aHWSNpEkwHYxzsfu7lYcvnzl0TtcuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746950666; c=relaxed/simple;
	bh=YWb2t8IBmufksPX1yCb1pll38Bg6jKtp9P+IlQaWEdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLEgdYuaVxdPBtT1mDCk9GEzLe4njnvGknb5jkvBbFHjRri8nCng2R6fSjXcR0jng2VwjyEYOdr7Ho0Etuvf9pytktN85jPcViNC1xKXV98n8/8UWNYKljgIuMAMPsgCXYJcn29nrzFiuHNxq4n5kr8YWrwm7EFTgiygazDWe34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=UDI8SM8w; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="UDI8SM8w"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AB7CB1048C2EC;
	Sun, 11 May 2025 10:04:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1746950655; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=8dMO43m2NmTXCiptYlYWpF264PfUA4CZZdQaWxjjBcI=;
	b=UDI8SM8w36xANrgdEYMHr0rC2uMoONObZnYMnuGUkcc7Su8M+ZOU7P+urr43qSVAHyX0uF
	X4IQq752XEJxTzxrV7x2QJH6m2y7RUuI2rrrdTPaNZtvXKlSb24VlnS5q/hyhh+Q1aWdTj
	/1+fRBOXEbu1l+QevGnHTEPdf59hHZtSJtCi1enzbXKPqFwUnLBrOFu/Mizi3S9uyy5n3L
	O1iZStUa4VkuCwVUCaOjkWOS7JJQWtN6RBQiD3TiyVxFGuMt8hM5VRJlTYqgIuvnfNqZ7G
	PL/fq4G4XlyQX/2CjN5fV3XIQ8G53FqpQ2WaoGXiLLVo3UIDXzNqZRDsFdU2Iw==
Date: Sun, 11 May 2025 10:04:04 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, yukuai3@huawei.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	tglx@linutronix.de, suzuki.poulose@arm.com, yukuai3@huawei.com
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
Message-ID: <aCBZ9Ie7/QLNWivS@duo.ucw.cz>
References: <20250508112609.711621924@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nIaulWZhoYdAc1QR"
Content-Disposition: inline
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--nIaulWZhoYdAc1QR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Thomas Gleixner <tglx@linutronix.de>
>     irqchip/gic-v2m: Mark a few functions __init

This is not a bugfix, and is itself buggy, needing the next
patch. Just drop both.

> Suzuki K Poulose <suzuki.poulose@arm.com>
>     irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

> Yu Kuai <yukuai3@huawei.com>
>     md: move initialization and destruction of 'io_acct_set' to md.c

This seems to be preparation, not a bugfix.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nIaulWZhoYdAc1QR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCBZ9AAKCRAw5/Bqldv6
8jCMAJwJdbKdQ0F8TqG+Kot3gNSNeZoCjwCfYhyNHmEl5MgDwqC/BB6LFkdxJkg=
=iTFO
-----END PGP SIGNATURE-----

--nIaulWZhoYdAc1QR--
