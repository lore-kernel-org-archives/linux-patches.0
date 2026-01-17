Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003DA2C15A0;
	Sat, 17 Jan 2026 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768681349; cv=none; b=nqMeZ8CJIMdkGh4TaK3DjtCRsA/tEtWhnrIrwrtf3+/1Eq+WZSf9SOYM43n7Kt0qkGQitWjS+rGMtgf8KRST1ox4WvotzayH+gvTufMXc6K/ITu3o5iW1ZXPvzonNUk9zEZD4r5UIhhLyG8fK67lQiwR1w0+m4Q9e8VhVNigsIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768681349; c=relaxed/simple;
	bh=fbacUL+q3c8Crp7iCPdhU2+05YfNh8jSPE7kjBLZeDA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tE0WhoDk8a/TcfUpNNDnXXL6CiEgRBRL8H2G12n9L8j5VR/olnmK4YBjwzk6HIyLyVbKNBCapAbDWHG3Iwua+ZbEEmKbc8nRei9cpjkYgoeHUX3ib3Xm65AoXnUyoPErnAsfENHPTlivclR4fSPG2v1fG5gCjzLNAG1NKY8hUeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCoV-0011fz-1C;
	Sat, 17 Jan 2026 20:22:26 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCoS-00000000jy1-3Ves;
	Sat, 17 Jan 2026 21:22:24 +0100
Message-ID: <dd71077782437d4517ee09ff7e10abbfc3672ddb.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 212/451] reset: fix BIT macro reference
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Troy Mitchell <troy.mitchell@linux.dev>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Encrow Thorne <jyc0019@gmail.com>,
 Sasha Levin <sashal@kernel.org>
Date: Sat, 17 Jan 2026 21:22:15 +0100
In-Reply-To: <20260115164238.569421501@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164238.569421501@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jvaDgWG+QHK5zYBK9oTk"
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


--=-jvaDgWG+QHK5zYBK9oTk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Encrow Thorne <jyc0019@gmail.com>
>=20
> [ Upstream commit f3d8b64ee46c9b4b0b82b1a4642027728bac95b8 ]
>=20
> RESET_CONTROL_FLAGS_BIT_* macros use BIT(), but reset.h does not
> include bits.h. This causes compilation errors when including
> reset.h standalone.
>=20
> Include bits.h to make reset.h self-contained.
[...]

This should have had:

    Fixes: dad35f7d2fc1 ("reset: replace boolean parameters with flags para=
meter")

That commit went into 6.13, so only the 6.18-stable branch needed this.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-jvaDgWG+QHK5zYBK9oTk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlr73cACgkQ57/I7JWG
EQnKvRAAmXeB/jmH4ge8mMvFhX5K7coHmlWmfm4m3N5dqmUlX7ytasxpd8dhmErk
xvX+Yu6dDSbKLQ0mM9AIzKUVkKgyxlRtFiaHbVLkA1qSHhNEx/B+8L1vV6hTkmiy
itPgcIMRWbX6kxzLgsPZF9OGhEozVTCY+WedvNiAV38GDcqafxh8tVXSge3Lefzb
RxTiTO1HW+NrwTt3qawsToTdSV/XgkTkMH92PojMf0zfLj8xdGiyt51dXvVrX6OH
fQ3r4Apev0r5cP1SgEaVlRlC8T9Krxv4xWV71pUPcDZP/DRf0gOz9OTKgZsBRiZy
2VS0zicaJ0lxtUI4tnUR3tSsrdQQ4OA/NAKJviX5K/6WS9QkCunBAwofHvgg7epU
cCoeE/2+WSPllhZ9radtLq3CrcX/WJ76UhBRcRVVoeR0QRdmJxuPB3uyelFQx/+c
p4TELt3oHOqkizDWd5MJdJUayU3zI7dZoic4OogiY/+uzsQRWrI6kxJPHfi1vEnG
FE/NJtlb2YCTh2ZTeBDHibKbyzQdy33+9QL3QLsoywkLWD78Kt16FKIm3zh6uvV1
yUBDMn0Cd+fpRxcTVxou3sEe7uRkK1SYlrUhMqKes1jL/IaQkv29U7FFozPND8xU
aLCzkCL6r2R6QU8pac1UJkTpjKWKhVImU/T3+E790A4TeLvy8VE=
=y3UP
-----END PGP SIGNATURE-----

--=-jvaDgWG+QHK5zYBK9oTk--
