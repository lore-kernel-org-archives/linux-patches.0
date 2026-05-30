Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF01BBBE5;
	Sat, 30 May 2026 19:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780170368; cv=none; b=bHNv7fRwp4kmuMNklGxJev4YSjJjywH9jLs7q7j1mDyrWNbyLpmtWWOXA/Gr6vUF9yZiDhtMOTe8YhRw+a/irpOfF6WEIUM2MglF73N5N+xgMVv7A0u80ZRyMqs8hUo95LS3xIsLeBvwxpf1TJq727VpLCjqCkQfOIPALv2nNNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780170368; c=relaxed/simple;
	bh=iNIIvVQAuSj5+sKBYCYJW3IPioaWgMVrQyhlp4bvtQo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sVs4+9COrkxn+12hPxoZ+zmffZAWNKjag5+9Mrp3bPx6yYWL5Zvw5xwAxUbGNJn2iBHybBV2HTQuJCQmxF6JnKa4FQg4QOvY7Phly8OS/fw+1WuuinjH+FQTAyjAFRSKLPy0t6CLs2R6DgCbmz2tcHlXGqnTLDvqaVS5K1OinRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTPdE-000K8x-24;
	Sat, 30 May 2026 19:46:04 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTPdE-0000000F0X8-0S4E;
	Sat, 30 May 2026 21:46:04 +0200
Message-ID: <56652caf63e8db874a3ebd761ec134c003d4986c.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 027/589] xfrm: Wait for RCU readers during policy
 netns exit
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Steffen Klassert
 <steffen.klassert@secunet.com>,  Florian Westphal	 <fw@strlen.de>, Sasha
 Levin <sashal@kernel.org>
Date: Sat, 30 May 2026 21:45:58 +0200
In-Reply-To: <20260530160225.295450347@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160225.295450347@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1gyBHEfPa8iPcrwGpl12"
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


--=-1gyBHEfPa8iPcrwGpl12
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:58 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Steffen Klassert <steffen.klassert@secunet.com>
>=20
> [ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]
[...]

This is broken - it needs commit 3e5241731847 "xfrm: move policy_bydst
RCU sync from per-netns .exit to .pre_exit" as a further fix.

I haven't checked whether that applies cleanly or needs backporting
work.

Ben.

--=20
Ben Hutchings
The Peter principle: In a hierarchy, every employee tends to rise to
their level of incompetence.

--=-1gyBHEfPa8iPcrwGpl12
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmobPnYACgkQ57/I7JWG
EQnbqhAAvykFMJTiLdlVzSR1fkaWfwxeuntrkozYysknjd1B0fzjOUVzSQv8E062
WaQwRDUCqn5yjnX2E2I2FQ/6BB/EwWT8QzCzUu6nz8Ow3xnMJSz05bB6VX8EaZ9V
AJv7l/DIvjttAaqhKsnbLmGFFHRfMpGarFhb1ngbQPL+JEd0wCcHUT7ePxRaxRvW
/jArtM07JBnxrTjt2BG1IjZaxLKLPQPh/RyWAeISsSikFsWdm5zgo5yaA5fVhNwR
4ZkONqQOpuOSPE+Yd4IGeDeahDlAVgzVHaK3LB1jlzcB9pwcrovM6atS2NbWdTBP
q2DwoxpN720/xEWfkfUI9gdhCHDoVOxEamkAn5TWECmt4ohnZiWlsZUB4A0buyz5
8YWRGd2TOS5BD4Mf5TcC8zylADVVSjvuEAIB1u20AIioeFHjZzdcH6bmoC4fRYPr
Y9IiUnX2PFCiWa6w0x5mww+VppNCsFzYoRuvUaewd6yzh7sRZQTuqyQxsLgqmr7l
Fy5hPz0fHEGwWqZXGcccaRxjPzIQpqIzzxCZYPMykjFOEr/7+Zs3ZkNiOLoAYigd
vC6/4RZr3kxiNESyMIw/UaBNN3hE+KrueJefxq1BXo2qZ4g+FQnE3LiMoZxePpnz
CTMxRnarj/3H/ITyG6a/5YXcjmoPXoUtoUUVLN7ag+/cfOLXzzA=
=HzCy
-----END PGP SIGNATURE-----

--=-1gyBHEfPa8iPcrwGpl12--
