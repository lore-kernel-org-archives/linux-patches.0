Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61632288CB
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742496934; cv=none; b=Z4XRHJ2YHpMeji+becQkgpNxI8+5XW0H3COWxfv8BE6O5HRIgqjZozbf6JzibwNDSY+NdbrCMeAG80W02hbXAPrQCF1HIoedL4sM7BYd4iI0Go4tLD1TU9vMi0iSjk37czWsA1tfdHzMucmcCTWmNnvetnuwuNHYKj8K/aGkeHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742496934; c=relaxed/simple;
	bh=TJPs+6wmIiv7YBBthqS5uAj/EfP7DIgfa/FVnOx9cNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DbmTJTFpesv6FaBwiWBxhlS/YlgHnWnOIOh1j7mQBk8F98fScUNDJzCZIjbsmq+IMuUnr5jwHbKVT6JnwtYwxC3iGIEgPIqk34JaL5/px03pHaKA7uw84qKyoMJjLXcoEOvC3vOiULbMZHyTAgu6mxtvJT125rK26lvL8UDAaug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=jqAECL/K; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="jqAECL/K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1742496889; x=1743101689; i=christian@heusel.eu;
	bh=dN7Ji6DtQjkkoXTgLs8+LwmmvBuvr5b2CCS+MInyr4Y=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jqAECL/KDr31zRO6qmeadnlHHHvWnb7RqG2skDKRwHLHsUiasiDsmBUBtHORb9Qc
	 wwQ4H/6XftR1Qum/fIObSwRSMnGmbqHp84tVCqkD+enLTqTeXElZ95FqvxrgGwQPL
	 qlGhahkG1aNe2zJ6qhb2NmldbfQleU09Rh4c/Ywf1syUDR4XophgR9vc01SwCcFWW
	 lBeGSEMOD29n57kSbN8AnUpmXV8GXGfFwrqFomGY5ith3S0SRyTDdNwWPUIH2qWUS
	 K1hT0aDkfWO9pWiyY90CU4aJc1sfw8pkjuftzzsjW93ZpqwKw4C3t0FQlAXQO78mF
	 ZGkTZQdXl8njJOqJdw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([147.142.150.221]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N5mWp-1t7d7S0mXz-016eyf; Thu, 20 Mar 2025 19:54:49 +0100
Date: Thu, 20 Mar 2025 19:54:46 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
Message-ID: <7ab191ab-448f-476a-a54e-31113996b110@heusel.eu>
References: <20250319143027.685727358@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xw3vwn7ep3f4np5v"
Content-Disposition: inline
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
X-Provags-ID: V03:K1:qS2mWgbyy4p+6ATI4UNi8W2UsUcEoRtG63M2FiZ4bB/p3WEqOkD
 MFXP4hUkttdmZW+Kt8ApPjcvr1F58NOr4B53AOby9TcTVQybuP1zK337lRpSz3jDh+1MeUs
 6YYKwFqi5E3lJh22eBhMkj5YmYKQVjUyDLZSCwQ9VR/wylgVev8k80Dxc0ay4fuVQpUaLth
 8aobssraWGqkAe/kkQjaw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QRTx/j9ooG8=;35D1lDN6NG7tGX3YK1KlaXLkTv9
 6zHW9xTDkloSpKqXiWYdDHO8J2HBA5OePiP6fy0PFO3MUGC29FkQeEPI9D0gKOP25OcUxeMCj
 MAhFmi+Psjl9YpDur4Bwnhun8rKlN7xTZ6pKBq8PIHl00l0t/8Wi1CCHA1VqnDO0scSQhol6v
 GcalbUXGTTCf/q+MgpqqKN93rcnFSbW7kXrNy2HFQaLaiQSFVyUIZQJJmMCKjnJVGNnXh5wxP
 +QlJAfOVNUcufg7tir8ldWIg04k+TquidTBbxrdOLlnRp7Vl0CDitL3f7yZ0+F+FoBdlwxkfx
 s44vEDrfhYEt0D8XuMOG05x7FwN/yyWhsRXiRuQqpIuTm+7ZfmxXKlNg88367Aj1GT3Kk3DGq
 3R6PjMAxvfOBpOMtmxnDozMKKuD6AyiYxEw1lYhK8DTDn066jwtD3jFQTaLHTBtOASA1rpF8x
 lHGkO6eQOJ4gmWTblnuJABpP4h/7NWafpaDV/lLXNzDlqZSrxhKe96qmcKQflh9/fcTZIfyFQ
 sTqYOsLc2gKLTYwVVDTXi5goOHTFrIHz96tRmDedwb/uV5EWTTLwyJjE+n3N/cG4BIh4iisc1
 3laHJKtWUxqs90ahVg3ulgxtD7bq0Fi8BAIq7Y3XCui93xwDbTols87VsbOmf26p+jxyreNDY
 NHAtB3Tp8dQQRlFWhdLyIXU53/MkxNIxJbTaUZyQyC4np5RVNmeW3SOduN0ylMywtoYGdJfqg
 O/t5BnN9+QD7a1KAOlLkz/LnNzVYcAurRb5WgP1gDjPkZ5NxK5AjxMBy81oBRpRf85zZrILAl
 /iwgbsyLKxiMKF5qCyssd6Nm78J97HveyaGwpUWux/OXUTsJahRfYrJ+bdb1ZRc7ub+gVgdzT
 VhDIZ1bRxEt2bSpX6Ugvw7B48Ay0pWbl9AFOOHjwx7dIQGRGRRWCq8sjqtXeiP7Ks2RwJdz5r
 E71wOfPGzVg4eRT+wRYMPrdxWqmh+W0MwrDcjIXpcVCjsFb5/aB58+WVYeKtMLm5Bf91tdNSC
 HDqXPAQPIdKHG0uFB/faynAPRFaAn/fpzSJAmSeOCgLbLWVENm0VkgKWNwkmnJ0fDF6YJeTUu
 CjNoXg1yowi/GAvLcRf6k9uQI8HvFqbdQ41LnKf6lvXdFM+L9aRY152oPSlxSJSRfKeGlZ/NU
 GypOg7q0rw5Xk7JRLf1RUbV8APj9TbeUvW69CRq2noO3m3o4M4PiOxOtTpcASFpmVUT9oLUb0
 k/wi/dOQxIoVBbRvmZhjiFbAAbDQr8UoeWRBp+KhrUqNDusRC8Gh1nEPfSQx8xJl3LHf0epp1
 esGtw8YDNNli5j1UwAxf4tEctDDHoTSmyJEVmYQ6g/YBSYCrc9S6dCC/uD7qMm+NRH9QVTYVK
 gWtVpZUT9t4R/7H+bsv4Em93lyr4OYTj+XPsg=


--xw3vwn7ep3f4np5v
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
MIME-Version: 1.0

On 25/03/19 07:27AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU, on the
Steam Deck (LCD variant) aswell as the Framework Desktop.

--xw3vwn7ep3f4np5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmfcZHYACgkQwEfU8yi1
JYV7ExAAsTcCSYipslyJJfjqj46cseSWoEVf/H3DawpIPeCrTX0vp284cL2uRz7n
6KHXAWp0KP3hSxXo5i/NyPhQ5SZus8BNYkbKmkMSUciC/vrTY9b5PrnQ//mndhUa
luM5yE6SAShkbl69LuMIxr8Jg9+/Lzk6HYdLeiOE+dvy/tR6izcKEhrulDn08qCD
qrIGMYGlvTNtAKrrwQYnHqBOv3akXUtXv8xrdoa5e7XeyArFbIXwU1wTJllLaevn
UQdAOjRD7PKAQYLV0HA6iY0Uic1yICZ2kEueSgfn7iEuvkijeS2rXLjynoev5YSA
J9LNHY7UQTQVzVyvRr72TmodRUwLFsETRwpYqPbhj37p7tYVfSV+YCHoEfI65IgS
LkMlZe0QdH8ywSsGbBs3chPcrA+y/bKeJ4pzSnuLLBOcrZPwK6qcxm9nQGcFMqu+
LmC3BxekambG6f+B4rF15vtuiK0QU1VlkJeFy5IGGJKSEDeQmqHmpbz+6i8AJplq
M9SfI6nmNyI0NNDiG7QtHYvnmD8Hcyst3Oiip+1gwfkN2WVn9v8vXiw1l3H4AcOZ
qAzA78xhnjZhpTN+WKPZNJVhQB0tdrpC0E6H7LSbeGh+3vS1WH5LrAhgCiRz/Zhy
uVfvQL+BJFJPn1AyVSXa6CYOMYKGHdQHghY0qOy1to1SkqxwJpk=
=ejVD
-----END PGP SIGNATURE-----

--xw3vwn7ep3f4np5v--
