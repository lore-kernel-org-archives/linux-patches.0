Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0806435E1DA;
	Mon,  1 Jun 2026 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780312578; cv=none; b=FGwmyzDZL/xApQYVzOfHY7VG/EQ+Wm7MZeUdKP8Qs1ija2X1QRWLFfNDz/tjUeWjukDcJePNeszTuZsmYodZ5jnRjrOeI0+lfKmikzuD8tvOngVvDX5M0yA+F6962KUTBHQO7YFTjyWaipUny1e4r9ExTcW6FwpF7bEvoNLWSXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780312578; c=relaxed/simple;
	bh=djJied4dawYJH5VGwlKlbIVawFM9/ARBlmVZ4+BH2Xw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mnQ9DtdeoC/aT3jL+MSvOPMhiqQH24zP9oTGq/Lj6m2Af8ogNJspXilKrc1zVIZPvwGZ48JxpPwuhsfxJtnkXAriF4BmT+8Z+e6PLyb8dAD6Xj+TzRnBul1ZKtKH0u1QPa7N2KICqxgNGPUXsgMkan/kor/8XR7v3CPL8YghcnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU0cv-000V3T-0y;
	Mon, 01 Jun 2026 11:16:13 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU0ct-0000000FXsA-41PN;
	Mon, 01 Jun 2026 13:16:11 +0200
Message-ID: <211fb901ba2c644e6ebdffe46d9face7e317db70.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 210/589] spi: rockchip: fix controller
 deregistration
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, addy ke <addy.ke@rock-chips.com>, Johan Hovold
	 <johan@kernel.org>, Mark Brown <broonie@kernel.org>
Date: Mon, 01 Jun 2026 13:16:06 +0200
In-Reply-To: <20260530160230.478262786@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160230.478262786@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HWfmFy+lonVxdOIi8ZMS"
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


--=-HWfmFy+lonVxdOIi8ZMS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Johan Hovold <johan@kernel.org>
>=20
> commit 53e7a16070feb7d1d4d81a583eaac5e25048b9c3 upstream.
>=20
> Make sure to deregister the controller before freeing underlying
> resources like DMA channels during driver unbind.
>=20
> Fixes: 64e36824b32b ("spi/rockchip: add driver for Rockchip RK3xxx SoCs i=
ntegrated SPI")
> Cc: stable@vger.kernel.org	# 3.17
> Cc: addy ke <addy.ke@rock-chips.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://patch.msgid.link/20260324082326.901043-3-johan@kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/spi/spi-rockchip.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/spi/spi-rockchip.c
> +++ b/drivers/spi/spi-rockchip.c
> @@ -792,7 +792,7 @@ static int rockchip_spi_probe(struct pla
>  		ctlr->can_dma =3D rockchip_spi_can_dma;
>  	}
> =20
> -	ret =3D devm_spi_register_controller(&pdev->dev, ctlr);
> +	ret =3D spi_register_controller(ctlr);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Failed to register controller\n");
>  		goto err_free_dma_rx;
> @@ -828,6 +828,8 @@ static int rockchip_spi_remove(struct pl
>  	clk_disable_unprepare(rs->spiclk);
>  	clk_disable_unprepare(rs->apb_pclk);
> =20
> +	spi_unregister_controller(ctlr);

This needs to be inserted above the clk_disable_unprepare()s.

Ben.

> +
>  	pm_runtime_put_noidle(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  	pm_runtime_set_suspended(&pdev->dev);
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-HWfmFy+lonVxdOIi8ZMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodafcACgkQ57/I7JWG
EQnWog/7Be/kcSY2goDxGfyABoAYReWH5An2ZMf+nHTdW6zQHL21zlgbOEChbpRK
28n+06wg9ZD5l18gLShnBcQDC5+EFMBfKz0huo2yPCCtQ4yhMxqIn8cY01QnIiz1
My/YJVS2iSpT3uX8jA/7tlB97MHdIfzJJ7qfwgO8Cw8udMUA+kDy837EL2Th+4o5
v6vxfVWiCGplD+DsbkwcZ1OAQShLktAgiSOLCGV8qh+z/ddEypuDUplYXLcZkzcH
lkXGOzPHgaAOa0l+doUGbmV93kID9cFvtSB6F2rPLEaAGkp3f2/Eh7r3joZ+0YNz
46XsBqmKZ1KU8axuh0wSAqCc5yBvgF2HKUvKsN4+Cf25VBbCeS3n/jg5qDER/oxl
mxunmw+3CxkXQMQjvpLXcjEqiOLPynN6VQmX3FspDWL5k9u4eyDXkrAGYuu646WK
5qUe7qtgH3C2MAg0ZWcBWwiwtmng/Y91eVDsDxoMSZh6lxPAKPn5BPH/tLP8fkqb
VDL1QE7yi2RuKUhRFsOGDEuCUvmfWI+5uhDrjhJ6E85HyeH8ar6dyFNLcSmH3A1F
R+QnhNBjSst4QH9S9gYF6OPgiHwu1g6QxtLC7CjynNI20sxdpDf+z7Uype06LwP1
pB7ZMJbyUJCq874FOk+H4GHJV5mZihswynzIOq8LUebTU7pKc2c=
=MNU6
-----END PGP SIGNATURE-----

--=-HWfmFy+lonVxdOIi8ZMS--
