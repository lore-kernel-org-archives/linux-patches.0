Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1B3B841F;
	Wed, 17 Jun 2026 08:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781683329; cv=none; b=SLqN/BtZ5bbEqo6Wz73eAAJX1bTNRL98WKliPBIOWX5lTpAY13NPlfOxGz73U2PgBQptRljc+SbgH/odRu2M5hDIuuK6/F3M0Ya0j0AhXKSWECL9CThA64ux/bH84trR9O/PPp2frSBUNIF08eCXSp/4BB98Sk1wYMDhfJYSrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781683329; c=relaxed/simple;
	bh=bQjg9d0xk5/y7Z7iDbJZ5ntWKfwGZABXPB2ws0qEAmY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lP/C8RICE5S86QvhiHgLtN+swHQ5WTd+W83XwKSuS8j8V4J233dEl93i4KBtc8QQXvTjzLKOONpapJQmzoSWpnwEccYzzHN7sv2527KQiTpznGRN3eAi3p5J1UsxxFC1D73hJiWiH9rCIs8cO1Zfq3EPq8DGJgEgXtRzJHBnUxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:a03f:8fba:4c00:9e56:df29:1317:540b] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZlDn-002tSe-1C;
	Wed, 17 Jun 2026 08:02:03 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wZlDm-00000006d1T-0pf1;
	Wed, 17 Jun 2026 10:02:02 +0200
Message-ID: <b6b679743c2383b5a367c5d72404b056dfebf080.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 054/522] selftests/bpf: add generic BPF program
 tester-loader
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, John Fastabend <john.fastabend@gmail.com>, 
 Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Paul Chaignon <paul.chaignon@gmail.com>,  Sasha Levin <sashal@kernel.org>
Date: Wed, 17 Jun 2026 10:01:56 +0200
In-Reply-To: <20260616145128.305073045@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145128.305073045@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wkhwUooaDJIhnGdFdMX/"
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


--=-wkhwUooaDJIhnGdFdMX/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Andrii Nakryiko <andrii@kernel.org>
>=20
> [ Upstream commit 537c3f66eac137a02ec50a40219d2da6597e5dc9 ]
[...]

There seems to be a fix needed on top of this: commit f00bb757ed63
"selftests/bpf: fix to avoid __msg tag de-duplication by clang".

Ben.

--=20
Ben Hutchings
Humour is the best antidote to reality.

--=-wkhwUooaDJIhnGdFdMX/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmoyVHUACgkQ57/I7JWG
EQmMvA/8D+w+2pFrEY3db/OnHk+Ci/o0t7iV+d1L6024nCYWfZrJLMb/P6BPYct+
Esg9a/AwbNCjqvIw+nEO3Wn6D+tll6arotHwHfK1ENGdXVpbZ5cEfKQXDdsYq21K
QqzLxl2FscGX7GR+fMMaoJekIBsUNL4Ax1CXaQSquTxpg8zA0wvd+J6aRAnrVf6d
IVZyaXrZTIE/GkH6FrXJLQzm4MplOE8b1UDw5rRZbKLrab7WvGq/xZ/h82+pbfrc
God+xp/GOsvp3PjCZavAFGbuaEwPhPoPq0MdIHkx4LrwA2M4nC84M6ZZSSjAPELH
VQKMygE6Z9lY4mxL1WnoTP0TBy6iqKy6uIFGi6kxMS5tPzWY8xrXIx6lcgIA+XBx
8e8SGrwKPqAeLq+qoYw873ouupwDb5tO3X0DUDFV4tmEIxw6PadIhGpy5jA5UBSM
5jPyzZyFcDb9R6YAw9GtYPeHr0c8cxOsdn3AIavHfDl/aF+wd6dldQA0gN0WACCV
tBm+zqVaKlHNO0SCTi4rTnf5BtoqIsSmYYbnCxSpPX5NZBOI+QQyOJbFWro1QGCV
njs4PvNONb5FCLv8ZcgXq6AghZVE9WBp5nYHzLdF/IidMNQebSSqfKVFDbZDI//p
hI7+BxC0Mpq3PTVd0MS4U7kfYpWoOB817LcxYuSv7Sv+ua8UNss=
=oEP5
-----END PGP SIGNATURE-----

--=-wkhwUooaDJIhnGdFdMX/--
