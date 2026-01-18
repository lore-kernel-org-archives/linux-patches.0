Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371152DBF45;
	Sun, 18 Jan 2026 11:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768737269; cv=none; b=FgkktnU+yjTZ4SOD3jrHfaZzl2a6Jtm6z1MwzJFrnAGKYY+lvzBHnpZDCXFqY2BgwQRL8zUa4RUbHOo+dETpSVHYlBVk5+qJ+UreAFypOp/8PogkvLhh8YME4fM9leJfmKoo2WI1sBQeANkoHupJkgS/DEkwNQAkwRiLnVki3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768737269; c=relaxed/simple;
	bh=CpLnLwiO3ZXS28zAWjR6YWpVwAElDwnxp1l9EP03Rbo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uIY5PHbx2EB1epofbYWEF1mOohJhCXMhlNOgAmNXL8rBk9LsBKTURqbR1Zj41v7I5T0PuptqN82LZoyOZvHukz/5Eyksg4dW/AgvghfAkfNgHmxmpcE4dLjLYLoaoe9WtBxvP8Lw9n2Hp7tcip9eSt0UMh3bc0qOBCI4gBTum3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhRMQ-0016fP-1w;
	Sun, 18 Jan 2026 11:54:25 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhRMO-00000000n05-2vTo;
	Sun, 18 Jan 2026 12:54:24 +0100
Message-ID: <2283a941e03c614f1a2fcdadb22dba95c5857dc1.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 262/451] io_uring: fix filename leak in
 __io_openat_prep()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, 
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com, Prithvi Tambewagh
	 <activprithvi@gmail.com>, Jens Axboe <axboe@kernel.dk>
Date: Sun, 18 Jan 2026 12:54:20 +0100
In-Reply-To: <20260115164240.364183352@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164240.364183352@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pqIVULbTvRmjGiSN/VNS"
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


--=-pqIVULbTvRmjGiSN/VNS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:47 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Prithvi Tambewagh <activprithvi@gmail.com>
>
>  __io_openat_prep() allocates a struct filename using getname(). However,
> for the condition of the file being installed in the fixed file table as
> well as having O_CLOEXEC flag set, the function returns early. At that
> point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
> the memory for the newly allocated struct filename is not cleaned up,
> causing a memory leak.
[...]

This patch is missing a reference to the upstream commit
(b14fad555302a2104948feaff70503b64c80ac01).

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-pqIVULbTvRmjGiSN/VNS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlsyewACgkQ57/I7JWG
EQlBTw/7BCAccNmGkdSA+iwX1XFmgAmpB3CFJ2jVIxUzUFArsTgyhVmtsefDAXWx
i4QEvpt8aKx0KGMDJfhnFWlSrO0eEHwXXIsxsYVaOWGypa5752aC6eVeAhCamb2k
elcIPDZ8dY2eNkB6WsUxrldic+i016+Ak1lzOnNU/r5wJYJOxqgmcfntqsles7sM
ovWfkArV1FlRyhg2utXsw5w+TYdgBBamyzwBvwpyEqV0qajeRH3zKv0kddMfyh9G
BCm0d6tTnDfHYG2nxTALUP8q5/1bjqAR1AKJiZCBPjY+l8Ab2IoUlR3q8hnp7S75
sUovkuNRX3ZLBDcc1KcU4XUHMBXNiEfz6hKe7uTcctcbNKokaxlo7W7ib1Jt9IIo
hvzEEHyXzDq4VqYA3+p8gQ3xvurMCveX+5GXVe2D9VtpgSH9Uep+YMkmOnAGyL7W
lV9eT04PGJeIvT36L3t9kTJLEItpgdAocyvnqsTNGZfqqiaJWhTHY8HLz9bYaeeX
NxvQVNi1/1jPw6vYTaEoBmtxpJDujyMYPbM7Tj3wbKLpiZ++OBNVsfEHLH+pVaKZ
jGZ//aAn/wiGfOKapmwQ+IOofvBLutR80siWkephmLmOczRUFm4l6wksXHsQk4ef
6rawCdJ73LuXKSpxoerCyJEpPERz4+3R/t5hDqI+8nvxySwxU7E=
=Uuy/
-----END PGP SIGNATURE-----

--=-pqIVULbTvRmjGiSN/VNS--
