Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A128C84A;
	Mon,  1 Jun 2026 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332069; cv=none; b=U3f5ovctYRkdZIOHrk2MyAr74PBTZA1M+CYipgDeXgEQtWKcBD3ZT8rK+M+w++wbtV+iT1h7yJQ2eGz3wy0coCs2il+pkeDfMMWl1ni6sf46PoUynIuvFWCgEi6QBfnsQm5b68N5hp6fIWq6S3/kSbmc+WQcQJX8tTdh0s4O7bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332069; c=relaxed/simple;
	bh=qQDxMRdRNwrMjzRPlH51zmqbHCeu395k6lIZKZySoOg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DQT4I9stCllIGmPCWhFOT52q35cTID2bY/qo6ObgnbyG9abYUdm+ps298m7I9GLOfhConYWmdTuhnYuLxyoFFY+oPclL+cv6nbRHEnJgnQDt8EwMStqvpdWb1y6RMXe196dZy5DdXx86BgnoUsjGgtE9UM+RQFZ6FTgvLzJcOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU5gn-000WZc-0h;
	Mon, 01 Jun 2026 16:40:33 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU5gl-0000000Fi32-3oaN;
	Mon, 01 Jun 2026 18:40:31 +0200
Message-ID: <7fee88099501bfa87594114a5f8c17a760ded36a.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 244/589] spi: topcliff-pch: fix use-after-free on
 unbind
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
  Johan Hovold <johan@kernel.org>, Mark Brown <broonie@kernel.org>
Date: Mon, 01 Jun 2026 18:40:27 +0200
In-Reply-To: <20260530160231.411962903@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160231.411962903@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2IWRWaAU0PpeU2v9eku9"
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


--=-2IWRWaAU0PpeU2v9eku9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Johan Hovold <johan@kernel.org>
>=20
> commit 9d72732fe70c11424bc90ed466c7ccfa58b42a9a upstream.
>=20
> Give the driver a chance to flush its queue before releasing the DMA
> buffers on driver unbind

This doesn't seem like it will fix anything unless commit 5d6f477d6fc0
"spi: topcliff-pch: fix controller deregistration" is applied first.=20
And that definitely needs backporting for older kernel versions due to
the API name changes.

Ben.

>=20
> Fixes: c37f3c2749b5 ("spi/topcliff_pch: DMA support")
> Cc: stable@vger.kernel.org	# 3.1
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://patch.msgid.link/20260414134319.978196-9-johan@kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/spi/spi-topcliff-pch.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1426,9 +1426,6 @@ static int pch_spi_pd_remove(struct plat
>  	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=3D%d\n",
>  		__func__, plat_dev->id, board_dat->pdev->irq);
> =20
> -	if (use_dma)
> -		pch_free_dma_buf(board_dat, data);
> -
>  	/* check for any pending messages; no action is taken if the queue
>  	 * is still full; but at least we tried.  Unload anyway */
>  	count =3D 500;
> @@ -1452,6 +1449,9 @@ static int pch_spi_pd_remove(struct plat
>  		free_irq(board_dat->pdev->irq, data);
>  	}
> =20
> +	if (use_dma)
> +		pch_free_dma_buf(board_dat, data);
> +
>  	pci_iounmap(board_dat->pdev, data->io_remap_addr);
>  	spi_unregister_master(data->master);
> =20
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-2IWRWaAU0PpeU2v9eku9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodtfsACgkQ57/I7JWG
EQmmJhAAteftrSMq66CAYjdpAyggbmj5QwUeeV9JlASlF/jJf6BZg4vY7tk4UeqF
/oM+nbQndM/9MJTr7nzOB/K6VwzlTDExdxoVAipsWI0kF2STqMu89LjGmMXpvT7Y
H/+VsXid7ymhHbIUDciZugTwVvYp4vCOa3HV3OaEXga+ZePPJhZ2Y7oFMwaFJ1rW
6Swy/DTY6kGZKM9BlCrwnaxy7hKXFrkuPYYHhlkYNtJLQJRmPOyIXQHXl4evjpYl
cbW5xX8CjJM1kcjQCxPsqeG1GwvsYQPmlWrapfX+zIEo1WjRC0NSTueMNttMT1PN
SrLVDcmyp/bGeO5/H9W3aLc+aVrlGpLfKh9+ViUs/83FSPUK2AD22gVMrFrJ389m
HsYLOpI/mwnL/Gp9AS0vQYulW4rNCdWcMr+6UF+n0PH9s0XHQ9ESeg2y+ojWwPpZ
vwrqqQ/wU/6Ks+hEpOxPueVqyfA63pqNG1XUUY4+VYxsUHWGrxAf3WAHSW8kcR3u
Xt0JfzR5X3Jj/chh2zCLOWTuKUYh44VyYyCg+FS2n/sz/4nQ7n9tFRNHDrO/DaPn
HRKLabQMuhs1EaZp03ukOCB/fyZsHCXDSkK3hrW42FrDz7DoEaA5fLm2O6xCTimW
2BwBidc3/JmFuDqX3Sjbiw3e/bxwDO9sxdbiiMuYjr3MDsDL3Ig=
=RK+j
-----END PGP SIGNATURE-----

--=-2IWRWaAU0PpeU2v9eku9--
