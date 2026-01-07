Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031A37260D
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 01:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767748764; cv=none; b=RW/nRjbdD4MLHGarMESnhEW58Y5kiGt/tLN0h8kjOSd9tJH2TXmsaHgOL8FBVFNlx8eN0pvHzDfuXb4Nlk/5x1dKSaE40ogFp37jnt9+SgDwlAtA+54uRp8n21CzM2nrnFUHeOd/9CnCVi1qh7DN9Jzl75Fhs+aNIc6wmO/a2x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767748764; c=relaxed/simple;
	bh=DJ8x18+rVbeTdWZC5rb6mndc40okBcea9rPwS6mh9vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgvRqwuNsGLn6WXa1/jPOwMiyzQZ42n49lFb7Z2JYVqZT1lLFPzg28EUi8ymz4z2yXl9kx0sZMKyrINLgwWmzBng4j50juEYQjRx8DJCIFZQkrJXVouwGqFaTco+QsiDAuK4JxPzOL0CqfY7AWYcn61a4SLNW216i3k5+g+754I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=cxhmPx6q; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="cxhmPx6q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1767748749; x=1768353549; i=christian@heusel.eu;
	bh=f+eVlcAsT4+f3dANXhZgKxe5UluorPMUS8CUY3So/s8=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cxhmPx6qXN0A0g851OUTL8Wdb4GJ9VCws1eWjJ/qnC9wgtrYK3j/Gosejpi8uVMr
	 aw6gGc5HweTPJ5UgOQ6mxwMZEH1gAXNDTn/DLulz6fcFDJf0utmqwN2x7JiqXnelu
	 CcuCHzSRyHK8o8RXFK4XJwMPLx0v4bP66NQPDLW+iGnyS9+fdwhmvG6epy7GCyXlj
	 i7ATKJ+I0tlhgtCnvs5vu7GafLn+/fYaB1ARtP3pX56y5jekRqIWYZu26PvlrlhG1
	 Dj26gaNpalX+V/dxfXU7GeAeYIKaHCtJ5iEPLvj2Xg9yk9I9gVfO4EmUOz1gBAN6v
	 XJwfVXVMXPPaOeJqoA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.239]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MuUSa-1vvMex2xak-00riJa; Wed, 07 Jan 2026 01:51:53 +0100
