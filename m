Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB7A170A2D;
	Fri, 16 Aug 2024 10:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723802955; cv=none; b=iT1Za5CqycltO1kWvqym2vvZsrXBl2WG62YiCbJfW8afxCHNFu3Fb+Z5fKXo+MuLVRRWStiKRBEyNlWJMxfJZuDmNOAyDqFIdDeOQkiZztjeQ6K7XPaxm7lR0oBZ7sDHeKaHCM1FeX/fbHdOzEzSEN92HOk7zE+2K+9exR5fL70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723802955; c=relaxed/simple;
	bh=XblC078xni1zsUW+8Or/GJX8jPozvOle7xqNGC4RZTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVX+Pk9NsJKySVrq5xuOy6qm00rIyM27W2J45+PWPjTerYfzYm4rzl7xTtixusxfFRxsdeat3akaMeX+Pob0YQ1fobZvLbIYZVeOFa1MNWA6ReaRZ+6t0Zoj76yD7A4Mqu36sunOChtqrad+bEDjcz72cLG+z+6kjPeUbNU/iKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=0rAapn9M; arc=none smtp.client-ip=217.72.192.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="0rAapn9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1723802902; x=1724407702; i=christian@heusel.eu;
	bh=do2Bwj8g7fpyb7cE3waI5N/4aZzXIwqgM6OvvBVCdzU=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=0rAapn9M/HHnd+OSQOQMZzhUhuXl3L6gQrshVPb8Gq1jKgk+mze+yQE+Nw15OK/R
	 w+XvPC/gFVUNaz9rQECbW9X/f0ndmmlz1Bx00ZQR85cd1/LiopZZQD0hxBwyYn6Q4
	 l3wZKw1jmnMvj4uuZuEuhlzzC+EzH2zIi/JBp6iCRpT2joQFGB2G70tL0PVpF+qxI
	 JNS3nhw+cIEX1r0FCgDC1CfEkA3LI5AtrcxltH3wtdKxe9+9sEqYbjmgLj6nekhZt
	 iS7WLBtBJwMXxzFCpYO+5A5iLWxSuG9VbB2L9vWBGPxTrHhQFFECNVW4cmiVV/dG7
	 oXGtnoTnTuCtynKS8A==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([93.196.141.81]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N49d1-1sEOmd2GmH-00scsn; Fri, 16 Aug 2024 12:08:22 +0200
Date: Fri, 16 Aug 2024 12:08:18 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
Message-ID: <6bd15eac-5ec9-42b6-8644-a716ffef67a1@heusel.eu>
References: <20240815131831.265729493@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="akhn5qsxjckqmavt"
Content-Disposition: inline
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
X-Provags-ID: V03:K1:9aabSk45RqJ+ZtzmTO3WSN0YZBmstwf7pqgDl01OY/mcI19xKAl
 ibHfNRGveAR7kNfHMi8R+04n/Jh0jSfZ1juH5Mo2gJX8dwESaG/OuVvWMmnDG5vaqClPGZr
 9PLmCTBMx+9J1Aanv0hWf+V2Dzpdpe7ixRoDwapmOA2lHzH+jz58zGqMtRnp9jFr5KzToMC
 m2SxSyyqOi8c/ylX2qX4w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ffyTtNvRhe0=;t8hEJbfZanaSV4+rzi6cbpBajog
 PqVo7CKlw/uuXQiyBf6lzUn7CSoOtbYW6HWg4b7G9A1fCaU96J0SaN1QIImsJb2bmXqmUkrEU
 VO/AD/bpvQz1G5Oy1eLSevkpTKTE4T+Fx4uvwF2J1OrIXaaIajgWvAq1FZQ1zKiuCyQOlSYYI
 sYD+o+wKTjdL5nE/TE4hBRq2hL6wJuv4VXrIa8VjjxLdHyjC/IAtz5sGa7G1GD5WsXyoP9sAq
 IvvCNYb6JxdSAKoYBh12A90Eb2cZCxPJ6vafoubmf0KLj3NJW1A63dRvdKacdKCSGqt+IZvnw
 L75whREfXqb2OroNwLMm7jeSdoKHxnaIDr246/uqr1LjwPX/zKi5PqPQAGAbDlQ+y/Khglc1j
 WqMwd0Gf9feUGDcHq+ofEb4AIQSxVCnc+RkxPafxtA+bpNS9633h78Gf1kO7Ouq40SmOa3DLW
 ikNBdEugH4ZFx9zvz/O0ecpGpBuZTBkgd/j2WpgC7nscISZyhJyRBOFFf9ey1g/OS22QbEBx6
 iDaADE/ceXmgwI3xZjpjTjc5CTuyb7zfXU6ka/bcfbeQU5k3dQPOGo8cMaoBXjxaIsuFU2E9C
 BzJwazXPJZNJo6UR8Rkf48TneLyh6MqJgh7buDUwOOkQOMwxByJIK0Zf/auI/9qzvj+O7a1lP
 SsQjnU6wddRZoQU0GTqH1G+Hvxhe66yc1fU33eK0XKMde03hMac+Yd9Nj6+M5mY27tz1Nwa/G
 1UFRMU3H0l6Vfw6TKzmzigp4Ri7b59PbQ==


--akhn5qsxjckqmavt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/08/15 03:25PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--akhn5qsxjckqmavt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAma/JRIACgkQwEfU8yi1
JYWTLA//d3OSFssO46jfyyh/6gniFNV3Z5Nq/lwnHxgStLiDVYCxlSohbz0I7rKK
oI9XfwiKZ+PhUagudeyNgscQjygKt/Z1stodjRJNKEXIq+syQB23KqLifTLqRazN
FdtBxq4ZfyFMAALv/dZuEKZF6BdX60er8sNHmZU6rIym+Ux9DxERKGoqVAGiUl4j
YV0BXk7p1CaccVY3jD3WxTZ4loKpXLJmfPU2EEAr1pWlgjTwQPOljoYbX23w24Pi
fbvgGukCzVn1/M9fBN3rXz9SH/eHVZLTP6qKFHpQKZ2izZ0Z4UHRnweRgUqrkHZm
TKfmyHZMO1Xnu3OOo6q2wUT5p8RpCZe0GiQZVz7ZWgQs3YcVCYrnUKgq9Lb1WEm4
kVL21hJOSiGFNSv7f70iqhvGTAnUfW5lGKyUVyNzKR4jZK62VJgi1bhFp62z4pfa
5zgtYm7AMwxbKq1kLW3l/skWW0WDNIBrRMHT3smnZjRAvL2BHeCQGvCo+Lr05HUL
C660BuqnDd/5nHxIkrDGcanKA09BIh4lA3sq7JEhpChmJYKMQncpgtPUOYOVzGUO
WK82yVztX9FY73sgNI1tNOtrtnKikUP+zp2WcVel2tZuUuCkPnr7IFvSqYpDBnMO
nkWyfIRgU7ja97OnWfH8WpBUs9xUUbroigOf5bJ0BjHp37kdW+c=
=HNMX
-----END PGP SIGNATURE-----

--akhn5qsxjckqmavt--
