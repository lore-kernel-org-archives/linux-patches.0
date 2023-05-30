Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED0168CC
	for <patches@lists.linux.dev>; Tue, 30 May 2023 10:26:41 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id A70BB1C0D20; Tue, 30 May 2023 12:26:38 +0200 (CEST)
Date: Tue, 30 May 2023 12:26:37 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	kch@nvidia.com, avolmat@me.com, arnd@arndb.de, vi@endrift.com
Subject: Re: [PATCH 4.14 00/86] 4.14.316-rc1 review
Message-ID: <ZHXPXaPPWuslRI6A@duo.ucw.cz>
References: <20230528190828.564682883@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HoT0r7ZN4EsSbGiN"
Content-Disposition: inline
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>


--HoT0r7ZN4EsSbGiN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.14.316 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Chaitanya Kulkarni <kch@nvidia.com>
>     null_blk: Always check queue mode setting from configfs

This one is in 4.14 and 5.10, but not in 4.19.

> Alain Volmat <avolmat@me.com>
>     phy: st: miphy28lp: use _poll_timeout functions for waits

This is just a cleanup, we don't really need it in stable.

> Arnd Bergmann <arnd@arndb.de>
>     clk: tegra20: fix gcc-7 constant overflow warning

Something went wrong here:

 #define OSC_FREQ_DET_STATUS 0x5c
-#define OSC_FREQ_DET_BUSY (1<<31)
-#define OSC_FREQ_DET_CNT_MASK 0xFFFF
+#define OSC_FREQ_DET_BUSYu (1<<31)
+#define OSC_FREQ_DET_CNT_MASK 0xFFFFu

First, we don't really need u after hex constants. Second, we normally
use upperspace U for this. Third, u should not really be appended to
the constant name.

> Vicki Pfau <vi@endrift.com>
>     Input: xpad - add constants for GIP interface numbers

This is just a cleanup, we don't really need it in stable.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HoT0r7ZN4EsSbGiN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZHXPXQAKCRAw5/Bqldv6
8qj3AKCDLbIXFtCX4xd31flyfX4Chme4ngCfapt3x8fLAKlpwUMRFeGiFCeTepI=
=P7xE
-----END PGP SIGNATURE-----

--HoT0r7ZN4EsSbGiN--
