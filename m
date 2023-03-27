Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D143DA51
	for <patches@lists.linux.dev>; Mon, 27 Mar 2023 10:51:55 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 447721C0AC1; Mon, 27 Mar 2023 12:51:48 +0200 (CEST)
Date: Mon, 27 Mar 2023 12:51:47 +0200
From: Pavel Machek <pavel@denx.de>
To: Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <ZCF1Q9DYDfhE3yA0@duo.ucw.cz>
References: <20230307170022.094103862@linuxfoundation.org>
 <CADo9pHh614h0vBkb5cKJvD6wCOXSkKwoCpYeQN9be4LFcArJ3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mABmfs2EqDcut8p"
Content-Disposition: inline
In-Reply-To: <CADo9pHh614h0vBkb5cKJvD6wCOXSkKwoCpYeQN9be4LFcArJ3w@mail.gmail.com>


--7mABmfs2EqDcut8p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Working on my Arch Linux Server with an i5-6400
>=20
> Tested-by: Luna Jernberg <droidbittin@gmail.com>
>=20
> On 3/7/23, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1001 patches in this series, all will be posted as a

Please

1) don't top-post

2) trim stuff you are not replying to.

Thanks for testing,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7mABmfs2EqDcut8p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCF1QwAKCRAw5/Bqldv6
8qHYAJ9x2LUDPsMnqJXz4wBjy4nEELA1YACghiCcdtX8BE8Z11wyfBkeAHgmCyU=
=MMRd
-----END PGP SIGNATURE-----

--7mABmfs2EqDcut8p--
