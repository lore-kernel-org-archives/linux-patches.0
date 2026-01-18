Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8274632A3EB;
	Sun, 18 Jan 2026 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768746134; cv=none; b=SJB1Btv7Y0oMEWibjHbt4rOjLeXHr5FJQcBggow9+SxuqVDOhInBbs26k81PpumSCiyo/4KoJncKzdGDWYyMHakhXD+oi6D+pjYx5EkRv23Db9t9CYmwS7Z/dJ357WMCgYLb9SKAOEfHG0JKW1Sxfz1i/7zdBcFtPv8/YPJ2P78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768746134; c=relaxed/simple;
	bh=D45cU69mUEWEgJbqJ9hdCs9R6h04qBv0d1fY9vllBzo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WpMIzM+kaoiL6yzcdrylSzylcAQug8r1r5tCmLNuh6j8CplOWi1fGkxdvVLNTGK/rF7dKKkwjxy2CFg8ZwNjlZnwVeio+Aoh/qha7b5d5Aeu+yni3q2ZlsbAcEu9H1INvtqjsbl8pY90MVpmDMWHld3gZzNOTJPtIOJW/24IL9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhTfO-0017gn-33;
	Sun, 18 Jan 2026 14:22:09 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhTfM-00000000oIX-38xK;
	Sun, 18 Jan 2026 15:22:08 +0100
Message-ID: <7c9592007c32c55935af212fcf6658fbab2baffe.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 326/451] media: i2c: adv7842: Remove redundant
 cancel_delayed_work in probe
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>, Hans Verkuil
	 <hverkuil+cisco@kernel.org>
Date: Sun, 18 Jan 2026 15:22:03 +0100
In-Reply-To: <20260115164242.691121734@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164242.691121734@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VeBS7nT6YVPBZDb8/2X3"
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-VeBS7nT6YVPBZDb8/2X3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Duoming Zhou <duoming@zju.edu.cn>
>=20
> commit e66a5cc606c58e72f18f9cdd868a3672e918f9f8 upstream.
>=20
> The delayed_work delayed_work_enable_hotplug is initialized with
> INIT_DELAYED_WORK() in adv7842_probe(), but it is never scheduled
> anywhere in the probe function.
>=20
> Calling cancel_delayed_work() on a work that has never been
> scheduled is redundant and unnecessary, as there is no pending
> work to cancel.
>=20
> Remove the redundant cancel_delayed_work() from error handling
> path and adjust the goto label accordingly to simplify the code
> and avoid potential confusion.

I think this may have the same problem as #324, though I can't see
exactly at what point the subdev is registered.

Ben.

> Fixes: a89bcd4c6c20 ("[media] adv7842: add new video decoder driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/i2c/adv7842.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> --- a/drivers/media/i2c/adv7842.c
> +++ b/drivers/media/i2c/adv7842.c
> @@ -3552,7 +3552,7 @@ static int adv7842_probe(struct i2c_clie
>  	state->pad.flags =3D MEDIA_PAD_FL_SOURCE;
>  	err =3D media_entity_pads_init(&sd->entity, 1, &state->pad);
>  	if (err)
> -		goto err_work_queues;
> +		goto err_i2c;
> =20
>  	err =3D adv7842_core_init(sd);
>  	if (err)
> @@ -3573,8 +3573,6 @@ static int adv7842_probe(struct i2c_clie
> =20
>  err_entity:
>  	media_entity_cleanup(&sd->entity);
> -err_work_queues:
> -	cancel_delayed_work(&state->delayed_work_enable_hotplug);
>  err_i2c:
>  	adv7842_unregister_clients(sd);
>  err_hdl:
>=20
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-VeBS7nT6YVPBZDb8/2X3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmls7IsACgkQ57/I7JWG
EQmSFw//St7uOwgz1sv9ff7qjga6yKNeTGUNw6m7gBCsKAuPQ/8l+wkfmqvbBJ+P
v+eU8G1okafvqa1V/qakkXt8Fo+FpUXZc6n1SdZ4ykDUx6lKEN+SAkLoxJUPJhmB
3Rg8Jr3euLRnhaU/5qpZkIdUFSflXwINZ52623wo7XU+LSeMa/Sq/DJMKWO0EtQa
97DaQjb0UeV4kyqQxXmg6kcDFFypjYgBY47Q8ohwH4mnKhpzDa7CW+6FrOCOxkG2
7VaCW8h2HQR81PbvxTgrpTTCnr2eM+mZ1PcfB6e1T9oowxRbV0kA9XVY70vXPdVY
/pLi74fEi/QP+kFUDzF0P9DykrU9TN3yQqnWNyPX77HiOcDrPxeDjJwc8xgKlU++
XW2rdy1Dapaj5BoBGt9uwofVHZaYv6BXicishRGBmXegyJ6cyUT21xDq8HGgugxJ
Va8fRYggLJsHt0p200YGG6i1wYhsbVGHvp11sspeV7vaLMkYDD7EhxrTnvT0X/nQ
m4jIT/MJl5+nrN58vw+IO9RU3bnqETfKSFbl1DVLCgsSbtuqgZ87hzCo9LdbCwTR
9K9PHcINr8tQ2o0BgeOsPyi4gap0zZhULvGwMBBjYMVi9TJgcxvLFZ1cu4zjH+XZ
d6yYBhHnaaW77HZNhY4j7QtqV3zu1XEBGboqMN5GSOG8zAd7h+Q=
=TPYc
-----END PGP SIGNATURE-----

--=-VeBS7nT6YVPBZDb8/2X3--
