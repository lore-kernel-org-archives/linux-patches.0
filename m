Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA323B7A8
	for <patches@lists.linux.dev>; Tue, 13 May 2025 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747096029; cv=none; b=tb1TV0fdSaJP8t+vUSfXFch8n1nH7alx2eb4ehIvbDcjcIxrG7GyeIKmj7w0HT4EzHwYYX08oB32AzPhGURM9HwOv0Tpx972D4oQbxriqZTyo+qjJpo+9wHmkAbCT9yUhq6E3e/YKOcAR5f+pcxqCam9LnfXEtGHr/n7mttv1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747096029; c=relaxed/simple;
	bh=BXBC9dgyV5bjgXbJ044gw5x83pbJoQpt2Q3Iaohbfws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLDmN2dE40Ab67TuEYSnqvN2DPh5mysN8efY5helhgNQMeANfXQ/OGhDnOlgMKuXfVqT/k/xnj7n8I04FIJXjEeBGqpwmq7KfaCvoWsZCPiIcFqcMAsQrroW1FbdVl7xQ+zX2v8a4etFztp1uyQVPseNpP8qUfuxC9bXYuTueBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=pNXVT8RZ; arc=none smtp.client-ip=217.72.192.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="pNXVT8RZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1747095991; x=1747700791; i=christian@heusel.eu;
	bh=pgvAVXA7cbbwQNM3I6YOEdfAsrkF7KItw3guvxZ2wyo=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pNXVT8RZGEFP39WtAAyhm2Ajw2NEQG0DGk3/4Un7SeZrZ+sv11LRXVsSHnWsGjiH
	 eMWEJ4nOmp+ZJbMnOtMFgCZVcslRfz8rf2pvPQ+sDRRLuACo4UOF91j7H9yem+qSp
	 Iqf0woqmddw47XSMqAxAmvqwMUyGD1KqAfMeqrKc9ZChguNj4npN4xt8OWkTJuXAI
	 cHxs+6A83hEWen5lrj5w8/nZI5Qk/osQN6p2mEgbhJN4rP1goZ7PFpjD9IrJt6ejO
	 dGRUNoULbM9CTkI8nmBTGO79wyae8W2lqBx9FN9ngY74whuDdGSc8n+H2W7F5Iu0b
	 nNVuIo07D9TTXQnPNw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.40]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M3DBb-1uIDqV48Kr-007y5v; Tue, 13 May 2025 02:26:31 +0200
Date: Tue, 13 May 2025 02:26:24 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, 
	Mario Limonciello <mario.limonciello@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Ray Wu <ray.wu@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
References: <20250512172044.326436266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="si4res4pihhmlnad"
Content-Disposition: inline
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
X-Provags-ID: V03:K1:AEauuiyyOgKMa6hAFd2BRFcsfT/3+JDg59UJktMQA11g19OyPo8
 rHm1sKEotm248SEmRnq6nl6vLpBylJx2pKzk8dDhc1OukpfF7/5R4Gn3WIanKSacp2X3nsy
 S9dfwRb3jee2O4tBgSufiaZLSt+Dqe1dL7E7swzv2683KnZcFDiIpZ0eCx1VUdqQB2M7QAV
 jHIV92pxKPqDU0DtU1C8Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ndod2FJe2NM=;3SQ8YHsXXrbt7EELh+btPzlCdmB
 boBTSsIL8hDNQ89Z8i+mWZNegltgE/ZMJGPXlcRwtkagPNSMJYzuYI/FgInBI7dHhY5tScMQO
 LE4A3tM6n/gMrQBrUHhGKov2kmGm1jce/2D2cAo2rrx12XRIKPUAPEVV7hqbLZbWZ0whMvOfF
 vRIkIjgZncksqx9Ao8QXkX+YbFa/mo1V89PNeUOjfJahT5pYbevvFsTKZdkfcP3uGgFJyL4Eq
 /NI1exnpHafZtfx95+qixSHwA41UfiiMndHTVyX+OJ7tH3zJnelxGa867ZpGioi4DRhQqQASE
 3ngzgDaoU0hWk5qpMSPGi8+nUXA8REpb9RzGtV+PLBBV/kqDLQLTcuFpXqOM+3AL3xVQrh+qV
 KmpxJeIt1tbvvs4GfQSpgSyQUeoCuDHlT1bf4hdP+mzo5FyQogwPDso5YMj+YH2GTgWEORHrQ
 7m0u+gdIgvvVSyzeQdBu6r+g+4zeflKH/xTK6tapSX/gKN1FBFsaynEbI/TrAhmk+sWJpag8c
 Lmwd+HB0bqZCpCsFnAw7nbz+mZK4SpsPFwhc3qj/TApDSb+5pof2UUe7n1ZtGHUF1nkuv76yr
 0ZGByBA2Xbfe970QmvyfXgjzxXl/01pUx4RYtbH/Dovd98QSR8F7ysJYM0FR4wf6v6O3F4qnD
 Im9aENqMpgKVuxp/aFZO8RMj/Fvd64Mzu+MEPVRPm2EjPvIOPNycAyZ2f9zlodguWm0SoOK+9
 TkO2virUut7/zXPYkbFnrK9d/NyqfOluOge7ZvEkWxAz4fuyMTkCvVkvZDqB3ZJjPVCDdxXJW
 JzoS5C/Pdabz1VvNhnd8Dj9BTgwA5wvbrtpDqsReLXl0vP4q2ps0FoR47HriufxNVcMEbAdWq
 Q/i1Cz2kxqPeiCPsRCSpzfwuMWsA+vAaf96Oc1ZRdVW+nnHc1ZtOKByG2GDR4//OUslAm5uXm
 w46i+0dNN+KXRujUtdGzlekIBe8H7PCeLIKoG9sH8CEjiZelRXE81m7UrmBT8BReJGrer16U7
 3Oy0UJEGxU8eMqP5JjFZmDj5zvxdK4a4OAFv+VPFJQpxYJ0OrhTC7JTaBhmBc2eUJoQ3gSE5e
 HqPLTcI4/XUGaCM50zIDULvYSYc5yFMCKxe44IDphwxw8ORJ3Fny2YMNLLneGyAecK7dbrJZB
 vHYedI2ifKO+gKv8xTCADD8/K3aqrkSa6YhUTT7TpZwl64J4ZYzDNwt3axk5hx7Hsx64cxaIf
 CwM69Rrm8i//PLztdWFAH3N3aaYd72VxAEvrsYQ2Oy5vij17BIj6czZGvk+o5YpE950KbXmgr
 2SfsGcyPNFRAjRD1jtv0o/gmiRgh8g/y2nSVpcyqPti4HuS+1JW2TNexOHaTBxy9KsLUpq3M/
 tAGKxh6VaPDiM+Z8UXb0N80OMVMfLU3rvXCy9Pc5nAlueLRdxB/Up5t9FjlOB181ijiwKxGX0
 fp4746PLGbBpOUuxtLInRYUPjrZ0=


