Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EEF35AAB7
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438809; cv=none; b=CO5ky9BBHAAresZOeekoSVeeNU4ZWO7t50+LHA0Gu8SonzrhhzoYp2aA4XFOkqapBZSGFPGMUwid9fa/KzfCpRMvgZ4pTSEGEAEX67Ie62NY0uhOe7O+R8DGuoymfuBcafbjIi3UbrXWM0bBT+YLOtJO2zTyGm/Ui1g1P9NBsSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438809; c=relaxed/simple;
	bh=VCNfAPp7Sy7myyBcab3liNIt34iixbHkF53kYAnr4xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv0eXFGa7gJj+AqQJQUbWnkX1JKZvkwb55u3tm35ZpI7SjVlYQtPsPI6UiYGe57WKQ63KQ1IEmK7GZNbVk9RurBiWZDdAV9tLK9In8aVob4RillA5eaFh6aBgOgRY/oV8NCdUr0JYksU06ODwdA5ZLOacbJ15fxZEpOaQHNvlAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=RKEuQvvy; arc=none smtp.client-ip=212.227.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="RKEuQvvy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1757438795; x=1758043595; i=christian@heusel.eu;
	bh=lxQbLs2Dv79VQGRhhMh8gXDo7JU3ntY3xU8qIpmceN0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RKEuQvvyZZ5NvCIn4HjE1jTQsmxBlTg1sgz7mTz0F0YdiqstWBdC3Gpr6gW6+YZr
	 NZvyQHIdnWDda9K7GxyH4BI9h39CZJacT3u+Nmj0KYz86NylxR2RuuJjAxOkKvFy/
	 /VVSW50BqXBbsVfqUm0hin9Z730+6MFz3QFlNUGRO8u2XOo+I/tHKgJns1rza1sLl
	 VCJKmRLKLFbncoeA/hJAFRWEHjquLEltM5oy3TgBfxefzZncHLam9MvU/RtvDaesL
	 xjqm57KGkOjc2VI4vgbE8niYkPcawuqFUxfAYNnA027MAkRogESAYb8xagOw1NX/q
	 k3y8ohTCOH1Aw7lN5A==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([147.142.151.221]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MjjGV-1uYlij3Vsp-00h5Bz; Tue, 09 Sep 2025 19:26:34 +0200
Date: Tue, 9 Sep 2025 19:26:31 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Message-ID: <04e6007c-d217-414c-9851-1b5fdf0600e3@heusel.eu>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="grsuunuw4s6wploc"
Content-Disposition: inline
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
X-Provags-ID: V03:K1:h45XGEMGJhtj3IMOWYcKSTkQmvDIYCaowrPkzM2Y50ci8Rqf3Vv
 fE2JNic27if6tPKEU6f6WW6LtuuZwhULqsgUP5jKHK7hjXO5b0oEJwLQjRGSNvjzYWNcKN6
 R1G7/W5aBZNcBZOeiWfytpFFOQyK7ixgnozm3QnnTpM30jvEpBRAxDRbhOLR9sgbc0H4rji
 6hIz5W9gR74jaQmVKZiIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Febgp2Sd73Q=;mT0QiTtnzcGJ0QhaRfjQB//nM6E
 qob8q3SqQXbzg5xrJQfjiXT8d2oEct+OgRb4kowJ+iTb71I05N1HQn+PkIm8m+ParfwF2JHB6
 C3tbTnswxXsuxy8EAOqavPDKXviClOV+piXaFUtPNMq3gqqh1gB7Ma9SloHcbcoG7u5h9lgGg
 0PVZ5MNUPDImnXE6sZHaiL4ce6sw0jHV6OXJjTiTvj5ZYcQgWY6sOPh/T5nrz/HRe0fIlKJ4M
 OT9ApigJ3AqkUTMTjk++Jb90oB/1epqzfzuLMZk9CFHyfhNvmpJtmMjbbgjgEbnPF+cyFfr7t
 r1hR4AOtVKhhPXWNM8u8SoZ+PclBWTAd0hNtRiEcUrj+WWKb02IdILsKP2FYuErH6eLCZ0zxb
 mA1Vu8dphMRtmTJhxIaUcnTKoIKPna29Nkn/yjeperVtxyjaAiZYXaPrwiSirpntXSDgiIs10
 UOhqv0HKeu6ntCOlt/oJkN/sQBn6h8e4NrfagsvSPfqor+7ixdrGB6tBPPT/OTuRd6RzCnogL
 WQj/0OVwMkQmLVEwEadahsYZn44WFeD5K9a4IN2vNdJVYW4yJfCVAaff6McYa7O0rE0Wrrg5f
 9kTC//YY2ZLAPwtrNLFWDMsQ5gaZn1pPm0yJ6/mM1CRNecjl/0uSr+P/8BUxCXSiDejlVpuou
 KHya53aNeHnK732y22ofa2NQvDU6VjKyBua/xgNo0ySYPsRTdr55Bsq6FBlZDRpmtR9DkfQSS
 XD9U3mDckcfa/SyDY5JK8K3iwQRlNrzh6ptxYYBH/8DnnS/qeSQ3s9+fTWip27l1Gv9y5tTGy
 WSjLnApICfPp4SwotqlEw22f5Aj0tNWTPrwO+hKgji7yYj2Fz5vK7aG6sAQD9Hu/mIFRFoBGB
 jWI7+StwUESx8nFQFdGKVUWzpqPAv0PnNjVOCCC2IcgyIGyQD2xGBYyPU4G5wgCOqIgdjEmni
 1rzTuSExN39PMs+bdAaBmGJBbTncEPDhqUw/DlV7pr1L1IwBcoYuMA3qs4DXKOQrnQiW7Hi4W
 QzZ1PP9VwPxyA5HoTLhols9kEoi1+NF0KGU5M9ADXU2smF9kAMk64SOMfShID49r1E4ffsr4l
 /0EEt7Cu+hZJoAIVvcw4pvAJzcsraZF08qBHyOC49A/eOVEZoR3aKtXOe8K8Id0TIMd/mvmX8
 e7icRcr1gGcUeKgQ3QZtp4XPOFZQ6DFLFPnaCGOTTPvGgsp0t9uQIYEQ54n6eZuMgQm404Jgu
 TlAexqybcK98nMzdSY3VN8dGBbFiJW3hRTG1DxuL3fBtmYXzzHAxdIzuDIaij5xPfD80v16s7
 hH1NNtixf1E5vE9saHJKP/VmxwJxKgFdSNcWDIdckNHeFlnBfpJpuoXlMBxoj18gSByD8CNdd
 ZiRqQ9odTXti2Moqz2L9+SYUlXYjq0CUff0YCeZnDNFXNo6Xy6CJdRjjbi4BkSff3VNKvQITG
 hcEnAkVSQjk6nqHfS1aKHBbFkjLmxNTBDumH/iPb1YrohK9whllmF2FrXo6VPcYyGPIOLHJkE
 pKPUFb7k2NzOCVus7FFFeEq6toPjnZ369VXXkE9oDOYqkGNykNlWxOTfoObBPprBOTarIj4a2
 N8gm2C1eY+hia9828y82zREF6mLeZjrOoGCnzt3PUNaS/sR7f8q1S4WSu+YF+Iyh4NEwz3UwT
 /NI4hLzNDmYrxxPqegBBagvzJ5iwqWqOuOhoMgY6JDR+jYy8xWPMd/YXaf+QhAkIlr4q2ympT
 pcBTsCvLAebUx6xqp1BV59TiX8uI6EwmeHyP5GxxGy+RIS6csx4yTpNM=


--grsuunuw4s6wploc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
MIME-Version: 1.0

On 25/09/07 09:57PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU
* a Framework Laptop with a Ryzen AI 5 340
* a Framework Desktop
* a Steam Deck (LCD Edition)

--grsuunuw4s6wploc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmjAY0cACgkQwEfU8yi1
JYUnUg//XLkJSUzKP4+zK8prxCSoilDul9VXaLSocPc2t0EfYCJjmKEJ2LWV8kuX
HBHuqH7bwouvi9IgCxPKGqug83TWA3LeSnJviQt+ykm7w44zWOoA+r7o+4AxeQBb
HZyalTYYfwPXVmOlY8vHNNBQErHkNo4MPgLRyV/LPszEv08OGJ/ojgsdZ28Vao9N
HjytdkT3HtiM8P3JclJpN5HCWRv9DL6f0MJerFCgpCoqwuI+hjlHcXdlawZNRfUy
M7Hfu8V+CHRHNqZ06xFGRdcMD6le96Mm6Sz4r8nLK13THjabl0MCHD2wyCO3r2tL
f+9sTH98oEHfqjMR7jUpaECGEqLiTNG8DIzTP641U6TO5GBPavIS4m2SjrUWd8Zy
8sF+FIvrrk2s5RHn3tCNpE2I5HiT1aKj/DNOjPDxKH7qjdZlw1V1ztpVv2ydKvBs
vLPOsirtx8hQB18XY+hjuX85OVPvph3MDB00t1T8Z4YzRrihqgeapA/TVhIVSC/Z
vTzEO671gReQPG240OfclTn4E0Ru93S3JlLcFFgbzFb1l/dw6/CB4q0dK//gonj7
vIg+z/yjV2rhY9WfLSPSeM00DzqqJb+fE6cfefMwDxnmhg6l0F8SSs3iGorhvtyJ
zmyIh36ygImPD9wuyZZK00pla042pjci0V4zjA9eIf0wCpOZLZw=
=qh7l
-----END PGP SIGNATURE-----

--grsuunuw4s6wploc--
