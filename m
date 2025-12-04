Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C414E34F49D;
	Thu,  4 Dec 2025 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764882037; cv=none; b=ccq7gyd3eE368R8o38DR5K4+QqNXz78T47jzTdUUaGtPsodUGLFGLmqHjz72c7+F4GKq23Nk1g2oB+gxzMXqKpNAJFh+hoBa3LWg3j4FkztAgir+4SRNuYJgzFbChvGGBmqXVZtFnqRBQh7aCutBLVD6Ts/CPcxSis/qgLwO5xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764882037; c=relaxed/simple;
	bh=jaPU5Hv/cOzy1vKXBOFOV8ijvjN7wqOOR5XTyXeT5xk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P7vA7aly8DPpSOd7AEl/yCf28QmxzKiYAlKCcl4Q5uuEoO+GK+3ccSjPWlCsPKHqR4ys8SH0RDERDpNn0soNXfbmkMxLXbndxYz5r4QbZI20wkiJNwO4OX4vdATnnQqeGjohkiVbMYMWQAbvGGnir4mtIf0crsv4lwlIiNpMYtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vRGRF-006E8M-0i;
	Thu, 04 Dec 2025 21:00:33 +0000
Received: from ben by deadeye with local (Exim 4.99)
	(envelope-from <ben@decadent.org.uk>)
	id 1vRGRD-0000000039g-3D1t;
	Thu, 04 Dec 2025 22:00:31 +0100
Message-ID: <4b5243ba872f979f1f15d6088da01ec301735bc1.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 013/300] ASoC: qdsp6: q6asm: do not sleep while
 atomic
From: Ben Hutchings <ben@decadent.org.uk>
To: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Cc: patches@lists.linux.dev, Mark Brown <broonie@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Thu, 04 Dec 2025 22:00:27 +0100
In-Reply-To: <20251203152400.949724126@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
	 <20251203152400.949724126@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QiSzwREwLbRLYGXE0UUQ"
User-Agent: Evolution 3.56.2-7 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-QiSzwREwLbRLYGXE0UUQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 16:23 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>=20
> commit fdbb53d318aa94a094434e5f226617f0eb1e8f22 upstream.
>=20
> For some reason we ended up kfree between spinlock lock and unlock,
> which can sleep.
>=20
> move the kfree out of spinlock section.
>=20
> Fixes: a2a5d30218fd ("ASoC: qdsp6: q6asm: Add support to memory map and u=
nmap")
> Cc: Stable@vger.kernel.org
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
> Link: https://patch.msgid.link/20251017085307.4325-2-srinivas.kandagatla@=
oss.qualcomm.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  sound/soc/qcom/qdsp6/q6asm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/sound/soc/qcom/qdsp6/q6asm.c
> +++ b/sound/soc/qcom/qdsp6/q6asm.c
> @@ -376,9 +376,9 @@ static void q6asm_audio_client_free_buf(
> =20
>  	spin_lock_irqsave(&ac->lock, flags);
>  	port->num_periods =3D 0;
> +	spin_unlock_irqrestore(&ac->lock, flags);
>  	kfree(port->buf);
>  	port->buf =3D NULL;
> -	spin_unlock_irqrestore(&ac->lock, flags);

You are right to move the kfree(), but are you sure it's safe to also
move the clearing of port->buf?  It seems like this introduces a
potential data race and UAF in q6asm_stream_callback().

Ben.

>  }
> =20
>  /**
>=20
>=20

--=20
Ben Hutchings
It is easier to change the specification to fit the program
than vice versa.

--=-QiSzwREwLbRLYGXE0UUQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmkx9msACgkQ57/I7JWG
EQlyEhAA1Hqrzni0yLq2xbI6W6OzEj4/jLyk/86uvgM1WeV20wmapDuv3W5OT1Xo
bdNhg9hR111WANNKB0wJ6DTAE8WqaZFZZCxtCit8oRx8KHp4aDkpoPS675LxI3K1
l7ehM/Coc5CfHYa/zq7GmqSw4YCh8PbHn6sAVNqsIrPxNDhPg5koB0FO2XOBYikO
ew51hvrh+o1KGg9XDgL6u+fMMPr0gyTvuOnNzH1kZ9INSe6zBjfFZor0JWroooxj
ZtAF9IJPF/yp5G53MLUQEP0lf/gR3Q623r27pK6GFt8070AlOdGFXmAUGEpCJ+Am
02FPiTxn6mLz6yqGZO4A1ltpU9GaUz3Q1EuDmQ4NPuBE9B7dOYo5R5LjI9WXgxGv
ie+wPtRUMOagUgHaA/kNJboIiijF/qkGx8BHjFDp9+q7LlccnWwS6LvIjqLALLya
EKnO1H3KXmHIeaAxAVkNE2+zPt3bka4oRY1A3342b6zUKAZauk7eoO7e0zhqyy4v
wAIwE95468l1HQF8Y/LSaQpsGoZnN0GXSj1EdgBIyNlMScLBHcXIDlTs3ahandpx
X1+ywmYpWmPNisec+dv6icAzGwakal4a164WgmBnDH8OVPojS0jVcVMHb1pD8ZPV
OmheroWC9OzahrQwZIi3Tya6UEl7sC69gjQLoM6p04lQwzl5GkI=
=v8Id
-----END PGP SIGNATURE-----

--=-QiSzwREwLbRLYGXE0UUQ--
