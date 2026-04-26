Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484A321256C;
	Sun, 26 Apr 2026 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777211057; cv=none; b=UCtfq5YGVOD8ll4zXhuFXrh4L2ZgRLtBpGQF7u9f4jVmgP7MTxzGovDZRwoYUkZ34GQcedkpbFWvBxpgUM6bQesI7PwShPr4cs7XIAYW984isZYLUjQJzo3T/TCu0nT5Uq4IGUWJKFM0v+3s8nuHEYDIm2vSb2cgGaAUkQuZvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777211057; c=relaxed/simple;
	bh=bDm+/uxPStK/NQbi/eGFHAIX3ZznzOA0ZDXZpddStIE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CSvumigEDoOX0fxKU/1VCMmeEolYDhIrgSoe7EIh7hHB7Bqfef94HByZ72NTyv3SjZ6NivQyWT/wjmEyAho33AyjLIpYAQ9HXnMIfod0+yAznotpw1wUNcDJ6jNsC4iMgS0julSZZtk9OdTjEU4It/wIK1XeEQsyRX1JIXSJZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wGzmJ-006ZV0-0j;
	Sun, 26 Apr 2026 13:44:06 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wGzmH-00000006skC-00xY;
	Sun, 26 Apr 2026 15:44:05 +0200
Message-ID: <e0f3860e1994351c8627518bd580b590090d0e5b.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 430/491] apparmor: validate DFA start states are in
 bounds in unpack_pdb
From: Ben Hutchings <ben@decadent.org.uk>
To: John Johansen <john.johansen@canonical.com>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Qualys Security Advisory <qsa@qualys.com>, 
 Salvatore Bonaccorso	 <carnil@debian.org>, Georgia Garcia
 <georgia.garcia@canonical.com>, Cengiz Can	 <cengiz.can@canonical.com>,
 Massimiliano Pellizzer	 <massimiliano.pellizzer@canonical.com>
Date: Sun, 26 Apr 2026 15:43:55 +0200
In-Reply-To: <5c718a4f-b0fe-4b80-8fdd-200871454320@canonical.com>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155835.127014179@linuxfoundation.org>
	 <0d3747dc57d7bfa3c53efcf4d133021ead5bef9d.camel@decadent.org.uk>
	 <5c718a4f-b0fe-4b80-8fdd-200871454320@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iryIRH0H4TTNncqYv/s4"
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


--=-iryIRH0H4TTNncqYv/s4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-04-21 at 01:42 -0700, John Johansen wrote:
> On 4/19/26 03:26, Ben Hutchings wrote:
> > On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
> > >=20
> > > commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.
> > >=20
> > > Backport for conflicts caused by
> > >    ad596ea74e74 ("apparmor: group dfa policydb unpacking")
> > >    - rearrange and consolidated the unpack.
> > >=20
> > >    b11e51dd7094 ("apparmor: test: make static symbols visible during =
kunit testing")
> > >    - rename function and make it visible to kunit tests
> > >=20
> > > Start states are read from untrusted data and used as indexes into th=
e
> > > DFA state tables. The aa_dfa_next() function call in unpack_pdb() wil=
l
> > > access dfa->tables[YYTD_ID_BASE][start], and if the start state excee=
ds
> > > the number of states in the DFA, this results in an out-of-bound read=
.
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >   BUG: KASAN: slab-out-of-bounds in aa_dfa_next+0x2a1/0x360
> > >   Read of size 4 at addr ffff88811956fb90 by task su/1097
> > >   ...
> > >=20
> > > Reject policies with out-of-bounds start states during unpacking
> > > to prevent the issue.
> > >=20
> > > Fixes: ad5ff3db53c6 ("AppArmor: Add ability to load extended policy")
> > > Reported-by: Qualys Security Advisory <qsa@qualys.com>
> > > Tested-by: Salvatore Bonaccorso <carnil@debian.org>
> > > Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
> > > Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
> > > Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonic=
al.com>
> > > Signed-off-by: John Johansen <john.johansen@canonical.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   security/apparmor/policy_unpack.c |   21 +++++++++++++++++++--
> > >   1 file changed, 19 insertions(+), 2 deletions(-)
> > >=20
> > > --- a/security/apparmor/policy_unpack.c
> > > +++ b/security/apparmor/policy_unpack.c
> > > @@ -841,9 +841,18 @@ static struct aa_profile *unpack_profile
> > >   			error =3D -EPROTO;
> > >   			goto fail;
> > >   		}
> > > -		if (!unpack_u32(e, &profile->policy.start[0], "start"))
> > > +		if (!unpack_u32(e, &profile->policy.start[0], "start")) {
> > >   			/* default start state */
> > >   			profile->policy.start[0] =3D DFA_START;
> > > +		} else {
> > > +			size_t state_count =3D profile->policy.dfa->tables[YYTD_ID_BASE]-=
>td_lolen;
> > > +
> > > +			if (profile->policy.start[0] >=3D state_count) {
> > > +				info =3D "invalid dfa start state";
> > > +				goto fail;
> > > +			}
> > > +		}
> > [...]
> >=20
> > Isn't this range check needed even if we use the default start state?
> > unpack_table() only checks that td_tolen > 0, so we could end up with
> > profile->policy.start[0] =3D DFA_START =3D=3D 1 and
> > profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen =3D=3D 1.
> >=20
> > (This is specific to the backport as the upstream version didn't put
> > this check in an else-block.)
> >=20
>=20
> Hey Ben,
> I specifically chose not to make that alteration to the patches sent to
> stable after reviewing the submission rules. That would be a non-backport
> related change from what landed upstream and we were referencing as the
> upstream patch.

