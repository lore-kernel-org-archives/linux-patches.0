Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD616A92D;
	Wed, 26 Jun 2024 09:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719394022; cv=none; b=uJfMOEeGm7AqLxFhNjlTJSlD536rCHh5EHf6Kdug4WgptEwTT/7/5nH01GI+mlziystJzdRMSPmoArN6nE+CNRqPTvxQxovookuYHvOUn1kP8daNi2OY+er/FvkQDX0OucZP5s1FBpZJXySXHLuCmIgw/SNu0pzlgTGr8YcXb6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719394022; c=relaxed/simple;
	bh=vO492fb63AEy8Bqshsm5rHwcRwI7AIfYqVgtGTdKBoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HG57HDVzF2vmPiNVZKwxAuGxkZ7JT61xNu9hAbws1fOvvSF3IAvCkAVdSiozKwTnASkEmg1/oCEmhbr0qBn2zI+xt4dW+2G3tdLGSn5zQ9riGseak2txqvmMfSzzEwFcpyf2msfZE+ohi4fOMzjPBYvhaKd9FAUbtaJCWyOOQd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=T4y+W+Or; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="T4y+W+Or"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1719393988; x=1719998788; i=christian@heusel.eu;
	bh=N7BqVRIw0HyflYgVHHlMh51VKUYbgiP/ABWws4GzLi8=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=T4y+W+OrdbIxTy84XbaJm0m2DpMOtKpytNhhd+zJCSMau2/9nMxecHbCfCRNZGgy
	 0TEO2t7SsehZxHDQBVg/CWykRH5bs5Y+v347nO4QVjxrnrD9KpxiVU5Wrs250fVp4
	 cwnslBHm63pnm35a33J+mePNBYq/pURl+e2tMKmqnRpPXg8V0GrpKVwVoqw7zfQU8
	 u3S1LET1LV5oz6sEkuE9DGiL6gJz21897XmM/dfOLNu7HoDLn9IjYzEGO+Y8NmLIn
	 QAztYu08ovbki5SRYb3jAWI1AqnEY6Eq8TdVTWk5maLYtCRCpU2mf6QuTKXZQetzJ
	 ygUXdy7YG55j9Q0niA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([84.170.80.215]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mc02Z-1stWPr2AYx-00geS4; Wed, 26 Jun 2024 11:26:28 +0200
Date: Wed, 26 Jun 2024 11:26:26 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <eedfed4e-c093-4de1-a2dc-46d69f09e295@heusel.eu>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mhmalrvrwxwpuvri"
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
X-Provags-ID: V03:K1:IfcpHBgE/WTA9GfFHNc4QzBNE/qLmMwpU9E53wPZ8j7mJ9mtgeR
 puw96m1j1qvrt7KRWjQyEgjh0MHtjuLK6yo6eaX0KqJBILVCBrBcCDKfzKA52uCkiV7FH0X
 XtUBhu0nQBksM+CXXaQ7oXlPAAi/R3ro6FE+ftN++tbkrdIMgderHt7lUrQeHXJNiXck93B
 bFUXrkijNP5/+8LeahkEg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ElWnchsaRgs=;rUHx5Un4mUMPLnWnVmcbfr9nqwd
 GzlUwWfz6PZshzpeZGCQQIBMruI18dwSBAEpH+uidOmukSaueoPq+wIRMX1tiGBE0nAefVjbT
 7m8ejnbVpczlUoSfo7SbPThWAEhXNgR3syDqkulT5JRXCI3jqrgzX8Qr+o9H1pGlQgtFNvoCC
 RPT227LAyKiBVrVmf0QpeKYVmqkVwYNT7rabUJgGMqG/6sIzXlHsaE/CbpZAbVZH5/ue909Z0
 rScrBVqUB5V1NoLGDEtB6xJPgT+bO5PAqhf5aF4omDZ9IE6fxtSK8WkvgainCN6BCW2s866/B
 7xKV6VrgKDooPf37WgER7WGUehLSjGpslBKJfnPSw3K67aIqLcIjTYNItZjtPcTFkCsCRnhIw
 WJdLNtlrDLrkXaonzpBJ2nPtQ75xHBNbK/bkl4PdK9mKAJB3D0mfWiVOcyPVUd50G7vO2Cr4W
 KEasKCoLPisKKKzlOp+pJWO/YRnChsg+6qOZTifQhEhq/DiMX4H1wfMAxkfMPlPqICEH4PDcZ
 2Od0yDLOumv1zBzDsmbcLl2mCwzz9ffLSg6TYyuOhbQu/+0h3EmrVWbPNYdQVeC/WYU8MJb8E
 UwA3GlpbfFxo+MVEN2zSRPdtpl4tGm2ZQRQS3OohS3MO6FjqAM6sq+Z00doQMlXq8t9yyZjg1
 RkZ+CB+i/djBXg8vSle0gz4VbyBWXMoTCqmzEZLZd00DRJwZL6PklE1H+A7Si3ON2Z16Kb1a/
 YBfWkfpCuvkWcTnarMKKUjsejcABD1Wryq9My7b56ZNPdq3xwnNxDg=


--mhmalrvrwxwpuvri
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24/06/25 11:29AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Christian Heusel <christian@heusel.eu>

--mhmalrvrwxwpuvri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmZ73sIACgkQwEfU8yi1
JYUQYg//d/4z1lrhjW5TFj95PTiNvTNNfRVA7qDCkXcCoW8KvCVxOpgBbp+rdxtv
sjEEMzq+rHGXfm1GJypkRi1NmOV4F7xBAM008VhZCnDkJoyNPhyLF2rAdvTN2dc1
n/Eaf1QIFulVd4IeCbwKxkn9mbZGmlq5JL2pSWRnm7mSQ9NF3G3BEHga69ctQU1e
apkImyuyqqC2OudfwW6s0kU/7u2Bw8z3L0mq7y7bWZezSSU0mjUSN9HyUzGm7GEF
7Dwg5v9cR8SNMY/3HNtSEosk3+jeyd+S4Z6ykncgJo1uMauazcDOo6L0tI37eJ0P
LwC3SzcAedjp8F6yHAqIaC4aKJjWpaaJGeymUoAby6KG4IpntPV/eu0xO8Tka3B+
Phyo3OyqLXFUbox3YoaUhCTkONzckWKHD4sZDt2+KD1BEIgpylnkdWU70G0nKNhG
5rRJ5LqkVGy7h7aiB6+SbZIa6hnEUCmpo8H0os7btog2QAiVvFIV2UPPOcycwh1E
D6KvXy8pwgY/lQOLg/Is9Dd/tCmzptsp3ABN1GpPHLoIlOD7z3Z1dWU2evsxggZP
pTm/kJXi4G93YexqNuSc0Ptqu0iIu5SdaDC+SzZTJGeiwyCg3YBkcZwVQ2SLLtZ+
EWrr33nW0/+vOk+rwS4T+axn9dH3XywPZE/eNkhIhMbXmk+LJH8=
=Z1N2
-----END PGP SIGNATURE-----

--mhmalrvrwxwpuvri--
