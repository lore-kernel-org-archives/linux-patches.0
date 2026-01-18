Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8B1A316E;
	Sun, 18 Jan 2026 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768762754; cv=none; b=liv+fIluztW9wT+FkKvv2StQD4Uafhvee9s3E1DG3A34uTFs0742RJAL5xSUXfJzTK15sm4wbaQluFzdyShaSzQppRSU3GJ+Fa5mzwOPFMXDUkpz6WSs5CRzX5rdxqhwrNC+Bx/Oa8uquFiPS24zGuOOGEN9K/TML/ee/dLiCQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768762754; c=relaxed/simple;
	bh=ex/2O6cmEjo2woUmKsAcQcDXJ8an36PUKEsLQ+euTtE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c4oZyvtMIYtf7xaLB4HuKaFUENWpFz+8PJo81084sSzALuEZ41nswgpXrA1irDBPiQoyOd1FlKUZoGQDsLjHfQeQ891dF3OoCqLy4RHjbAbyj6iV1AKAX+YxwupfRaIhBRFSCXuBcdFNEfArdHI36zvfoU18FZBhgcddInXTGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhXzT-00196F-1s;
	Sun, 18 Jan 2026 18:59:10 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhXzR-00000000rI7-1INo;
	Sun, 18 Jan 2026 19:59:09 +0100
Message-ID: <ca5a59b665e1e91b723e66b30e4692cfa13a3a31.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 394/451] mm/mprotect: use long for page accountings
 and retval
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Peter Xu <peterx@redhat.com>, Mike Kravetz	
 <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea
 Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
 David Hildenbrand	 <david@redhat.com>, Muchun Song
 <songmuchun@bytedance.com>, Nadav Amit	 <nadav.amit@gmail.com>, Andrew
 Morton <akpm@linux-foundation.org>, Harry Yoo	 <harry.yoo@oracle.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Sun, 18 Jan 2026 19:59:03 +0100
In-Reply-To: <20260115164245.186677511@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164245.186677511@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hJdlc3SGN0eHhDMV7FtW"
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


--=-hJdlc3SGN0eHhDMV7FtW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Peter Xu <peterx@redhat.com>
>=20
> commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.
>=20
> Switch to use type "long" for page accountings and retval across the whol=
e
> procedure of change_protection().
[...]

This was a dependency for a backport of commit 670ddd8cdcbd
"mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()", but
that's not in the queue.  It seems pointless to apply this by itself.

Ben.


--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-hJdlc3SGN0eHhDMV7FtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmltLXcACgkQ57/I7JWG
EQk/ihAAr8ZzwpyDdJakJhjCtb1d8EW1364VNnaHGJeCCSx2ZrGl50sF5w4D4AbL
qhiAu12Qx7f+/WV6U30dSz0ozefqTMXG+xcO+iZLDilBcOYtfqK3R9+Yx6LpPZ6h
5i+I1RhcoLwgFa5LkZhGeAhZTtzDKeNvCfKdfXOsBHHNLtXrtM+kJCBWSusftFES
UFHyW0qWs1y4LKIeU9s3CRdnbv+X8eWZ8dgpr0SJxY3csgp2naM/9PLejqwtgi2q
GrrYznmaadq/O++xOek5GtugcnKNi1VLHxu+MW1sfPeTt83iJQyjWXbUNnAyv15m
U0SXIZqV+0rL4YSeyziv2c0RvyQBOtCTOmLZMBpLgajTv20q2PNl6RD2/TXiYJTG
NKspCwKXJHz0MxKFcl67BxGE09yybfUzAO6lT53vXZq/pR8okzfizt1cxnKzgy7c
shHopnScCwIDg/fDiLVTUpJO+Pmqwy65+F/7E2g8orD3ZtbHBrX2of27G5NB8vWI
E6dHemrC010FLDO8LPfOUFCfILnIf9aiLMZnh4Oku95PFS1bnIjFJ26AkJJfn1p3
oeqk5tA084oggtX1hxb/RvLbxhtYUWXanbD4+e4UcOM7jACGBroPC9pxvGWR+nsn
Ao9Hvx4JaWFtbQn4STnGXODzJJqc+5wZOTwk5NXqOc1ksbS6HeA=
=/ZqA
-----END PGP SIGNATURE-----

--=-hJdlc3SGN0eHhDMV7FtW--
