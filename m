Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A281748A;
	Fri, 26 Jul 2024 21:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722029285; cv=none; b=BTuRYOqs+2fDu8tD2w9M3CpzfsJSgzf4VwM9NCA4SsG0acgEL4uADdb9hMfVsgERy+C0Q7teKFXnvfNNM/+2bDGKOOaU0OuEdfvlnX0hOUSBVGis4n3HSjItfM0mJXer5L1EGc+36Gjp3WG5SoE0Uc6H0KlXjR9C6Qjwq8IItYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722029285; c=relaxed/simple;
	bh=OrrdlTnH3WEKPN3TEJlkVeUCJlHW+7VcMK+CyiOaVko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/D1WeeA0ECVNuMxgTOuichHP/pTXf0nZjQDjvwi3z8NvUNf61UBirNOw2uEEAqnDN8h/zanqAvsrcnnAP86wpfkmWQp6twly/y9M1eHCtIInqrnZHcjdng8O3SiFASUOQjztuykdpM9+z7Mj0cpEhkZxYtqYmrpNEVmCRG1bEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=NS/ixlHx; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="NS/ixlHx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1722029243; x=1722634043; i=christian@heusel.eu;
	bh=7cb9FKqiTnmAm4LGtD713mXbbQFUzBHgztfenIYWcFs=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=NS/ixlHxQgNlPBNJpdaCictNQj535JyqyZxV6PfqKrH1mfRDCFYuSKZM2yVgNKS9
	 D28ag89tIeUkviAkdavPscpp5EFzG4n+wMQTP9WhSGihfhgN+AXqD4NCyEVKBTBoY
	 9U3Gu86GOaxkRwdtqD2v4MFai0syNRcCAwfWQiaVFj3BVugdgP4IaxChfGVnGpNo6
	 ua3p/vQRh5yIU7D83EwUdwMJT4yArzmAmD/7Z7ewWP/igTJlLwAcc44MEkA1CNyBf
	 iL9ztpc9t5YxbQGSRG7ZvoiWCMr1FjPFn0FCbJBinCbcBhpuZL6gISboYsVwTbMgE
	 9PhxBRBm8pjrlkfXJg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue106
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1M4rHF-1sXBM41NuZ-0030Ij; Fri, 26
 Jul 2024 23:27:23 +0200
Date: Fri, 26 Jul 2024 23:27:21 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Message-ID: <ff7f0e41-537c-4e06-8fba-5a027067a6a8@heusel.eu>
References: <20240725142731.814288796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d6guo2gbfiwflmbb"
Content-Disposition: inline
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
X-Provags-ID: V03:K1:u+DcOdoBn801YoG1swHt3jWoqlewT2v3Rp51C4Gn3TFSbo7y8YA
 RiwlhTjFS/NgIvioR0ijVxc8aF647WDV0i97P0d1lCOlw0BRJ+YlHJQfegMYc1xLQrCUI4i
 QWV0V2RSZBd5rp6r1aJgg1CHGYieQIuKOmFH2fixtbhqLjij8GP1tGNC101k0Ut+fcjq1CG
 +TK0XBf/4red6q1zQtmWQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2qsYY1e11Dc=;fgYB+yoosq6hmmwAi9PXEZDvWfL
 UK6BgD8Fo6iA6T8sEt42ltv26qu0aKZs2s6qJ/r71xl7MxyY3WWHnU4oAfs8el0p/fhic4eTm
 K6/vEwPcUzP18oydD+a/Y5SSV2AQBsAoAX6DLiwQcfBn+UbgiZi+PLATo2ZwVfGqVdtMiR/R6
 5Q3sSBtzjGwT91DaHQOa4N0TWvuSi2iabgTDP9EIfKMnUUZNArkXtUSjFW8qplIgkuRJlHHAi
 VZ0GdlfPzpvVz1kKO2FSeKE7onhar3B4ygMFSqZOPg2oGlAFPWqDUbxYcd4qRL2IDhb9lH6T2
 zomfxSTXGo7yQUdF3xS49BkrlXi/B5T+NL/NiY1Dv9agbtnohOcXDLUjIYyGo+CIDdm5qD2bz
 hcn0YdF6kzlr3EX7DG/TJzZ2J3eodztXGJqQOgOrlFw9sbw6+z8XuLi0FJTxvP1gM/j36XNtd
 FXiryxz4BceyF8TtFmTNG4oTFPFVSxzNUwO9kXRxLY9K5e85YhthH54N7hDJgWcIm3hnXEo7L
 8FjAco4hCbAbMPilgnggn3t22QbSRxK58O8elOyJkTAd73Lu2uwyHdV8wHPrKUI0mlo8ZsXm4
 mpPdKndz8MwnJWKKEqs153BmT/wAMwLsGZuMImY7Jw8rHud/ou8kPCwgX89IgIVOCLhRZVD2J
 6mzSvTpNroFFLknzQzi4sojeX0u82D6Kvzk9k7/i3Anvq6vZGpavWwdIN5qniOulTOmbPm9dX
 glBnZgMzIUkjbtCgrKgwpLO/0cgU8Nfqw==


--d6guo2gbfiwflmbb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/07/25 04:36PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--d6guo2gbfiwflmbb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmakFLgACgkQwEfU8yi1
JYVL4Q//c3u7IM+ekLkSdT+bjoqcNA4/nqR390psXhySqWaO2Qmyebwqf2QuO8UN
DE2qEVWHmQIBpgUM7lQah8lr41nfioMdMC1J3M9mILRahkVmvvY3URqamGEgvNmy
SqKeErbxZ8b5HaohINtfaipCEWkHOyamFF2wITbRzRKqpfTIrwnBBedCtiTmsYZN
R/NhNVY4Qy4L9Ith2AMjGTEPTfNqExnwzlAHDXHtGwitkFOFqtJRPAakOCRwJY6e
l8kotjvpMRdTj6KouV3MyI/au5srpw6Dp4jbxOdDpkqyuvQXJZsSBzVShJwIWEQn
PBcMeazXeVaGNK+CankKTLUfLr53AoqfeHobn30q4woP+sh9i/RLR0NUkKOsm+gk
C64XTJqq+15Pp6kLW3h9yIxe1Yd6HQdTb8azOar/HDbfpM2JM61R15DZSOtbgQVv
YKOzei1uvuN0bgI/uPvbm/yIhmueIRmCvpd614mPngiRhy72AF9KPpf38t/upRfm
vv/AzxGVdei4ovd3UtH7q7ZtVN6TVmGnFHIoxwB9JdTAT/w/OUjpOHoJq/J2BdSS
JdcF3RNCV6YjwTQC6RHzGQCXyR9N3MVduDcCNyPJozOUE0SCL/U1wwmc2dhzqmqr
+FHkfgEX72OG5s7o9R4YZfXFX7hXbzLzi+GkXcWTeGtYjZQfySQ=
=7Q49
-----END PGP SIGNATURE-----

--d6guo2gbfiwflmbb--
