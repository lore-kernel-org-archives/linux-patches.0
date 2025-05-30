Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EA054652
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598259; cv=none; b=lrtqsTuCVBM3sO+s5yiN8yxvP9aNIaxOZaEJGXPpswBuvzngYxiYvU1N+QJo7RptaDt683Dp3a9R4kCu9+1MafeqpvNygS267Kk9hfX8bW1vTHdFbw8jhbcm7OgCNLIp5rHd3xNgl2n2hS0A4N3PXVopS0YiSWD1fy1ngaGiJeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598259; c=relaxed/simple;
	bh=D350On+AsLjnXsIA/+25E3IXiLa/6tSjAv6ZjC9HGQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PY2K894Jk2sKej0w2W7vrFLlBJIttuOsshwPEB9O4wKUPT5YKxta8q4wqz8jtW0KZ3wWCZMtNRWcOw7MP7tdIUUG59XO3/Ww9K59qBh4ofVzI/mavcz+i898T+NCpJecZO/2EQaIfQsa/VPLqEYkwr+vBDREXPDTMAJ57IS3ajA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=HZIapxYU; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="HZIapxYU"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BDA031039728C;
	Fri, 30 May 2025 11:44:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598255; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=BQf9VDutM6WP2Gg0c2hacEXZI0LH1i57sKHD4NpP86s=;
	b=HZIapxYURp19fjPtGCOvm/2u4KgywHs4ZbBxyjgcdftOU3YlIN+2PtysajA2qgS5pwvmFw
	HGS8VaEnb1l8+Qc7vaM0O465qN5GyZtWwgQALK18T9ORhrM74UbDKTaFe9SqfLi/GVNMGq
	flEPwlAZAcpZMICYWGCooDhYeNoiGnIRtO/Qs99BR+cweKxWCTdedzKzp0/JADit9CfvRh
	XqBido5xuzjbI8bwyBz1ruyFlaR2T3ArDfXNGS+JtJZ7Me8KpK6AqOLnwrxjH+ZGz4YDAu
	ETBFtAqPs14uze44wG6aKNUPpkJfG9qkyODso7T7GyitIB5GAPAnozMQRrU0+Q==
Date: Fri, 30 May 2025 11:44:11 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 044/626] kconfig: merge_config: use an empty file as
 initfile
Message-ID: <aDl96z62+zOouyrJ@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162446.848246889@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ic8l2gTiE5IbjkJZ"
Content-Disposition: inline
In-Reply-To: <20250527162446.848246889@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ic8l2gTiE5IbjkJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>

This is not stable material.

BR,
									Pavel

> From: Daniel Gomez <da.gomez@samsung.com>
>=20
> [ Upstream commit a26fe287eed112b4e21e854f173c8918a6a8596d ]
>=20
> The scripts/kconfig/merge_config.sh script requires an existing
> $INITFILE (or the $1 argument) as a base file for merging Kconfig
> fragments. However, an empty $INITFILE can serve as an initial starting
> point, later referenced by the KCONFIG_ALLCONFIG Makefile variable
> if -m is not used. This variable can point to any configuration file
> containing preset config symbols (the merged output) as stated in
> Documentation/kbuild/kconfig.rst. When -m is used $INITFILE will
> contain just the merge output requiring the user to run make (i.e.
> KCONFIG_ALLCONFIG=3D<$INITFILE> make <allnoconfig/alldefconfig> or make
> olddefconfig).
>=20
> Instead of failing when `$INITFILE` is missing, create an empty file and
> use it as the starting point for merges.
>=20
> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  scripts/kconfig/merge_config.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_conf=
ig.sh
> index 0b7952471c18f..79c09b378be81 100755
> --- a/scripts/kconfig/merge_config.sh
> +++ b/scripts/kconfig/merge_config.sh
> @@ -112,8 +112,8 @@ INITFILE=3D$1
>  shift;
> =20
>  if [ ! -r "$INITFILE" ]; then
> -	echo "The base file '$INITFILE' does not exist.  Exit." >&2
> -	exit 1
> +	echo "The base file '$INITFILE' does not exist. Creating one..." >&2
> +	touch "$INITFILE"
>  fi
> =20
>  MERGE_LIST=3D$*

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ic8l2gTiE5IbjkJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDl96wAKCRAw5/Bqldv6
8i67AJ4quQ13WQAQVriKTLLZb2KzhiPXGQCgoh7pGpaaMFfPpJLkSuVXnW//cQM=
=u0fU
-----END PGP SIGNATURE-----

--ic8l2gTiE5IbjkJZ--
