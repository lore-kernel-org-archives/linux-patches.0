Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FCB24B26;
	Fri, 13 Dec 2024 01:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053043; cv=none; b=eRzimHxzXCVCcpB2WRbTgRujEnRWKWW4fhANtRdT/oTmZESx/+U0ngJiQ2r1BY4h2zm3nEC/th04vk8QQLdehaZ92Dv+ywxEtQjOiK+1b2fMdMY+Znvq7lUkm1Ew9mcv/DQoldMN2eWnAOombKhlQceEkfvM3TZJTMKk6YDf3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053043; c=relaxed/simple;
	bh=cjTzSbOB66RpNs2u1PtSfM9i3WRRlSzNHsSFeVIYd+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uto7HkQr/6YM23TPHlf6BpkOmigIQAcDmUCUHMOBPyYD1xox/ehkLpyvxVVp5VlMyGvC06aTP1THORJVeeefcis20DfF0LyweHpJIH5Nf1mRKjdnL1NCs15fFgLd9uYFvhPKGY4Fb4/2LMH4APexqzwQ/gzDRunf12fqtJYK4ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=IXs90B2G; arc=none smtp.client-ip=212.227.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="IXs90B2G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1734053034; x=1734657834; i=christian@heusel.eu;
	bh=6wdAbLiY59GdZlUWARytRramMZu7PSe4YRETZnKrmdM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=IXs90B2G8BhDQmLElWMFHt/Rtwuo8LhTYIv+oHp7Yl75Mf0QFP11KPTYOSg85BLh
	 myYRIqAwD1R1XFPFSblBz7P0gdgxcQ7MPWMZxGEvvOX23KwBGSGf28/YJKluh7ilu
	 U4Qcq1GLKP9jPHyMNur2Tp5xPiuqnZLWbFzAtmtpa3Gkq3nXfawyGTWOCKwk0+0d0
	 CuLQQxmsWuS9FcrREzhmJdOk4NMz/gic8EW5ItrY2OM8+LnF5a+h2BP/r/pkFycNq
	 05jyvv1tIwKF/q4bgTtwslWnHEBCm0kaOd9i+bL60GahtIT/nqy+juTyhSb6rDR5h
	 xtRESyFqtAK281dY8w==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue010
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MXGak-1t7Avr3Sk2-00KKal; Fri, 13
 Dec 2024 01:56:29 +0100
