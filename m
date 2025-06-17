Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E32F94B3
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176828; cv=none; b=c2J/0faTiOHLFVI9ZBq4OChtq9Jho+3EFcSzxrTl6ASC058yv2SOD2hEO6KIRSDYQ0Y9QhYRPb2vCJ+HAwday4dWb0SO534FaABfHjgRyOPtAsmmushit8LjDf5RTYLtPmwRJlFOo7Yij4belyLVRr4xm/0jPL4id7g9Nqzx6O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176828; c=relaxed/simple;
	bh=odXfEf04AblCiwtd5oaSZsRjpkfGUvIS3F2wdch70Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BA72i/4BlmM6f4iLWhlAr6r07z35yj/IhtWdRd0Ijj852nEWpJJra4hQ4WehsNOdeKZZEYizC/kCdrduA6yhSJZX1Qpib1qJrKfEoHsrrqQbocGGysWVqj99W+7Z8y3JR9A4HetdU4eWN4s5BfHwyydTyB+hZLhDDwR/vA1nb3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=BTdRH3b5; arc=none smtp.client-ip=212.227.17.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="BTdRH3b5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1750176778; x=1750781578; i=christian@heusel.eu;
	bh=9kwaX69BYlfOgsIpG/Pvl71vvTAMGxrM4gg1LwJXpw0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=BTdRH3b5pRt5SsU+xd2Q9QDqes8HCXXRzARmfnrlNjAnZY+NzenFTF5qKe7u5Jjk
	 glzBxzR6ZRfFnKfMnOZl39+Gh5YgiHwedcBcNz6Lyg9bpH0Lf7dISTgWTFR0ChsJx
	 79baaHfhC7OpBsy0lX49WGwePnb/+2ARr8deX+CyUv7XhGrLvrh5CzFhxCOCBVxY3
	 RzrDC1wD0tP8rPO2Opxbn3/3YAnMq9H5vbVTLOasuJ4XiC4qeiK7wXUFcw0aW1n0M
	 3nMCpVWJ8I66Acz3KFBKaacHD3Uxh/UCMx7glCk8gvSZkLwqRqGlKxuMlLrrhHVkR
	 VNqAAzM4x1RN8BDgSQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.55]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MEmAX-1uYSxd24sd-002fsg; Tue, 17 Jun 2025 18:12:58 +0200