Date: Wed, 7 Jan 2026 01:51:51 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
Message-ID: <f7ea70a5-a8ef-470a-a8c5-e8dd59b27da0@heusel.eu>
References: <20260106170547.832845344@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mu3qtd4ostqhaly4"
Content-Disposition: inline
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
X-Provags-ID: V03:K1:ndKig8m4M8Ew+C5qnt+FauN9bwinCMshLxsDvYLsvO/IFHowLwe
 SI2Izn1H24x2dJiHjxXxdHThlpgXFjjwzydehVScUrb1liM53qdMZ3nlqm4//oTO6+LmSNY
 zq6mPgSj2pvzQGwClKuQOu5lKuPyWCz6mSVtN5POUrkx33q8uQ66xutW7e4KA5eo+h9reG+
 l/Ypi96gTh+tulsuCPrQw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n9SfgEaJLR0=;1iaGVDeny1Onw2KjjNAkmSOkcpC
 hGQisOC+jeOr/aLK9/RX4uHXRk1+pGGlNIIc4DOIKr/zfO4JdvNG1qcq4SsvsJkHOas5sCMJs
 aBK5VaNHrbw/uD9jLpov6yw4aD6X4eBX1VPV6CiuRKELBh/tg9qJk5HueDXV7mnrylL/7Zcuw
 N+QQksuvUE/saKFkhhhTcJtk6L1xif/EJH15fujuJ/fhxHBchssVqgfKEoSqviYz/YTIhjYjb
 EdTQmaX329Jx7BZRInOG8dQfgpR+BfONHVG/9NPKiwyAqJeMT0APppLoDwq7vYm70oOWEZ5qd
 oORgLX4qjEwt1x0a31+i0dXeYfIm/Noae4uM6E+cx+MWri4x1AUJQSdA6GJvCLqWtgtAMbkmq
 cHCo21BXwgfI8gXzXUMt1YTIXRsgKJodrbdKU1AbOXbtss2zjmOB0Ic/C3GLXySakhr3lDbCQ
 XmlhTDJ76Fj2xNLOQwH/+n5uAGY1cUihsUqD9M7ZMjnVsv6TK2/7pcA/fmTHWyyEwey+amDET
 U8FMAuoOOuOU0FbRsyme9HC8ak1pgWF5h1wuBYAjg0MI58wvBP3EOiUCIcm464uTlFCTCRMiY
 +U9QbcWPyLUUoViQ83FwrsrcL/7wtsIz+cN/6vWORmxkFlIETD/K/+la4J5sgOJxlsJYU7c4C
 Fk7/sQIr6xhA5LupqnVrn4aH9W/5wBTocaWonBq39ugV1mQxMsvicnA+SlOhZp1e6PqEgnmsJ
 Ok79U7WraB+a+UnohAExUEKnVvCgBHTwqhe1z2jN89GXmjhCHSjTgOpWRX4RSd+rLw5WpUlfj
 K+2/unBm9n6djJPtLh+WaoRzrYM+brQ3rd/jepMNrqtcRuu7zIRwFnRUj5hZvUt35rWZDgeqJ
 g8zlx7Pm2P0+cLZr4dr2W0k3WpEaffXL6KwNUqmG+W3K61s+JYJVEnHHZeOg7ZB1o49vojv5F
 uf3cQkRSk5on6q8y2nu8lOXb+reu3p4offBDqIkF8AR18TSbpLTxHGBxMMTxjeEkMY6QeZviB
 LcuO5KwSA0Wc87VW1J3d/cz2l7Nyv4eXkxBoeCQagcOKzXb5BasyVY/w7RNwPL0Z9CIAE+fCl
 Ek32Lj6JU7cD/DrxALwu/G0jxOFS7JJZBS3YNty06iJF6+Cb82CH+su4nbiKFW+YUMolnAuqj
 UwVZ4ZZmN8pQXpWRm9YnenLskXqXp03lwyjgEiYf5b0hyqpns6Je3zsKG3mLP/WQh7T4ZFXlI
 Cqv/YpSErh1D6CwO7z5yUkGYWiU7IRmzYkraDcFKmAvMAFxACAqc6BMEjMYRZ0SIF+b0ArHAS
 k/idN7fNl+sG2PlySG9iXD62gzHYjTVLiJ4R69GGnYSrsWcT17o2hZd5Fg9zzPseYF28mKw9s
 CDNBYBtpDeTwpVXTTnr2z37yZrWqC4N0LAiCJDjVt4LnaNF3iDTwWsKiYanBGdURka8OYGkiy
 6spZmhKEcZTRVGaaDYi2VALyAfBd4y/LvHE+bQ3u73keBd6X+LugEqRHd1q5IvyjCEKXt8uwe
 ZIMQn43rckd6lprSg023RliwWJvKm+fsxXn1ykzmWs2TnRO16wu6Dw54vv3dyCguafh+CgY3+
 z0XtEKcCOktFLemkU6uta3m6E4G4IAnd2TKxpzIqDcmhxZnpsCnK7Pm5UXVYSQlqPVCALcAZy
 aJ70Q/8v6SgE9d/lr3kzbCoItnzFKgtwyj7txe0w9y1swDMntWDnMXtdHDJvFtooq16k4BjJB
 PNKamdKYWuF63


--mu3qtd4ostqhaly4
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
MIME-Version: 1.0

On 26/01/06 06:01PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.18.y
> and the diffstat can be found below.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a Framework 13 Laptop with a Ryzen AI 5 340
* a Framework Desktop with a Ryzen AI Max 395+

--mu3qtd4ostqhaly4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmldriYACgkQwEfU8yi1
JYWYBg//ZSEqxCRbL0/by2JJlcpRP7/szCImUpUyoH1IHOqgpnsd2lGtl3GwkAps
qR0Z1zdY60f7ImphE0ZfL1qAqXTL+/cBvFryG5nlNsjhtkG5BvUwd9y7w+Uc27Yk
dVPuW32r0fjR2nOBnrI53BTTOYigBQUF0c/eyqK7UyTr7h7fD1yIUto0D6TWkRmB
wXy3Un5v7t/EyuVJq9B9r/dycZTAHVEQXcDX1Nh4WCton/tcP7PMXVT7O7hsS6xV
+A2T8yqUDmM5IDsKJD7nkNi87lSp58iyBWdMEumnUIPsxLyPrUMr4shY0Or7s5Up
ZZlxehIvwVZF4o98YYMtuc57TUQK/P123wc2BQJoZuHKNO++eGzuPbvcCpek9EGx
wwIVGLzX3lDcwXrMF6ef43OtJfdWufhw/WELeojnr0TKQ7EIp8r7lKUrwt4Kl2nH
uiTbhke3uZHqYuYKQMv+wFp9YYPyWSjzhnvXEjKm0j76Fs8GBjaEpmZ79th0v7vg
vi+VwZV5gmbQXJE81ucX2LUUOwXgI0X9aC569CCFDm3bYArHJFVQVmrNPxz//c6U
qMTo+kz3my2Pea2ERsuE4Auy2cE0cB9Uv4QAp4IWwU4xvPF29oU3I7YeUa4PispO
4fAIynqMK54lf3RS6ZjDi2FxMYW9oTVSzA2kqrJDwO5c37ZUL2k=
=MbQe
-----END PGP SIGNATURE-----

--mu3qtd4ostqhaly4--
