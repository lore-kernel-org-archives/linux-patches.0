Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5A834CFBE;
	Thu,  5 Feb 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770303439; cv=none; b=U6u9aVgHpo+oegYjhNlHroFJSdiKIHbO3I5gL/xukn5ap6ySJPzqABc5nB6r2DJtFhs6gq7z4LoDwz2yxbnMZ0CSER8qATbDzFmRI3Polxa3FXc0fLzBrhBl6VpvsGPHWmVEhsjuQjFiq4DWFHbC2q71wMPOUUk608eeREBriIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770303439; c=relaxed/simple;
	bh=jpQPhrZphWITwRKPkvG3MqZqoHKBpoqa5t8z5ExqLzY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VZNMZaoaHjQmN/PD6grwum/rY/QB7rp0jdmIBIe97IYsgWv5rKkSrtwuSs9HP8G7efbZ3h51j4tJ9DpQ4mFjyt+k/m0Qlra89zeQpAPQ2shsPo7JU7vbLAAqAV1H3lhlbOfvJYnowfpNBFXCYduD5gD90VU3O+IZSxbFGQbJSFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo0nE-003uFH-1V;
	Thu, 05 Feb 2026 14:57:15 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo0nC-00000001fBW-0lpZ;
	Thu, 05 Feb 2026 15:57:14 +0100
Message-ID: <24fb4c47ea6f4c8025f6b0592088c1a9d10741a4.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 037/161] dmaengine: at_hdmac: fix device leak on
 of_dma_xlate()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>, Johan Hovold
	 <johan@kernel.org>, Vinod Koul <vkoul@kernel.org>
Date: Thu, 05 Feb 2026 15:57:08 +0100
In-Reply-To: <20260204143853.096025132@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143853.096025132@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-J23czQC1huxxyY3KXwkO"
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


--=-J23czQC1huxxyY3KXwkO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Johan Hovold <johan@kernel.org>
>=20
> commit b9074b2d7a230b6e28caa23165e9d8bc0677d333 upstream.
>=20
> Make sure to drop the reference taken when looking up the DMA platform
> device during of_dma_xlate() when releasing channel resources.
>=20
> Note that commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing
> put_device() call in at_dma_xlate()") fixed the leak in a couple of
> error paths but the reference is still leaking on successful allocation.
>=20
> Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
> Fixes: 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call =
in at_dma_xlate()")
> Cc: stable@vger.kernel.org	# 3.10: 3832b78b3ec2
> Cc: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://patch.msgid.link/20251117161258.10679-2-johan@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/dma/at_hdmac.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1320,6 +1320,7 @@ static int atc_config(struct dma_chan *c
>  		      struct dma_slave_config *sconfig)
>  {
>  	struct at_dma_chan	*atchan =3D to_at_dma_chan(chan);
> +	struct at_dma_slave	*atslave;
> =20
>  	dev_vdbg(chan2dev(chan), "%s\n", __func__);
> =20

This hunk is being applied to the wrong function.  It should also be
applied to atc_free_chan_resources() (but doesn't apply cleanly).

Ben.

> @@ -1579,8 +1580,12 @@ static void atc_free_chan_resources(stru
>  	/*
>  	 * Free atslave allocated in at_dma_xlate()
>  	 */
> -	kfree(chan->private);
> -	chan->private =3D NULL;
> +	atslave =3D chan->private;
> +	if (atslave) {
> +		put_device(atslave->dma_dev);
> +		kfree(atslave);
> +		chan->private =3D NULL;
> +	}
> =20
>  	dev_vdbg(chan2dev(chan), "free_chan_resources: done\n");
>  }
>=20
>=20

--=20
Ben Hutchings
Horngren's Observation:
              Among economists, the real world is often a special case.

--=-J23czQC1huxxyY3KXwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmEr8QACgkQ57/I7JWG
EQm4mA/+PAKRdv3squBxZ2y/F+09mq0BpcvGLW/PX7bvf3ley/tQxTffTM229Fgw
+49XTdqWjHS0mu7KXk8muEfr/md8Jf4cqvKjVBAxzN4U9Qb5Meb2OGIzFAintq+Q
7lch+PszbmXqcds710mym5orrJQybTK/8hGhGd7/lT13HzwP0Zg6NhPMfc5UQcvw
S8oGqC9SSZv+dDSsSKTnLSZX0CNEKwDsworfO/WCfX+Yn9aYmsA2q4XWYQ4108uV
6hvNYy+0Xknl/K1b56CMVXRpN9iGJhq9CynGDnR09/MM64msVLABxYHw2F7oNxy3
DoHtZb5pvW2TGBim9xEGeHr8XfuQEEvE7AZpnqWdqmmw8X6VVqKqA3Acd9INPd0I
GyaEjSb+SyqkE5Ae6guvzGhiI7oH0YnW3/g6P5iuqt0/uM+vJB3/jr4IJ9ag8IrZ
clQL9Vboled1tYtLy/FwLJX9yBdB0QWPVrSrRlWq72FhGDCmfX07yntBYsZEGrlo
LTggHRh/eNVdAqmTbnJgDk3Q/1An7kh6c1rRwoxJSvqPGbdB6nN3aakXQHTfaZ7a
mAclX0uPlwUeY6fXltD4qjn4N/wySeKvQk940io0lDiUHCnSVuQi2iXV94Cbg4+Y
38nafrAL2qvbqxb4mg1e3kFdI/Uk+kDG8XuzQpvyZ3Q4Ts/NM+A=
=YxUf
-----END PGP SIGNATURE-----

--=-J23czQC1huxxyY3KXwkO--
