Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF62A7C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 11:29:11 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id CDDFD1C0DFE; Tue,  4 Apr 2023 13:29:09 +0200 (CEST)
Date: Tue, 4 Apr 2023 13:29:09 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sanju Mehta <Sanju.Mehta@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Message-ID: <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.499791738@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QPUMG3WcAYkC+ftV"
Content-Disposition: inline
In-Reply-To: <20230403140416.499791738@linuxfoundation.org>


--QPUMG3WcAYkC+ftV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> commit 1716efdb07938bd6510e1127d02012799112c433 upstream.
>=20
> `ring_interrupt_index` doesn't change the data for `ring` so mark it as
> const. This is needed by the following patch that disables interrupt
> auto clear for rings.

Yeah, nice cleanup. But do we really need it in -stable?

Best regards,
								Pavel
							=09
> +++ b/drivers/thunderbolt/nhi.c
> @@ -36,7 +36,7 @@
> =20
>  #define NHI_MAILBOX_TIMEOUT	500 /* ms */
> =20
> -static int ring_interrupt_index(struct tb_ring *ring)
> +static int ring_interrupt_index(const struct tb_ring *ring)
>  {
>  	int bit =3D ring->hop;
>  	if (!ring->is_tx)
>=20
>=20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QPUMG3WcAYkC+ftV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwKBQAKCRAw5/Bqldv6
8rRSAJsHwMppkZv7sHEdAc/+N07jcUO2JwCcDm/nIt/5Dcy/9KjT13HYCO5vcb4=
=JN/b
-----END PGP SIGNATURE-----

--QPUMG3WcAYkC+ftV--
