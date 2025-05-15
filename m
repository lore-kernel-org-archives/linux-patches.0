Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA65F299925
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312883; cv=none; b=tISucMv3u0RhzA//z0flZhlJvwdqU6AYrvWAxaaAcbZdsYpxhtyS7Y/hG1PBr8QaF8H7as0ORovBpV4NoW3D4Xyb+EjjwHXba5otzzwPWeZ7xtrE8YE7HAXzmfu1KmMwpT0kF2QjFPMtkRR/bV2Yv02F10K8j97Yr+tug7fQwv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312883; c=relaxed/simple;
	bh=dKGeHmuc0AMoqMd4c8uF73dFFuyhRt3JICyL+r37aFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4SxdpF+b6XnEV2OeS3KNUoruBMPeFfq/rs5exqtuj+hkTCYoDxPdlyObJqkXdbJwS6yYdrxUSC9GjrxcrBOYIS0F8UZzb0Zvb595fKKMgR49xXReFrkBMdpNxLkfFQR2vxmDJjNo8s1dWdCeIi4g3OrgqGRaDEwofGCKZgXf6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=xLjzYB1o; arc=none smtp.client-ip=212.227.17.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="xLjzYB1o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1747312827; x=1747917627; i=christian@heusel.eu;
	bh=ACEh/F0PUTfCw1qiHO8MuM8t4bWtlvu/gCbC9vwARUM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=xLjzYB1ojZAHcq4EWl9Jusxx70ThHfOMyNmlSQJBz9iOTQw4ThlYkKw3q4UJ671H
	 kY6Z5b3gZIKjLoI33AQZrGAciiVcYX/cY6T93fr6VU1KKtKexW8plGurOMWBC2w52
	 Rq5GrCM3QF3ojDybasqNTmO1qtzuJpz6W1mMSQ1sPapNw0yjc5HSMjDvupEHCxD34
	 pZkximzOSWkzY5ps1R5q3N5RXq3DCbNP/gWt4aKb9PiQuo63eaAnf6k0oT8ibe5aJ
	 yYYI4wxHBDUpohlNvkEfud28tykbiFWR5VYMy+BTzs0rQ4Mm+5GMno45H13g3ljiC
	 Igv3wXrS6USl3hLV0w==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.187.66.114]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MV5KC-1uNhMq3oZy-00Yt9A; Thu, 15 May 2025 14:40:27 +0200
Date: Thu, 15 May 2025 14:40:21 +0200
From: Christian Heusel <christian@heusel.eu>
To: Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Mario Limonciello <mario.limonciello@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Ray Wu <ray.wu@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <f727a009-a896-4eb5-8b1c-03417d48e545@heusel.eu>
References: <20250512172044.326436266@linuxfoundation.org>
 <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
 <CADo9pHgq2jzeVO4PFW6ObBj2bT9FSWcJUC5fRA9kVjMVah0J0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="e535jvafayoassw5"
Content-Disposition: inline
In-Reply-To: <CADo9pHgq2jzeVO4PFW6ObBj2bT9FSWcJUC5fRA9kVjMVah0J0g@mail.gmail.com>
X-Provags-ID: V03:K1:SNlabFiPlNQTwGuUCxIXGH4/0d3iWUjlJ0EyZAtoCQ/RCBAhXdu
 wFhITo/s+Jc/ndC8Giu1SBZPruJ9BaO7Nlk06qaomH5fpW8OU/l0cxeiIDan1h4ZhiaGHvy
 Y36+2ke8mWkYhnjRm9cb+i1oKJVGEdykYsjQyB53ETeOd8aNCBqHnl/3ldy+YvyOTmsSokr
 crkVXTJVf61ssTRXnmQ/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wwCeajMMog0=;vY3teL2xY5Nx/Oyj+fNIrB8mkhK
 3X25UwqhCnBDmY6y2lD8ZBbODrF+pLaHFQqgvM1OyZlrc17BCfJbJpr/uh6jkS+Xm0hOA7kQL
 JDtS4NS1Y65SG+mKrzeQxwEK4QYespDppoq3QZzh0A2yL4XdV5t7d2J5f59O1cOR8hSp8RfzS
 2PhHa8puDDoZShSFfpCegsus0sR+6S+6WPI66uafh5lLjhmSMBKsyG8OzjaoOUQSY+NQvo37l
 6i0XXeccDZXvDe4tsVqEkQzU1M8Yrq/SwXi4eOBpdtLpLI6HfCfn5bzasi30neUa3EAYC5jlY
 +evjNrQF9Zlrra8SfGRuDIGS1mOv8XnEHTqPbz6XfF1AHLB84v2ALVXcrBhU189xBqQ9RWQ7v
 9Q7wnVWT87lTMnz2o8/PJn2rK8AbOUFlD+2YJLQa3Ezgdr40xGrG2ZbpU7pd/Cap8/DHZvO28
 0rFyxg7HvKJPenItPTSdutOuTX5/fjvqUda6DyaubYMR73iVcZps6dW2DASl55uMpn5kkTUlA
 KZTCi+CEUdyDY1iHdoycvM7XNP/Te+Cc2H+ZqjjS7JO0LXMj+oj6UeKtZlMyzLz2pMEnEqnPN
 eCpMb34VsPod9NBJE0OaJoSKmEXUgoCbnpArudRylpcnddJmRO4CLUSOKRB8toT9AnnveKnMK
 RjOEOh7GMY8KW7csAkJttJLDqEMHLu9X5+ZUKVDdFBqFlPsXzeHXJkAXT0jLt520xLbxmNshW
 oeHD2zaduRvVXrccidMl7I6wn/vgwNDg7sWhO3leZNaolEm9sh2dG863R163PFfZ9WlTB/KnI
 3arVyxEPorZyYGmdFTmKenxJO2bppSpjDwPbf+Lz3ITM93MUykFXK4dNkuni1Ud6z8eujCvtL
 wj3peNvVhbXxG1192zc5pqkEw8j4xEbQanfBtUm57SpdHf1Tzt4wsOl/h7eHSyTbBCwwfYXU0
 ITfxCGjRe+Cyc7rMtYj6ByBCoyMOGWBYMrrZwDba5gM7gpOK+pb9utsNx+tc66YZDlGAIxSHg
 L+rLwCV6i0l5i5QU/lGsP+yz5fl+SiUsUDkeJwQ6ZuPnyMQVCF7kLqN6uKBUy5WO83ryIKEKv
 Ha/vGtgwUi0jp5s8xDET3k3m81J0PnPX8+FxkHGnvEpXM+CcPVSSSPIG+XgVed/aj83s4GJsi
 2EXdTu1wVPrVVlA6EMOxiqP9PoO3JOfiyra4x590Xtrvio3zFfzsg7ZBsWRNIyeaGPcJxP2DL
 SN4nDsEeRsmy3S6ZMaZxnV/f4JGHgtj0ZDBqCCxKsypBBjC8Xvf1RmeXFt9eOhuC2/Yd/Hv4f
 FFTzgGYFEhZFU/0nSLHtyQ5ucC/OJB++3ksFWIK4aFRy/j1ZZxiC7x61zR8ensuwqTSsczRgQ
 bndZSpqhbNQRup5Iu6xcFSIbDmT5miQqZPrtUvXBWYiNCy/MyIrvy8aTgu42e0zScMem+dr70
 JEm4pJw==


