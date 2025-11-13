Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE629ACC6
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 09:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024984; cv=none; b=GU+v8itF0up96QqZ6v++HObY7FAQ5oUS7kO8QBWxAPOu9hkpqZg62U978hfDUg5OmKw+n58UkAaeTpZbhyWkGYC512arai4OqK9gJk54nhUEVnJrviWn9JkapsdtXuujazccKAFgY3zzK/jhRZtPCWghrBWRGTysc5udC0qDRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024984; c=relaxed/simple;
	bh=Rp7Z8Nbk+XngHPvukR28mGt8Tvb9RTvzouJkBVBA+tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npxgvFSwV+jkU16vS6jzK539kGtgk0HGeGPHKVRmLissdUrc9pQ090+OmDnmRP8iVyYmtfv2R07wAPLYKUMWznfJYVnpLXX8NzarjAB61dszroLiMQl6vNGsk/PdSA4g6eq5Z/57cJ30wkl7GPYySpbJbzcxxfkyamHitqIXGyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Tt3fERR1; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Tt3fERR1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E29C0103D144D;
	Thu, 13 Nov 2025 10:09:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1763024972; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=K7E9QF6PoTwdjOzELtXjqU+UET+KoQv5bYJIbXqp7B0=;
	b=Tt3fERR1JHfof1JWppuTTQolC40L4kIY2MoOtBs+1zGebPUwDPibQEQzeuinqGtS4xoecw
	PIYv0HFCSRqK/aK1DkKA27Fd9BxgUE39oDlBDk1v3Qh7jqIElGsNAmYlsi9C+dGIddWRWK
	hv+ydRd6py9mGjKILUVxXnpi4IsLZivZmxOAKq5D8OSynjrRZBTh0i4NBWmVVUDH+0MH/V
	Ib/zUMSa0HRpRfOUtVPzmYPfGJ9HxiJItLhSg7VEUsB85wWlaJc075oRKnYeU6zxzCrCFU
	kJmYEPz6Oanl5yfEqqN4q5Ptyi3LOFAbffafzYJUIt+EICoKOHqDZXUQUmHihg==
Date: Thu, 13 Nov 2025 10:09:24 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tiwai@suse.de,
	niklas.soderlund+renesas@ragnatech.se, lirongqing@baidu.com,
	viro@zeniv.linux.org.uk, theo.lebrun@bootlin.com,
	arkadiusz.bokowy@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Message-ID: <aRWgRG5VmLHFZDWp@duo.ucw.cz>
References: <20251111012348.571643096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkMACDBEIuRlEgTs"
Content-Disposition: inline
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--vkMACDBEIuRlEgTs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I don't believe Sasha or his automation did good job here. It is wrong
to sign-off patches just because of LLM output.

> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add validation of UAC2/UAC3 effect units

If the check triggers, we'll be breaking someone's audio.

> Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>     net: sh_eth: Disable WoL if system can not suspend

WoL is used for powering up systems, too. Congratulations, this patch
breaks that.

> Li RongQing <lirongqing@baidu.com>
>     x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of =
PV_UNHALT

Looking at the code, that should really be "goto out".

> Al Viro <viro@zeniv.linux.org.uk>
>     allow finish_no_open(file, ERR_PTR(-E...))

Not sure what bug this is supposed to fix. Sounds like preparation for
something we don't have.

> Th=E9o Lebrun <theo.lebrun@bootlin.com>
>     net: macb: avoid dealing with endianness in macb_set_hwaddr()

First, this does not fix any bugs. Second, code was "cpu_to_le32", now
it is equivalent of "le32_to_cpu".

> Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
>     Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI f=
rames

BTUSB_BARROT is "write only". That value is never checked.

Best regards,
								Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vkMACDBEIuRlEgTs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaRWgRAAKCRAw5/Bqldv6
8mSuAKCxatrZYWRdTsqb+VMeMJcO5rylqgCfW1YNLeoPMoUzaELhp79o4uuu9Lg=
=4tVS
-----END PGP SIGNATURE-----

--vkMACDBEIuRlEgTs--