But the upstream patch didn't have this problem!  The range check was
not conditional so it would catch this case.

> Instead I am sending Linus a 2nd patch that addresses
> the issue by ensure the loaded dfa has at least two states. It will has
> a fixes tag and will get pulled back.

I think you are talking about adding a check in unpack_table().  I am
talking about the later check in unpack_profile() (or in unpack_pdb()
upstream).

Ben.

--=20
Ben Hutchings
Nothing is ever a complete failure;
it can always serve as a bad example.

--=-iryIRH0H4TTNncqYv/s4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnuFpwACgkQ57/I7JWG
EQk1OBAAm8wwA53ntd81DAn8VqPtxnJesnjJmsgx6Pwllwko9UWE2dYQSk7DoWfl
7LZiBHyJL90z+mwHYxf597KIp6zNTKpVnmRnuAEdgCL8KyMqJoPo0WS7PEAV3Czy
WKAoK051pi8TimAgMZSWHRDzHQiarSujKRp3ho/cyuMZ8DhMqYNkb+vXQchOrtZa
AqZWpSo+pgjAgbdsuzkgiTW06iOXkiYglqPNyr8elA3GpVP3ETdlcG8/qPpNJ2oU
PBpYqKIUlf12VD9MLAN2601QaIJ4l9Iwf3LlDp+XZglLFAkW/LYxZarVj7a54Nmv
9GMa/ydKBctOTPnub7PaUnRNwfm10h78zaLJ8jdrNztiwcom14DAM3ejoU2nNJ1/
sbvD4SCqls1G8YFY+Wo0gIKNq//6o/+nVtdnhjXjUI9qR7QjciHuNliuWErIx4qO
WNgjRCNRXh7UTgRvZD3hfUocJSI19p5kV0//ho0Z4kQ2rEgTxZ8PMltyfzagh95L
yPP23BEi2EhkY0SOf+KNbOuBd4DZeq1r2lUP08GoHzXXFNUXF6fHCCbYF+H5oHqf
3rRUz90dTQOxlx02zQoTMxo3kESsy3M5yYdP+0Y5n/jAKYvXEPrYaYnqXoc3yaBD
VZi+V81bUNbSc8zVrDxG8VRAncd3z1RA0fBF0piLNQ6jMgBvNOU=
=ZTqU
-----END PGP SIGNATURE-----

--=-iryIRH0H4TTNncqYv/s4--
