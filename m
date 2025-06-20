Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53B4289801
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417778; cv=none; b=UGs1GT07QXhYN7zXsZqhFoirudrvmGnr8rNrpF6QzZ5B/L4QsjwQn9+71tiaHLjR4erAg6A/4ZlHZNrAifwmVRlC3iWkStsHqdXr86GCLb9Ijd8pHtNL4N9eObHVnVuGxgH9elj5JQ1xQswfqcvuGWgJJZmEvucQn/kRYXNlLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417778; c=relaxed/simple;
	bh=qnIZWlFeNl91SYdGSHTzG2x6vcWOr5uWGqArczQCsMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBmRW/b24weTTdBDVeXU7ug01AnLCC+wL4ZGoHuM8nRR6aDNRM09+nqMngeeozY9VwxKUrun+J773VcSEGDss19DXMhzcAuyhRA443HrO0inkLeR24Wi7UotK3lCDNEPtzCwK9hmD2UlAmXQ+90hpy8EtzkvBom6xNHH86sGF0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TZLP0afF; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TZLP0afF"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 44875102422BF;
	Fri, 20 Jun 2025 13:09:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417774; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=aV5zFYcOOarUpWjUWs6mZ5xkCaDGI3TErSipbcP1j5A=;
	b=TZLP0afFGxUI566iearhLk1bnWC+tVE/kIUb3Id6S8669cwPwONHMIgk5reQUlSy6wTUM/
	+XwU9D2rwGm6OVyRdCHvq0nassjJ5gDSp2lp49b7H912ucM67JNOM2GE5kqbO3GKpq1dfK
	gntS4TTLhY/17A1gAMXnOH3/+/w8RKNxuyoTEEeYREyOxeSb8cKg680CXQKdgej77VuTeN
	7bWFv6owKFYI2ytvNv87Vq6CletRTOWp3c8oUlGZjMu/BvL1P7u5QUEiDfbEY2kmPrZC8a
	xOhEtUQo4bv6vhsnb0WQUxjpO3RK1d0qXwEQCyYwRDA7tlqvT6Pd/PTPWTzPMg==
Date: Fri, 20 Jun 2025 13:09:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 261/512] arm64: dts: rockchip: disable unrouted USB
 controllers and PHY on RK3399 Puma with Haikou
Message-ID: <aFVBa4ID/6uxE47h@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152430.161978386@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PekQYsNvx2Kod8zr"
Content-Disposition: inline
In-Reply-To: <20250617152430.161978386@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--PekQYsNvx2Kod8zr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> No intended functional change.

So.. no reason to be in -stable, I guess.

BR,
								Pavel

> Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
> Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
> Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
> Link: https://lore.kernel.org/r/20250425-onboard_usb_dev-v2-5-4a76a474a01=
0@thaumatec.com
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts | 8 --------
>  1 file changed, 8 deletions(-)
>=20
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/a=
rm64/boot/dts/rockchip/rk3399-puma-haikou.dts
> index f6f15946579eb..57466fbfd3f9a 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
> +++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
> @@ -284,14 +284,6 @@
>  	status =3D "okay";
>  };
> =20
> -&usb_host0_ehci {
> -	status =3D "okay";
> -};
> -
> -&usb_host0_ohci {
> -	status =3D "okay";
> -};
> -
>  &vopb {
>  	status =3D "okay";
>  };

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PekQYsNvx2Kod8zr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFVBawAKCRAw5/Bqldv6
8u7yAJ9+ZzsBn5ND1wQ/caziXF4D1iQ3QgCdGEIrDQevsJ3R2XQqmq6m1X3K30Q=
=u/hT
-----END PGP SIGNATURE-----

--PekQYsNvx2Kod8zr--