--e535jvafayoassw5
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
MIME-Version: 1.0

On 25/05/15 02:34PM, Luna Jernberg wrote:
> Same problem in rc2 just tested

Yes the fix is still on the way to mainline (see the mail from Mario
pointing to the patches posted to amd-gfx), but given that it's just
some log entries that stop again and nothing serious it should not be of
much issue.

Cheers,
Chris

> Den tis 13 maj 2025 kl 07:26 skrev Christian Heusel <christian@heusel.eu>:
> >
> > On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.14.7 release.
> > > There are 197 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> > > Anything received after that time might be too late.
> >
> > Hello everyone,
> >
> > I have noticed that the following commit produces a whole bunch of lines
> > in my journal, which looks like an error for me:
> >
> > > Wayne Lin <Wayne.Lin@amd.com>
> > >     drm/amd/display: Fix wrong handling for AUX_DEFER case
> >
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0=
x01.
> > amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> >
> > this does not seem to be serious, i.e. the system otherwise works as
> > intended but it's still noteworthy. Is there a dependency commit missing
> > maybe? From the code it looks like it was meant to be this way =F0=9F=
=A4=94
> >
> > You can find a full journal here, with the logspammed parts in
> > highlight:
> > https://gist.github.com/christian-heusel/e8418bbdca097871489a31d79ed166=
d6#file-dmesg-log-L854-L981
> >
> > Cheers,
> > Chris

--e535jvafayoassw5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgl4LUACgkQwEfU8yi1
JYVVuRAA215yB3QegwDZsVFCIU5RTpcQpgDwt3maQYJFBoInHghVmIoVVVs55qEU
I2eBdykmCpTenyWI6paJIKA1AfwoX4tFZumA3M7gZKYqhmWx7n9M3da6IDP2a+/t
3GBZAmSn/DTGKsTcgaPzguyEFBJo1lAulBk0dWXd+X3FwmKcdgM39hE7TnR5lULz
tqbad718ghHejBd0K5rK+1RarHH/rJ3IvL/wASdL8f/d+eez4Xg7PzJVSpwoGRQG
3tD2zEu+mbWBXvD6RXeqlbLZwNHpBm92otxu+08QFOcsqv+6Wqt1SBq3nv1hLsxZ
c9Ha9UxdgoFreKpRIyF5+hEt+Q53Vh8uGpiM1fM6qqC84vvPVBzOSg6jn5MjhLWx
o0VQQgHkzXeVh3pQnX0EJ64vQR3VDREXoBw4vdweFcRXwT99/Lo/LTnUXUZ4MqVC
nDaqWEWNUNwxAvO6J6PoJbFy7e45+J8k2CgOofc+GfHo/tV1gpD/GpDjOs+3pNui
hFIaxPtVbgctdVhguvmJFs1yTrZgbD8ek97Lua9yDaXXgfuLpFwu8DuH2CQd8udY
jzL8SmbqHjF8FYD2YyAIzPAsIPgaKY4ziIoCUyzv2Mreg6xxeWiwjJIcezphEWd0
mJ8oYuYJsHI8ndb7FnKv4YM4v/mGlFJs1AV372ethNQGtjH5y58=
=DPF9
-----END PGP SIGNATURE-----

--e535jvafayoassw5--
