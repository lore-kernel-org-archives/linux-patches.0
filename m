Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6F41F9EDE;
	Thu, 14 Nov 2024 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731587581; cv=none; b=WaMQzTXV74MhaYu/d0sBCoI5rqgIYGkjNg443xdoezA+UNsDJ6gAAu9jT3atrXyJpSo/AUi/Y+zjf1gY4yfZLLqwtZYs8lc8a5AMkEH0Ejs31/YcZ4kxvSt2e4vZWglid9isMfRh6JrJ4TOLYdH03sF1Y/iIG7LNx+98TnQlODk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731587581; c=relaxed/simple;
	bh=zqeC9y2px9I6WSvOgH/ULmpWsBmb4ZskjipqsxauY9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4mJn3sdDPxqTrY6+hvpilgsnAK0WHas7mdXpq1hRVrBvIWCK+wfw6cz41l3gNpjxpocc6ralbNPLqg7MXeH4ozPD+olYQdM4SXRaZWyt9chKVSxbKxilW1+zQ5GpJXOHSVN07sp1shBV+9qOz/CKaDXJyQOOs4E8YfTMgpuX2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=cBk25v32; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="cBk25v32"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1731587572; x=1732192372; i=christian@heusel.eu;
	bh=wbFEtVUMX5z5xYJLpgfAgGu0jKXNwIXTeb7vtea1FmY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cBk25v32DGiesSN2KskPysWGd0knYBocIQ58fqBFd3KTNV2awSAsXTMzt6JyJkfD
	 CH3ZxLTegIcPCiViqrUvaAWNUzLLUj0wp0UA9JG0Gfzxnmt6qY9BWyE16VuVwLs8J
	 C6vhqp7E69E2/VcPYwyZYlhG70vVhwHlPxt6cGXpZn5zQ4APwWBRq66UVv9g1gX5W
	 s4+iux4vHA1ZnepxTgGFYXF5nHSK3USQSJ7hZJdz3xkl9uKs8237Tke38v/wLH3tP
	 2vseKaJnoNeKPpgCyIYh9m+sfxL8t0py7FNjM7rdn98W5YK2qDh3mQr4BL/tpHKQM
	 QIVZqcDfTE34ixRnAQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([93.196.138.62]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M5x9B-1t9eTz0JWF-00Gus7; Thu, 14 Nov 2024 12:45:52 +0100
Date: Thu, 14 Nov 2024 12:45:50 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
Message-ID: <f2be671c-172b-484e-89ee-e48d98778193@heusel.eu>
References: <20241112101900.865487674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3j56jyl3jhuku4vn"
Content-Disposition: inline
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
X-Provags-ID: V03:K1:3YapffhT9LGBvelwX0YrG8wKzO6z8qCqgntwHXwBmJ4OEbPeoBG
 QARTnXmiTXwXXGpMDrUlFj16avERa3gQH0esRM5gUiUo+Y1/EU8a5J0WLTTWvtv8AtLR+6m
 rJ5iEYIR54/HYoey0Yc0j/RiCpTVa64hvkXPtd8LCSC75JO36AWt2km3A1Rt91z01hPMyI9
 OgRULIBspsQD8x++HSO5Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yTOlNCkeJ58=;VIcS5qhR8P2yELB6Ac9AzeB6P3x
 jsDMDs2WxDBb5uqW9ZNlnICwdF4RKiqVCz8xGW/846jlNCWpyhQgAYO2u+oyG9ib0iXNEpoHN
 71MlAZ5OP34eRK3ubpuLBAXdHU0TN5+r0grqc+2/7GJFvKKuVsG8giYbSYfXWMaiGc1fichfo
 bE10qzFkgVGSuZT8W6dirxVh7ybDAFl+OscLLdbMlsMJ7YyLkOcTKMjnk0gZCmv9KiDq8WVZT
 ckfK264WFpATtQ4xSaT6gobESqaPsptQspbYBqIyWfbp47/htuUO6S6gk3j+/V4QxChEWzOHi
 DjKdsitwFBdPOKk8m0ytawLB+r0QxuuzAHSyvwqG77khglCEkggN1Ye0x1eM36eMlI2ocasSe
 DhfVB0yliqSx5CAT1wFlIUM1ICYk2luHshM7sdqTc+C2jJaNK1xQWcKPkAcTbl2uCnbTaq9z8
 ZnBKTRWjRC3hUqJ9uEhYd1Sag4xqC85nSfpa3/ojTN74ogf3B9SsYDRWoC/G9JwWEQy9aoJc1
 029vCQc0l7GdKo+skn8oDjP3w05kFeKjkNiMWwu7PUsaL64mbnXePewI+9mZcbjauGiTlEUl+
 ko8G8Zzq5JaiqF1c+62HNaQuwI9kgE8N4qh6La70Zvq7m7h+9Bh6LQJkCV10jilmHI6w368ny
 emXoSmC47W3RT8QHTEe29U8amt9iNsOe4/IkqD3UpUSSdYnqdmgPWx8CL+cBrkfC9jMX6Fe3U
 uEc0QaMdBCYDfsMKTvpZuVqCvxwAOHZdg4ZyR71jWbg7eEzWSKXTfMmfRu7Hq9/Itdr4dTY04
 hgdVbgGzObahYxhs0R3REyaGrP86x3Z1cMnfNj8CDL+iJ7m5CtVSY3LuDVHB+9MbSm


--3j56jyl3jhuku4vn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
MIME-Version: 1.0

On 24/11/12 11:19AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)

--3j56jyl3jhuku4vn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmc14uYACgkQwEfU8yi1
JYUamhAAvGMYObqyuRVdGRd147yOR8mnZRw/Cqs7/gSoo7+m8RkP7UtaJtmd3Ehx
aEDfnqswCncUFAHz/zS1hXpQSAytkEBKsqczOTOe8GsAcKJWLKS67RlgIWcr4LEk
VvLe+MmIwdT8nsH3WiRMhFXuHoSAtTuFE0Vr0S7rXvUNVLy8dR27Rz6kF6AFjBhc
UeYE4rN8FPp53Bia5LYmA3VWH4dUgud0JaRCbEIfA8ITHXQSjG3XUVXPJAgsGFfa
4iEKNKXFQJakYIm4heA0z3Up8guK7cGACH7zoKvCARlDrt+NPbCcMfhx8T1BRh7q
frNor7r1yBKN0gb6W1y8mX6KF6Gtu8nP424D2qKVt04AP8CZQ4OT0aze8s2+AFBq
tikBXfdQkaiKKkW3ILlxbIZgqRGTj1CuTRU2dkEvXF8fCpBSFJJffmOjpGfXuU2d
7GQT6ZF53Xq+Vdw+o7raIxtnOFFIlgaDzpGiGhTBR9M2qNSDPf01zo4EBYCXm6zm
agV/6GNqEJPk8RBlBJs0LkP/VHI1Jr+7S5LLM8NO02Pz4heGF4AZ0nKmkOIjyfTt
JlrChJU/6C+GpF1MhPvaYgqVxB5zzFj57r8vffsRHhgqBXoLkXrGTl+hVNLfEG+Q
MtmTc8eY4WxEmJTQsdarmDKjd+11MofFz170wKTvKURAtPq2+Kc=
=WzVF
-----END PGP SIGNATURE-----

--3j56jyl3jhuku4vn--
