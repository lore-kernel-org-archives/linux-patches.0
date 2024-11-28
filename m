Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7294A1BD9D3
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732816499; cv=none; b=qT5EErzGBiGbK5YFj8Qsl6zvKGFltQZXwN6oCPaoPFhfZ1ZFkcAZkZJSgy6fb8r8yZmAv4aH3Gmm8dI5dUVifpckI1TsRrG0C9A8pi9KrKkEd4e2fcKHSFlrzPLVzhEvnWMmGxQ2pROouh1hWKLyuAkL8du9qVD+xkfbqVX6QRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732816499; c=relaxed/simple;
	bh=zgsYQeGz/vAxjOfw8TLnkOR51KjFdaw63yTV/8pJnds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjDby0K2r8e+F532yDx6OK19UiU13kAqhStcJE+EiN9QR3YfRLpdetpuE1lOhTJjAULXQL6mva8Fh/ZVfnTSL+KrOEyOAvKsJ8mgtertA005BcsJUP2ghdmLxPjSQTAVFL1Zw8fcwPMSLV2v8XzkNNM1l7Hl/ZWJE8fKT4xbWwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AE7B01C00D9; Thu, 28 Nov 2024 18:54:55 +0100 (CET)
Date: Thu, 28 Nov 2024 18:54:55 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lukas.bulwahn@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <Z0iub2ttiQ6CWv2d@duo.ucw.cz>
References: <20241120125809.623237564@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IVawPNaLSCz26phg"
Content-Disposition: inline
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>


--IVawPNaLSCz26phg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Lukas Bulwahn <lukas.bulwahn@gmail.com>
>     Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS

I don't think we should have this in 6.1, we still have BT_HS
supported in 6.1, for example.

IMO this should be reverted.

arch/loongarch/configs/loongson3_defconfig:CONFIG_BT_HS=3Dy
net/bluetooth/Kconfig:config BT_HS
net/bluetooth/Makefile:bluetooth-$(CONFIG_BT_HS) +=3D a2mp.o amp.o
net/bluetooth/a2mp.h:#if IS_ENABLED(CONFIG_BT_HS)
net/bluetooth/amp.h:#if IS_ENABLED(CONFIG_BT_HS)
net/bluetooth/mgmt.c:                   if (IS_ENABLED(CONFIG_BT_HS))
net/bluetooth/mgmt.c:   if (!IS_ENABLED(CONFIG_BT_HS))

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--IVawPNaLSCz26phg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ0iubwAKCRAw5/Bqldv6
8gkSAJ0Rm+yxTukzp8zBbd31fZRhBeDGbgCgrYRpl1NA+/C9fEBP4F2e/eOWNPk=
=WQu/
-----END PGP SIGNATURE-----

--IVawPNaLSCz26phg--
