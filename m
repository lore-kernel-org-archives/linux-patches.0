Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3F31DFE1
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752082490; cv=none; b=uJZCuojbIIy7TJV7RrS1iJj8ARdfKYhGJHstVfxzvjypQdQLnuB3gyozn7KoiMKoOdrRtTieZjR3HiqEXmZdOiPcrw2F2Js8s4RoxfWGydcpo3J5AjHMDrWHjvQdrd/NoV4k/K4+WdaTdbBWWvV28wXhWZ1cmCRNAuaZGE7r9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752082490; c=relaxed/simple;
	bh=X5qPewITFNQEpAwzhGsLHekYx+r+paofysPe4hNI+10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoyRMkBCXg9qvTY2wKQp+pxV5lLu3wVKoeyBciXaY18OFTchdIChlPWAiw8oK8KdFViTm1ZGd3PFJiKCWQY7PZ/SuUbnqisRYdRYMdvHoYXyzC1kodAel3J1vXqjH7TyqmSdpZjh4izB1XWkrcW1nbLtO/fEOzaiciPMhkupLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=sRGvDhXd; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="sRGvDhXd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1752082473; x=1752687273; i=christian@heusel.eu;
	bh=c0IEYQyWxD4AtFpY+qQMDcLFAoe1atswqtNGUdt4E2o=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sRGvDhXd7Mhu0Wq6LPC0RuOtLfbB3S3+tazdTVCO7zkR93DwAKnD7CnQ5AgD30G2
	 AuXIs7ZyObYI230HGtpdhegmpP9jiLebI6Qh5x3/2oWRgovHp2+LTenIvNfLyyffG
	 Jgz2ULSIU2Kv3A8awrtIZ9mdlaOdlHab0YijcjxWmAWaf0rSF949uyNi/bcsSjRlE
	 +f+j7XIQshPfFxxab9oa0wa9NLHilP0BNTwHyk4ouF1uvpwSDMNub+7+hD7RrWZAt
	 26ge+mRPq+KLmYfQdqv2WzSGcifHU1DZZpx9jLhcfD8TYo1/qKCDPJLm3qYNKSLV8
	 SX6EvXYh/hPcmCEbDQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.187.65.231]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MwPjf-1uqFxZ1Rkz-015qvq; Wed, 09 Jul 2025 19:19:40 +0200
Date: Wed, 9 Jul 2025 19:19:32 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, linux@frame.work
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
References: <20250708162236.549307806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tnngkyygq5ckjtkw"
Content-Disposition: inline
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
X-Provags-ID: V03:K1:f9RkAiyKxt0ACuJu7rJckYHMUflUzZLGuynR6Y2E/rj+gO/WWFS
 SIvigM78jbMo2NNw84kIz64MHs/X32xwLUlSQm9wqZLJ7Qf85YJrcpbzcpDg7uKkOsvnpSA
 /1LyOQ747uoUyfW9qF7Z/xk6QxsB6Pg3quTmrb0WPD0kg6tyf74ILA2Pjmv7e9lOB8RdnMX
 0hr85HNm+oGJ1LNdtrBnQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DKa8gBObjdo=;lCWWOhIvNV51t/sEijCnpJbS4e7
 nTHxop0Fpwap4ApSpMIq9HL6fkIBFfCmb2duJsgwcSZeaaooXGVTzazX3QF6azrtOVNniaw8/
 ZJ15Q+zM1Jysr+hssToZZMK9JIzsQ6Cc5OgDmWps5HBve0iRoE1Dc/fcGEXmUdkSxfMiItrPX
 kIPdOeRwYIS7OAtiGRUGp04c3s2V17jMD1JY8GTXxFebXczhyMY8MTqgP1STiU6IuUjkYf6ny
 cwAQdHU8OCmPUqCnWxSU9tLJrG+nMpH23ttZgC7YBQHV0TRjU82EBxb+2PYcjmKJaC/492C9+
 MiVthyJQqUdan3sbYSgJAAjWxQePlZ2BILifUmFRc2qRFRBXF8nr2MoKuPmFXe/OXFMiCoWVz
 boEkWzSXQdTK9WVHtz3AYkG1JItKlvy+TRCxuDdMJz+NZhR4CtncPnz0wYx7zFzR/+49EQiL+
 FjI5RjnivhONdPyaTcV7N5OiwGkS47AiLf/MIp0sYSKyzzX5Xc5LE0483/X4wqpvcS6gxBb3W
 U/EpLdYZykDEtIWmFj5k+n5dlefS7ukCRG8SWqgYcuHZClga+jjX02FhddcowZGtNbVuSGoRC
 Tm431tDMjTpzmAUSnoyHB2H6NtyTxzFpTsISrsLOqESWO1j2wDvKGUrySw5pxq8yivZKbkBdu
 BSn48k+vcNsflO/pa5XDO794lWTdkgO8GbpC0fD7h1ojw4RJzCB1kg3CInOjhtlkPvodcf/Cd
 wnbIHjIPDlhXi9nbarlUmu4GbWl9ZjfEoY1i1IZoZYx4XA7U0fcwrmdV4FoXVl2e1H960Vg+s
 14Eaxzhzp5vk1M+7JjqlZu0RUHdjAm/uz3USJ6pwpRi/7+S5vmLS3r9g3+SmnsBCyr2txCJyB
 KYG6oWRWgMi0pgnDN85Jixli+6lmf9y2EUiOdCYE6V+jSmMNg0OidBHcwfHMXcb5Mba4TNQsY
 WHxOPI2DC4Ml8jlspyF2dAPW9QG+dtdQNR2/F6labOV1vGXA9pxd7IO/JXgn/b49sXj23dV6s
 L+HUEi9sFdQmS2zM4C/KpcFpc8IBq9nCe8pVMMhccSfJaWrFAwh+645jRm4mxANFKcTWuYc3S
 Jjngh684mBJS+dhG0DYQbhrGOSXkRywS818YfvqF++kc5eCNb6Qi4kwauq+F5wqi5XWZGiID9
 Oeww0bH1UALeuvLbMYLu2e8kQ/l4bWVr97ZIe0ZZZUMtg+0xqAjhIZhXvh+rJtw2VqLHasc+4
 bTTYztOhs5sO2n/mTabgwqMe98g+ZHwzN1S/aEW2Da7nSE5+UUWgMlgwzAEHFLMFh46/v7WNt
 QtWNrGL70Jy7IMfY5r7+Fa2/YShXgKFkB3Y5admzLwwHGAb1HlGsiP2ia2mTNOIR1pIPWr1bX
 GLQ4/R+MKSiWTPhdyGeT4gD+GVoLGJoXcn9AE1MrRNCem26noL7WNI7gEDrJUUwGlWxwqq0kx
 mUejoxe1lfG5Lz5W1mAlHAESKLU+iVSFdRYALGnLUVB3zp564pVw7oYgr9ArttW9GFAyW9A0c
 dxp6eMWbO7HfV1jTXY31eak6kTqcwSfR+0hB+zQUcog+wq+D+W7jHj+8UQEtfQ==


