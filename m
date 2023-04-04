Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B7B7C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 11:27:03 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 678471C0E01; Tue,  4 Apr 2023 13:27:01 +0200 (CEST)
Date: Tue, 4 Apr 2023 13:27:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
Message-ID: <ZCwJhAfrTIPorVTw@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xL+ikprMmmbWsSJq"
Content-Disposition: inline
In-Reply-To: <20230403140416.096716862@linuxfoundation.org>


--xL+ikprMmmbWsSJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
>=20
> Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
> case as it's only needed when trgmii is used.

This one is very wrong for 5.10. ssc_delta is unconditionally used
below, and it will not use uninitialized variable.

(In mainline, that code is protected by if (trgint), so it does not
have this problem).

Best regards,
								Pavel

> +++ b/drivers/net/dsa/mt7530.c
> @@ -403,6 +403,10 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_inte=
rface_t interface)
>  		break;
>  	case PHY_INTERFACE_MODE_TRGMII:
>  		trgint =3D 1;
> +		if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
> +			ssc_delta =3D 0x57;
> +		else
> +			ssc_delta =3D 0x87;
>  		if (priv->id =3D=3D ID_MT7621) {
>  			/* PLL frequency: 150MHz: 1.2GBit */
>  			if (xtal =3D=3D HWTRAP_XTAL_40MHZ)
> @@ -422,11 +426,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_inte=
rface_t interface)
>  		return -EINVAL;
>  	}
> =20
> -	if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
> -		ssc_delta =3D 0x57;
> -	else
> -		ssc_delta =3D 0x87;
> -
>  	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
>  		   P6_INTF_MODE(trgint));
> =20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--xL+ikprMmmbWsSJq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwJhAAKCRAw5/Bqldv6
8mYeAJ4w3zv0OY2gBX4ssOR3SzI65IpJTACfWhRCc5Ju6H5SdLg1JjYI0QN+5+o=
=AvMh
-----END PGP SIGNATURE-----

--xL+ikprMmmbWsSJq--
