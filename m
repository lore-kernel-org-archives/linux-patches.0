Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BB0A92E
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097044; cv=none; b=imwCj5ynGo59JDsNOLvZcpRDGeNkcRcNmoRRYzn9VrAm3dhnd4365zgzqjPY/Nhaa0G6LEgWQRm9ZB0/Ok5J+LHe+k5lj08C0x365TGEx3tGpOGrHWWatYXlj54kShMc1coEOdczmxMxi9TwuXoR6tiHbHObKei7HyMs74oKxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097044; c=relaxed/simple;
	bh=BCKdLwnKOpH2DZRNMpBYqQ3w8IBLQXrWCCBMIu39cbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4xpa5LrtrD7bGd0pO6UUQDjnNhFXVlI9yFkZku//MvEw3hz2LJMMlio2ROU59N9OHwis0vzZ1CuWFfm09oe9g3GE4pwmZ2J2MxMF+qX8mtR1dO/DSUMA5GczknhodcjMGvp+NrRqDVHCBIIrvfm2n/eOeVOZmH08POuuefaBCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=0ueyFfZ1; arc=none smtp.client-ip=217.72.192.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="0ueyFfZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1752097015; x=1752701815; i=christian@heusel.eu;
	bh=sm4GwRQAXXIghgdM1jOWOzQwfMi+m+j+boo2hCKzLs4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=0ueyFfZ1s6w8ItX1+b7KusEEDl6064tp+njpV1+h43HOUimrQXLYSmj1R6A2f4GT
	 TlE1QRpuAo5SlAI5I3q/TpfwQFgbkJUmOkpx7wRrfJEwICeZD24pHkiTdF+j8SOrz
	 0hfrspcPZRMVzNK9vVvXQVzSUMr5zrictX4LYz9Nz4fdArFN6jCx9V6VQEy1Xyksq
	 dioyMxKFUDp+lnx48oGRf+YahGhCYy5bVrV7M2mONL/fmhvetm7JI3apIxP7g+RB9
	 epi/e3j5KrRsVCxnskiSUoY+gAAMw7ph0+ceN0YSwCfQe8nSm7qB2keG4Pw+W89lW
	 ahOCsh+L5MIEe6shbQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.33]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MTiHb-1u66gd3xu9-00QNYE; Wed, 09 Jul 2025 23:36:55 +0200
Date: Wed, 9 Jul 2025 23:36:48 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, linux@frame.work
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <ea43ef36-a5ba-47c7-a0d8-f1cd920c1dde@heusel.eu>
References: <20250708162236.549307806@linuxfoundation.org>
 <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w57c5ejiz6ileb2l"
Content-Disposition: inline
In-Reply-To: <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
X-Provags-ID: V03:K1:4sj1eLiCZ7i4ecolP+0YvYlw2Ukzge7jowpjvkjOQSorsqJK9Q0
 R1r0mt1vwMPDtWejFI2Xq14knikpGnY7VaguDjxiq+uYq6f68xEibAxvQfLfGlGTgUZ5l00
 tGAZOi5LO07uGRo8yj0uWrLJiFl7h4/7yosMk23MtWrkrGl1ALguKX6RbLI0zPIXthET1Da
 KLUH30WyEuBM1Sew1Bmxw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jhSZ6yGkhRc=;b/+SrUtl+wqbn1YbArMd7vzyaGq
 Zl0iFBGrL4fFyvES6okwXX8k8UWC9589DYqdLVrss0cXewuVKInXIekZ58u3kIl/0t70/Sq6F
 0Alkuwfwjotp5QZhTMd3Ga/J15DWNw9hbuv8V3FgPTvpqy+cN/yFRUtzu/YR6EdrpEdQVNKvN
 Ak6gPtRMkSHmxrg6cyL0tun2y640PJobJSZ8ur5DaY1ZRY9b+qv588BXB1yxFEIclmUd6Lp5w
 n0t0trG8G6w/yjCjlPCGVXW+lYA5ovYPwRpKMev/UQ3bl8VgP4iTL08iMuoPcOXWshGDP8eJt
 lrodyS68XFSAvIf/dSipcnXbAovfJzRfuzBjCq3gc6sdKcCIMxnwxQtf1HKZ/VvUGO6KLTSWQ
 72GhetYP1wNitZJd3o1/k7RZw5q3f82enWwt75UOY0m98vvHDVjAHRDiQwb2pvW5wS5tPsHqR
 qXxHxG5i+/lWLGKTsrViXZtUFpqnlk3KlHxJbwWU9L6LHMeWJP7SQEn7HZyY2YbH7PhjSfxSh
 QYn9AQs3nJ//0LAYrELtbXJqE148EVsPknstT4s3YAdbX4eM2U0AOaSRMREvdwK2XrmM+Vqbz
 0sFPhrsH6LJ1nU06Dod/wC+3hjch5MC3pDMn7qkKm7ly3EkPf2BcloAIvxDebejnBOgjzZZfV
 iP1mw1vf9XaYfv9mIDPRvtENNG+KADpsu06TUFPov+w5lrtxEBQIAuFXmCcQ58oh8xGGcK3+A
 WUhMifhELD2p3DF2F4Z3ABaWAkTooN0WYHAIcvACx3cHsPXb5h5g6lhRqw4GUJ4rF75aOSvai
 +Ua5i0uWrLCZfWcwiRlVci//Sn+SZ6p1AWMH5Byi9is2FIbM2vLWYo5yAuTyKzjpz6pg+I9R9
 CsyxIw8C3PWMBrLiXZYDUd4T10rr4QKqJ0FCzrkS9xXC6DDuzfw4gXADCqKZHNvgJIB7rNRdt
 OedoEZFMlBYJWWZ/hvyMy2zWc9tqM+97YcEphxolIHh83y3c8ia63Ay1zAlZs21bn3mjLhpxq
 lc14a1EREZM8cSkjmQh5nWHikMUSgs+mP+9WANuOm+5R3WvEBNYnbwD6/VO22yWab7w1adHkV
 CTMbvtTCEgW10b/aLIK2ujLuUM0Xkzju9bHhOiIesIETRSvby0AZz9N4l+aLvCSvD4mwkzkZ8
 6DfWhcGKG0ag6MTs4pzWsV3DMF/URMdi8ZoDSo4LaTITdbGGwcDtazPacomSg8W5GLP4jXkkz
 1+xqJR4sTOiYQT94tnE3AFpoQuX/iKUQ9VWamsPYWTvYeVxpFzcepkedu76i6339O5iCMKDkC
 5/2qmDEeoNq7AYcP93hsmogjO6KLhuPjnHy82e3PY+3Dm2zi4dmNq7hB+VeE0jEId9nwZXML/
 /betxxKOTbWkP71FKbYMxctvno5+kTpsKK/h/Gym34+bxM/+SSKmiZO6Es7ucIm3BdlNcQrLg
 T+5BMH2qv1DWSq8Kl1xw9kp+nYe4KMONidZtDtF+xjQ+uPp5qN5NXt1rooHAb1Af8kvufXRrp
 UL/0gxasAH1gfFHoyD2fgJ+9gMLnGqEJnksVftn/FPCYBFioruEbFLz/3boT3Q==


