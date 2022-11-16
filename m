Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57E2F46
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:25:52 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E92911C09F6; Wed, 16 Nov 2022 11:25:49 +0100 (CET)
Date: Wed, 16 Nov 2022 11:25:49 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	wengjianfeng <wengjianfeng@yulong.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 024/118] NFC: nxp-nci: remove unnecessary labels
Message-ID: <Y3S6rSLK1Xx7sL9p@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.716314975@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MP6c9xx7/oXGF3+6"
Content-Disposition: inline
In-Reply-To: <20221108133341.716314975@linuxfoundation.org>


--MP6c9xx7/oXGF3+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: wengjianfeng <wengjianfeng@yulong.com>
>=20
> [ Upstream commit 96a19319921ceb4b2f4c49d1b9bf9de1161e30ca ]
>=20
> Simplify the code by removing unnecessary labels and returning
> directly.

Ok, but is there reason for changing the error code? ENOTSUPP ->
EOPNOTSUPP?

Best regards,
								Pavel

> +++ b/drivers/nfc/nxp-nci/core.c
> @@ -70,21 +70,16 @@ static int nxp_nci_send(struct nci_dev *ndev, struct =
sk_buff *skb)
>  	struct nxp_nci_info *info =3D nci_get_drvdata(ndev);
>  	int r;
> =20
> -	if (!info->phy_ops->write) {
> -		r =3D -ENOTSUPP;
> -		goto send_exit;
> -	}
> +	if (!info->phy_ops->write)
> +		return -EOPNOTSUPP;
>

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--MP6c9xx7/oXGF3+6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S6rQAKCRAw5/Bqldv6
8opHAKDDvYTUSXz/b3zY8uDlieVgnOYxOgCfd7fU/XnXtKDp9Lk0BYO6lEmS5/8=
=z3r+
-----END PGP SIGNATURE-----

--MP6c9xx7/oXGF3+6--
