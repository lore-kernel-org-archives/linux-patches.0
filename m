Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7FF2913
	for <patches@lists.linux.dev>; Sun, 30 Oct 2022 09:54:32 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 011A71C0049; Sun, 30 Oct 2022 10:54:23 +0100 (CET)
Date: Sun, 30 Oct 2022 10:54:23 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 12/79] kvm: Add support for arch compat vm ioctls
Message-ID: <20221030095423.GA25519@duo.ucw.cz>
References: <20221027165054.270676357@linuxfoundation.org>
 <20221027165054.739599117@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20221027165054.739599117@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit ed51862f2f57cbce6fed2d4278cfe70a490899fd upstream.
>=20
> We will introduce the first architecture specific compat vm ioctl in the
> next patch. Add all necessary boilerplate to allow architectures to
> override compat vm ioctls when necessary.

AFAICT this introduces hooks, but they are not used at least in 5.10.

We should not need this...?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY15JzwAKCRAw5/Bqldv6
8hZhAJ49Y6nA19pezH8aEO7CiULR25OX/QCfU2+NrWQgLMPZutHIt44PESpQRYQ=
=4ECv
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
