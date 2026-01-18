Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871DD2D5C76;
	Sun, 18 Jan 2026 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768745149; cv=none; b=X7qsCaRYwTSvYZ5bZQSf2WyZ7uHYxgafJ8xTSuZ2LvBsTwFLbfnNlIGRpIXLBqFP/ydshVX0ScdbF2SSe/w3TRHg0/E3lkPBzc0EpHxhu/h2ltlmpPl9BTUhsJCOKSBHP00Fcfr6I9ZY4kLXZ14OorexcqKfy3PwVeLdYbt4NOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768745149; c=relaxed/simple;
	bh=8mBL8EbFuI+wuny9f5SCHs2w+6gJ2DC2iYcnQx1TtM8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P9sAMyyHK8VRAWfB3F+849K/gaus5SxoVMmQ/Jm1JRFN+SBG7ex4YWx1fY9fsT43xY5S1xLIpeTUCK62Mebxb0AXCwtOugBxtSBKUxaB+x0YIe2iV/jBZNp66PjAsadhrxkH20YB8dUucD2pvpTNxHzOFKQ42LsS3bGSlvPWWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhTPV-0017bn-0M;
	Sun, 18 Jan 2026 14:05:43 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhTPS-00000000o74-1fYt;
	Sun, 18 Jan 2026 15:05:42 +0100
Message-ID: <df0940555d70eb912f2962a70b59270d0f579b9b.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 324/451] media: TDA1997x: Remove redundant
 cancel_delayed_work in probe
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>, Hans Verkuil
	 <hverkuil+cisco@kernel.org>
Date: Sun, 18 Jan 2026 15:05:36 +0100
In-Reply-To: <20260115164242.620539205@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164242.620539205@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-I42sbkXvfD4K+v0URaVO"
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


--=-I42sbkXvfD4K+v0URaVO
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
> commit 29de195ca39fc2ac0af6fd45522994df9f431f80 upstream.
>=20
> The delayed_work delayed_work_enable_hpd is initialized with
> INIT_DELAYED_WORK(), but it is never scheduled in tda1997x_probe().
>=20

It seems like it can be scheduled as soon as the probe function calls
v4l2_async_register_subdev().

> Calling cancel_delayed_work() on a work that has never been
> scheduled is redundant and unnecessary, as there is no pending
> work to cancel.
>=20
> Remove the redundant cancel_delayed_work() from error handling
> path in tda1997x_probe() to avoid potential confusion.

I don't believe this is redundant at all.

In any case, this doesn't seem to be a candidate for stable since a
redundant cancel_delayed_work() is harmless.

Ben.

> Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/i2c/tda1997x.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> --- a/drivers/media/i2c/tda1997x.c
> +++ b/drivers/media/i2c/tda1997x.c
> @@ -2779,7 +2779,6 @@ err_free_media:
>  err_free_handler:
>  	v4l2_ctrl_handler_free(&state->hdl);
>  err_free_mutex:
> -	cancel_delayed_work(&state->delayed_work_enable_hpd);
>  	mutex_destroy(&state->page_lock);
>  	mutex_destroy(&state->lock);
>  err_free_state:
>=20
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-I42sbkXvfD4K+v0URaVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmls6LAACgkQ57/I7JWG
EQlExRAAitkiOT43+1q5GymWb/MZwaPO1YWXNwb+Dk+JmVtESONU+cpQLVJn70v/
bvWSwYyQR5bd4RFYw3XPgvPc4lu43WI/Trhspt6nSr/ht9JQyua6v7VHm+izSe0+
aFWwU9WBCRo828AOBxP8VBX5UPb7o/8e+tVwLTPdPdLeKjU5MUwSvUXg9EE4d2WD
jdMkX2/moJG9uwa0UMKWvvTFuAXvXlI703XM1nY9gXyjLGioqDLoWXHnrt5S/sE8
4x+hr/7kdTfsuLF4atvk7uJdhrqn6FGOnL0Cdwh1rQaVmeAJbsIu8YpZhHUhFcKK
p55jEDU6MCG9LeTvWwiSKJd2tvXFK2F7EOpfFEOLNNnPCK2N6R1DgldfXqJyZ6om
5RRucAxahhD0Rx0O5Vje1PiYXHknsG3e0pWjMFRZk4NTa7Zp7LNPVdrXfx6Jto0k
Oy4hwmCsPnUjO4mcyZ8HP//uXYjvW9Kl/OsuQbILHhs1BqzRZD3cZNMR1r73uLvl
G3TwyR6dl2yL8ehA6AV0KtZXeYPvoAM7K6pfFF+fk5o9tRsTSKdqaWi21oiVjZms
c+ST7F+P1IXUW9AKSeG8dGMTa2zkg1lDZOxr5mk89YRXyKtgHwUUgew4QQhBUcwh
g9VQMcQXAXoLloLdMP44UYVpP2Xi8RRdmvcTxhvgq4/uY+/wy+o=
=3Oz3
-----END PGP SIGNATURE-----

--=-I42sbkXvfD4K+v0URaVO--
