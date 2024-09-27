Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DBC1C2423;
	Fri, 27 Sep 2024 19:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727465952; cv=none; b=ZA1xTCR+WatvDgSBq352jKam8BnadVUKXxUZZ7hIJUEzild5SvQdEIYA2TZZmmbiF1K7CLyCE2hUew0NEZCMqOkf64YLIoL6SELI/Oey333+Qv5IQN4nk/QOIiC8jnsAUi1ux7vcbmxohfMcG/izxENCzDG0C/+w0RYStE6PLJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727465952; c=relaxed/simple;
	bh=iUSQyWPip64LW4hjHTaNO6R7uDw7eSK82FXjxG0FfgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btGUPrEIZIfGQ5ANcmUfgly05Fk2zKw558ky8/Val99mcP4hgQhU6G6NZmMu2H05XbdsgQiuZIFja+KmBpYS8+NLzCxsNvB7hnGjil6SzWbTZCA2lcEZA0dKB9rVlF5egm4Ui5csUUwdk65nfj2zlrnES4obXrFOeo86S5JinYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=G4VU6Ga4; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="G4VU6Ga4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1727465911; x=1728070711; i=christian@heusel.eu;
	bh=+wh2G1IM/WEtRDztfZ9dTlq0+df1g02cP+TmIcxrxPE=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=G4VU6Ga479ojLMSETJ8sa0mv2MgbzRL4RAtvJxxoT9lYaJcu1zB7f4tObaHRRLlY
	 E5jra5ah620TaEHoqRkDDGkYDSsZhTNEs9E7zCQiY7GU90UxzcXrBsM7STo7Tp5c4
	 paSYQgldz0MIs7H+fAfK/QjbC9c/EBgmVBKXJLzsOTI5rk49A2nKlwBkFELbX4kLV
	 mUb3UQcc+KZEKIIeFLV/pakoN0p6DQdfKNZ1BnaYjLz9clqocmCqIH/qqJyzma+tN
	 /GFoR0zPAJLZMoEMTCFHTMB0OEcmWHf3FDylcKUTqFznbR2UbYSxcYc7zd7crjv7l
	 0JHREDitz2XcdpUPtw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([84.170.92.4]) by mrelayeu.kundenserver.de (mreue012
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MMp08-1sbe0x1YFY-00PuUd; Fri, 27
 Sep 2024 21:38:31 +0200
Date: Fri, 27 Sep 2024 21:38:26 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
Message-ID: <b101d82f-1027-47ae-9b71-66c1f1920067@heusel.eu>
References: <20240927121715.213013166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pgsqqoxlr7zx6fjw"
Content-Disposition: inline
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
X-Provags-ID: V03:K1:l0F8h0d0SJ5LVOT6LDnI4hGMzyA10u0yz4FXeuKDLrSrG6Elz3z
 7/XM1tjf6LKE/wt94rmcA1X/uvOEA+u0Cgpy2pqVkAn1vs+zDcgH6YzN4srfBK1Jb2Ys5Ko
 SY83DrPXLJJF0K4G1cBOY4XGgUUKgPtc7NGJYjBRSbXwZjesUe6pOyceMSDHuLGM4tkjqWj
 5qdZM3I+ZO6YxvDPw9vqA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:juHWYLMKzWo=;5BLDvMDrHg1c2UxuXck9Rf+2zr7
 a1g36AdQNH3iYud1WiEJLMJJLEpvbKimNkHSRvdeAwGY2r/XaKuY8roxUm8xthZJNwE8SD4qM
 z322S4jWotKiqde+6RulMCqpIW1MQZdlBXYleNMd6HgBoL+e+RNRawlW95FnU79DwgfATSNiA
 KjU66Bwh6tGdwN7cAeI3ixRsu6ZbBnuuODTVATjfi3JayIn2vvVSFPTOODLofFdvg1iGkwJGQ
 VmEaoxvaCJQa4yTc4TNJ9ztX/m+apCqG01RgYoQmN8mfi7L4mFdgkqJAdFtjyauuhQzMrrYSW
 aIaBpw0AkXRiBpJSr2/YDzbX7Eqvn/OEtoCgEjQ1KIw9tE3mRoKNbjMx1jLow4fxThfnRJVGz
 oFS1srwcFf5DAM5benxOm+8apSP3QXZghGf35GROuMtxMNaE2lKTZHl1M4t/DLI3kbV3OTahD
 WdriY+kk6C1hQLP72HXTD22b7cnKyQLrSBmAXeg+i8HNiubPin3+zXRAmj/IpF77Z6iMXdlqK
 uV6zy8G2nsyj3pso47b1XTBu+bSYv27JAsCQn7/JCstyUZhHnJSAaGRisdeeqPt7hg28fhfP8
 ig4hoiYKRs0ZqvjvUioepInYTHCJ70cd9yUeqpfwxDFat1CMaBXqosSJ4uZyGnikopJ48ds81
 Qynl5ZcXJeyBZlSw/DEaLC1DCqANe9Z4Gook6hH7/a07UaTS2Ce96wDlYduBHlBHe8WmYXxyF
 a5dGiSvFqkFp9K1P5LChBMBZwDWy5hM7Q==


--pgsqqoxlr7zx6fjw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/09/27 02:24PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--pgsqqoxlr7zx6fjw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmb3CbIACgkQwEfU8yi1
JYUHLxAA0IQglor4Zv+OvTH+drE0s4+TDE2pLzuvIogtJg1bBTd1b9F8rZ2KtJM3
MX9aHZvBe737lgyAnTZToMtXLynhKPaAF+bddXHXcxY3g7gzD7qlyYnuIR5vD1gV
fKwqz55T/yeQGCfuf7Vtqx6H89vDZjOPRrcEPwj9MJ27G6X54DejJsCc+flJ79Vk
7mdxF8I1Zj+z3A4TCt4/iGbTRFuRU6Y4lRIoeaRCCcq1Ty6YtI8kGQfueKb3S/7s
Z6E+18ni55ASTqbe6v19jyGLY3l+SOmw+MdVptW2bQ1thQwd9bCTgecnbTfsOq1T
1kSr3dew9pUfd+5ngy8BoKmqz+1EcdvhtKO1ClpzzYttR96yYPnoetJ4KjWbbUKk
HqpMznwc7ljj/80SLbopFrZKxP9USTnCiQAEYcBV3gbHMgwP7q318FJmicxDkf5u
xSNnf3wgczyZb6Xi1D8hafTetkfGt+zXdKygjXiS38oeSpIlOPmP780x6J3+VypK
F/eo1U2Q2CxAASdmHaVKfTR9AZDWGUZcROQ9Oc2w7LyfskAXY5269IroleF3Lehc
WUilIjLSDAKJdaWCXCSyHeyYDaw/TVMyGIWGwsRX4t1BtT72GMs8ZZ9K57KNfl4e
JIb62uRKBUPf776FimSm4KIr1EMj3ZCnCboZw8Fq6zBgDawrgmA=
=hbcJ
-----END PGP SIGNATURE-----

--pgsqqoxlr7zx6fjw--
