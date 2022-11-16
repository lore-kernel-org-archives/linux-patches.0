Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75752F46
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:16:14 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 8269B1C09F6; Wed, 16 Nov 2022 11:16:06 +0100 (CET)
Date: Wed, 16 Nov 2022 11:16:05 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@control.lth.se>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 001/118] serial: 8250: Let drivers request full
 16550A feature probing
Message-ID: <Y3S4ZT9Vz8VmU3Zw@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133340.777783271@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdASTUNSMj+b2l8n"
Content-Disposition: inline
In-Reply-To: <20221108133340.777783271@linuxfoundation.org>


--gdASTUNSMj+b2l8n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Maciej W. Rozycki <macro@orcam.me.uk>
>=20
> [ Upstream commit 9906890c89e4dbd900ed87ad3040080339a7f411 ]
>=20
> A SERIAL_8250_16550A_VARIANTS configuration option has been recently
> defined that lets one request the 8250 driver not to probe for 16550A
> device features so as to reduce the driver's device startup time in
> virtual machines.
>=20
> Some actual hardware devices require these features to have been fully
> determined however for their driver to work correctly, so define a flag
> to let drivers request full 16550A feature probing on a device-by-device
> basis if required regardless of the SERIAL_8250_16550A_VARIANTS option
> setting chosen.
>=20
> Fixes: dc56ecb81a0a ("serial: 8250: Support disabling mdelay-filled probe=
s of 16550A variants")
> Cc: stable@vger.kernel.org # v5.6+

You said you'd drop this. It is still unused in 5.10.155, as flag is
never set.

Best regards,
								Pavel

> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/825=
0/8250_port.c
> index 8b3756e4bb05..f648fd1d7548 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -1023,7 +1023,8 @@ static void autoconfig_16550a(struct uart_8250_port=
 *up)
>  	up->port.type =3D PORT_16550A;
>  	up->capabilities |=3D UART_CAP_FIFO;
> =20
> -	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
> +	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
> +	    !(up->port.flags & UPF_FULL_PROBE))
>  		return;
> =20
>  	/*
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 59a8caf3230a..6df4c3356ae6 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -100,7 +100,7 @@ struct uart_icount {
>  	__u32	buf_overrun;
>  };
> =20
> -typedef unsigned int __bitwise upf_t;
> +typedef u64 __bitwise upf_t;
>  typedef unsigned int __bitwise upstat_t;
> =20
>  struct uart_port {
> @@ -207,6 +207,7 @@ struct uart_port {
>  #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
>  #define UPF_DEAD		((__force upf_t) (1 << 30))
>  #define UPF_IOREMAP		((__force upf_t) (1 << 31))
> +#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
> =20
>  #define __UPF_CHANGE_MASK	0x17fff
>  #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gdASTUNSMj+b2l8n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S4ZQAKCRAw5/Bqldv6
8vh0AJ4to+GGntRYthVZloBmFo7qmn3/oACdF0baGwVtk8P0OWvaLCNPg6GFMV0=
=A/qX
-----END PGP SIGNATURE-----

--gdASTUNSMj+b2l8n--
