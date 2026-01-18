Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266C26A33B;
	Sun, 18 Jan 2026 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757033; cv=none; b=ml+VnTiH0yALPvwlQuXipCjOGTXBU5fz2kSyqeQ0hLIW5X5o5G2Rty7lQ+haL2etyK7tYTzpu34zT2HL0J/2LR8hzj2ODRtZPsHP+/iaaS9osWpzsCYGKADz+UCA1ykETcD2UDidfl35bXUqWjjXbnwNrk7LAY+p952qQIEfMWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757033; c=relaxed/simple;
	bh=JG4Wh1eha2S4AbQBh8EE14PH3jGD39mgG838aA+3uWo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e3QvlT0ZEU7WS2Gt/kROWR+wpTOi55hQBj/C7GticlmoIH/DO/i+QEnaX/EHnnEUmc7dk2mm4YxlOPz99c3ZmZipIVQgcNuCYepTSlrIcbrxKUWnzaTkuX+bx77AQzuosmwTDtIx5qMPw+6QZARF3y7SXXi57XgwYFMIp0SMlSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhWVD-0018aA-0r;
	Sun, 18 Jan 2026 17:23:50 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhWVA-00000000q0u-1qIY;
	Sun, 18 Jan 2026 18:23:48 +0100
Message-ID: <020da12b0832523db0723a3e36892a17b1ba7665.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 374/451] ARM: dts: microchip: sama5d2: fix spi
 flexcom fifo size to 32
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nicolas Ferre <nicolas.ferre@microchip.com>, 
 Claudiu Beznea <claudiu.beznea@tuxon.dev>, Sasha Levin <sashal@kernel.org>
Date: Sun, 18 Jan 2026 18:23:43 +0100
In-Reply-To: <20260115164244.445442721@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164244.445442721@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nY9CRkbBO8i2ucBO2LDg"
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-nY9CRkbBO8i2ucBO2LDg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>=20
> [ Upstream commit 7d5864dc5d5ea6a35983dd05295fb17f2f2f44ce ]
>=20
> Unlike standalone spi peripherals, on sama5d2, the flexcom spi have fifo
> size of 32 data. Fix flexcom/spi nodes where this property is wrong.
>=20
> Fixes: 6b9a3584c7ed ("ARM: dts: at91: sama5d2: Add missing flexcom defini=
tions")
> Cc: stable@vger.kernel.org # 5.8+
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Link: https://lore.kernel.org/r/20251114140225.30372-1-nicolas.ferre@micr=
ochip.com
> Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm/boot/dts/sama5d2.dtsi |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> --- a/arch/arm/boot/dts/sama5d2.dtsi
> +++ b/arch/arm/boot/dts/sama5d2.dtsi
[...]
> @@ -925,7 +925,7 @@
>  						 AT91_XDMAC_DT_PER_IF(1) |
>  						 AT91_XDMAC_DT_PERID(18))>;
>  					dma-names =3D "tx", "rx";
> -					atmel,fifo-size =3D <16>;
> +					atmel,fifo-size =3D <32>;
>  					status =3D "disabled";
>  				};
> =20
[...]

This hunk (only) of the backport ends up changing the wrong node - it
should be applied to spi5, not i2c5.  The starting line should be 905,
not 925.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-nY9CRkbBO8i2ucBO2LDg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmltFyAACgkQ57/I7JWG
EQkaSg//SpZKYaGKKxRe7DeM+3C7d5KES6Wb5BmM+rGcXVP1yaodux1yuKkEnaa1
63dN3E9kEXjiOHr3m8ezYFaua012tZSyLESZy3qEHtUbNf/9xu5aLDnEMZKiR/x5
joWYA1f1ecjgWMHmQQFdE0PgYkuecXNJo5g++XahIthLWcwjrvpDIwRk6O6pbCpZ
d5VHIlyZlu1eAItTvnKAPTorlYhtmHIWK1dqRfMUAq7FAEGoUhNsk/ZVO4vD3F1l
c14r2yWkbO3QKyU2oHR9qUeSTycH7hf2IAZhjCHwbKF2EBv6xeK1lGvDg2b0hYLK
lMD9KaXhqYgoT92v9wWIGAqmiEDJMad3f/8SPHrpI5IJtioHRHsxF6s5w6UrKgCi
uM82UvQQEDRdXfJZjR45u3PbHOTSpq0+DpewUw+V4a9DadOEuiynpcwg1utv9Q2r
J+UpKuWxyp9Z1d3FL/ZQzFOwAPhYRcmiy74YCEjMcxLFDBuA/dNnF6pl4TGqBjlT
4O9u4lRXmQdq5lM9N1wFm4ztG2Vh4q8SqMwed64ENjDLyoJzejfzImyyIe2vUmjm
/dUhhaxBXXIXT/NCB6TfEd45TFKJCxHkRknWtTiEFj4lF5+OnCxteLqn1cCUlCBd
l5pbmN4YS+d6OC0M04T8ShqRXB3uZyc4ev9QLAuwtUYpoA4L4P0=
=a6WF
-----END PGP SIGNATURE-----

--=-nY9CRkbBO8i2ucBO2LDg--
