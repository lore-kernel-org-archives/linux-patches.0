Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333B7C
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:32:13 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 7C2C51C09F6; Wed, 16 Nov 2022 11:32:11 +0100 (CET)
Date: Wed, 16 Nov 2022 11:32:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 027/118] nfc: nfcmrvl: Fix potential memory leak in
 nfcmrvl_i2c_nci_send()
Message-ID: <Y3S8K6Bzs62UkKXg@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.836879145@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sit6fkatb6c/qX78"
Content-Disposition: inline
In-Reply-To: <20221108133341.836879145@linuxfoundation.org>


--sit6fkatb6c/qX78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Shang XiaoJing <shangxiaojing@huawei.com>
>=20
> [ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]
>=20
> nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
> should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
> will only free skb when i2c_master_send() return >=3D0, which means skb
> will memleak when i2c_master_send() failed. Free skb no matter whether
> i2c_master_send() succeeds.

We still need to free the skb in the other error exits, right?

Best regards,
								Pavel
							=09
> +++ b/drivers/nfc/nfcmrvl/i2c.c
> @@ -151,10 +151,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_priv=
ate *priv,
>  			ret =3D -EREMOTEIO;
>  		} else
>  			ret =3D 0;
> +	}
> +
> +	if (ret) {
>  		kfree_skb(skb);
> +		return ret;
>  	}
> =20
> -	return ret;
> +	consume_skb(skb);
> +	return 0;
>  }
> =20
>  static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--sit6fkatb6c/qX78
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S8KwAKCRAw5/Bqldv6
8jhNAKCi4n/aOKGXNaFChdfN32UQh2z7BwCgks+eFlsEN3b6yyumgpecGPkw8So=
=Xt4m
-----END PGP SIGNATURE-----

--sit6fkatb6c/qX78--
