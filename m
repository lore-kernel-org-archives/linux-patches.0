Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A628AA4C
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 22:03:56 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D5F9A1C0AB3; Wed,  1 Mar 2023 23:03:47 +0100 (CET)
Date: Wed, 1 Mar 2023 23:03:47 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kuniyu@amazon.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <Y//Lw/zL168J3spQ@duo.ucw.cz>
References: <20230301180652.316428563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SfylrsavIRoFCp2I"
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>


--SfylrsavIRoFCp2I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

AFAICT we should not need this patch -- we don't have b5fc29233d28 in
5.10, so the assertion seems to be at the correct place here.

> Kuniyuki Iwashima <kuniyu@amazon.com>
>     net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
>     sk_stream_kill_queues().

CIP testing did not find any problems here:                                =
                            =20
                                                                           =
                            =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y                      =20
                                                                           =
                            =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
                            =20
                                                                           =
                            =20
Best regards,                                                              =
                            =20
                                                                Pavel      =
                            =20


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SfylrsavIRoFCp2I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY//LwwAKCRAw5/Bqldv6
8izUAKCmo3ncVN67b/E4QaSFAkxgocnrxACeIInLTZTnIlvCkx6jzMhB742Rp8w=
=wHWb
-----END PGP SIGNATURE-----

--SfylrsavIRoFCp2I--
