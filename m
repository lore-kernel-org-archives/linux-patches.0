Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F1420DD51;
	Wed, 24 Jun 2026 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782318300; cv=none; b=qTJFTeemzUFR4iITOschX42K4OK0ArIYuo+PgliuCTtavdzC+tUZjd44H9iXeIXp9hsAGjXKqUSpEef2wp9O6Vo2zNXJklKt4vhFZMDy0P5bYd2Sm2Km8UGfIgCcMS1EmUhJkUT96d9m5Cru8oB53Mav+jvbHRCcK7aRasJezcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782318300; c=relaxed/simple;
	bh=R5ZfFVkRQZeDfb++4G4BucOYTlrYjFIRmmldsD6a4Wk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSL4nlSaGlpBN3w9xb+SVioeWavxurM7C5u4EncJCkSSQULa8MNvhiGnlc1s4wUQtJA11F7CpgXN3OGcSNN8P6h05fkT8yb9Lc/Cg8gdj2bhfZRz4OayhDuhSOIwh5EWixE/R+Wsc24g+yFADWyMxe5GlQil7B4EYJmprsRmyag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcQPH-0042Fl-1C;
	Wed, 24 Jun 2026 16:24:55 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcQPF-000000085ap-3kxj;
	Wed, 24 Jun 2026 18:24:53 +0200
Message-ID: <6218e66138c5c1c5fb02bd653c8b91d6ff8c3abd.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 375/522] net: ipv4: stop checking
 crypto_ahash_alignmask
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>, Sasha Levin <sashal@kernel.org>
Date: Wed, 24 Jun 2026 18:24:48 +0200
In-Reply-To: <20260616145143.326415700@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145143.326415700@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BywJuZ00Y7z4WxuA4+IA"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-BywJuZ00Y7z4WxuA4+IA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> [ Upstream commit e77f5dd701381cef35b9ea8b6dea6e62c8a7f9f3 ]
>=20
> Now that the alignmask for ahash and shash algorithms is always 0,
> crypto_ahash_alignmask() always returns 0 and will be removed.
[...]

But that is only true after the earlier changes in the series from which
this was cherry-picked!  To avoid a regression, it would be necessary to
backport at least the driver changes to support unaligned buffers:

9924003807a9 "crypto: sparc/crc32c - stop using the shash alignmask"
f35a4e237f4e "crypto: omap-sham - stop setting alignmask for ahashes"
8c87553e2db6 "crypto: starfive - remove unnecessary alignmask for ahashes"

However I think it makes more sense to revert this and its ipv6
counterpart and to fix up whatever the conflict was.

Ben.

--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

--=-BywJuZ00Y7z4WxuA4+IA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo8BNEACgkQ57/I7JWG
EQnOoA//fKTfYCyNPKJnXzxFcCIgYdQFT9ryfR99lLYsvxhKUqwrnOzxWrfI7BeQ
n86yz8jVdxhRGaOuX0qWobrMWYXmLvEwbVTeaa4WwtR/buHJZCPcY9sVAkJOTwxB
0GeBPd0emHsEagPVVLsKgF2bqJ2aUaPO7YLUWk764sRWR72S5N40yZySVv0i5rP0
B4LZUgOxdHdNR5tRTTMfaakolz8azPHHznVWp5l2Jj8Xrx4cCWhtgM6aZ4DON2AW
zfgjth+Wv+l078GOHhpOovqkthMCe6eaP31K1/fADoB1ZkH/XEh/z2KBostOVTTc
ILPBgPABQ5h4DOhy5PwCZHpM1+gBteEaN/YX619F6ADGCwSer/tXm90NQLdXIQCm
kCqdD696JRZgLeuEhWOFC04KT6GjBXCwA/Mll1iPKdEm2osEwkbozRAkpxk7J+sf
2taHd0RAoTzNSFTYNBY5BDyo3hOrs/QKXcOTpGiKiwGAU3c2rKyarI4SOPjt3g57
dAoHzCzE+5uvN21YC24kIpEFaCpKFy87HRbvtwMSl3GGDLz81H6IaXfTM3HhjaMJ
LZCpsfSV4gj2ERnJDeSfRfwbVKKOIRpR2n8Mu8r2xKeJnzE3drwzUVqnz7N13RVJ
t91Pq7HSybwV8o/79XYo7tpiD/xa2NGmY9Al48lnGOLz2TQOMGk=
=W1K3
-----END PGP SIGNATURE-----

--=-BywJuZ00Y7z4WxuA4+IA--
