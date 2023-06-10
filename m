Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A3DC8F6
	for <patches@lists.linux.dev>; Sat, 10 Jun 2023 19:23:51 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 307FF1C0EB8; Sat, 10 Jun 2023 21:23:48 +0200 (CEST)
Date: Sat, 10 Jun 2023 21:23:47 +0200
From: Pavel Machek <pavel@denx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Thomas Gleixner <tglx@linutronix.de>,
	Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <ZITNw9cv/WoZcSaO@duo.ucw.cz>
References: <20230607200903.652580797@linuxfoundation.org>
 <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
 <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R7QnfhQzEFI8g4qW"
Content-Disposition: inline
In-Reply-To: <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>


--R7QnfhQzEFI8g4qW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 499 pass: 498 fail: 1
> > Failed tests:
> > 	arm:kudo-bmc:multi_v7_defconfig:npcm:usb0.1:nuvoton-npcm730-kudo:rootfs
> >=20
> > The test failure is spurious and not new. I observe it randomly on
> > multi_v7_defconfig builds, primarily on npcm platforms. There is no err=
or
> > message, just a stalled boot. I have been trying to bisect for a while,
> > but I have not been successful so far. No immediate concern; I just wan=
ted
> > to mention it in case someone else hits the same or a similar problem.
> >=20
>=20
> I managed to revise my bisect script sufficiently enough to get reliable
> results. It looks like the culprit is commit 503e554782c9 (" debugobject:
> Ensure pool refill (again)"); see bisect log below. Bisect on four
> different systems all have the same result. After reverting this patch,
> I do not see the problem anymore (again, confirmed on four different
> systems). If anyone has an idea how to debug this, please let me know.
> I'll be happy to give it a try.

You may want to comment out debug_objects_fill_pool() in
debug_object_activate or debug_object_assert_init to see which one is
causing the failure...

CONFIG_PREEMPT_RT is disabled for you, right? (Should 5.15 even have
that option?)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--R7QnfhQzEFI8g4qW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZITNwwAKCRAw5/Bqldv6
8gMQAKCninpq2IbLx5zozdVkDJvbs6AMzgCgnaBEzhZym15ISXWB1LFhT8v8jR4=
=Mu2c
-----END PGP SIGNATURE-----

--R7QnfhQzEFI8g4qW--
