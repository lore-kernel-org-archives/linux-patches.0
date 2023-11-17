Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3E2C8CC
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 19:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id C79BF1C006B; Fri, 17 Nov 2023 20:57:17 +0100 (CET)
Date: Fri, 17 Nov 2023 20:57:17 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tglozar@redhat.com,
	tglx@linutronix.de, phil@nwl.cc
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/379] 6.1.63-rc1 review
Message-ID: <ZVfFnU1FU3V6IHJ5@duo.ucw.cz>
References: <20231115192645.143643130@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6GPu7+NXCR1QNfCW"
Content-Disposition: inline
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>


--6GPu7+NXCR1QNfCW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.63 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Tomas Glozar <tglozar@redhat.com>
>     nd_btt: Make BTT lanes preemptible

This is for preempt-rt only, and we don't really have that in
-stable. This means we don't really need this in 4.19, either:

d9ea9d2ff 666300 o: 4.19| sched/rt: Provide migrate_disable/enable()
inlines

> Phil Sutter <phil@nwl.cc>
>     netfilter: nf_tables: Drop pointless memset when dumping rules

A cleanup, but I don't believe we need it in -stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--6GPu7+NXCR1QNfCW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZVfFnQAKCRAw5/Bqldv6
8iBhAJ0cwhl170g8auTIHKASrVgXDMznqQCfTW/9XWjNoVVUwSBLE8vU/2nvt9E=
=xxS+
-----END PGP SIGNATURE-----

--6GPu7+NXCR1QNfCW--
