Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEDE2853F1
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417727; cv=none; b=p2X2axo8NsmIClSmyK4vR6TDzmFPr4ajmcQfCZy/Ao4R96X/3E18LdF9JuOhU5+nszgdPQ8SVBZ8RLL3vo+SsXXJ3o5M1htk+8FcmBCkztMho6YQ1UooADr/js9ImLLg4p/EHAfyRSPCH4l4N8PWODxqMdcSZYUiP357SYO4DCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417727; c=relaxed/simple;
	bh=nHbX0n4K0mYSePrR/jKUHqMkuFUmtSOQLp4emdCTR3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIvW08CLepcS6yv1YTYXOw+7NEf4gfL6/njuNSPs7FgmL1Wg55C8T/l1joJcRmKVyKnsIoQMPFrwFh+BbHm67OopjZ5BBk4eEpShhD4qRWLj0Zdu4vbroVBUt3jii5aTfdJ4W69g22gTwUJIPLfyr8xSnrJoWcvfSZSC7G4Fa50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=VkBRMdY8; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="VkBRMdY8"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 32080104884A8;
	Fri, 20 Jun 2025 13:08:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417723; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=GzPGI7mjTpgC1aVy38Gz2sNnfuLlF5wX2KbVKUy3oR4=;
	b=VkBRMdY8wq/IQT1qeaqKWJh0/MbeLSruCsmUBvB6+YI8MAu1n3IDePmOSND5VwUlcuSuUK
	w3Xgxlbp8NwwyiSl85njiyaZlMdsKAyrrTP4141RjxRFhnuiJ+mhz40bDeCospQY1+pYp6
	QxyO0qsLLojOTWVOUgLuIcr035KF0oIZg5RPOR8dHQl/u+X74UBf2FVLjOSmvXe01VQIhF
	iBGWwYR/0Kr6NZI4TFCkr9CYk+B7ltT0TL23aZl+HUbL8sm8cchoN2NVCir4Fd0RJ6pSUH
	3Tn+U4kJo8inJsplHNFbajS7rkvsPb1ALcu2bO7d034b2yNqWtb8+rkKbNOZvw==
Date: Fri, 20 Jun 2025 13:08:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 247/512] arm64: tegra: Drop remaining serial
 clock-names and reset-names
Message-ID: <aFVBN82+452mpSXx@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152429.616508304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vrOaklxRidfSzQp0"
Content-Disposition: inline
In-Reply-To: <20250617152429.616508304@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--vrOaklxRidfSzQp0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Aaron Kling <webgeek1234@gmail.com>
>=20
> [ Upstream commit 4cd763297c2203c6ba587d7d4a9105f96597b998 ]
>=20
> The referenced commit only removed some of the names, missing all that
> weren't in use at the time. The commit removes the rest.
>=20
> Fixes: 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
> reset-names")

Nice cleanup, but we don't really need it in stable.

BR,
								Pavel
=09

> Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
> Link: https://lore.kernel.org/r/20250428-tegra-serial-fixes-v1-1-4f47c5d8=
5bf6@gmail.com
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/nvidia/tegra186.dtsi | 12 ------------
>  arch/arm64/boot/dts/nvidia/tegra194.dtsi | 12 ------------
>  2 files changed, 24 deletions(-)
>=20
> diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/d=
ts/nvidia/tegra186.dtsi
> index 2b3bb5d0af17b..f0b7949df92c0 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
> @@ -621,9 +621,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTB>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTB>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> @@ -633,9 +631,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTD>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTD>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> @@ -645,9 +641,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTE>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTE>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> @@ -657,9 +651,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTF>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTF>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> @@ -1236,9 +1228,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTC>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTC>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> @@ -1248,9 +1238,7 @@
>  		reg-shift =3D <2>;
>  		interrupts =3D <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks =3D <&bpmp TEGRA186_CLK_UARTG>;
> -		clock-names =3D "serial";
>  		resets =3D <&bpmp TEGRA186_RESET_UARTG>;
> -		reset-names =3D "serial";
>  		status =3D "disabled";
>  	};
> =20
> diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/d=
ts/nvidia/tegra194.dtsi
> index 33f92b77cd9d9..c369507747851 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
> @@ -766,9 +766,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTD>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTD>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20
> @@ -778,9 +776,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTE>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTE>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20
> @@ -790,9 +786,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTF>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTF>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20
> @@ -817,9 +811,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTH>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTH>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20
> @@ -1616,9 +1608,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTC>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTC>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20
> @@ -1628,9 +1618,7 @@
>  			reg-shift =3D <2>;
>  			interrupts =3D <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&bpmp TEGRA194_CLK_UARTG>;
> -			clock-names =3D "serial";
>  			resets =3D <&bpmp TEGRA194_RESET_UARTG>;
> -			reset-names =3D "serial";
>  			status =3D "disabled";
>  		};
> =20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vrOaklxRidfSzQp0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFVBNwAKCRAw5/Bqldv6
8uhwAJ4gb4UmFR43ytydG5IBqc4S3baVPwCdE/blJ6y+5OjUPl1cO2GvDTjsfE8=
=Kwg1
-----END PGP SIGNATURE-----

--vrOaklxRidfSzQp0--
