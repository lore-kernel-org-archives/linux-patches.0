Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2313812B71;
	Wed, 31 Jul 2024 15:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438831; cv=none; b=o7OF84qdMxDs0tF/SFc2ns6a9xhwlXfit+BkOQtH1zXh1iI0JEs0nDnkEfIgnl4fQVCzw4vagR5AE26L8lTtQ6hFOyO26KrY83DD9BR+KkbnEcc3220oMYeY+DC/uHUtPw3DfGLRMMKPFWnyXCRGhUcKOWNlGe0FKTUxo9LJ0z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438831; c=relaxed/simple;
	bh=TNAtonRidmna81IBY8G3UGvtn9tX31MGv18W/k8LTLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=od3dDpzniUHlOtwogxG4+xWTQmw6u5Dxf/+KtHaVX0frKZicqLCFOFMFW7p3kDlgV7cq4Mnlj5X1cKjcxX2jeDw96/C+GUosm3lwsgOJ4BTvj6N0HsExv7HucXyUbmptaos/sWmdVQmsiqfZDT7qlnK/uuZQxfLx3DBUmgf241E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=u+3/e0Dt; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="u+3/e0Dt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1722438755; x=1723043555; i=christian@heusel.eu;
	bh=fiuN9fTjYPSMySejhaU8aJ/MESvbQXsZn6JAwSDbzoY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=u+3/e0Dt4tdSfpFLyFjUl6smtzg7Vx1Q1LJu236Bi6Pdwlm05H6JT7gQSuNwSy0F
	 zRvEADi+nS398VOq143zX5wzYTyVDnTFKyfMLvfDq4pq76CvlLfghqwzGjwoTHRYv
	 7pFbAoqBBbkRW7DO7TP4cALFiXUI3zh3wNDd04YEfXERfXEkMN9liS61t0vbykPBo
	 96wiM+4bFfYH+gDTzRbK32MNTeIdDRi349TVFcp3WzyJq3b5K3DAtlLx6CW0uIn+r
	 NBF8CWpmFIIbzAp9zJp79sh/bH670SfH5JkktU78RwO/haEzvLW0hj7OkNC+b0bUO
	 CkxSW8SedJ+DSMKM7g==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([129.206.226.57]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N3Xvv-1s8brM2e1L-012igo; Wed, 31 Jul 2024 17:12:35 +0200
Date: Wed, 31 Jul 2024 17:12:34 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Message-ID: <47c19dd0-b9fc-490b-ada7-3e2fd74c32f1@heusel.eu>
References: <20240731095022.970699670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cflmrewle6jrucdq"
Content-Disposition: inline
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
X-Provags-ID: V03:K1:fPz2yEFyjf42LoBYm0wjWV7TJYdOYLZfAv5I1xJC5lw+EpAFNoE
 beSr/qV/J+MqsLcIzPYaAc4/Z9FMEp5Jv2ZWOMh7Vz9vYJRTXGUXTIgu5Am92BTzbCpiJi4
 FP1s3cKUfLTK/07yFCiRpBdEWrjgFrVpD2oFwLxhXsGgJprIEODG+WPDiK/PDwrQkg+4GDS
 xapcnO+zUJn/9S4HYQSmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zJPtp1StDLI=;7RB2+PUw1FOq1De1ZUu7NVEbg+P
 iU05n04wMlOd9H88p3LIlB2FXkchH6QVJy7tNlM79fyq5s7hEeDPRo+iz0HZQUNKruomp0oEj
 LTg6G/moeQBsEcdVR2ad1CcASgupAi8sHhuUD7b6NzRtmO6dTMzWOkqM3hi+dG6eg264hAJbR
 WVSnGL9vnwGertfrH9TJ33FBf3SAc7SU9ZPq4g9BK0c/XjLkjS0iC9kDW8a3IK2lsH3VBOD+E
 M3VR4Po3vOthRycVhKtmJ5fj/YkTCNqd1K1gfHHsJBCE6zW5Gf9GT9CsBuo6y5LtddCtVcFde
 UteN1GMoinRX+a9+5EDWuJY8fuFRLt8EHo8TMhb+Y6T2kY2hIDsGe6NZrrO/8W0XXHW+W4P+m
 1XiziBYUQG/Wh/sQCaphhyuOaDlSxQ5Y31gARZrFeK2yFehU1R5dEigAI9TkmFdZXxEmwRkcD
 HVokdfnTUXF1ymK5l9ruQNh3ukKuwfciZCOkEt9GJw2oSwtnGulrgoPNp2gFH6y8PLhw72l8l
 /5kZF8K9aCRNLJCfiDvXj3FZjAUtTGWwNqlRHq8jghWS8Hp4eryOIqofF4GP1m7GYQAumJwtS
 LNDcHJPaoDuPdRnx/Pv/8ocv5MJfY8OtsjN2m3zyr7NQfthhr2UFmWosaDHYDCcxSHN05oaN1
 iJUHCBsrKMA8b7NmzlbCGShzOl3APVxgrQJkavgXOynK4mh0qH4SwM5s+vQ0q0yp1FXs51t58
 Lf9wJOSLDMQFugzd3iFzKAFvjjLKRpT4w==


--cflmrewle6jrucdq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/07/31 12:03PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--cflmrewle6jrucdq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmaqVGIACgkQwEfU8yi1
JYWW6BAAgMb43zlVQ1DaIuqk2kv7cdamBQXFOU6cQz60p5UgvKCgZkYt6nBbHsz0
FmsnlIlunEe6K6TR3evgcH88R3he0XkLhXAPS672YKtYytRlbIQ1KWNlYqSmp0WP
5c6tZdq2O8TmKaFzBU0ZFS3C9wh1MfilSxUrfC8B4tGcnDL+YkHjUq770sUYENoq
21pq9Ne0/ALF6/ID9ck2p2tyh7WwJ1+A07RBoJV8Z0b9cGBevozRtKaw+5BuZUBf
V4Yiwa/1gvp8MAL/6CbRHBwj+r9x79oxkDH+GKEPZUJzW0R0y6cDqy1Mw3hWL5uw
h9VXo9qY+qZvVUHC6pIfbWhB4QCDPyBh13v6pFcQ6tNT08VN2n24kjNI6X0yphfZ
WQeQN+t2psI85rzFfqQA6/33R+Lhr6Ypaep+fGGvoWWZzdwgltZuAnjgBQ8d6qPW
cvSAMpe86Np5bXpTOHE/pjFiY7kw4/gzccsMiv/QxO0/b62u0u2cYC8+vQ3O74xD
BJutJ210o24ESKE4UrIEFLcwsYx+SXWwzLeRE6n/28piWwfsEgd9Ojo82K6p1KMN
xAzTxOLm1hI5b+UIOO3MoqMGpCDtAdIyXm8r5VNW+s78wurxY75hUuPubHA959b7
V3bNEm6Ocmssc5IJSUgkCyZyRmpYf8C7y5o4eA3pLGYbjjH+PXE=
=m2sJ
-----END PGP SIGNATURE-----

--cflmrewle6jrucdq--
