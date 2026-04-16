Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022233F5A0;
	Thu, 16 Apr 2026 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776365037; cv=none; b=NUWcoNPrakJnWYzDMMfET6/O0xbeowqUj37kpFRokrDI1lAY1euexW5p5xvqnD+HYbZEsrOsHgIPYN0CS6mj/Rsyynicz0e9f6IP1vCD6NywFQ4Q60zZu74/n83FbcJUW/M1/U2B2Jz/vm6AuYr1eqnPXh5weIitRfI8kGrDtII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776365037; c=relaxed/simple;
	bh=e1liLybHqSu1gNwaO4To4rUv9vWmN8tQlunb6Ws8OmU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t00pCd/JDXpXCAjZRPbRvIHGmCPrtNasBM0rpb+Me9/2QfkVLBNgWvYMaub5XL99hscxGndWQRoncnq7RbI5HZSX+aEM88+4qh4/JeE/1B+ctR0F1NhL0BoFv4HaT5TBIvbwtdTWa5Ci5n0gYrQclzbsa5Gk/0qc1dQtbMYeAXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wDRgw-005EZS-0S;
	Thu, 16 Apr 2026 18:43:53 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wDRgu-000000043iN-25Ee;
	Thu, 16 Apr 2026 20:43:52 +0200
Message-ID: <6def01a404f3b10ac374c011000637c86598453b.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 311/491] dmaengine: xilinx: xilinx_dma: Fix
 unmasked residue subtraction
From: Ben Hutchings <ben@decadent.org.uk>
To: Marek Vasut <marex@nabladev.com>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Vinod Koul <vkoul@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Thu, 16 Apr 2026 20:43:47 +0200
In-Reply-To: <8c909ddd-c8ff-43a1-987f-1a348917d75a@nabladev.com>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155830.683657586@linuxfoundation.org>
	 <e4bf9ba9ceba4f2e23483b4aa0ebcff8251c0b73.camel@decadent.org.uk>
	 <8c909ddd-c8ff-43a1-987f-1a348917d75a@nabladev.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5LxiYOwZjQcEA/tx7cmC"
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


--=-5LxiYOwZjQcEA/tx7cmC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-04-16 at 20:20 +0200, Marek Vasut wrote:
> On 4/16/26 7:58 PM, Ben Hutchings wrote:
> > On Mon, 2026-04-13 at 17:59 +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Marek Vasut <marex@nabladev.com>
> > >=20
> > > [ Upstream commit c7d812e33f3e8ca0fa9eeabf71d1c7bc3acedc09 ]
> > >=20
> > > The segment .control and .status fields both contain top bits which a=
re
> > > not part of the buffer size, the buffer size is located only in the b=
ottom
> > > max_buffer_len bits. To avoid interference from those top bits, mask =
out
> > > the size using max_buffer_len first, and only then subtract the value=
s.
> >=20
> > This change is harmless, but the problem it claims to fix does not
> > exist.
>=20
> The current code subtracts two independently read values which both=20
> contain status/control MSbits and the actual value LSbits. Depending on=
=20
> the MSbits being identical in both separately read values is unsafe, so=
=20
> the change in this patch masks out the MSbits first and then does the=20
> subtraction on the actual value LSbits only, which is safe.
>=20
> Why do you think the original unsafe behavior can not trigger a failure?

The old code masked out the MSbits after subtraction.  So, there was no
dependency on their being equal before substraction.  Since borrows
propagate to the left, not the right, the MSbits could not "interfere"
with the LSbits.

If you still aren't convinced, please try to find some example values
for which the result would actually change.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program
than vice versa.

--=-5LxiYOwZjQcEA/tx7cmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnhLeMACgkQ57/I7JWG
EQnjvBAAwS0GP7zvEutxbz+85T15fpWSzZmt8QYwfJvpePLbaICxvTjpCVmVP04Z
LyrLC+YfnQMJZfZm3xe4H8zFYtEsNa6+30v5dN1MINqxJmFUqbSlEm5gIMN925wk
F/caUB7rNnU0t4YbsmzyH6+X3fc3OH9hk66QZOPWnFFNmSWbu3YAVDN/OMQlLLZf
Y+ir7cZn/dIWGpMOsJujNf3/yiDrY3ob4qFP4IWXVsTJS2o1sGH7v/VK0Y1uYwzW
tjwaX2V7I456GXtgQfo73VmmTx8iQXHK6ky5y4RdKuhfUrbBlX4yQTGyQmAgl0E0
DfSxeBST9NhahRmrcPH2+mxM8ZXzFCf+DhXuX14EB1rW1oKWB++5pQ4q7a6o0tx6
wofv9WtOgmENrCBBvzuBc9JynY1BPgiBttK1zvsbb/d5Tfz9+L+93OCjQISA5fP+
z2SvB6HFFqvZqcYR7nAjWGJ1RxbhGA0mLz6TNPW8EDR/Pj7tI7hrBUKKgOpNk+4I
BfhuK2SCqH1f1EWXSSOFhF0jRwC5bSZdMIYiubgkv9xzf5REgJrdmV3oU53yuGLe
xNHkbAeYMSiWYqBmdJTGr7Rg4aXYvj3tGatd5zHrWHVyqNYhl9q+ItTmWv9/buRP
IF/CggwFVWGJ3V0eW9rxWhA9BGXxrq+zBMtKRCwuaJKXaNhyWE4=
=l9SL
-----END PGP SIGNATURE-----

--=-5LxiYOwZjQcEA/tx7cmC--
