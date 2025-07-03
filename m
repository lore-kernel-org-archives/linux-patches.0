Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4AA289E0E
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751567249; cv=none; b=CFkKrx7jr8IvwJOi/nxg+VQn/w/5MCH2jO2XMBIn5XzipMbVdsiq9xn5P+2zZIs2Ao0ubp0m+bUHOwXDhM0gpXr6XsHoTmGEOiIIiVD4EX3Pt4dTjHFSp8aoDUM83ESLF0ecLF7e7K8Sd7INCm2U7cU6+AyzSxW+qMg3qx1eL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751567249; c=relaxed/simple;
	bh=FhhOLMLtyQDceNm9+gbHyRjeGgsXtQe8Tb1/kHxH+LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgHmvBkOKIemUhdWLIH+sY9DrUCJKkIwq50+nmmMoJfz86/bDnrbH1zzyoZsqua/9LVGBrE/WNyx3Kz76KiEBpWz2s1x+inLHau2Hwqe29K1xuTznvmucFteSlT+SYqLl87PMs2DWkWprkZ5a+WhdjXQrCKpvmxtDF88D/h2tyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=b4+CImyE; arc=none smtp.client-ip=217.72.192.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="b4+CImyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1751567244; x=1752172044; i=christian@heusel.eu;
	bh=tAuKAaTCum0yPt6lcI2S74zA5JZ+pTUwTYUWze5Xx34=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=b4+CImyEKULrnSBUuBUjkJuB3CQztvDaRCCpPYIUZBxUB+EczUIw4q+nWe9OIHxX
	 Bk4W8T59hCriNuXuQEw8rxBDgMgUpsMc1khiLoVkKgtxxhwufZYbpCYbvdTyX7246
	 6Fie25Kao2KaUTrL3mVOJ4twab2KHD4bHRWJMOd+G2o+3STMxguqoSC0H8jCsVysE
	 prkKZjkSYENHdN3wZL0DDQErbr+aRbZRnqS4itpLqB1OB2JxMk6nSWT9Z0Srsq3my
	 n12BaaYYKLy6lav0LrFZgS9TsSRVXeFFxf/q3sQRPhCaQVdQhFWXrjhDpVJ8eYOfI
	 6MX/kXJfGMfi0WKzDg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.187.65.235]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MQeI4-1uIUrx0EXW-00Rj1v; Thu, 03 Jul 2025 20:21:03 +0200
