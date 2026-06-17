Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4C5395AC5;
	Wed, 17 Jun 2026 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686882; cv=none; b=eXHRW2b3HVxJhdJ7+iqRUy4fjJ65TsgT735t4xqLUQKpRPqPO3pqeUr2WCf9L0b4LDNiVcNPyDrdMWhbWSZPn484irBAXFlMfSafd+zygoV245lwzZBN1x9lxWWYHxa2ME/kJGApuLYfHp0q5HrhZIO8fkpQgNc6a32sNObQtAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686882; c=relaxed/simple;
	bh=K2zLVQL1BzmILF4ERNaZzBchvoB7Cc3ypPlIVWBMvn4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hEIrqp2bBlU9fTROeTIn+r35alhzT1xbcQF80EH5K6cS9r1EsgpCrwChZqJYq6TDDyzxhjxRfsCQHf5e8GVVZtJsUqytkRZExNRf2rJe0Ykg+P5LVQrkrcNfCkhSzNlqlMfQJL43wqOZ+u5lQNPPyW4s28vR4l4BLI8MPbuu/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:a03f:8fba:4c00:9e56:df29:1317:540b] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZm98-002tb4-2k;
	Wed, 17 Jun 2026 09:01:18 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZm96-00000006ft8-2kPl;
	Wed, 17 Jun 2026 11:01:16 +0200
Message-ID: <f0be2ecfe2c27c1920a44b6f41d8db87611267f1.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 035/342] batman-adv: tp_meter: fix race condition
 in send error reporting
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, stable@kernel.org, Sven Eckelmann
	 <sven@narfation.org>, Sasha Levin <sashal@kernel.org>
Date: Wed, 17 Jun 2026 11:01:11 +0200
In-Reply-To: <20260616145049.888286838@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
	 <20260616145049.888286838@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MBZnAM1IHasi8YnJP9N2"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:a03f:8fba:4c00:9e56:df29:1317:540b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-MBZnAM1IHasi8YnJP9N2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:25 +0530, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Sven Eckelmann <sven@narfation.org>
>=20
> commit 71dce47f0758537fff78fddb5fb0d4632d29b29f upstream.
[...]

No objection, but this is missing from the 5.15 and 6.1 queues.  (It was
already applied to 6.6 and later.)

Ben.

--=20
Ben Hutchings
Humour is the best antidote to reality.

--=-MBZnAM1IHasi8YnJP9N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmoyYlgACgkQ57/I7JWG
EQng6BAAn/PM0sXmV8ads/cM5w27r7CmYrzaL/J3RfUNoeGhmo6tJwoMZ1/s5m3G
2yCGFGaE8D7yKKDKIKPRsq4+zSiWeBUqID35PX/jTaCpfEhHm5yW+yfQhhw9h1sK
+OqhOCaIFS5uG/yx+yUwBuztNq4FzhXSPhEmz/toLpoEVOcGj5xdpt+5d5hg3Ud2
K+8L7HRAoy7jS5uEHSn6nO2APpuhPvbon2kM2MvS0yn4ql1e3kW4zDeMFUww4MyX
6C/RYSD2amIW+uTcipo8GbTYI12FI4zTEzJ3IQ3dWkq22+4K1lJ2KjxrVcfO5CW6
YN7Auub1lB0Y0x+KeZFv/2h0sNTSblBho3yPu8tGYI3dl9cbOtm8IuANEZ0XMYS5
AJVOF6Rn6L5JXFD7qCS8SyoV3Ikb5hn3E93bT4ft0RvJw8cGkr5s8VKUlQxMM87c
nU1I1hKti3dTytD05ZZm+nP8/Jd2dAY2aCNrLYLcWQbgu9LJwmiVKcnng9Yld9I4
fcvB47vh+7Q75WazoDSeTHmrZ0BJ5bsSTEtg23B82LB/G9HFjAwWyu3tjqaoSGrM
vXSz9D1rgmns0PDLT8qute7qe+tfokzwT1DMWpqULMkTA3euGSyWilOUA77DSdP/
Q98Mf63S4ObxxcQpu1UU3Ifj5vosL5HNafW5mb4foQuJp82dp8k=
=CPOu
-----END PGP SIGNATURE-----

--=-MBZnAM1IHasi8YnJP9N2--
