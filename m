Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BF88480
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:28:12 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 652D81C09D8; Fri,  4 Nov 2022 18:28:10 +0100 (CET)
Date: Fri, 4 Nov 2022 18:28:09 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 62/78] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add
 missing put_clock() in error path
Message-ID: <20221104172809.GA1197@duo.ucw.cz>
References: <20221102022052.895556444@linuxfoundation.org>
 <20221102022054.776977847@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20221102022054.776977847@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dongliang Mu <dzm91@hust.edu.cn>
>=20
> [ Upstream commit 3e5b3418827cefb5e1cc658806f02965791b8f07 ]
>=20
> The commit 1149108e2fbf ("can: mscan: improve clock API use") only
> adds put_clock() in mpc5xxx_can_remove() function, forgetting to add
> put_clock() in the error handling code.
>=20
> Fix this bug by adding put_clock() in the error handling code.

I believe this is wrong.

> Fixes: 1149108e2fbf ("can: mscan: improve clock API use")
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
> Link: https://lore.kernel.org/all/20221024133828.35881-1-mkl@pengutronix.=
de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/can/mscan/mpc5xxx_can.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/=
mpc5xxx_can.c
> index 2949a381a94d..21993ba7ae2a 100644
> --- a/drivers/net/can/mscan/mpc5xxx_can.c
> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> @@ -336,14 +336,14 @@ static int mpc5xxx_can_probe(struct platform_device=
 *ofdev)
>  					       &mscan_clksrc);
>  	if (!priv->can.clock.freq) {
>  		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
> -		goto exit_free_mscan;
> +		goto exit_put_clock;
>  	}

In this case, get_clock() failed and usage count was not
incremented. Yet we do put_clock(), which will lead to problems.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VLqQAKCRAw5/Bqldv6
8sS3AJ49v0dvUZiuoFPgBpa3xjphouSiygCfQ4n9vmvS+dKJFxOhCB1uB6GCQpI=
=BA6k
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
