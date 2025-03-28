Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB31E1E11;
	Fri, 28 Mar 2025 21:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743198615; cv=none; b=KkrVPsFrMYf211WcJTCWXkYP1kC8Ui6Sn+ZjX9el8Bz20ePwYzk28yoRH+45MzjLodmahK4PkNQadbGRmhVLSwlF/6ZpmSV6h/5N9OxpJW4Vdv3cMUqk8w33KfyiGSxF3QTXRjoAz7nZP5856M1NmQIp7HiPUaua+7eDTPE2tkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743198615; c=relaxed/simple;
	bh=ESVNHVps9FLYqo4hKCVsvyQ4nTzDDoyJ8JilqV9YoGY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nQsrchecAprN4ujcrCSedZlvontHkBlMnF4JfO86KUCHfqC4cUee+LdM+z9FSABJLip5PtuV7tTUD389Ur3/ltyaKDPXvv93Ggv8HYPR7bXslQzskckxE89Y/1y6nz1Qze8zw6xpN2gr+5f+cdITpHESLIhPW7P4Dh2AknMQJFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1tyHad-0006sb-3C;
	Fri, 28 Mar 2025 21:50:10 +0000
Received: from ben by deadeye with local (Exim 4.98.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1tyHab-00000000AAB-3MVQ;
	Fri, 28 Mar 2025 22:50:09 +0100
Message-ID: <5d14c4f54dc785eb3fc8aa1207ad492d52b6de57.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 462/462] net: ipv6: fix dst refleaks in rpl, seg6
 and ioam6 lwtunnels
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Justin Iurman <justin.iurman@uliege.be>, Simon
 Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Date: Fri, 28 Mar 2025 22:50:05 +0100
In-Reply-To: <20250311145816.586107514@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
	 <20250311145816.586107514@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Df151gGSlTta+Fzmaozu"
User-Agent: Evolution 3.56.0-1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-Df151gGSlTta+Fzmaozu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-03-11 at 16:02 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jakub Kicinski <kuba@kernel.org>
>=20
> commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.
>=20
> dst_cache_get() gives us a reference, we need to release it.
>=20
> Discovered by the ioam6.sh test, kmemleak was recently fixed
> to catch per-cpu memory leaks.
>=20
> Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")

The 5.10 branch does not include backports of:

> Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue"=
)
> Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue=
")

so the changes this makes to seg6_iptunnel.c are incorrect and appear to
introduce a UAF.

Ben.

> Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/20250130031519.2716843-1-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/ipv6/rpl_iptunnel.c  |    6 ++++--
>  net/ipv6/seg6_iptunnel.c |    2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
>=20
> --- a/net/ipv6/rpl_iptunnel.c
> +++ b/net/ipv6/rpl_iptunnel.c
> @@ -232,7 +232,6 @@ static int rpl_output(struct net *net, s
>  		dst =3D ip6_route_output(net, NULL, &fl6);
>  		if (dst->error) {
>  			err =3D dst->error;
> -			dst_release(dst);
>  			goto drop;
>  		}
> =20
> @@ -251,6 +250,7 @@ static int rpl_output(struct net *net, s
>  	return dst_output(net, sk, skb);
> =20
>  drop:
> +	dst_release(dst);
>  	kfree_skb(skb);
>  	return err;
>  }
> @@ -277,8 +277,10 @@ static int rpl_input(struct sk_buff *skb
>  	local_bh_enable();
> =20
>  	err =3D rpl_do_srh(skb, rlwt, dst);
> -	if (unlikely(err))
> +	if (unlikely(err)) {
> +		dst_release(dst);
>  		goto drop;
> +	}
> =20
>  	skb_dst_drop(skb);
> =20
> --- a/net/ipv6/seg6_iptunnel.c
> +++ b/net/ipv6/seg6_iptunnel.c
> @@ -380,7 +380,6 @@ static int seg6_output(struct net *net,
>  		dst =3D ip6_route_output(net, NULL, &fl6);
>  		if (dst->error) {
>  			err =3D dst->error;
> -			dst_release(dst);
>  			goto drop;
>  		}
> =20
> @@ -398,6 +397,7 @@ static int seg6_output(struct net *net,
> =20
>  	return dst_output(net, sk, skb);
>  drop:
> +	dst_release(dst);
>  	kfree_skb(skb);
>  	return err;
>  }
>=20
>=20

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-Df151gGSlTta+Fzmaozu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmfnGY0ACgkQ57/I7JWG
EQl9Rg//frAGD3PCwT7DmDSeyU3Yfzl7xrI1bhBVXVz+C5KJR/Xey53TMFdx8dXd
cIm+FKx9B1LhuoMqdq1KT4g8uSnr7nJHHGglR7Fy8w+drDkwy8m9IWvkmakAfmHj
iHYKo+Tb/h+m7cQfn/0VSPiF1Q7HEWQwfoGJ18+Al6qbiZGi9+BkBGWIiiByVbQ0
/RdiIbc0sFX8qybt3d64wSVYH/UPPuJOJjFu92L49tF78bZ4gw2h3JVaB+XJrWxW
NfeNH0t+XxylIQauhM2X153T/eVBY1OWBmXlG1hb14hvEm4CqbjKciEr9A4ol3CB
+Ybu0hS0SmlWhns/yTx5CvBiEmowf0k+xTXjaug7aDxFS26aMJdNnkp6dCsu/fqb
mTmazjOZlEFCVLp07Ju73N2LZ7p8ke2Vl2I4jaxdLtwoHhSJ5bR5mY98X3sXsx/E
7dBsi3qVGD5qberki9WbbJTETdO4yFQ2VEpORsFrkV7wZamfcVPWrrMEWgFJeWpb
a1Z8+ksZAAGVWHP9A2sxTfTmWAgFkemf7GoKvSfzifZFXMqNAWoYtyWn1Vx1BWeS
V6UngLH04Bs+mW0UEFQL7HQyQRlB9OG6mRgawoM6sxFxRH46d3xOdqww+RKVJ8iH
ocyLO0Y92f3uUbs2Q1pZM2Zzx57kwMby+RE7sudu5/haM13BzeU=
=d+yv
-----END PGP SIGNATURE-----

--=-Df151gGSlTta+Fzmaozu--