Date: Thu, 3 Jul 2025 20:20:59 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
Message-ID: <b7cd70ce-271b-49a6-8992-ed16d9e38cb0@heusel.eu>
References: <20250703144004.276210867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qx6x64jksvhmxpwo"
Content-Disposition: inline
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
X-Provags-ID: V03:K1:4l3TB7DG62TWGuyCSamBdfl++LdHBPweGeqBkL2k818sVsQfwNn
 cEfgPZU5MIGlVJwu+VWEz/UPV78DU7fRRD2StExrY0Y8LJJrN7NVbXUNEniStQtSuuMigS0
 nUe/GDZVFRE/IDv3yGJAeDjiJYutz1RGM7cHcvMW+NHxqb0yofua3EYuwVwNbQ9CvuRVBLv
 V2HKoSCOgPeyE15spp5tg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+J+7j4gVzVs=;HYGYcm/cy763xKNQZLqMQBWNk7h
 cF5uq03mBuopsIkWBvL+AhucoqNZWTAu5ghPNqwkRIDn+tcWGwgpNXKqkPBr8sod/vSkTlFtA
 +B6xzuV6leoDFqwv8fwQ7hD7uxArMY6g5axD4ppeF2SPt0EzGmjMK1CV+pK0fK2E8aUfsdkOW
 pJ5AzZxQvC62ds5TgbVrCL1rr0TY2yUY8EdFfecgm06xqOdhHcgtnKPnuaGk3WsJWzXgcKU3h
 M8Ibzow45ERudDDli2ngp5OrPQ1MQd08LqS6pJFsaMAqlZA1wpA4uXOTrpkLh3HMuQeqOOkof
 3CKsPm6ChTDsfb1Kq+RSFuNVVPTkluW/DuE1ld+0HWCbQDoX7OsNl2vXbKYrnSz1X434wqF5K
 hCFbJY37b+3HleMSgWDjodc0FaBalQwVMUx62e0zVB20CXwI4vI0qo+21TaD7lA/hFqV0jjMm
 7oGsAgzQ0iBgR+f04Kbn02C40/AF9jlnN7vDHx5QY0i79/wOAJYB1mxWWAWA2IPbBbZLwPlvW
 TB0tCOsfMZRNHdxU6stE6qeXo7glLn1gc2pjRu55g4mPeeFod41He8liOIc76LdgiJ+LvTOO2
 biZEuFIp2QiFGk90N2Pk18vMd8Q0uiIErps1jeGyF4wClm8oAe7USljTrdWbNRAR1ogJ1Ey4p
 A1fAowAQU4F4RAGpzyw46wKTkFXmRCFey+7CISasoQjjgcr0KYBuohW42/G8vkcw4WwSX8XCu
 vfzUU+K1ft7WLszexOf872jknxnxxdmobM34ARfIYPktFptjlfF7LWNwyMdYyscohH9i02i3t
 UdEDgbDXzvuSGcjVBya3GOQEX3hDWh/zcOVABrH0lLd2UUbN/aQFbBM6H7RjpdD3cBq6l1HcJ
 eb/AQcYS8PNeC1TRDrpBBu5890AYzd4WiAj9ItEy+Cx4/MNyXIISvtfwYLcBo+nUL7w/zzswB
 lhlKqVaAz8B8VI0pZ7vB+JpnI4HTRbhBndRyxJ3oLK1FaaGIr3iZMr1VL9Oo6yodpZKoOQfB3
 4fJtsm3fgpoCdgb6QSIYRYGfTZl/nY/uQPNzf2zGTRvJeoRGVSx5Q9e8xQgBC6jP/3sXVQBN6
 7jsz2bJZKKMZfHqVQF2j3W4FIKm/KC1uf54do2zWziFW0F7giFyVQe02Lp49w9ztWxZJ24cWN
 zug/gLVx3RMXlN15C6dbfZ+Il0iUmVStYQlHvjfwJYHk6IIrX/MDD1ARBRYLqnzd5PJ4T1WnG
 +ktOOJaNiMrt0t1pav1zFcXPTyVHNOnQMvOZdMBFOjZRw0pGgEDUb5hL8KDKI12hvQnHBMXi1
 ROo6hd5GYMMpybrWUO6c8D8EgexYSi8gB8PiyPgyqnPkO41bqr5h2/r5BKz36Uit/FJSk7akH
 FlHs1sqU1Cv56L+IN8lHIjLBzhXl2c/nQ92RCZEQhW6SQvaJT12TcZhe5lycwUHvnI9paptoY
 EasiNNnNr8PoxgvJBa/FcgLvY8wHDa+49Pc5994IUOxxggLW1e0zE5xuNkVPNvIGsNM2qsK3r
 Q6NYgv2eCzo//2wA/z2Np2/i5Ph1g4wkS53BgggTpG7GLgyb9SB/1Vulih5ykbOKS0S4nRsYu
 GPhPEyrqUk=


--qx6x64jksvhmxpwo
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
MIME-Version: 1.0

On 25/07/03 04:38PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on a
Framework Desktop.

--qx6x64jksvhmxpwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhmygsACgkQwEfU8yi1
JYXb2w/+MciSSyewEhofOHBkHLxwY0PzWs2/dYmJo0oNKVxhoLRTsYzH5g+v8qH5
9yeXohqEiFuLGJpYC3AfwPE5kgByCr6hQo1jVJio5JB2eRtlNlaCu4TQqe3kaAsb
VkeCU5nwJbRowK8E/fAnnDlGd5KzJaoTxR4KZ3KDFh5mCd+QG0m0dR4Jo4LNU2TR
HCH6EIdxnf+f7DrSPdcPPSpqF9fr5n0CNFL4+xTcx7tXWmOKFl8qZnbUB5y+s5pP
K18Fwug1CIc17YTv5seCC0LmxI2Irl1bR/VE6i5zQVUJtGUPskEkzf6lEQJ6XKBx
JZExlyQVH9HFppWntIMjbq+F0r11omEp9D90q69Euunq2OCz1dhpVrwDeKg+csYm
cwjWccHXsyhPVF94+kSnWlMzwiAQw68+eu1UYZTJReDeIh47trXbgoQ6cBCf26GH
+Xf06FC/v+KZqcVVHcoPI9A8Tf/fubxpbLczDn+vqUGAGkIkSDLhUOgqAe15HpjS
zsLZChVS8uxZAk2a6MqPfSqtOSk6S08lqOJ7zQksWf86IAiF492FmgGsFBvkrJV0
ljkRi91Ez1mVLpoEBhnA7vI5bJuEiDdB3hYSi9HZ4pelc8ulU2jIiy8jn1HCKx1z
ITgFBGNTD+M7mLFXJ7roaIBBgjKhkY8GrKT4bxGdct4G4xM6YUg=
=1lYc
-----END PGP SIGNATURE-----

--qx6x64jksvhmxpwo--
