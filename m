Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5251D20514E;
	Tue, 29 Oct 2024 11:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730201851; cv=none; b=L3+52HnCCpAbxMxhGiCEnIyu7gZF3HqFgwmKXfZ8EtZ4BSaZfTk6GTFDJazxkSuNiSRfqZah4eUcovo6VStQ7uMuQxThPHiKIVc6vwL9rcCDXbQ8HSs14BeoSGy7V+r5LbU5oX76+T3v1FlSdgU8oqa+YZE1S/M4ED/QQtqVeLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730201851; c=relaxed/simple;
	bh=o2E1FQYdtO20CbBV3qYSi9WtW0hUwUhugtlkNPHSqD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGFa5WfA7M1lvDMpjUmfiQllWhseMFhhfAsIdjcuF/wFQtGwPbisbAnpJh1b0j5qKq06pI3+RwzVQHi1Wr8gYbm7vvuRsxoiG8OmPfr88OrQg7ewPb58XvcnFyt2WR4SZ1njB6FXVsydMJbEvaWy2e7ht/XbUSM9wx3UKwYsGnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=a3uzFKdp; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="a3uzFKdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1730201801; x=1730806601; i=christian@heusel.eu;
	bh=uPx/693D1KOpsC75//Rzve20O6pDdXOCslY44UXj3UY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=a3uzFKdpOOt14foID4PhT1BsUt5A0v8QljsNVCUuy1AG/+rBtwZM3Vqfsf8P8D8B
	 /oHKm0lPhAyB7QH6smn8ACK0XEZ7+kVknYY1FMkXHo2AiUFKOZoSnlT2YlAkav5BW
	 xfbQKaRGSsOs9basaTQkICnL5pXZ2lqsRro4W/LDKnp2XZKKpM774nP3AZqYbzTEV
	 r8FETuy/+O2oLrC8FUFCSMOTiWyxH6SDwjgOiU+H4XDgNnBkCP07iNr14Z7JtgcZN
	 n+MG21EvdV8HoXDs8Ik83RlydH7Zs2DXRxbh4OvCX3/ybhWTPiQKSTdZ5jGSs87c4
	 0rzlsLa1rJJKI2J4VQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue009
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MfYHQ-1tlPw91vJY-00jaHv; Tue, 29
 Oct 2024 12:36:41 +0100
Date: Tue, 29 Oct 2024 12:36:39 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Message-ID: <dc2297a1-aa4e-410c-b4a8-ded53a4a96a1@heusel.eu>
References: <20241028062312.001273460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="25aaetkewxcot6dh"
Content-Disposition: inline
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
X-Provags-ID: V03:K1:WIuvLVObM+VfqWn6SLKPhk5tdVFYSxFfqVmKE3oroCCtr5V3KKh
 RBBt5nPhCgyoXyaWF56Zh3v+KHwP4IV7bNMCGJTky/XCVzUb4BAYNij6bOlrxOuoS5nt2cB
 u5HNxu1kQpHkFPFDx2ZXff+xIt/DtvnRVfQoquYzUqmjJW+/mlV5YTogimmNVtBq0kOiV7m
 A6at6VnFVliIsRYIxHGeg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:63jAJymAGVo=;2PI09+GH+HHCSVCrYKZBEPwt33F
 oAHeoHmQK7dN4VZj2n/Lx9oPVyiXwk/oKv3PQVSKqdRabohlXS9tUx+MIrIE9RfgTiceVqI8I
 zoqh/DrTK35IgnSpCR/LCs0Zl1ui09Qy8h7HGT7ucJvvxhxXGPvvGAEOOMi7wqdpRNLkwSwwn
 w5n6QyJrhpOtq9SwkSRBwlqHWlYVXjuzixsujAYkUFZ0q+XaEn6/biS+6sQS2WShgA5LD9e1D
 fDTLzHRM1D725Qn4Uf238rIstYWj5FyuCz2++O3hlauckD8Ie69d5Wf/cz/2aeWO+ffklC0Me
 2P0nnI5wwK+q/3Rv3z10riEhD9zmhGVOYi9rHetHScusVje833lduudZLSEhmCIDOPnOnywbI
 RQUkXiOEbsZu1FQ07YZffbjNQFihWpbYE4u+7TndaaHcBQF99Hb16RWaXZSYyHPRE1sUPTvjg
 OJOH8IK9MrgaUCRQ05DV9ty/bBr0DfW6ETjR6mojuSLsNIF8j7oLOWqDe9RLYQDGkuM1RRwD+
 cZm+EEYxyh4Tlcon5ItsQga+67nWqksWNTg5IZ+LhIWD0NSQHe/X/IiMfrolokq4wXA8Nsfp+
 nd1rmM/BdBpHXdU9R+VR7uh1w1ON2Lo0bZGjBKp4epp4FQDKBa7TovZflKDX4eDm2C0yKHsLD
 Nfas25zj0enoJ2x0hs5ulduXOHfHFw+Ei3J5EaRb0IaiZ/TiuMqeupF8lTihi8+rKuwXyyysv
 6OAH6Fg8H9mKwvbDf5V75cJnAKtcxY5zg==


--25aaetkewxcot6dh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
MIME-Version: 1.0

On 24/10/28 07:22AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
>

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant).=20

--25aaetkewxcot6dh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmcgyMcACgkQwEfU8yi1
JYUrxw//aTJQRwtT6aLo2u3LUsuB4oC24QnzP0j6S8npCogqDQPFrTFLvBTdf1Sj
Kg+BDVwShNg5Nc3pNG4VABEsVmrOWGhyZ9OaCZfPI+XXwuTJu/HWMCE1ja/3flo1
maIEY9QBVRyjmvJH5jgD3h+q4VIYLUJ0h8oJDgrAudxOMPsQFOxpZqmgaGtUnOQM
b+ngYsV0fifzyiL3BwpHAt+EDtE+qLx8KQaKI0os8S1bbSBESGFvK624rlmZLVzS
TQsSGu+eOBqhGPgv8DwZ7AlIegw8MkTkToKTDW/MUVJ3m9dx+KOWUScN3qvZgFB7
ycTl+hS174+9XrJRaS0pXBAe5kry8c2xrnzjQ1p6xoWnICTC+x0IGy9lhXi7nO16
GYSfvhE5103WcMkXiLlvIPo1pUcKLv2JuKd/RLe+/LjzSeqDeK0BSSQwWDK6vJ4s
QlmLtqpNNID+GaZNcs819yzxqpW2hOdqTQirLvX8LUJAUJeZqSGaJ/y0Om1RAvyh
C7mUGzqzT1lTfezFk/Ug1Wct2tx9IAYwPaKbit644ACElqDVMA0dyOl+7Y4BFCEY
7kBFv2yyRM3rCdzpNJskWmbuXDD+YK1hXSpbfPBBMNbm9vYNzweqO4+90KrGmUFm
m/WpbaL2Fxy03m9JWwZ1gqZpIV6ZI/Vu0OqFo5U+MMYk71WdcEs=
=41HY
-----END PGP SIGNATURE-----

--25aaetkewxcot6dh--
