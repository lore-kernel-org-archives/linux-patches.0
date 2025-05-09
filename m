Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C639F274FCE
	for <patches@lists.linux.dev>; Fri,  9 May 2025 08:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746780474; cv=none; b=NGGzPYcS77gSzveEzLVh5VLLmM6jFJ6IU8fOtO28PY2ZlMKfjUYcdKgFRj+TrnlfP5mtaYzzNIGO4D2eI6YhUrj0c1vRn5fy/giLG+A38u2ew2e8gHXfuB/CqZ3nYZT4SXZz4plWgy5ZC5LsSqWcCXSrxxWe9jfVZ/Id6QUcClk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746780474; c=relaxed/simple;
	bh=SEoSsi3ett6o6pUdRiHxp7fe3M4N18U+wukVJjqimCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxAj7wJxsFyuIa30ZWq2uPfNjoYuaf6bZQ9HJxuZSo1DUMDuEq9xh4NFFKIX2uHk2uwC7wocTF/gdzqPF2GQSFMKhBL6GUOeFF6Bt/uSWtDI9mzwPvw3P5aN1u152jOdWU2rYr6bDI8jCDmorhFMcRTVQBsS1s+tooNngpp+lvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=2goed3b7; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="2goed3b7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1746780469; x=1747385269; i=christian@heusel.eu;
	bh=TIojQnKcGA8HumCrxDJ31cFYqtelx81BtXW1fwzCys8=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=2goed3b79Yf/MPPasfkd8HXjfV7I1IeWZw/W3k/Vj0oZiqB2N/RqhIPrbTgaFDsj
	 OcPx1LI2xNRAT1KFoBxnr6dAmzS2hxMB4TFVozFieyp6vlTf0vWl9i4N52iSn1A8h
	 sde7Dc2juTSgRPEaFh55+FNkFDkmK+7zjKWACJmDaG4rkUu1m4IFBtHa+g5pNjm/2
	 HqM8FSLzJsUynwHCVDI6XnP2p4uo3M3LZwdSGjPCkmZuItE03cirZbXSDPoQkdcH6
	 A18+mqGZ6Vvp5jXuXByzvv2k1Plb0tkxlTqNb2OTLN3yUuT7XBDLfws51vaTpZPmb
	 elTSXef/+06DDTD/qw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([129.206.222.166]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MOAmt-1uO4oP2IXZ-00I6FV; Fri, 09 May 2025 10:41:32 +0200
Date: Fri, 9 May 2025 10:41:29 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
Message-ID: <e82396ea-ca7a-4ccf-814c-2d674698a839@heusel.eu>
References: <20250507183824.682671926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u3uhr5mzdzw2ymni"
Content-Disposition: inline
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
X-Provags-ID: V03:K1:RLGs2bY4QbKII0bIzj9LCZhoPD5sEVfNozmAVbsDnVyTS0+t+eX
 oRvy41WJTiLPlWaBE5NmipmtHomEEVB2xy0kwThayvTLyGmEU8G0/N9R/JpxiMbZ8jFFjBa
 EObbg3Sdzp6bl/EWMoGo3DZVxuiVcNYTMsBMgE+femjBMCGQ02ZyyhoifCQOmLqH/82NMlF
 MyUrNfWzYJn45c1yj4q1Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:v5q+0R0EntA=;YWWUI9YMT7QWTk9Iz6eMWf4ViRM
 JSDCMyWQ20w3gJbQxzxDLd69kkC0xe7g0NsCWc87DSeoddPOSfQRf3AmwT+VLKd4maypH0Nl4
 niPHRPFcewWBD5+K5eibmU57Sb0hcF+VF7ez5ZJ+0vn/HWklWAsvQNSPSanNcxQEojvEzrzrj
 G9n5bnGLOAUbyuL0bI5Q1l9W91CzC+I6W/bH1Imjg7IBb+PgkU8+297KsphSryZf/xTUjwjiT
 L6f4KD4v6StzWV8p3IyqTTxUoHfqEsYdmS1oSyzOJGgblZKTWAGPwTMrdMPjYNLvRgICYMUYX
 pX5uOdtEVVsDfuLl/NB5n28yThoh7ybNS9hjVYymY3WiFPbM4UrA8Znb+7ZqmEZKldjbBroR+
 YLUo757WuQe8CGrBSAu0EILkVC/How7NfSw4tl00CPfIZ/ja6qSgi1HD6ZaBIZp7bJmfWmmxo
 VYVr8Bsw3i5Eq3nmdVuciRaZ12lpfzdw4zq+7NTNCglDT02yJsif9iP0yepaAunDBjngeD8E6
 xIXgqvJ0wJdrkTtZ5M8e4+YoerDyHC00M2PkVKEH0hRpX/ytNKi5cUtLZztOBt3zPhqXzKiJi
 pMKflUvNBbLhDBBH+dXTsRYWc9mT10rhqD+GctuTjq+kfSf84tz/S2qTgAhUjQBvoMYR/BsDN
 dAaCxHZLSTIV6hZaMNre+emXmYwb739H6xM0ZtuG2oANQ/pE5LSSAaqN48atxq4KclXKxpi1W
 yC57VzIQE7TUw5tr5hk6icu1UcHR4gnjA0QM7eW5aex9cQYBxrAejp75lftL75zg7keAEGScb
 lEFMevWC3q3WmKtN4DFUMFFKx2xlrZFCeZymhYmWexf9eERbxyIkAdoVN8FaWVAAEYeRI3lil
 NrroK3JtHKfP0rPAiW+A+XuH81sVDhPfCyLFqmvex2jT8gIWi2y1nTtUzxxYw69WRxaByv8EK
 Zk6Znw/005Kts6M6ynxh21rCKjpMW3oIMVj5r5QwhnfHNWbKgQc3FypSMLSStDqAqxSeJMGZp
 8QCG1rEcpoQXUSeTE4ZB9D1SCtNB+kspsMW4qvruQ/Bcf33N8vnQnd0lxJTAwgBgGP2fYkVlK
 r99IMx08rJsGsOdNWzhlu/c7+OReVpspKxJjLSQvwq+YcJk3v6KIvutTbB7UQ63pBn4MbIsC9
 wCu5s4j48uam97bdmrQWiNVBsNyyretUi7ZcMLxHGGpoc14HPVCl7Vp8vpM+OMFtDY6wMH/ET
 tDxjfV943lB21FKRrjyw72j4+PqfuWzwKI/twkOOnirdRwJ+5BZxxJMrFO1CDoxhIFCY9H56W
 aPk3p75/AUV7qId3mxgWol+kNMmLuesVwO6TCEYDamFTH3qFFZYKAhNcaYsmmPmrooJ1Eqq1d
 rcMs1ch7L8PEZvHJunPgj4fgDN3VIAdYcDyEPHsB+sVbvf4u0Xk38s6z1bBDWkLzhNutD2SkO
 BvvaQdQ==


--u3uhr5mzdzw2ymni
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
MIME-Version: 1.0

On 25/05/07 08:37PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--u3uhr5mzdzw2ymni
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgdv7kACgkQwEfU8yi1
JYWVNA/9GxCifOOnIUC22tB0WhuybgI+4sLGs/5alIJXygyPz0zwsQ9B+/aMfz6I
ga/inQOu039/mJHjiymqF9CZ/Ly1U9HZz8WXEFbwqJTFpU49DdOzOyEyHVxJxs+G
TgYwRy2dFSMpPS43SoY2TlICURgIJV2S7I2sQMYXgqSR8bQlxCf1zr0Qm/1u5v7k
1jox+xPGjD4rmOVFb8mrvLZSUojhdEjTicMbFcEW49amY0Kz1F/93k6Pf++zD9KU
sz4WD7HwDxcOX5SlcFstFXObuREp2B2/LLXBgwrl88d+usGgmk0WTrX9QFE9dGkW
2ITYdMz26yeE/NmpDTLtPt7p/awsEsJ+Li89wWZPOZrwb/k7s01hil34XpMqd5KX
4I2tTeWUTXgWKh6te4ImBtIs9SR26cbCzUCCTHph9tjSmQRdH5d9inxs756V4a6E
SRoutX/g+gL23UIHEav/PJsOXn6kqGEg2FNbS52vrmOIR/XoUwBNfAoecP9XAlNF
5QfgQs4vPUdUfevXIToSZ1MGeaZOPWfGc7RBxO0ttZQtvAz4QLQhOFiewlpcUtZl
S8juvuCbAgJAuzxkttY1Q69z5J4XsAFDKCVUhsLc2vsgmg8zg67rNgqKChn8Zjsf
gkuTLkHM0EcO15GtxK/tisCRA+3eHgxXw5SL8XJ2f5HFl5srVok=
=g2YJ
-----END PGP SIGNATURE-----

--u3uhr5mzdzw2ymni--
