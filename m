Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA687C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:31:41 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E40F01C09F4; Mon, 23 Jan 2023 12:31:31 +0100 (CET)
Date: Mon, 23 Jan 2023 12:31:31 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85wE2OBrVvwUlLp@duo.ucw.cz>
References: <20230122150229.351631432@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EO3ICQiYStspkriT"
Content-Disposition: inline
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>


--EO3ICQiYStspkriT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hmm. Interesting.

We tested

commit 9096aabfe9e099a5af5d13bb0fb36e98bb623398
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon Jan 23 10:49:12 2023 +0100

    Linux 5.10.165-rc2

and found no problems there, but that is -rc2 and you announced -rc1.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EO3ICQiYStspkriT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY85wEwAKCRAw5/Bqldv6
8mELAKC6XYVXnYoGaUEg3jUIDWP0zLMmfQCgnddfsEF0EEw3PXbjyldM7S6vsb0=
=WREq
-----END PGP SIGNATURE-----

--EO3ICQiYStspkriT--