Date: Tue, 17 Jun 2025 18:12:56 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <fe2120f7-8839-4a0a-8bf8-70b841a8624c@heusel.eu>
References: <20250617152451.485330293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b65wpbro3ixgg3e2"
Content-Disposition: inline
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
X-Provags-ID: V03:K1:rkeVi0aqo4aMzMglbOeMMhlCod2mVcFqnJiyVI5aZsidvr7CVy+
 5Cf/EVtrSMO0fPlek2bHC2ATQsWbao9hZsr2it240brdeZFZs21EfOCRztrj8+FZ9ZWuO2A
 akM/05d55SFX9Gf9RCSfIc27eTExAMwd+IDbR+1Q5+EeiWJqMfe5IKm5dZle0AkPFmu1gV4
 CXob+wKERhI2lgWvMowqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aqsyypDRLQA=;dWSk93rFFeHiX8CDMAFxHsc13sw
 JbPKPm4jHhVSp6V7PBidsUdgYOx1x7cvjYLRqz1QhjWVCEa9NCqxllFHDBNYZGzJ9OsFnEfDd
 v1e9Po4xHNYTCD2tL1i/KLEcArDz/JrnuxRLDO/oiMnLmryPnqVZmI4J5pc0La25XOs08YbKH
 j+7I4RhsRKQ038bpq9OAiur1pq4nYzgTEil1JaaPvdCoCpIAkyt20dlbUf8d4ohwt7l9Yv8Dn
 9m1/x3kMXJyODKXBdsyyWyDCqlFloAU4f5H38FBsUfzykww+nXoWYEWUkl9rY3S0dmK35EkmS
 rh6SiHHkRxzkgnR0HB7UF3AmScmTFiDF0Mq1pOBh8OqMZ6XLU/AZzwRidjC5cSPDegAsjyI4q
 HuD2/ZtgZhLCIB9yLuwwYkS/Icf27SIAIC5KGukE0gSYj13siGe27tOHa1+30pkODxX/DwHNb
 viX3TH8Q6BAcjB0eNG8Z2ElhxNvqZ5vqFWGYi5kB5scX37c+zWkxT9XliZBL7lzUYR/wHuKoY
 iewxlDtk04/Mx3fXq/9hBG5DOf8f624YmLe/3e1wl1m8qIiwAUijqkVS+W6BCU9BFOJRQUlhC
 qDP+6S6baTUOYCYnYbm5+wpajBuL4HiALwDgVmRHObVN5V14PqYzvyQ//O94PJZshoBd//b8P
 RDjSf4/o7GqG6eTY3ogu8m6Vwd3BkFDOaPciwj7PF6yxHWBAmM1i9RPtbf5rRBm6d2tUA7pfM
 kCK+ABNHR7L5HCFDLCh/E2fWbTJDt98B16Cn9aBVcwlGbMFO4frDL0X1Yakl7vSB91IbTPv92
 B6IMQJJKpUxb66V4eb/8V9YwyQQl6ueA9Hryr8SeELQ3MOGhtPdlzgRcq5ere9KRFMvsYkoKh
 v1pXfkC6zZkmicS9TIpERsJqmZBfXrR75X2wg4G6lYVavKqAPHdOPT7chTBwn4W8g5f/VgJn3
 oCE9MiO0qH6nUI/iQbpNwviVaXF/y0SJw3QoJiTjfB0aCVaoBRGDRg8a0hR/BY6Ox7s+9fLfT
 n02QTKiU0h1mS3m8EaAWrTCI23kfzHq8ruhVjJVgz+aanHAL/e+9Wyg0NME18HknC7271oS26
 5v9tfrZfkKY/gqWuahePKAAdAQ/TBwDqPYFFXaCie110mPfkv459w0VBYzUPJodd1dNCdZ4CV
 nfmqzdP5mkXMUJPQ6ZblwsBgEMVD3nJNkquZPrlSsPjmEd/lb69RDI5/4Xs2Qg74FxXlocaHs
 bGflXiP09EpI6wW8D1NJ7RqYKk5DEfbdRvys9s/cK5OlcpmSvlbSrBtYcO7SBRT4w3ey7xEr3
 OcgqvXpYUQ8tf0xlf2QTk4fzwfB1NaoofwOdIffgV5Hc8Ouh8g4SGcKxUpTqF0QJArJ4ZITza
 nu+BbRtfifaic50ymb6Q+WnMoEBxDnRoLw0igfvAEG/Jng/msp//Cugd1n


--b65wpbro3ixgg3e2
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
MIME-Version: 1.0

On 25/06/17 05:15PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--b65wpbro3ixgg3e2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhRlAgACgkQwEfU8yi1
JYWrxRAAr22WwpGat0STLhfFC5l4KRlbFOPLB4jgZV9IPwkgK4dAL5jSfLxJxMcY
0EbBI8mo4+Dn+A4N24VMy7XasicUdtg/48l5ImbyHEveZhWqu9LxtEg4hSEc1hLp
qV3XaMGQ1BnYzTZnUsYqywJVJQylytUSjFIhgvvAALg8NYSnzGNQJ78U14sQjx6y
OIVxucmlhHchMoRcPhrcorxJuk0ui9FgFwejpgyZ8RE+x1l/lGUGX9vm4nqQprgE
xxd0H7HGomVh427b1i3avDDFu+k924McKQB6NVu3vhXmH3gd6pmHff/D2EFc9ase
ocP9JJvH58I45PRLG6kOk1cxIwyS8h2G86/eiIcnttE6xqD/2xOj/J+ufyAdkMAe
02r4F0oVtkZaYWLM/hgEkXMBkn944lWsMNQoFUPO/WcAM/A6+SSK8AlDgoxiprTK
9uuegqCh3+8/E8+dj8hOpg8m0f43b6XULP8EmD0GVDlWaUCqeMpyBYes97wifDhM
he3zfH8R+2ib0z0zeCjQbCiZYD+uwafC601DWOwhpZiPK4K6IMPMsbIegJhDwG/d
YgzN5CZYJkRq65jYDLl4vHwVWq5HjBLgjPNew7/ul5CoaoaiUO4y6uaEub7LWGvG
Thp3B8M4PC5ZnvFda4ATaMW2nVrbg9XDCIc7CuklYX8uHNhv260=
=8EQi
-----END PGP SIGNATURE-----

--b65wpbro3ixgg3e2--
