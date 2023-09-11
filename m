Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C052A11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0546C433C8;
	Mon, 11 Sep 2023 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694443617;
	bh=/o5U7v5CEh6tJZJh+0mrDPVsIkMF4KLwNtjauuWmYcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0F17HoUa4q86S5Cuzp7R3pQ3grLqjNmwmkF79ZmrCTKSHpmHQtRpx4bLmeNWWAXK
	 +aSiP+wQfFePGLMq0eUAg6PEMrFPAt2rXf3EIx8+yC+zAmx/NeK8NqPfhyEaT98d+1
	 qTaFtExXHhcPtXXeLeQK70k6OfsE6TdUK6LOjLVAoSB8IK3wVn9W209W0i8X+ZSi0I
	 rHruLO6vfmVEufM8hGxvLzpMLnQN1kaxbipi5RSCNUnbUo1SW+HrOf/F40Uyyvtol9
	 aEKiJeNRx4760aPqZBr1KaCaaaNuyalvtTu1ml6md8RIv6jFXh0GPq8+AJMCWizVwz
	 Ja2ftChqqiAaA==
Date: Mon, 11 Sep 2023 15:46:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 365/739] ASoC: fsl: merge DAI call back functions
 into ops
Message-ID: <ZP8oXToYJFUCeJ40@finisterre.sirena.org.uk>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134701.347315064@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n9/5o3vSTY80nZ6a"
Content-Disposition: inline
In-Reply-To: <20230911134701.347315064@linuxfoundation.org>
X-Cookie: Save energy:  Drive a smaller shell.


--n9/5o3vSTY80nZ6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:42:44PM +0200, Greg Kroah-Hartman wrote:
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> [ Upstream commit 5e5f68ca836e740c1d788f04efa84b37ed185606 ]
>=20
> ALSA SoC merges DAI call backs into .ops.
> This patch merge these into one.

This is obviously not stable material.

--n9/5o3vSTY80nZ6a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmT/KFwACgkQJNaLcl1U
h9CtPwgAgHoAOyu+YNvMrRwEH/2Ut68OB2xqn+0+l9j/eyX/AQ62F4ZOih6XokSH
F8JkWxLLvl5uajRRu7eHUqc1AJlfRVKPeJCfBd8Zc+QMrxIcxSbdu89DJMXkkJpp
7qiUcSA5nzIZbc6aLLfKhKJD3P46cPgBG2wtOXayo4tMhkzUvxQ1MFV1fD7674ot
diIp3c8rVbWMrTmkAzO6p0KzE1kTa5AoZBdt/DpE+RbOZX4BeBrQAcH8cDG87D/+
JiJDeQ7WWvE8t6J6I258tDLf9Vyp5Ij1FpXO7D2/0mdQruAakeilvj+k7ngZsIUL
afuUsFPArjtxkw+77aFIOAEVwZi+3g==
=HJt3
-----END PGP SIGNATURE-----

--n9/5o3vSTY80nZ6a--