Date: Fri, 13 Dec 2024 01:56:27 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
Message-ID: <ff3e0086-9d82-47fa-8909-9e1e6ad2995a@heusel.eu>
References: <20241212144306.641051666@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2zgbx7zmgkdfeq7q"
Content-Disposition: inline
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
X-Provags-ID: V03:K1:yPCa3ZWbcwCJhOpAagw+bmS3r2Kj0hjC3EkYe9qzv/j0kpZuLOb
 B0d5Sj1d2OcYfkAd4QowBQQ/LDy6KXa8Q3FHUHjzs8IPCyEOBvJjLJyH6uDJDE2yv0EJ0t3
 RqXCHrfZTAVr2f49V7TcqZgUjcUxgXz8zuSJvsOjoPEUAgbJ2nWDCX6D+CkqUj5oesf0DsN
 ac3WH5COZEq7kZqzKQdmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:H1/ILvt4YJ8=;exysnSBlCaigbOHlJLRaiy/et8W
 Iyof2giMWxdAoEk9iY9kLBFWUm30YpuKpZcmzUqlqqGGg8RKZEoAFxV42UDFp75albK38TlcU
 IFNTyvEHdca00F7iKv9Kq3vmG8+gTVWhtfZ3Y0vqhOJ30VbB0zFnZcdGVNP6NHv90t8pNn22A
 CT9psBZOPGOiKiKbhFDS6JX4Aci+bePRPKTIQ84sBh9fd4dFZYfnQwM7ruJtC5x5E6xunMpR/
 5swOnk2DoThNI48VUMboiE068XCf3CHP5odTi0xUCxqmdPlr5ikwJD9pdceYawqTX6/lHMbJr
 9O26C7XKT+ImLOXTFtlIevLYvc2Y1waeso/NU06JXF4PgJMiIyL3vZGtpUwfIR7C5RnqLMOEY
 QeDdncc7TAhcuwCz6AJWPIH3/i7B5HLB6QzC3H4k57IgHZvV/rvS1o2cETaICEHtdwDwErJbw
 ZVMQ2hDiH1YWehJZnXnSoShADd+QuDibjreV6K37WgriezpAZC9oZuCgPCIM/3khppv26CUEv
 gyumdC9LxuDYwQUdk9Yad9c9FUfyluWb4LBynAAGay45KxLaS5v29QM3nfkfhcgubobQ/uQjK
 NotYVcjs7dwL4ugY5KHsWHDZAxPqewu9eSLBCre+4gBJwMXCDhXE0SzyxhBlrdfeknRlnQjDc
 UMyFP7ik09lbDzEynX8/GK+BvFnbi//oNIcy/BOhkbSummm6ZoGHdssVIuqVwSMYtn7ZyHuPc
 SNBaNMQWVIAe0LFhB8pTrHzgN/7LFjdXJo4InCTaa/wge1bcOrrHY9rjU5oKiUG2O3AsyWDx4
 +6sipj4WYc7MQqK5aFyWHxbGNm6drjMC2rDESIO8XB7LPKfJyjnRVlwMR9L9dV51EdV9sW2gw
 ympnqoR6cx5Y24q2FFF7D+iMB7fDfKVwPlosx+uSKQNtv5BJYQtLr20b5nSFKn3vdnh0eBtDk
 7r6fYJG/chHYa5y5qsu9X2c64g/FBDDPukgKZJuSi0z2uoRCov6Cb5/NJnbpWOzareMi1GmXp
 W8e0BkpmXP6vGA30o7lsw09AuhTNuTB922LGRrB


--2zgbx7zmgkdfeq7q
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
MIME-Version: 1.0

On 24/12/12 03:52PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 466 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant).

--2zgbx7zmgkdfeq7q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmdbhjsACgkQwEfU8yi1
JYWPKA/7BLkCLKK9w+QTkvLib8Xw24HIhvseJpSXB57OJrDJmlTxXaV6qeFDOuXj
K4//ajZ+7/BOA2x6Wi/uuSffSURpIQtTg4WDZu50vbY8PG8qWYffwjCTsa0+LFMp
OpCksrkVA5Ld/Z2U4smd3IfaEUnedyzcNbYB9i2oSFo3MOioPTVSwfsXSFT1DBlY
xchxIlFbKElgjdKL0tNFnekOvBmNoI4OIRmFRmYrs/dXqWqOmbQFL2UZIBWEWmIm
VE9LS+mdotXrwEqdXYHseqNJr6e0O8vRCbfD47MSTb1exKtmPFjCvix3H1F0rTOo
3pcx8rptyMHkVpRRav1ypqZEPiNtf5GJjvA/zRy5COnAzkHYHh5DlcAP6/ou2aH5
hnnRpd9xAZUCQzSRj6pV8Xxn6cJ+i6caRIGZ66VuU7NbWHq8y0di1ERR+U8mFnSY
HiWOMH/CFmMxaGM6zBt74K8bBkifdINqD+ksW2gO9Frj1nkXM/3eLU0mv8oeUZeU
MU+n0wW7dDeJgvGZZPt1+ieDdDqO0v5NvS+y69pcT39XwYJia9efWVeWaA7o6Eu0
GmAj+4c8A4dqPDAWOunAxMWVIwqV0UUPVGGgNSBClnri7BwSw6UwfIZKK6q+zuf/
IXYJ2Bh9LSeV3NUBDlH5Be0WTeMXbH00XmJkZkxLvnGVKSzfShA=
=KBnm
-----END PGP SIGNATURE-----

--2zgbx7zmgkdfeq7q--
