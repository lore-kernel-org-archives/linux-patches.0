Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58E633302
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 18:35:51 +0000 (UTC)
Received: from [213.219.167.32] (helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1q59ck-0004vW-GI; Fri, 02 Jun 2023 20:35:42 +0200
Received: from ben by deadeye with local (Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1q59ck-001Cf5-00;
	Fri, 02 Jun 2023 20:35:42 +0200
Message-ID: <aa0d401a7f63448cd4c2fe4a2d7e8495d9aa123e.camel@decadent.org.uk>
Subject: Re: [PATCH 6.3 145/364] staging: rtl8192e: Replace macro
 RTL_PCI_DEVICE with PCI_DEVICE
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Philipp Hortmann
 <philipp.g.hortmann@gmail.com>,  Sasha Levin <sashal@kernel.org>
Date: Fri, 02 Jun 2023 20:35:31 +0200
In-Reply-To: <20230522190416.389735437@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
	 <20230522190416.389735437@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HWqfuX877mXofA46aiW+"
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-HWqfuX877mXofA46aiW+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-05-22 at 20:07 +0100, Greg Kroah-Hartman wrote:
> From: Philipp Hortmann <philipp.g.hortmann@gmail.com>
>=20
> [ Upstream commit fda2093860df4812d69052a8cf4997e53853a340 ]
>=20
> Replace macro RTL_PCI_DEVICE with PCI_DEVICE to get rid of rtl819xp_ops
> which is empty.

It is not empty (except in 6.4).

This needs to be reverted from all stable branches.

Ben.

> Signed-off-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
> Link: https://lore.kernel.org/r/8b45ee783fa91196b7c9d6fc840a189496afd2f4.=
1677133271.git.philipp.g.hortmann@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 6 +++---
>  drivers/staging/rtl8192e/rtl8192e/rtl_core.h | 5 -----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/stagi=
ng/rtl8192e/rtl8192e/rtl_core.c
> index 72d76dc7df781..92552ce30cd58 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
> @@ -48,9 +48,9 @@ static const struct rtl819x_ops rtl819xp_ops =3D {
>  };
> =20
>  static struct pci_device_id rtl8192_pci_id_tbl[] =3D {
> -	{RTL_PCI_DEVICE(0x10ec, 0x8192, rtl819xp_ops)},
> -	{RTL_PCI_DEVICE(0x07aa, 0x0044, rtl819xp_ops)},
> -	{RTL_PCI_DEVICE(0x07aa, 0x0047, rtl819xp_ops)},
> +	{PCI_DEVICE(0x10ec, 0x8192)},
> +	{PCI_DEVICE(0x07aa, 0x0044)},
> +	{PCI_DEVICE(0x07aa, 0x0047)},
>  	{}
>  };
> =20
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/stagi=
ng/rtl8192e/rtl8192e/rtl_core.h
> index fd96eef90c7fa..bbc1c4bac3588 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
> @@ -55,11 +55,6 @@
>  #define IS_HARDWARE_TYPE_8192SE(_priv)		\
>  	(((struct r8192_priv *)rtllib_priv(dev))->card_8192 =3D=3D NIC_8192SE)
> =20
> -#define RTL_PCI_DEVICE(vend, dev, cfg) \
> -	.vendor =3D (vend), .device =3D (dev), \
> -	.subvendor =3D PCI_ANY_ID, .subdevice =3D PCI_ANY_ID, \
> -	.driver_data =3D (kernel_ulong_t)&(cfg)
> -
>  #define TOTAL_CAM_ENTRY		32
>  #define CAM_CONTENT_COUNT	8
> =20

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-HWqfuX877mXofA46aiW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmR6NnMACgkQ57/I7JWG
EQmi/BAAo8VfvkBsasngSs798y39jSoxXwGKNiYYO7rl0IHbai2E5w816Xah6dxg
pGaGnN3qQNuoVgXKDUGCKtqCHQ8M1e2mIeD55shL/0gjKHNHkIHlsSJ9MB1Bfn1d
BkZeD0jUv/hg9qkUrzBQyKrSesVK3dlJg12CXo/Q1JrojLELZ9DIfxQUk4mUdNc7
ebfLz55X9SvW3J0t9CkeEEO+2mxWOZ8EYyrPimmJ4IxNS4aEqLzXLJcTIKPsgymn
M9Rjc0mKRAw4AUww7pF5ZT4JYklgLCIwY3QHhCbwQTZN+D4GWfXrFAIv6W0q2iUS
YbAaiCyugnTqM0Bg2UOp3YQ8jxhxj4KJDBadUFhzUb89X0w6cLJUFnNZyuWifYkk
nlba6/wVi8jCMPtyRYrvQb2SCvnTl/7ABsnrmSkU1KgQfLdYF+vDPiCpSu7jTVTP
u0TY8GP5cd9BNc4jpYBjYzEW6EZMT+tj04liufJlEl74qqFo1fM7ampVhZZ14uN8
sTW6BS5cDaelmlJJkcYnyJTPUfvsLUL0sRXXN4iiWRAnD6lqNEpb65vs6bJ3N6Xw
PJWclX8nKGY00aKChdiD0JVkwql7UWUT9N0fWIQ4B8cFbsiRSvWk1oS9pqOsG1UD
yxNGH4gSD4EhsQ2e/c/MRtbUh5iT7NyTnnG+1gCFTK3yaAwdp2Q=
=kUmH
-----END PGP SIGNATURE-----

--=-HWqfuX877mXofA46aiW+--
