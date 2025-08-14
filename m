Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A555B318133
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 10:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755167515; cv=none; b=Fh/InRp5YFYU81l9VHxaffnOT/tolGH/9SutiCVXoeZbSrrNvFz/HJv/72pp5YswfyP+u1i7xPSJT/CRi56HE2n2HbjUipI24R/UP9d5ZFfxzd9WEzpFPB6e7Ja1iltwnFTaUVAy1cMeXtafRV36LlH0l4mE9euAGT6CxbCRbLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755167515; c=relaxed/simple;
	bh=a8nJWGrKgjaDQrULPZIHosDNKPSDFC4N/Axl41KsowY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZOhuSkcne0oLSs01f9I8wkz0ahYLuN8FuCQz/nlVHBSynud+U295CKWIj+CobhGP61oi5qecIEV9dk/yraK0wc5PahEwvOIaCyn4yymKpo6s1aO82qsR5wTA06gQsJ42PubdrOE9XePrhCQ5oOVTT4gmWx3uTrUMODI40AyjTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=DdxLZbqt; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="DdxLZbqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1755167506; x=1755772306; i=christian@heusel.eu;
	bh=GoIHizLFJF6SJrp0Z0/G61o1a6vfrBG25gjN1/LQrZw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=DdxLZbqtcyoQ4BCUltZMbvYDBHUYRRqLh5/uyKspSxTydC6B19K3U6Btfh5Dex+b
	 JQ2O9mCg5x5dEsbk4TfnAxqux6Q/AtCcy2fHy7w76w9cl+Jn4pdFyEvOgGanb1seT
	 GF0EoeaW9vZPiOyJo5T+WWbO34bleKoxVOavMySC/AwlbzKDlC5MMpuNL1or05xSC
	 xWmS6Tv53w8gQccoW+YS8z5jQTPsjwwGC0YCNesF9/V1zIaCw4ljy8C74pAkh1iu0
	 VicckVQPK6wzcfYb0N5j4JNLdG9m7Wp0/zc0RtkjK9jF4ARDlZdc3AMdKN1BxU/8T
	 g1CR8wbai6EsYiLIlg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([147.142.166.140]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MryCb-1uG8sd3WU9-00gQio; Thu, 14 Aug 2025 12:25:18 +0200
Date: Thu, 14 Aug 2025 12:25:16 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Message-ID: <3641f985-9a0f-4cd2-8c0a-62c81f372b33@heusel.eu>
References: <20250812173419.303046420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="psqisqcmbrlofjwt"
Content-Disposition: inline
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
X-Provags-ID: V03:K1:5FKFck/tbvqqUq06Xdda52whjUXiDXIPAKvgy8Jlhs9lUtyF7dL
 sGEHMawhdOGnbvepSsSFX7zSsndP+GVTX4GjupmKnTT26q9e7uBufUq9DXu6wTGO+GGF7Y1
 BD1mDhZoj5Qw5z76/a4LIpD4CQuACxbKRlUptBxSQ3M7XgP1xOH556Ap7iq2L4nxTxaffT5
 pYXRfwAGL4Dm5OWBU0syg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qfphPktefSw=;iA36aDLRJ6GuX4p1nkvYiAGxNvM
 d71bMU7WKD+IxGcgS/bCUOjbvQ4pNqtshuBDGXG9ncufr2DY/ctfEmrepB8yrz03oMGwmXkMJ
 CdKYNHPHlMlUFsnY2yJ2WF72ce0BAemoREUbM5H/NHYjb2VTW/r3Zr0EUkhv9qqc2i7qo7Qpi
 oMEqUlBw69gVM5fVooUa4XGtv+wlG+uH6x+yrvpUXFVZMDkd7t1Lhn974IkBJ59DrxscyKW7Z
 bdOqvz+7fiafOUfyGmQnb8znNXqthkkgxRoPSN7cbD9Tk7w5S3VjMp+NAX3fuLkbhLX88J6DF
 w599Q61EpicPixbkBB5fnucIQ+0m5ln2kpZCk7Qyw7uRfJarssrsS4ek9QFvMW2IU2oZjOhZs
 fYEFKAEa7G/n8krjIdvoIENOuprqAOl+OQ8ppGOoSUx5L0Xx7IieMrDGQTfw0MAAaj0eDGdeD
 97wMUQcZQZSj8p9nlVxYnzUPq53qDqpDTf80cBHa7m5qBoQNOcFjxcHtRQtmA7r1mJEZ+o36n
 KoziN9VrsvgslCtuZD3I6Y6sbY74A1BSemodi3lSYaS/uAo9flfcREecFNQ7TNTiW2PRiPgEn
 8ffqQoXwydaNC3Q4VQ1YFRMT1imTEOLk2/L4uKR0KpwCRqVVlNZZUL/i+6uo+Af6VTQoETe2u
 Vom7INJ8bIWmAkIMRLW5ZSJD0zNftF2CsnqK9hKIKmDa5BpDDYxxWbrypyBf8t3Q7cS6ca6iT
 sxvSeYuCcsj7PJ+3HXvn2jmtHmoSiPdkGOpLrFVDBfnFAq8KzOFVGI9qjZd36o5unK5PtI4ZS
 a+PXTHRk4hCXT1LorBIwN7L1ziIbgni7pqR+E1lHNcs6PpoE6mrEfl5V0FW79t6tXgX6C5hiU
 6EFpMi7sdsyxjfWl4iWLVJhmGbeBfmYpl2e+kzx58piiMepLJu5azj2EczWwdBdgF0Wa+0/CK
 MELCpaTODwZx4nW7i/DYAMc1JSoZH1/FNioDHWxUC295pSb7lYQWmQrGRnDjeIuBNGpIjpGxH
 xvdk3AArc9K7DsRk0EpFvWf9VIpLdiMKK4hbXFAnzs7yGcfyNSREHzIb+9fWfSoQwwaAXIaHJ
 +NO8299cwoifG9eRhuSVnrkFdTok9t1ZlBJumUqfMU48WilK/TxjEUk+OqWsk5Dv7wUiR10nB
 3eR9qMyKvZRcdtnAu7xCQEvDuiPm3Gek/B1aKvkzCjvPCF6PhqeMlIjKhpqNF1d3iojfFkWGB
 ayFCR5yVJw+/qq89GSZyWY2ImGBJNH44WtBVykPNC9Z+E91gw9q/iRijN489S+xtUDiAbYwYA
 nI1qvaZ7t2wJgYnYJGd2mC3skdqdZxOiBy1So0TMhvj2sSRJWyzaNd+eGNgeSxhys/tIamJaO
 cRKKUGqYfYpFHBxCpLHYoWQCrC8j4wv2bkWz08tP2wIBDgm77Hs3wRDMf2s/fknjJDC4FvtI3
 3at1EFs2FshZASLV9dF02Kivqh1cKJmKpcZXyEiKnmNi1OnwqGFB6W8pMc/3c14crrN2Em/Re
 jtrRk7SoID4Gpeh6bLZqJ5PB12PDdA9d5T0BQHL8BEOt6e2WJYLk/Xno8ahaAhaBmJ7XGFZ2H
 qPIJVhaSBE6oxNjDBrfrh5wco1P4txlaOwlqElU2SuBbO+UJqPNm3nstiM7L6yar6Glh51Ccc
 SuiUSpqOoCx/WG7xUiB5SEpq3qiiywCn7czzUO0mVO1A==


--psqisqcmbrlofjwt
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
MIME-Version: 1.0

On 25/08/12 07:24PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU
* a Framework Laptop with a Ryzen AI 5 340=20
* a Framework Desktop

--psqisqcmbrlofjwt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmiduYwACgkQwEfU8yi1
JYVL+BAA5WZ9NSOEFQSxZIxrV+iRxPDiRDZlg9xGG1KdVjm9sr+8yLcWwkjLv5m+
Xh+/7Mi1pFA7TXpuwhRTqBRHwp00JJLPb9reA6objvItikrPud0N/NxF9zbbutvv
6UuoUF1/jtVQ3aZH5bhvTfjj8GUrhvJtiT0zevrznM2WDoLGMxdNm6AAxqmYPsr7
1e0UdW3/dKrPU1kn3NdKWp08phJEtlyzNuIpBAsoTfJDe8eEpQbKgfFF/8Kix7Ep
sFMnjoA4FcS+EfA1rNhuFGWSuxUSVDRoJCBkjtBZDrwJwrTiTyKWIZxyhBJG3GF9
Ec46wASsgep9voFreOZPmsn4WT2CmcAQtXJ5TBufcJOXP8JL0gcovLew3O1YRKAI
+iEiuyqZSsq4ORVK/P3giqacKFy+bewZWkwuMWLxoTQkaOi6C1NzJrnj6EzdBbgx
u7CJMb3VokIb6r4IXB0gBTxKTrqPIle+ENr5YDbC7CBmG9hCYkMNAPyNSWW3EXo/
Dd4SqENXi8rtC9gDf4pTeuLJxFH15O+jqZEfp/C92Z1X6AThRFTCnD+jIYYO2WEY
AwGTl07CuE+x6qyy+MEEEOq7c3t5v+IHqSzCW+Xi0ivvblakXwD3pDTKphS3q4jx
cBcjc5R3f3VaGFjPeLcLaC/3HaXZJcG9CvL9W14HQ3f2cXi7CG4=
=tthR
-----END PGP SIGNATURE-----

--psqisqcmbrlofjwt--
