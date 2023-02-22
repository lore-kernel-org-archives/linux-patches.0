Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88E42F3F
	for <patches@lists.linux.dev>; Wed, 22 Feb 2023 14:43:08 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1164A1C0AAC; Wed, 22 Feb 2023 15:43:01 +0100 (CET)
Date: Wed, 22 Feb 2023 15:43:00 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, toke@redhat.com,
	daniel@iogearbox.net, dsahern@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Message-ID: <Y/Yp9PPbY99p+i8X@duo.ucw.cz>
References: <20230220133553.066768704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/7m1nmvh2r3HdAv"
Content-Disposition: inline
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>


--s/7m1nmvh2r3HdAv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Toke H=F8iland-J=F8rgensen <toke@redhat.com>
>     bpf: Always return target ifindex in bpf_fib_lookup

Changelog talks about bpf_redirect_neigh but we don't have that in
4.19. It is not clear what bug this fixes. Do we need it in 4.19?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--s/7m1nmvh2r3HdAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY/Yp9AAKCRAw5/Bqldv6
8jw/AJ0RCtiGX/QXR7TGDEenQZjX620okACgnw96PaeuUBJAYVq7cLYOdZajkM0=
=SmSR
-----END PGP SIGNATURE-----

--s/7m1nmvh2r3HdAv--
