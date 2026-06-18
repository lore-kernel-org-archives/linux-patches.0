Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE61D2222D0;
	Thu, 18 Jun 2026 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781793246; cv=none; b=KYpaZrYnLCTp07XJfoC5U2W5ZBpA9Jq81xy71+LeSQt3lh3X4IJRg8Jy9YlihbooH1G/e8M/AIdpP35z8Hj5chZlGFqUQmfVNacSwUY3IQ2PNtypfJI0YBTKJOTtukW7maH2VXlmb4cEJ9Nu9otHbAS/kpfs0avGofqP5w5qmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781793246; c=relaxed/simple;
	bh=DNDV0+pikas6MP5wUk44x8Onr0t42in3cpi45mdoaSU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RA4ud9B//kfAEiMoYRsxxCy0axRYZWKqpWFDuGaSDULtX5RHhi/NrXP+BMwuZRv2IjdxNQaOhBUrs+jg5JwNDlCWBsxOc8m0+oW7DFdEw5kTjNrfsEYVkfZmf+BvPQzV9wPXqSrwtWkcHqYmnXZJXP8Jq5jIoTNfU6cSQO8a0TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1waDob-0032nG-0k;
	Thu, 18 Jun 2026 14:33:57 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1waDoa-00000006s7y-2WC1;
	Thu, 18 Jun 2026 16:33:56 +0200
Message-ID: <6f805abf1f8b058c1b1241e8568d7539185145df.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 208/522] net: Annotate sk->sk_write_space() for UDP
 SOCKMAP.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>, Jakub
 Sitnicki <jakub@cloudflare.com>, Jakub Kicinski <kuba@kernel.org>, Sasha
 Levin <sashal@kernel.org>
Date: Thu, 18 Jun 2026 16:33:49 +0200
In-Reply-To: <20260616145135.793184452@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145135.793184452@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vhT3ChXx/CtIV4msNMEW"
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


--=-vhT3ChXx/CtIV4msNMEW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:25 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Kuniyuki Iwashima <kuniyu@google.com>
>=20
> [ Upstream commit b748765019fe9e9234660327090fc1a9665cdbdd ]
>=20
> UDP TX skb->destructor() is sock_wfree(), and UDP holds lock_sock()
> only for UDP_CORK / MSG_MORE sendmsg().
>=20
> Otherwise, sk->sk_write_space() may be read locklessly while SOCKMAP
> rewrites sk->sk_write_space().
>=20
> Let's use WRITE_ONCE() and READ_ONCE() for sk->sk_write_space().
>=20
> Note that the write side is annotated by commit 2ef2b20cf4e0
> ("net: annotate data-races around sk->sk_{data_ready,write_space}").
[...]

That other commit hasn't yet been backported to 6.1, so this is not a
complete fix.

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, on joining IRC

--=-vhT3ChXx/CtIV4msNMEW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo0Ac0ACgkQ57/I7JWG
EQlBVhAAiC5o2JO/kE0+kpsrCP2CGS+Vk1+Fl5a9ioFz1yOP/juwX3syyW7dzaAW
2ItWMnImXHc2WltBCjFE6kQLtfZ5WeHkaC7zoe39JR0UwlTvWJ5NJIZojuIQIa5j
43DzPO597TthVHZRee4OYVjVBCKBWfdjCd4XCVuFa8jWuAqXqZ4VNr2f81wRexQZ
x1S7fB250q9S8XZ2FNK+IzoI8DjDLiStJKozumJBi/eP3RwKcRq0Htq37rI9bNOg
64swjL+bD6kK3OIL71aL6/i0HRCIY6hsy9jhn652Jtio3Dap6+FtII7dhWJosNRz
OpugxRXBHV7sUvXFOuJPvR6RWP02wUmG4riXAZNBL3AbyBnNFv6iPnZnwdp8FvRR
tC4h+tKnz+8JXHfHCWn6xJJs2Hbznx1SuZGadPnJFKtPfMm0sQKO2PD9HjjHvgUV
ksRletx8g00374htQVC+lllBWZzHVQiwk0IFdHzB6RtfUNSPJM9LgskM9qMid3Vk
3/Nf62bRWPJSp7ESuIljvPsKTQakc0YwygO65TOqL6bmrIK+MVeRjCl9BK4yvPJ2
GoD0VKLVyN2M0WGUoVrIqx1PaxitL+iQYs0w0CwcSbexGZ595wIxZ2EQsLUB5DfG
yydf/0wulzDlYcom7a05qkxG27Ea3eFNXCh1MDH8YcNfGFL1zZ0=
=4IcO
-----END PGP SIGNATURE-----

--=-vhT3ChXx/CtIV4msNMEW--
