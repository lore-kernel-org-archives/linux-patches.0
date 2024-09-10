Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A44185B43
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965878; cv=none; b=iMkSgte9EEtZXIUMFZsvS4KxEpHBb8k81pApBSUgOsaiQKa3uF5vq5fbseNPhpyqPlusH9nqju1Q0YkowJFYnjTwTewyutFJQ2nQiGT889Sl5nTx9kmHmMIecQOnVaYftfg6KHuXNBI51yD4DQed1yI998jO8PdS+Nh8QnxdOM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965878; c=relaxed/simple;
	bh=tTecUmMwMV7vjPhIE1nH3KpDvjXUoOSU2QQBQRGtupE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EO6L4DEssrQiwL6RRz2XgKNbYI51EWcNyT2EOx2ww6/EPz6mC9yN/LeuMG9uyXlUrN2nbJg0UDFntwahXZ2wh9TrggBaWlzsI0T5DsS0ifdwd4XNzb+xmE84o7wxkZNUFGYRKVRTW9DlyAzs/2unaZ7/APqZ97JHn7uMGg57JNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1snyZ5-0001iF-C4; Tue, 10 Sep 2024 12:57:43 +0200
Received: from [2a0a:edc0:0:b01:1d::7b] (helo=bjornoya.blackshift.org)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mkl@pengutronix.de>)
	id 1snyZ3-006sM6-QY; Tue, 10 Sep 2024 12:57:41 +0200
Received: from pengutronix.de (pd9e595f8.dip0.t-ipconnect.de [217.229.149.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 6B267337707;
	Tue, 10 Sep 2024 10:57:41 +0000 (UTC)
Date: Tue, 10 Sep 2024 12:57:41 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel@pengutronix.de, Vincent Mailhol <mailhol.vincent@wanadoo.fr>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Heiko Stuebner <heiko@sntech.de>, linux-can@vger.kernel.org, netdev@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Subject: Re: [PATCH net-next] can: rockchip_canfd: Use div_s64() in
 rkcanfd_timestamp_init()
Message-ID: <20240910-therapeutic-olive-turkey-73dc3c-mkl@pengutronix.de>
References: <20240909-rockchip-canfd-clang-div-libcall-v1-1-c6037ea0bb2b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="25ff24i24dga7xbo"
Content-Disposition: inline
In-Reply-To: <20240909-rockchip-canfd-clang-div-libcall-v1-1-c6037ea0bb2b@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--25ff24i24dga7xbo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.09.2024 09:24:25, Nathan Chancellor wrote:
> When building with clang for a 32-bit target, such as arm, a libcall is
> generated when dividing the result of clocksource_cyc2ns(), which
> returns a signed 64-bit integer:
>=20
>   ERROR: modpost: "__aeabi_ldivmod" [drivers/net/can/rockchip/rockchip_ca=
nfd.ko] undefined!
>=20
> Use div_s64() to avoid generating the libcall.
>=20
> Fixes: 4e1a18bab124 ("can: rockchip_canfd: add hardware timestamping supp=
ort")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

A similar patch by me is mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3D9c100bc3ec13914f9911a937ec5b38182a5c3d64

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--25ff24i24dga7xbo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEUEC6huC2BN0pvD5fKDiiPnotvG8FAmbgJiIACgkQKDiiPnot
vG8g4AgAiBik9dV5HcawcjdwbwyUqH/9YsohijhBpU0b0WuBDp/79XH3o4yu3jIv
C8JcMkL8C9D6bSCdcgcbV94/qzeiBpBAGwRPqn+M+VyILvV0rkO76Em4vmLiCK/G
uSJLElidOCNkLWkGOtVPH3k1lc90du2ZJh3peQ6V9E0tbv0RJamKrnRgIFiQP1Uf
K1Ji2W0yk0VArkepwqO/rdVysFLoLJVtbJB1mHd0sK/mQ/M1PrbP2KAgWmMfv/4b
YYrbgYMMcIhoprVc1ISs3ChOVywIlV6EvQE8G8zn0tYWIWARgcI7HpmXkpzoaAIl
JOWrOfTk6792XowID33b/+Fni2RXYA==
=FMZt
-----END PGP SIGNATURE-----

--25ff24i24dga7xbo--
