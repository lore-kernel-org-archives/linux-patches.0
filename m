Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2429A32572A;
	Fri, 31 Oct 2025 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761941385; cv=none; b=iWRnmf2AayxWK2HG/2lRh6Ho/YrjLNYbWGHuuasLtaOep7ZMCyt9sqaupsx2BZziErdPoBocxN5rnuDvxvwVrpdrlXX+d2pHv+unwS1zjYOK8aIk367imyYhFMnSEtKd65cAufzZCa+PbprPqlSSfOFpI2yxev/03dan4Nc3Hnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761941385; c=relaxed/simple;
	bh=zqby5kdSuT0SNUIRk9/sIipp05lxU+jS8y6Y5zvi7UQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uT4jr6yg8yDm6IJSyAR+QlEF39edY34K0NP3S9Zm1A1fBHQf8gEFj1bPYGBxXrH07hfKpncj4FiVnbNdTsl2PlmO74vwPVSBCdVdrRrBuZhtAANbt4KnNXbPfzVydGxTkaSUZLEsNOQasCQemQad+dmEaE5074g9DNIMnyCuIoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vEv5u-001qm5-1M;
	Fri, 31 Oct 2025 19:47:29 +0000
Received: from ben by deadeye with local (Exim 4.98.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1vEv5s-00000000D1b-3FWe;
	Fri, 31 Oct 2025 20:47:28 +0100
Message-ID: <67ef17680d4e107847c688f9bb7fa45f4e6b51a3.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 171/332] lib/crypto/curve25519-hacl64: Disable
 KASAN with clang-17 and older
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, "Jason
 A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Eric
 Biggers <ebiggers@google.com>
Date: Fri, 31 Oct 2025 20:47:23 +0100
In-Reply-To: <20251027183529.142271445@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
	 <20251027183529.142271445@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MVK10Ijgps+TIJRQ8YbD"
User-Agent: Evolution 3.56.2-7 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-MVK10Ijgps+TIJRQ8YbD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-10-27 at 19:33 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Nathan Chancellor <nathan@kernel.org>
>=20
> commit 2f13daee2a72bb962f5fd356c3a263a6f16da965 upstream.
[...]
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -22,6 +22,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENER
>  libcurve25519-generic-y				:=3D curve25519-fiat32.o
>  libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:=3D curve25519-hac=
l64.o
>  libcurve25519-generic-y				+=3D curve25519-generic.o
> +# clang versions prior to 18 may blow out the stack with KASAN
> +ifeq ($(call clang-min-version, 180000),)
[...]

The clang-min-version macro isn't defined in 5.10 or 5.15, so this test
doesn't work as intended.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-MVK10Ijgps+TIJRQ8YbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmkFEkwACgkQ57/I7JWG
EQkPShAAq45Ji5zIm0MXfy1TutPuKhZOJdeQPM3h7YHYBkI0EudkjI7D9dU9n/6r
GJY7SSdPf0y9IUN0NGbyZ11BKnqfAfuQ/2TxkZTGiiQY+lrOAywvEopFkh+/OaEU
1G7rbQswQGy+AgFsUhv7zQ4O++lkOEDRliX5ATeSVI6+s/HKmqtw53/kiW2PKxj4
WSZpS8OsD8Fxo7WdmvEE/EEJSC48Q5bnSDTFuPC4V/GQKL3oHlFzr0cLMI9djgv7
fFgFTaH1/Ug+EQAWdP8PdK4iwKwcv9wireyT1Ppq8c5ZZzyUTOe8fUSQbXfLI3+v
tcBZB6PWVHkNYHvCa1r8+c/V0N2i2a/MHO1gKWejs72TyiVIm0nL87jqLPwTJ8lR
mV2D5fbCcFvZ9of0qFJ4VJ7UFDb7B/sRo85dmGiPxiG5MeOVAIp8xgf2knqTSB3H
5JiEj8DhNFITcqsTv2swXwXKWw+Ev+qiGV6w7SMwJHOJ9jgWGyVTqP1cEIhRkgo9
AcgMYDEUokJbiyjGRiEL5mXvYYmExP0Agbn1nZXR6F+mtQBZc+hQQ+3tNElRfH/J
cTl3O5SR0xW9RQqG4P8a7MNTm+lCNtph+a79Fa456gJIsLr9inA3XPbchEzr2QDx
CYDrTTyzze4+LybxF3Gr7K3R7W3DkFVEV/5Pa8DwLV37i3v/0eM=
=TeW4
-----END PGP SIGNATURE-----

--=-MVK10Ijgps+TIJRQ8YbD--
