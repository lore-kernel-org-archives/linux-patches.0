Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368AD38D3F6;
	Sun, 31 May 2026 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233634; cv=none; b=KpiDyfjfFq+Xi41elLJmxoeJMuaWb96+0251G21sFv83Y80FvBuYWOOr16V7K+n5M8unWKMeBuO/DHt9MIjm/UdcbUCpS5BqwSfe3sVkNt5Se11XybBHS1BhaNbwNWwbxjVoH0ZXIr6eJSfoEffP9tWi7aWFGI9eKkO34Qx7ULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233634; c=relaxed/simple;
	bh=KUBg7hsI1YVDn0Qj0Kaw6/CZu61rIfo+N9/0U1evMLU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oblIuHeOXgii8lxyOTsRwZGA/27HrpoHCGqvNnaK3pNBwTC5twmeKiMqLNNCOyVxkBoywuxJE2PpN6loJYa6ampNT3mdefdQlDpUaIUSyocDJLGEVrjd2Bea1qcherOo/Qhg/YTEud7Iv2rN37Ni8CQt5H4szkyN1mheG0velRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTg5b-000O4g-19;
	Sun, 31 May 2026 13:20:27 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTg5Z-0000000FCef-3MG7;
	Sun, 31 May 2026 15:20:25 +0200
Message-ID: <866e188244055e8b90d632cb82e2badb40946706.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 101/589] rxrpc: Fix key quota calculation for
 multitoken keys
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, David Howells <dhowells@redhat.com>
Cc: patches@lists.linux.dev, Marc Dionne <marc.dionne@auristor.com>, Jeffrey
 Altman <jaltman@auristor.com>, Simon Horman <horms@kernel.org>,
 linux-afs@lists.infradead.org, 	stable@kernel.org, Jakub Kicinski
 <kuba@kernel.org>, Greg Kroah-Hartman	 <gregkh@linuxfoundation.org>, stable
 <stable@vger.kernel.org>
Date: Sun, 31 May 2026 15:20:20 +0200
In-Reply-To: <20260530160227.359961685@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160227.359961685@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KdLnGxpFZeMT36rZDyM1"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-KdLnGxpFZeMT36rZDyM1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:59 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: David Howells <dhowells@redhat.com>
>=20
> [ Upstream commit bdbfead6d38979475df0c2f4bad2b19394fe9bdc ]
>=20
> In the rxrpc key preparsing, every token extracted sets the proposed quot=
a
> value, but for multitoken keys, this will overwrite the previous proposed
> quota, losing it.
>=20
> Fix this by adding to the proposed quota instead.
>=20
> Fixes: 8a7a3eb4ddbe ("KEYS: RxRPC: Use key preparsing")
> Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%=
40redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: Jeffrey Altman <jaltman@auristor.com>
> cc: Simon Horman <horms@kernel.org>
> cc: linux-afs@lists.infradead.org
> cc: stable@kernel.org
> Link: https://patch.msgid.link/20260408121252.2249051-2-dhowells@redhat.c=
om
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ dropped hunk for rxrpc_preparse_xdr_yfs_rxgk() ]

Indeed 5.10 does not have that key type, but it does have
rxrpc_preparse_xdr_rxk5() which I think also needs to be updated.

Ben.

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/rxrpc/key.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> --- a/net/rxrpc/key.c
> +++ b/net/rxrpc/key.c
> @@ -108,7 +108,7 @@ static int rxrpc_preparse_xdr_rxkad(stru
>  		return -EKEYREJECTED;
> =20
>  	plen =3D sizeof(*token) + sizeof(*token->kad) + tktlen;
> -	prep->quotalen =3D datalen + plen;
> +	prep->quotalen +=3D datalen + plen;
> =20
>  	plen -=3D sizeof(*token);
>  	token =3D kzalloc(sizeof(*token), GFP_KERNEL);
> @@ -718,6 +718,7 @@ static int rxrpc_preparse(struct key_pre
>  	memcpy(&kver, prep->data, sizeof(kver));
>  	prep->data +=3D sizeof(kver);
>  	prep->datalen -=3D sizeof(kver);
> +	prep->quotalen =3D 0;
> =20
>  	_debug("KEY I/F VERSION: %u", kver);
> =20
> @@ -755,7 +756,7 @@ static int rxrpc_preparse(struct key_pre
>  		goto error;
> =20
>  	plen =3D sizeof(*token->kad) + v1->ticket_length;
> -	prep->quotalen =3D plen + sizeof(*token);
> +	prep->quotalen +=3D plen + sizeof(*token);
> =20
>  	ret =3D -ENOMEM;
>  	token =3D kzalloc(sizeof(*token), GFP_KERNEL);
>=20
>=20

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-KdLnGxpFZeMT36rZDyM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmocNZQACgkQ57/I7JWG
EQlRJxAAiEFKtwUy3nJ/4y1FfxU0J93QfRiALaoiMSl6QtKX/V3to7AmxdW94nsL
IAx923DA+9pbMi9XX9EtOcWBOxHo6am3VtvXeN7bj0KfLb1t0q86d7dTEW0o497O
VRM/wElqCzI5t09LGidZt8LBN5CeEO+1KXzZtatNKlG++dNMboX40mrY9zFJptHt
OER+1wpK7C69cHWHx/iLLw0/y2DdgK7rBhP6blJfL5DwjbdaJ2B5kDKuhsoJ9D/2
oR2cGfep+pNfVoGin/iYPke8UETRaDz+xoFqiFKPKk+wZzS5dp6UH2UR/UMI5Nv5
Bi4AKfAPG9giFS+8C3+Ih0insWiXu0ru3uj56RmSpCTyl/xzS6Jl+AJNL0RFcWNW
aK1Gwq0gKpW73frm+KQZpGuEBZq3EOqyk9I9NAyVKHxXPT5+D8+jlqFHGjHdvT4l
gmqelyKyXEnX+wLIxjIc4OLLE4bCrMIfWy696ormBUovMuFkEO2AVIlXJCyu8rJ0
RcY2hPvoXOrYXQyrEFGb5+DDCdwd87W4Is4K5ev9EH6eWfkVNhAGv7nPCH66DpGO
us8s0GPwaKdltseP/NWXr7b6maH1rq+kJB7G5hkoT2t4nidl4UABsDrVxphC+b6A
VTe75hPObNH5yonkM09RwDu9bg8BjQu3lH+gl0ovaW2bmzoA95k=
=tNwi
-----END PGP SIGNATURE-----

--=-KdLnGxpFZeMT36rZDyM1--
