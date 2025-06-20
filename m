Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294723817C
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417549; cv=none; b=O9+53bw5GTtMyhZY8GlkyT57tmJSAUm9g9zEYBeq8cfHkMx1v2sotbI2kF+SMxFD8z9pcpi5+qFuPBFOAq8xFNZKMX0D50rL2RbDs5XyELNdN463syMJsOgIbjyMJnjw2e9wgu4PB5vFN1Kfl+nGNazaCfg6icMF5xNN8GZXOqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417549; c=relaxed/simple;
	bh=Mm+aGftGtVbYlbnzaCbpvAV8wIXRRq63TDkKr+pwLlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0N8XHNpuin4r/SSE8582PAq5WRSqekT0aecqeqY8noSnIVRKXYQ+rp7MOyNbdZUQ4cQsrqKk3aFUUrC5vIo+ZyatmF9zhhkZGQNq1qSmRTQOBy56WF19NRW5ibtvA5oU6GPoVle9uWbDbraGUZ6YuxVmjPZUvkcihFnx6j3TiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=f+7BcWSW; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="f+7BcWSW"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6475B10240F5B;
	Fri, 20 Jun 2025 13:05:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417544; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9zXnXoyx5LOCQ6Nn5eqmzicqfUZY3JHRxfQtassglRk=;
	b=f+7BcWSWgL/a+lFPu45sxkLM65hSwQfOY32RcnMUX08IvIofgDLC35CfoAqbe4Mrj12IAV
	5lWXecIAo2RayV55b7kL1LVAJChx253/N3sPoRwPJCmalGAoxXCG2VU5UTsRktUypC4E8V
	NCdAzAGdgsBVeH/p5czCrH3MmsgcHlcOIPfqjriQvgHVn/Uflz0vfVTuyW2lZMyfpb3f1o
	Rh3LnJu0J16LZjwFsHgbLEUTWvmKHtd7phoPkgAomEObFjy2VucPjRSTeODKvt3zZA2NIq
	g0YLdpbTGuxP+frNktIXWQj9Ielr2BqYeKLVkiAsi1EUs/S9afo2OFqAb+ksJA==
Date: Fri, 20 Jun 2025 13:05:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 126/512] xfrm: Use xdo.dev instead of xdo.real_dev
Message-ID: <aFVAg+aQz/zCWCkS@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152424.696299116@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cV9iaqfk9T1nAZn5"
Content-Disposition: inline
In-Reply-To: <20250617152424.696299116@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--cV9iaqfk9T1nAZn5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> [ Upstream commit 25ac138f58e7d5c8bffa31e8891418d2819180c4 ]
>=20
> The policy offload struct was reused from the state offload and
> real_dev was copied from dev, but it was never set to anything else.
> Simplify the code by always using xdo.dev for policies.

Cleanup, not a bugfix.

BR,
								Pavel
							=09
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -1135,7 +1135,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipse=
c_pol_entry *pol_entry,
>  static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  				 struct netlink_ext_ack *extack)
>  {
> -	struct net_device *netdev =3D x->xdo.real_dev;
> +	struct net_device *netdev =3D x->xdo.dev;
>  	struct mlx5e_ipsec_pol_entry *pol_entry;
>  	struct mlx5e_priv *priv;
>  	int err;
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index b33c4591e09a4..32ad8f3fc81e8 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c
> @@ -373,7 +373,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_=
policy *xp,
> =20
>  	xdo->dev =3D dev;
>  	netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
> -	xdo->real_dev =3D dev;
>  	xdo->type =3D XFRM_DEV_OFFLOAD_PACKET;
>  	switch (dir) {
>  	case XFRM_POLICY_IN:
> @@ -395,7 +394,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_=
policy *xp,
>  	err =3D dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
>  	if (err) {
>  		xdo->dev =3D NULL;
> -		xdo->real_dev =3D NULL;
>  		xdo->type =3D XFRM_DEV_OFFLOAD_UNSPECIFIED;
>  		xdo->dir =3D 0;
>  		netdev_put(dev, &xdo->dev_tracker);
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index abd725386cb60..7a298058fc16c 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1487,7 +1487,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const =
xfrm_address_t *saddr,
>  			xso->type =3D XFRM_DEV_OFFLOAD_PACKET;
>  			xso->dir =3D xdo->dir;
>  			xso->dev =3D xdo->dev;
> -			xso->real_dev =3D xdo->real_dev;
>  			xso->flags =3D XFRM_DEV_OFFLOAD_FLAG_ACQ;
>  			netdev_hold(xso->dev, &xso->dev_tracker, GFP_ATOMIC);
>  			error =3D xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
> @@ -1495,7 +1494,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const =
xfrm_address_t *saddr,
>  				xso->dir =3D 0;
>  				netdev_put(xso->dev, &xso->dev_tracker);
>  				xso->dev =3D NULL;
> -				xso->real_dev =3D NULL;
>  				xso->type =3D XFRM_DEV_OFFLOAD_UNSPECIFIED;
>  				x->km.state =3D XFRM_STATE_DEAD;
>  				to_put =3D x;

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cV9iaqfk9T1nAZn5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFVAgwAKCRAw5/Bqldv6
8jsuAJ407jxTBMPLIASjsaxL3EQBRXyrjwCeJIf2K2EkEydmG+5dqDn4Lh4HIWM=
=Jktg
-----END PGP SIGNATURE-----

--cV9iaqfk9T1nAZn5--
