Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8371E1E11;
	Fri, 28 Mar 2025 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743198726; cv=none; b=TeFgNj/XH9d2U6gnYDz3ibHeta52epBkiYaNnSWu7l1jL34gn3XK9Oi5G1cPjf2MrrESBjpD8pLkTwfq3lTnM5xq90GyLeb8Dz2qY2Hx1Nkodz0nHREjleIeJz9I9i5rGV4qFw8OPM79XGqzmey7xAuSudaJ9+KzXTpr7OUDr1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743198726; c=relaxed/simple;
	bh=u/bNVK7pDHk3erQmVbaN0DW8LfqFUaLoQqjFM3kCwfI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YyudzDH4CSVqrNSN318GJj0qyi2WqxiGgsujkkSVw8WTKuvTkSZRCbeXw9Gzp+nbm3ntBhWBo2ADPLLq7m27DNskAo5CrQ399D5qP8iTitxiEf9bql6MryAQKDg5lUOpQaUgD8bYNFLaF+w4TZ5nlyV2XTXywWzcj0NwsdawvW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1tyHcR-0006t4-1J;
	Fri, 28 Mar 2025 21:52:02 +0000
Received: from ben by deadeye with local (Exim 4.98.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1tyHcP-00000000AFP-1cEZ;
	Fri, 28 Mar 2025 22:52:01 +0100
Message-ID: <f104048adbff7eb54c913e488c516be45e404419.camel@decadent.org.uk>
Subject: Re: [PATCH 5.15 620/620] net: ipv6: fix dst refleaks in rpl, seg6
 and ioam6 lwtunnels
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Justin Iurman <justin.iurman@uliege.be>, Simon
 Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Date: Fri, 28 Mar 2025 22:52:01 +0100
In-Reply-To: <20250310170610.006675223@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
	 <20250310170610.006675223@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rad6cctMQMogCoCIl8lb"
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


--=-rad6cctMQMogCoCIl8lb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-03-10 at 18:07 +0100, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jakub Kicinski <kuba@kernel.org>
>=20
> commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.

This backport to 5.15 seems to be correct.  But why is this fix missing
from the later 6.1 and 6.6 branches?

Ben.

> dst_cache_get() gives us a reference, we need to release it.
>=20
> Discovered by the ioam6.sh test, kmemleak was recently fixed
> to catch per-cpu memory leaks.
>=20
> Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
> Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue"=
)
> Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue=
")
> Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/20250130031519.2716843-1-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/ipv6/rpl_iptunnel.c  |    6 ++++--
>  net/ipv6/seg6_iptunnel.c |    6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
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
> @@ -490,8 +490,10 @@ static int seg6_input_core(struct net *n
>  	local_bh_enable();
> =20
>  	err =3D seg6_do_srh(skb, dst);
> -	if (unlikely(err))
> +	if (unlikely(err)) {
> +		dst_release(dst);
>  		goto drop;
> +	}
> =20
>  	skb_dst_drop(skb);
> =20
> @@ -582,7 +584,6 @@ static int seg6_output_core(struct net *
>  		dst =3D ip6_route_output(net, NULL, &fl6);
>  		if (dst->error) {
>  			err =3D dst->error;
> -			dst_release(dst);
>  			goto drop;
>  		}
> =20
> @@ -604,6 +605,7 @@ static int seg6_output_core(struct net *
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

--=-rad6cctMQMogCoCIl8lb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmfnGgEACgkQ57/I7JWG
EQlBRhAA1SIHQeMBR3V/aOlttcbmfbdeP3Muor4sDnEpEUDrRPsXTNJgRgHwLpS/
cCvkexbBD7Vwxl+TCJrRc2mBUCa3/+FYOSBWeKgjMe2HbKWtOGpmqfMCnMc7sjE5
6zSaIzPo875+TBGRF/0jcYNv0mYE2WPSrzVtJLMddHrs/Q5r6jD4TW0fhcgOoPs5
AhL0zn+bqI4qTAgtXLKzwVATuzZYKg+MLyunUoVyR1ar7l/qNj3Fajg8rGIuCIuL
vvyEI2Rry8wetWWpgY7JDRVclfyOwV7jsfxqYN2pQM+PfEmQ4beB3SlUXzBs84TX
IAjFWg7MB4JSafF6o+C8hALh0KQz9BR5TDxvv4wrz4CBYr9FZBX9YmfEwdN77Lxm
/5i/U7+w6cZ21IykUwLL9bxQV7R5pidrur9m2jJ3f7/3tmX6UTfAa5rB9emYhdk2
xZcA8+FbOKsCU2c+50zYI72SduksM4uvvp9c90GrWnOtHJfNxs3wPsBOX3B9DcUy
Bcf26j65z6bsqWvCIOBc/RjyEUAAkivwiQ3s6cAmPe0ShVOF8k6RQZTv5hnAY4pJ
1Ivm7KNbHz0UWyzsU0Ax+oCmBK/hU8ijtwseXW1ePGaowY5PPH9LPKNrYzagHNVm
DTNp7Pnwo88VMfuAKiYTvewb/+Fdzd1JjQeuoJfUvhBniLpSRZc=
=7GPj
-----END PGP SIGNATURE-----

--=-rad6cctMQMogCoCIl8lb--
