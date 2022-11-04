Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE08471;
	Fri,  4 Nov 2022 17:07:05 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id C86EE1C09F0; Fri,  4 Nov 2022 18:06:57 +0100 (CET)
Date: Fri, 4 Nov 2022 18:06:57 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
	Nathan Huckleberry <nhuck@google.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 38/91] drm/msm: Fix return type of
 mdp4_lvds_connector_mode_valid
Message-ID: <20221104170657.GA29426@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022056.117630968@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20221102022056.117630968@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0b33a33bd15d5bab73b87152b220a8d0153a4587 ]
>=20
> The mode_valid field in drm_connector_helper_funcs is expected to be of
> type:
> enum drm_mode_status (* mode_valid) (struct drm_connector *connector,
>                                      struct drm_display_mode *mode);
>=20
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>=20
> The return type of mdp4_lvds_connector_mode_valid should be changed from
> int to enum drm_mode_status.

We don't have kCFI in 5.10, IIRC, so we should not need this.

Best regards,
								Pavel
--=20
 'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany'


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VGsQAKCRAw5/Bqldv6
8miTAKCwgANXY1Qwqo4vzF6TVQRFA47IZQCfRYhkOffY6b9C13WBkOr/T+JszJc=
=KT8s
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
