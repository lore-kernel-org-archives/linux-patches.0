Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58731DA30E;
	Tue,  2 Jul 2024 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719959956; cv=none; b=JS0Ki9jHhqIwRQJ8PWfM/hS1zmSoS491ZSv1DM9SlT1SwgnxoQmM0ZLR8tK2MJux9uOmbgF/LW6SIWQOlSxTkK0Jh/xoTVjbsodZp1SAXk/Pm9N0s3m7tMhaNzf8BKjxO4BgrELXSYAUsM5mvvGiyY718llFMBedhnGUGQw/IG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719959956; c=relaxed/simple;
	bh=AAXTr1TExBe3gk+DNojZaJirkXbvIOWJhgwD6gel2Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4GrRloiI4KOXcOfF9SxJEMwuumrIx1O7yMCjXCoArk0LkScen/6DGFTwVoI8L6L0UusWycI8QMXWPkfXBdA3+hPWFwo/jb/R1sE2nOEuSIYiVWafejiTpjHKX6vnmpnhkB2I6s27GmMiHdpB38OJoZy1GY3cAI6UhJN4XUgtZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=msvxH7rB; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="msvxH7rB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1719959934; x=1720564734; i=christian@heusel.eu;
	bh=LtxDyP5UIQp8b7Vpfhxf1W4aVmwu+wOGuYeadRxap8U=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=msvxH7rBbHyA7h5OdoFaXYaCZGUoNO4Md1VXKgtYVQut5BCuDBbtoh2+B8mcRY4x
	 h/ZtZCVGA5XywtIMeYnabo19r3LR9Vy49PBPDqE0rr5K/Yge0FAbCadIBSp7ZFOcW
	 RAGZ5PYclQ/eefOY5hxYzAg47dzHXejskdtHQIRZO/bRacsAKVKAKACUk1d2JQKOX
	 MkwVytZZaZqX2iS2B36hZ+ojpQrXZmdW9UVUV6fFDyhfttJ7qyF7JDyG+Di90HTg7
	 wn4NsgHXKKYsA1+CN+CQTW19xYiMf9yKNrMIICKZuOU32wxvgTDZpJcGe/6HAlUZq
	 R1HCwJDmLSH6VVOyBA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([84.170.80.43]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MLRI3-1shGoG3zE3-00TuYE; Wed, 03 Jul 2024 00:32:56 +0200
Date: Wed, 3 Jul 2024 00:32:51 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Message-ID: <1b8eef46-0f75-4403-a216-2101f299213e@heusel.eu>
References: <20240702170243.963426416@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mnacg57codumhvsu"
Content-Disposition: inline
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
X-Provags-ID: V03:K1:nhtFSUYL/TDj3XrId7AHYcwIS17tl/QbIweHdWCpMTJ8T3+72bv
 56wddLQnHeWjjBkMo1OXXSF2JDqVmvx+OMDKMqWSCvJZbBYkMoBKmlaA6w28YNFZJq1rE9q
 zWLbi1AF5fa7mD3yIxb0yWUWEXoPkzuAbEjRv8EN4f30PLVJwSB9UFdddMXfgr4aJXbAEoO
 u9H0DyOpjS6zQ00ymySEQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:y3Ypxlzf6KY=;D8rVEB7gukuieiCawB9G/8+icMa
 6rFogIhII/Um4ALmCIF2/e72ofVlz0MexJ0in6Lu+o1E5V/YdP6xvoIR6VnxeIfGrdg2L0ibn
 08Llx39KqX80SUH8MQcQeAkyxwLINn/+uxIgmQ/2UOpo4zFj+xuCi7dsVif9u25iPE3ls6T4t
 OiUfpG+Z34zXLbZAoT1LuNYbaZgbS+dV66PNOJfRFrCIbOmZgkXVvsmxbeXxCxwOg0Z6e4O5D
 F6pANLA2Iz+GxDb1Gbw1YFQOC6NgudcUkQbsWC0hORRnhEy1lu+5vLsooYWCjnssN3qZuzTgK
 HLdnZiYPau+8IuFTeHiHPutbznHGfWb3b9D3mes7aNqormegfAXkLNGvwZNk96daCwCCcek08
 qGsbi0QacSaOSuTS2tAjRzuS5v9M4+6F8qNa5kF8APtCS2zZNYhRFvCowXju+1ag+NyGYFWvJ
 jrrElN3FcbanrXVOyEAiorJrpU2gNpFQtpZdUkSb89fACWY8CdT0ezEDTS4nGAFMcmvjGK14r
 mKlrrCXvy4BLadHnoHQDPlXbLKbZU4BC62VWGKRVmhmOy2U6bPMWwjTa6fNzkWfLMAHWkxFJL
 hl/R80jJV/fBP3xkMC5FkrDZ1symnir431mNejaDv8GcFgfMp+VvMpThAzOKdNsmnEAOUonUV
 9XjakelA4eAcXeGtzXy4gptmznjAqgnvKIdw8mJsIgCg7w3nvvYmK3z64bVzr6rLK9TpFaUhc
 8e21fxefbqI0uUK47oTHwj86J0P087ovuLA6ThMrU8mw+dymlNDFi8=


--mnacg57codumhvsu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24/07/02 07:00PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Christian Heusel <christian@heusel.eu>

--mnacg57codumhvsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmaEgBMACgkQwEfU8yi1
JYXGLQ/+NZJkpHORYr62hZSn5GEgoAIJ9FPxiAY8hsoioKofultA3AU926qGZX32
NG96fqFDgNnEB3M7SH7X9OyT/tqu3fwNETnQctaWbwu9vUW5Ogjp26jplNrMy8x3
XyT/I/ceFXlu5NE5KGZShejjr+jV/d+nPF6NiygYXEKRh0YBc3YlrLu4Ph/7jQ3J
8wcXrE0J8p1ZwoJiXnvZ06SOvnQoIc7Z2k3ujeBeeaLGHB4el9G3zEiej01J7Qkm
gmCuJTt5YZGsdq/xuW46324J6rtJTlD7Lo0f3aGHai/tvnSnQ35+OTHfOgWSyuiX
aalDklpOYa5nIoiIdP1GteFegyOzoLdCyILPS/RL8DTys7JuK99QyY+lzx3RItOg
e0OexOI8LLb7NI7Mw6MzVnh/+jxFQXqSDOm4dxmNvQI7IppN26L8y7HnLnwnMi4O
c3rH5xbXLCiJevo+5Fc6E2Mja4sC/l4tvLKrqPzskDwC49EyXjin2nGJUP8h6K0g
As9MIO2UOGayYqAgS9NokxS5yr8ursB1nw6GDoMcbyOwpOXPfCAGBNTODnDALJCU
YoIhBkHmMgPK4OY1oFODaS5yqr1cml6HsOqQLY4nGH0ckfkh41gi9Y3kBLuM9jgW
DXIZM7Vg+IHMCW66rw+zUCG4hpuulLam6R9mCTG27F4guRoYV7Q=
=DF2x
-----END PGP SIGNATURE-----

--mnacg57codumhvsu--
