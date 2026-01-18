Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445A314D29B;
	Sun, 18 Jan 2026 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768734710; cv=none; b=i/OVoWrB0rA7vz3Hy3tabk7weGs/l6p0GnNMDEXPaT7QJSsEvcFWapYlaWTIRbGRodUzFr/6SCfytI8xnYqPR4weQ52heoKZFgvfJqXbikDsyNwAwRkXQnc3rnQXfzJSoXED51ryzsYllC5+y22W2WrYdBdY3rupsK90y8ySZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768734710; c=relaxed/simple;
	bh=xzyOwPgoBVo1pmqZkgFRcggkIHaM43xGpVnu2DrhXcQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ka0M+SceJd6VVIaSML/ais9Jqp7V3hwZPh97nYptiCowLgj6XFDUpTrEG5QKRw5jYQwSh7oaimlBzBJcVU4gczedhDw2DXaXyEf45EP0KNQ+ZqpVE/dI0o9X13BKuaoQ8IonsNgHhs+DYQtxPQkkcVhurZZ8tntVP5ZEkRPFvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhQhA-0016O3-2b;
	Sun, 18 Jan 2026 11:11:47 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhQh8-00000000mUs-0lfZ;
	Sun, 18 Jan 2026 12:11:46 +0100
Message-ID: <5ba33a1ce95dfa2fd2bb828b9c3eac82c2ae1111.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 183/451] ethtool: Avoid overflowing userspace
 buffer on stats query
From: Ben Hutchings <ben@decadent.org.uk>
To: Gal Pressman <gal@nvidia.com>, Paolo Abeni <pabeni@redhat.com>
Cc: patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>, Tariq
 Toukan	 <tariqt@nvidia.com>, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sun, 18 Jan 2026 12:11:45 +0100
In-Reply-To: <5f6519fc-adf1-4418-beef-251e4a930e48@nvidia.com>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164237.523595757@linuxfoundation.org>
	 <188e82d04a1d73b08044831678066b2e5e5f9c3a.camel@decadent.org.uk>
	 <5f6519fc-adf1-4418-beef-251e4a930e48@nvidia.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-j10gqlZraCA3dNas/TA1"
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


--=-j10gqlZraCA3dNas/TA1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-01-18 at 09:30 +0200, Gal Pressman wrote:
> On 17/01/2026 21:58, Ben Hutchings wrote:
[...]
> > Everything else I could find with Debian codesearch does seem to
> > initialise ethtool_gstrings::len and ethtool_stats::n_stats as you
> > expect, though.
> >=20
> > This change should be documented in include/uapi/linux/ethtool.h, which
> > currently specifies these fields as output only.
>=20
> Indeed:
> https://lore.kernel.org/all/20260115060544.481550-1-gal@nvidia.com/

Thank you.  Please add:

    Fixes: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on st=
ats query")

so that the documentation update will also get into the stable kernel
branches.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-j10gqlZraCA3dNas/TA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlsv/EACgkQ57/I7JWG
EQkZxxAAjX7or7VKp5GOtblJL7vm8fzJXKjoItrjaNoqX/NryYeysb/3zzoGOHm4
vTBFVhZwrw4QE2ta7u1OBHhB/SNkkH3usInOZibrvWeMIwiQ1OOPXvSs5j7T43PU
FLk9CMmIpOTZiR7bGdbdYoxLqXaB0vDYKcM90vgDmY/JMXr+ECLXUQkrnbz4wTWg
TMHyDrXbJwKqBt09WfaAVIJdbGH4wZBWv5F8HXsRSe2hgxOcPFTEU1VcBK/J3l80
rilX9lMlqU4kbNO9C3fHG3XL10CrqwLvqYUdBw/khocGxtKxFKIKJCtBJpb2gEmG
VttJbMMXXbyK54lCZx7YsjVRW82Vw4WEa6C3V0rtKreTS7CvJxYfRLYnr93XCzyo
+AC3bXMCWYZjPnnLrqS5FiPwyhTsxZ/yzxkvHHErQtgfSF6PnJlT8RvGo9k3BO7D
TqRrn7e3c6+WzeUzCQVCXalRuOLnR6cPaFjddmDq6K3bSNXnw5dxvO4bWOlDiGK/
DLMBmn0i3CHLCZO20QpOrhaGijlo7nGpJYfDk9uZozFzTBRPbt+fPwLLEZcCCZgk
glTr5PF5BjN7MrP+OOfjsIcSGoyouTh/H2GLIqSor3XYSZFrPZx34pMYjII0D2bm
b8iXQR5VY7CY7ur2a6QaresQB+dvP3HIxGwfS7kPuZr9RJJuBs8=
=UD7+
-----END PGP SIGNATURE-----

--=-j10gqlZraCA3dNas/TA1--
