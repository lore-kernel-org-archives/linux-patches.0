Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7E192B88;
	Wed,  9 Oct 2024 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480295; cv=none; b=Pdr/p9FasOFS7fq/fUie2QBdbwptBNPfPzVpM5GqwosF06DDkQrisEifbsa3C6RlkBOCBYnKcDkdJ21YfxxFQ7JGS7BJK1k4J25IbpoCXL1zDgiAH0HcspmZWJZI9/MiMIc/J4kh0DxHNyEpSNqg6Chj79hX6iqwuW/PKE5MVyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480295; c=relaxed/simple;
	bh=6E4gYaI3fvbMb8LnspnqP1eYmSVkBwm+Y4slNbIj+cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3OeclR6hH234rs8BVpzoUI+EH1uqXW6n3AL6SEejtUo+7JgXsLETEBrd4KspFoRHXi5pYkGYNsDPCDoP5/qIgcaZjxKa6F6gDwXoxRsEbCBG6Rw3v92eDdgKd2g5B+AGR2gPECERwQfwJh4lsab2PDb0LIQuNbEZiNPcRd4BUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=QkAdLmHL; arc=none smtp.client-ip=217.72.192.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="QkAdLmHL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1728480204; x=1729085004; i=christian@heusel.eu;
	bh=jLiRZdys0EnmRMY7S75snsrzjvMyGZ9anDGQtcOnnnU=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QkAdLmHLB1pREg25JezE2sCyXr7CvAnYk/MW2fM6GIGhlUD05INEqwRUcuzcdyO5
	 JowzNCpDnNC0OsTxrbek4MnVHp+vY+GBNoTn9DKikxOdigR1gdZzsFl+JYAtpP9hl
	 Q0r+YQl0xUhDvNDkzb7KBC5DZ89VSY+fupZhRgsX2VtG8Xzb4xiMREXLJ4wCrQB0X
	 DlQZQvtqtv3v2nNxdXw+ZihgG7JEtTt5TQ08BkDpYp8vp8CKTq9T5p6h6BEs4j4Bv
	 T6U+Hboo55rmPkyYL+RaTWotVf3blb42CLJlD/Cda7Sqp1VrvCchA7wIZPaAupERG
	 HlN6ZhOEY67o2v22CA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue107
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1MOzjW-1tLish2w6G-00Lplm; Wed, 09
 Oct 2024 15:23:23 +0200
Date: Wed, 9 Oct 2024 15:23:20 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
Message-ID: <01ac335a-4b4d-480f-a54a-4e246a68ed51@heusel.eu>
References: <20241008115702.214071228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="66yilxzghi4uofwm"
Content-Disposition: inline
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
X-Provags-ID: V03:K1:VKVLQ2cJDEz6KYyWs7DZxK2zRU5Ly0hmRIf5Vcmx+4ZroX1i2n1
 nuGPiW7BnJfRJSygnou9SuMX2YEebw0LIrXK/UEIMDxGmbhHS9UBlxBINPPU2+V77sHvF2X
 ilBfRn9KSUj4awQMxXKGMCUxXKVHQDPeHxj60A1wstOKXLF4xEa1rGXgaocEjQRSADQdxYg
 Z0i0CdVqkAwn+iHWj8dYQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qXZi3j77yFU=;IbARazX7IgK8N0j2eRCLWzr221p
 QHICrAoHff9QO2nFUJFXb+keA+d65FtEdTNtPg19/uuENAhZeBnQZfR7ZirZpPyqh5dZN02Kh
 9H1ya8eMn/WRJ2CveVFqivyd8gVt9iV9Nd9m9OxSlpjMLVAbliaqWlDfl1C0xn/vC4yfrssy2
 hGBIQ+j1BSaYvj898stQgFTzLRz8IEjH0bNWye5IfnebVqdpkmr6s8zh2QcTIj9wzs6pWRmSq
 0ojJUYr4Esv0F8IGh2lP+SXyh/Yjl/m6UnqTgeo7bL8xqWfFdN4Gp98DY0kz2UpTCyBp3JE6p
 dNVWJnIoV820JEz+N83pkpLuVwEo0NgBIJztiUN8qbSsXLRfRaEzKWqiPVJcDSCPw8XkvZHB5
 Q7vfSkh03xye6SHMbptHcH5PGtXFYlGcMDqE8RNaJt1AGMepzrycQBF3F8Qo9U7nsl1ZaIN7v
 8C7Blyiapq/1CydxkQvOHqLpc60SkYM72kYcNvSu5b2cv2HTAWM92qfDM1ibXER2ysCIi0PE6
 kkt11HPiFS07o9D2nmxUDNzBN5hNqQ62Pzoy5JtNzjLOI1RCBMIgRDM/DlLyKqxCx6JFiI0Jn
 zfFUKdfBiW+MlxGGmdOcJl7npol10r2fGUZARq5Ty7BtL/37UBQtp9pQz60w31NCYy5TpgUrz
 wT1P7EWYyGrUM1631ZntSTu9rgzVKSeCVL0tQHz3U4Va6QIDHNXRcIHEwZAA7RW1BcPISRv20
 1YMklFQUG3KPjZfnaDKeBU3hJnBZJdPNw==


--66yilxzghi4uofwm
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
MIME-Version: 1.0

On 24/10/08 02:00PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please let me know.
>=20
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant).

--66yilxzghi4uofwm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmcGg8gACgkQwEfU8yi1
JYWjag//eaK7+cnLN0Cmr+UPO33O/zH/ABP6QsKtfs2nJErpN46OfpcrZE7aN054
BwXDFL+hnLxcprGL/3tA/eiKX6EAh9wLdpPs6xH8mfa5lCbbkPXOOHL+sQxBPPr9
OHyQ/1qixRuJPUsJpyreWl8eZsMwAuV8piK9u5FowJ87O+pOCwEYSb39vtJ/+OCL
D9a3plkAyuRaYmCKjq49AchURMUq7cmBCUi/DziIUtBcNVOScrbsbgYnWdmha0se
DjAY6emwU7nnwl+xQlt621QfD5sxIc2Zc4znsajh9KGTJB6pNxDN8+i/5VQ0z03R
bPQFKf3j78yPQ3RITpzO5d1USaSsb1JK0FfFJyC8erJs0/M+Km6J5Dx4fo+H6YaB
Qh+lvLE7WWutRJjqSgoZz+K67xjrnxnKFcW8cp/EjQ3OllBzBLuJxAq6ycIOnr6D
v/bwrvppI/4D2Lok7lcaLBD6ZNxiBtfFhlkeF7Su38510Nxa0+7T46MA6jNDevkb
tyqsNZCKtrzdHxGCAgTY+Iiff3TxNanHs1Y0wAw0q/pIBF2sJaV5Duki3kue11zQ
cCWn2CqalZZR4bcR0YDR/mf3v3uoZf6QWSQVFxGcVR8FCpPrtM5eggH6Q/CB2TKd
aOS+sWhBv9wr4ZV95iEyaGhm8kb01B2uyHPfzv11E/hVl0oeMog=
=6wI0
-----END PGP SIGNATURE-----

--66yilxzghi4uofwm--