--w57c5ejiz6ileb2l
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
MIME-Version: 1.0

On 25/07/09 07:19PM, Christian Heusel wrote:
> On 25/07/08 06:20PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.6 release.
> > There are 178 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> > Anything received after that time might be too late.
>=20
> Hey Greg,
>=20
> on the Framework Desktop I'm getting a new regression / error message
> within dmesg on 6.15.6-rc1 which was not present in previous versions of
> the stable kernel series:
>=20
>     $ journalctl -b-1 --dmesg | grep "PPM init"
>     Jul 09 14:48:44 arch-external kernel: ucsi_acpi USBC000:00: error -ET=
IMEDOUT: PPM init failed
>=20
> Maybe I can free some time to debug this tomorrow, otherwise the
> Framework folks are in CC of this mail.

Since we have now concluded that the above is just a red herring:

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and a
Framework Desktop.

--w57c5ejiz6ileb2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhu4PAACgkQwEfU8yi1
JYVF+xAAvZQ4RKLhuSEVhEpwMf90OaWn6nLqbwp3ixxDEL7TsOceiAVauTamnoLX
s1Zby231m8sR4JAfSQ7+zQcY1l+P3+OTk97u4ajs+tGkCOT8eCE93msUL2ggxnqL
ZtVz48f0dA+87lUnPwCARgJHiurIgMZOUT9/37+RvuuGULawE51Ip/SZO6wRNhCw
2d6jztwVDZZI5BB9JMeLhx3ahxvbCaJZsGiwteibsbPLU+QGm1rjZ8RZs8b/mSiN
KqKAo7j9MJ7URggsPZVDCNtNPUTlFZ9m5PUXWnbtrRURhVY8maBGzlyRgiS28KJB
pq3pS6R3rqb+W/yg+WvhcCkv/AcsmAPHGrUQG/x6PyvF9QKdEVov6YV+6UnlnIdV
Y4Bpv2Z2n1YyjxRKEaWQx85zxcmkyMZcIqu+FutOy99rRcJiIzRNbT5ACrrFGmB3
EFMPY4HL/vmTSVCyCSay1ow8bD2jZk4Uq66qmjyXs0BjeMWcfLnt5NeV4Y61pMOf
bGjYfT7lbpyG0LMTfRrMRaEkRsFr4C9iXZz8408yZX+vItETVsv454jSFY9/gxDt
DqkeVliQfhXNpetk809RCyVNYn27LaahO30+TnB9p1VYsBV89n5W9koR6q7lDCCC
d89ZI3JrVdniKe/aDXP5Es/HgaX9xx6iD/q8UKGz6Z0Er6Z2rxM=
=M3JH
-----END PGP SIGNATURE-----

--w57c5ejiz6ileb2l--
