Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF1C7C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 11:43:34 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id ABE0D1C0DFD; Tue,  4 Apr 2023 13:43:32 +0200 (CEST)
Date: Tue, 4 Apr 2023 13:43:32 +0200
From: Pavel Machek <pavel@denx.de>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
Message-ID: <ZCwNZEoySWUWoKpR@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org>
 <ZCwJhAfrTIPorVTw@duo.ucw.cz>
 <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="53sEu/xf4uFkW4y7"
Content-Disposition: inline
In-Reply-To: <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>


--53sEu/xf4uFkW4y7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
> > >=20
> > > Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_T=
RGMII
> > > case as it's only needed when trgmii is used.
> >=20
> > This one is very wrong for 5.10. ssc_delta is unconditionally used
> > below, and it will not use uninitialized variable.
> >=20
> > (In mainline, that code is protected by if (trgint), so it does not
> > have this problem).
>=20
> This patch is not stable material in the first place. As a newbie I
> incorrectly sent it to net tree instead of net-next. This patch can just =
be
> ignored for 5.10, if that takes the least amount of effort for you folks.
>=20
> Sorry about that and thanks for pointing this out Pavel.

I believe you did the right thing, but as it had Fixes header stable
people picked it up.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--53sEu/xf4uFkW4y7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwNYwAKCRAw5/Bqldv6
8hkbAJ92g96m/7Yi/jSmHm/3DtFR+zK40gCdH8EfP7KuoFlBBYdT3mpmWEqm8S8=
=Y7HH
-----END PGP SIGNATURE-----

--53sEu/xf4uFkW4y7--
