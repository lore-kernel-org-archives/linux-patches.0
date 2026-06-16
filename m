Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9937EFEB;
	Tue, 16 Jun 2026 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781648234; cv=none; b=a/46Vd7jxsdoi8Ue/mdu5M6PLObB1kO6R/5QiW5MPnmB3SYZQkVlJMtkuj+yxgWAvw23UHbp2UIM6II04JVcno2p1LHiB2diUSGhsE//F6XdykiD2BXfezMNCehTO/3WwfoF59ZuKJfm1wgoasXber6hvLPeijgOFKg1tsH3OOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781648234; c=relaxed/simple;
	bh=OtnRhL63A1AyvvSfyvuo1VqwW5W7S68cFQ7YZ5LrdXE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J/8fo73OSlOB4TVkcLueVUqmU2a2JDGMsmnTzFjt0Oj3f/JvATr64vdLzCpIYqJPcMjGrd81vx60ps+nkHimEsmfamWdjS5ioPd9Zg7IdY9fopXOnUyqot/X3rOKNc3SPtgHI/2xpRJCy0iWn+3m9fT9p+GtCp/naBY61aOgDqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZc5m-002rDr-1I;
	Tue, 16 Jun 2026 22:17:10 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZc5l-00000006Zbt-0avN;
	Wed, 17 Jun 2026 00:17:09 +0200
Message-ID: <cb2e59a48887f106a57c3fbef66d5a164b8e2f5f.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 033/522] net/sched: Revert "net/sched: Restrict
 conditions for adding duplicating netems to qdisc tree"
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ji-Soo Chung <jschung2@proton.me>, Gerlinde
	 <lrGerlinde@mailfence.com>, zyc zyc <zyc199902@zohomail.cn>, Manas Ghandat
	 <ghandatmanas@gmail.com>, Stephen Hemminger <stephen@networkplumber.org>, 
 Jamal Hadi Salim
	 <jhs@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin
	 <sashal@kernel.org>
Date: Wed, 17 Jun 2026 00:17:03 +0200
In-Reply-To: <20260616145127.216541751@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145127.216541751@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kv5okF0W6ZRtYsdkHqTG"
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


--=-kv5okF0W6ZRtYsdkHqTG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Jamal Hadi Salim <jhs@mojatatu.com>
>=20
> [ Upstream commit eda0b7f203bb166c98d1418b204135bd566ac83b ]
>=20
> This reverts commit ec8e0e3d7adef940cdf9475e2352c0680189d14e.
>=20
> The original patch rejects any tree containing two netems when
> either has duplication set, even when they sit on unrelated classes
> of the same classful parent. That broke configurations that have
> worked since netem was introduced.
>=20
> The re-entrancy problem the original commit was trying to solve is
> handled by later patch using tc_depth flag.
>=20
> Doing this revert will (re)expose the original bug with multiple
> netem duplication. When this patch is backported make sure
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> and get the full series.
  ^^^^^^^^^^^^^^^^^^^^^^^
[...]

That whole series was applied as:

98b34f3e8c34 net: Introduce skb tc depth field to track packet loops
eda0b7f203bb net/sched: Revert "net/sched: Restrict conditions for adding d=
uplicating netems to qdisc tree"
b213a4c6074f Revert "selftests/tc-testing: Add tests for restrictions on ne=
tem duplication"
9552b11e3eda net/sched: fix packet loop on netem when duplicate is on
db875221ab08 net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mir=
red loop
a005fa5d7502 net/sched: act_mirred: Fix blockcast recursion bypass leading =
to stack overflow
e80ad525fc7e net/sched: act_mirred: Fix return code in early mirred redirec=
t error paths
d38dc56a0225 selftests/tc-testing: Add mirred test cases exercising loops
0f6e00aa5f65 selftests/tc-testing: Add netem test case exercising loops

You included most of those in 6.12.93 and 7.0.12, but for the older
branches and 6.18 I'm only seeing this one.

Ben.

--=20
Ben Hutchings
Humour is the best antidote to reality.

--=-kv5okF0W6ZRtYsdkHqTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmoxy18ACgkQ57/I7JWG
EQk06hAAoqrnMFrfG7h8ifAR4jqfst2FsbioPZo4UQsjYEp+ZPwUx4pvdIiHTdQo
ogTsyiSmQbrtgFmzgkqXtIS+i3WVtY+/nrcONGYKkdr29DruQk/Hhn/A9fcieNCq
U8d0gNRXqp/uwO4Nl0+vbZFjHwFuYJjWecRmG+NuyA8XLseJEV2QKsAiRV2Qh0d/
02HUIF43+WWcruQIw4cFjRu122MzmNBHxJKKGB0ONv1ef7sRqXuYJLqMmeOdJ/+3
8RNaPiJi4nWP7k0j73t6ngoLqv22aoYXiD7ONp8+DnJ1jeT8qmONnIfeV3bjbbAB
hl1y7/JoWI+j/nmrau1+GyFwNENatvuC1jSOPmKZa8iRaG4To3DuUJk0WCsTD2Cs
u2+WJ1Ep+X+b7aCjA3+fBktj+KHFZ3r+RiLMIVPOUNPUqveGSxBsajE3x+jJKrxj
3t/tbtVlvyRoQsX9tG2eJdpRilzBUk/O0rT3EBzFg7KaX53I/EtvYM0agxcf5kHM
35mNaI8gngF2VDDFCctuu/XrlSDdHf+hLTmv5JVJz3IZMl/i9o79DwBq266U0BjN
a0nsn03lijLbvv2iInp559IGZnj7EmS3fUWcNi/9Cgf+RwdPS6wAELjgNzmtpP2I
2HBkkA2rKlyX5/2E5z2rLnkJQum9xTQ2AWKDhwi9k3J8xQCOeqM=
=OSkI
-----END PGP SIGNATURE-----

--=-kv5okF0W6ZRtYsdkHqTG--
