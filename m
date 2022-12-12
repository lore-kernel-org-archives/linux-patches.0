Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9428529CA
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 18:32:01 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 962541C09DB; Mon, 12 Dec 2022 19:31:59 +0100 (CET)
Date: Mon, 12 Dec 2022 19:31:59 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, yuehaibing@huawei.com,
	keescook@chromium.org
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5dzn4y73kgwuas+@duo.ucw.cz>
References: <20221212130924.863767275@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="os3BK4mzJ0NoTXgk"
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>


--os3BK4mzJ0NoTXgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> YueHaibing <yuehaibing@huawei.com>
>     net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET un=
der ARCH_BCM2835

This one is not suitable for 5.10, we don't have
PTP_1588_CLOCK_OPTIONAL there.

> Kees Cook <keescook@chromium.org>
>     ALSA: seq: Fix function prototype mismatch in
> snd_seq_expand_var_event

This is useful fo kCFI, but we don't have kCFI in 5.10 and others.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--os3BK4mzJ0NoTXgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY5dznwAKCRAw5/Bqldv6
8pB4AKChD0dIRIi0VEIS0k32S7FVgKHmcgCdEGjRfL2RBSBy7Zn6tLhlbtKa2l4=
=Q6Tw
-----END PGP SIGNATURE-----

--os3BK4mzJ0NoTXgk--
