Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB00F20AF98
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598201; cv=none; b=WkzBV7hrpD7w/bh9WChgDLpLZMRhMAgO/5tQbBAjBPc/vixn+GovnwB4kc/coSScFwfQjPGxnKAdXPff97+iGVJXV6mH4jtbtfLo0jPDoVpHedymAKQuwq7LfZBiJN0UXbHfwoeft/qhGaYWN71eQpz7I32iM4CvwvA6IkNJJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598201; c=relaxed/simple;
	bh=mioDvC2ui2Lxen2IMB4GYdqH2dt1hyHQQ6NT3WLGnEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLSs7b6uEAEhKcuPuxe98BEyxtQyIuM2d/4WUtYLGtW2E86cCKNPEZUo0cf5e84HlMmH7G/3p7YcpcC31ZAq8SOWqm+gTIxG8ooqJmMn7FBbF8kwOvBG+ACUE3IkX2VTAK0s2p2lDhnRAkOPa6iMwTwVYu3ut2TmJirN8EYMRWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=PFerO9NQ; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="PFerO9NQ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2471E1039728C;
	Fri, 30 May 2025 11:43:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598191; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=FQRxEscHyQvbeEYaXoppZrwOnFMUfcM8GeS7AnKpU9k=;
	b=PFerO9NQjRLNXT2V82j389X3VTgCUUSGBokFd6zZtH+rMNSQs/rD5HCnuNLRGd8CiF7yJO
	lTPfcrzVbxcAEZY0QOln3bBqk5Z92fi4pxbUZlhY3nNGGvQ1aHBrLxIFbNnL9rCaMB+piB
	K/mFSlNRFUDPa5Jdlxxns7zctAO1U6WDgNKeBZpAhYjajQFSzgJ3250bWs7PulFEe7kS0c
	3XAMN5OkWmHAbgq2isaOGAALNCBHQa1s0EmwB9OqOdkmaYnoVKzHs/OqeixU59uNMSsQv8
	CeNuGNnRcKWzznsmrIRodhlG6/7b3/URGUyFKOwHtGghKgmMadJtcuVD6jkNQw==
Date: Fri, 30 May 2025 11:43:05 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 008/626] phy: renesas: rcar-gen3-usb2: Lock around
 hardware registers and driver data
Message-ID: <aDl9qRLgMsPk6wfm@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162445.395868574@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8UIl4i+mEuGkEsGB"
Content-Disposition: inline
In-Reply-To: <20250527162445.395868574@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--8UIl4i+mEuGkEsGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>=20
> [ Upstream commit 55a387ebb9219cbe4edfa8ba9996ccb0e7ad4932 ]
>=20
> The phy-rcar-gen3-usb2 driver exposes four individual PHYs that are
> requested and configured by PHY users. The struct phy_ops APIs access the
> same set of registers to configure all PHYs. Additionally, PHY settings c=
an
> be modified through sysfs or an IRQ handler. While some struct phy_ops AP=
Is
> are protected by a driver-wide mutex, others rely on individual
> PHY-specific mutexes.


> This approach can lead to various issues, including:
> 1/ the IRQ handler may interrupt PHY settings in progress, racing with
>    hardware configuration protected by a mutex lock
> 2/ due to msleep(20) in rcar_gen3_init_otg(), while a configuration thread
>    suspends to wait for the delay, another thread may try to configure
>    another PHY (with phy_init() + phy_power_on()); re-running the

You should not be holding spinlock for 20 msec. You really, really,
_really_ should not be holding irqsave spinlock for 20 msec.

> +++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
> @@ -118,7 +119,7 @@ struct rcar_gen3_chan {
>  	struct regulator *vbus;
>  	struct reset_control *rstc;
>  	struct work_struct work;
> -	struct mutex lock;	/* protects rphys[...].powered */
> +	spinlock_t lock;	/* protects access to hardware and driver data structu=
re. */
>  	enum usb_dr_mode dr_mode;
>  	u32 obint_enable_bits;
>  	bool extcon_host;
> @@ -348,6 +349,8 @@ static ssize_t role_store(struct device *dev, struct =
device_attribute *attr,
>  	bool is_b_device;
>  	enum phy_mode cur_mode, new_mode;
> =20
> +	guard(spinlock_irqsave)(&ch->lock);
> +
>  	if (!ch->is_otg_channel || !rcar_gen3_is_any_otg_rphy_initialized(ch))
>  		return -EIO;
> =20
> @@ -415,7 +418,7 @@ static void rcar_gen3_init_otg(struct rcar_gen3_chan =
*ch)
>  		val =3D readl(usb2_base + USB2_ADPCTRL);
>  		writel(val | USB2_ADPCTRL_IDPULLUP, usb2_base + USB2_ADPCTRL);
>  	}
> -	msleep(20);
> +	mdelay(20);
> =20
>  	writel(0xffffffff, usb2_base + USB2_OBINTSTA);
>  	writel(ch->obint_enable_bits, usb2_base + USB2_OBINTEN);

Here.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8UIl4i+mEuGkEsGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDl9qQAKCRAw5/Bqldv6
8iedAJ44sblWyUv4c4lD/YYyPEGna2RtlwCfRuk3jPq6XVlu/+j0yQ0hDYWHPwM=
=TsQE
-----END PGP SIGNATURE-----

--8UIl4i+mEuGkEsGB--