--si4res4pihhmlnad
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
MIME-Version: 1.0

On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.

Hello everyone,

I have noticed that the following commit produces a whole bunch of lines
in my journal, which looks like an error for me:

> Wayne Lin <Wayne.Lin@amd.com>
>     drm/amd/display: Fix wrong handling for AUX_DEFER case

amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x01.
amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written

this does not seem to be serious, i.e. the system otherwise works as
intended but it's still noteworthy. Is there a dependency commit missing
maybe? From the code it looks like it was meant to be this way =F0=9F=A4=94

You can find a full journal here, with the logspammed parts in
highlight:
https://gist.github.com/christian-heusel/e8418bbdca097871489a31d79ed166d6#f=
ile-dmesg-log-L854-L981

Cheers,
Chris

--si4res4pihhmlnad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgikbAACgkQwEfU8yi1
JYUJ6BAAn7ljHh/+u0FkjdPoAmvX6nlcTu2d8hIp/JhZxvu7TONCXLDJZ78DiF2s
csraQNKOZyqCaS6u+Ry7spSAFNn9nuGBCt6eesMVr/+4PHWpQ+U2DpO6/TxrTb4M
OKUUe5x0nvB5Wy4Vx7YfPfoXufXXkzm6VPZTJT6R/2oDWPO8J+QquiYoQNi161YF
3pydOqs4PBzAcojSzB2WsKBdstlxREzq3l4n+mCD6ZB67YbvDFlMo6rwTrW5rEda
Vn/JB1njybQR5s4WolU0oxDaGH2ZAa2qTtvpnKH8YlZ8gYiJGINKi15twyIjZjbZ
NMH+hdPrBmHNM4k9eD4bA8vnxE2aSgNSTc2Wj54K9i0EaVux57kIKRAj6KNkk48y
hKmfLhEkvvBDY75lpsYVflfVdVwBYa+kBF9eQyLn1qiuoqnr8oTTkMVXaYngSBe8
3cJlcsSTQB2d09nuaVVVc1N+6VNKp7zeDKCx+iv4aaFdr/be4DOl9gvd3/fb6Qqb
6SOduzvMtLtEFv/0RAI3ku+bbbY3u+r77k2sjSQObYK/7OZyPURryRzLT7qWJ0w5
LKdQOq2wkCYkN16vGBV9WQzDpf4taYPVrPCYJhHLYdI6+mI8kFyNVZenWhmT7VZz
+hEJPuDjYKAUcnqXpUHlnSyxngco9mylYW1uOFvAQNzGUMvxlCc=
=Dfva
-----END PGP SIGNATURE-----

--si4res4pihhmlnad--