--tnngkyygq5ckjtkw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
MIME-Version: 1.0

On 25/07/08 06:20PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.

Hey Greg,

on the Framework Desktop I'm getting a new regression / error message
within dmesg on 6.15.6-rc1 which was not present in previous versions of
the stable kernel series:

    $ journalctl -b-1 --dmesg | grep "PPM init"
    Jul 09 14:48:44 arch-external kernel: ucsi_acpi USBC000:00: error -ETIM=
EDOUT: PPM init failed

Maybe I can free some time to debug this tomorrow, otherwise the
Framework folks are in CC of this mail.

Cheers,
Chris

--tnngkyygq5ckjtkw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhupKQACgkQwEfU8yi1
JYWKORAAg9XLN+v3Zg64qslKfwTNySut0W1FDVCZlTOn7jBlCqDgUWcbqffcyGkz
W9y8tthHWtXDAQMVfs30+TWR9ONurrtjNLUxk7zbrEPx+S2p1QZXspRU/daXhLmx
Yp4REnPlIRrdTubAdJH4jC52ra9YnFxLsAQ0Vx0BSB7ZqhztH7Hi1NgIq8Yd8qJV
yp6R8a2bVRWxkAXoIScog2AcOuuJNyHmfCWOzZcdEWQG5LE691T1CKfHDsCgO2Rn
3eG9dGH8I/zLgle8JGM3hZxn153CIBNRXPvilCl3PlwuW7ONKdWzM4YGG6wqxYE9
PZWsAH7ERgHZqBFIOnBmiWEnTHfj6uNz77mGVsU6iXCHVKE7s3ewzTeFbMs9aRe9
yo5X5zU2mEmQpbkzQSZvRYRFki1I0XAs3qzUTOb9WrIyAbhfYHPFi+mW1CSgvxss
XxBfUbOt0OqJwoZWL0K5sBVbpFRAbN26mEu3ag/sV6BiIIvKYAMVLFB01le4y4xW
IW9SRIg8cIdGcDD2btREVe0PJM9WpGoh7KtHX8/vgHtzi5ljtJGlhz8uPyendLY1
CS+iVwt4Fu3rweXuugb07TVjePLpFE1sALsqA0W/ABYzvsf/FuvOoTcq3pFrH7a+
EO1mdo2kjDG2+j5nDFoO3hDM7CONaBjwehHC4ObtCUNqWcA1WEg=
=qFiL
-----END PGP SIGNATURE-----

--tnngkyygq5ckjtkw--
