Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3333B6AD9
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:37:14 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 6BE0C1C0DFD; Thu,  9 Mar 2023 12:30:29 +0100 (CET)
Date: Thu, 9 Mar 2023 12:30:28 +0100
From: Pavel Machek <pavel@denx.de>
To: Chris Paterson <Chris.Paterson2@renesas.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"pavel@denx.de" <pavel@denx.de>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: CIP doing -stable kernel testing -- was Re: [PATCH 6.1 000/887]
 6.1.16-rc2 review
Message-ID: <ZAnDVIl09wDaFNXy@duo.ucw.cz>
References: <20230308091853.132772149@linuxfoundation.org>
 <TYCPR01MB105885F25AAE8A2FDBD2E577FB7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uryvEXGq31Vxb63"
Content-Disposition: inline
In-Reply-To: <TYCPR01MB105885F25AAE8A2FDBD2E577FB7B59@TYCPR01MB10588.jpnprd01.prod.outlook.com>


--3uryvEXGq31Vxb63
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 08 March 2023 09:30
> >=20
> > This is the start of the stable review cycle for the 6.1.16 release.
> > There are 887 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> CIP testing did not find any problems with Linux 6.1.16-rc2 (bb4e875c8c41=
):
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines=
/800470660
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/l=
inux-6.1.y

Hey, that was supposed to be my line! :-).

Well, in fact Chris is doing testing for CIP, and I was just
announcing the results. We decided to test all the -stable releases,
and due to increased ammount of emails, likely Chris will be
announcing successful tests from now on.

-stable is rather important for our work (and we'll likely be
maintaining 6.1 for 10 years). We do have some resources we can
dedicate to testing and stable maintainance, so if there's something
else we could do, let us know and we might be able to arrange that.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3uryvEXGq31Vxb63
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZAnDVAAKCRAw5/Bqldv6
8swPAJ43oyH290iaCbEvc9yCQo3wrwDhKwCfaB1Y1bywyCo/qEpb6ei8zIa0VQE=
=fdjY
-----END PGP SIGNATURE-----

--3uryvEXGq31Vxb63--
