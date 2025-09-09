Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8643A30214B;
	Tue,  9 Sep 2025 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449520; cv=none; b=iCWLB3D0vbCgIKOgePn+Q5Esma39jp4nMvEBZRdNYIax3c8eDKcqu87Wh0C868EyK4hD0zKaTgxUbROjD+ibn/9+0qXqanhHPTEhuG8D9XHlkZQFckAxpOaV0C8WLVOAtSDJyNA8qecfdWQSQSunYAbQU47es23PjiRVQaWlcjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449520; c=relaxed/simple;
	bh=B05ab1H5adfOB8fknHXZFCe4sRqjE9IemtvtM0JGmVk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ND1wFBtKOYOTEWasGokbGJhdZurLODiwk5xcebk2sPxfoEFJfW7/1nbH+7GL5nDbSRswl66CNLFspvqzQcBE0H1fszvTxDnAGG7p58PYMHMdOIYOh2D2no80UCHjJkWUx3utHJ/NurZ2fMAjW/nUi6B5y246ImN3cPzU7FSmODE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1uw4Fr-001VTS-0h;
	Tue, 09 Sep 2025 19:43:51 +0000
Received: from ben by deadeye with local (Exim 4.98.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1uw4Fp-00000000Bq6-3Kra;
	Tue, 09 Sep 2025 21:43:49 +0200
Message-ID: <d2cadacb17dd4c96352f472ca10f656cd795b881.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 26/52] e1000e: fix heap overflow in e1000_set_eeprom
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mikael Wessel <post@mikaelkw.online>, Vitaly
 Lifshits <vitaly.lifshits@intel.com>, Mor Bar-Gabay
 <morx.bar.gabay@intel.com>, Tony Nguyen	 <anthony.l.nguyen@intel.com>
Date: Tue, 09 Sep 2025 21:43:44 +0200
In-Reply-To: <20250907195602.752505443@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
	 <20250907195602.752505443@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2BHSEvwaaqnP3B5XN0n4"
User-Agent: Evolution 3.56.2-2+b1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-2BHSEvwaaqnP3B5XN0n4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2025-09-07 at 21:57 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
>=20
> commit 90fb7db49c6dbac961c6b8ebfd741141ffbc8545 upstream.
>=20
> Fix a possible heap overflow in e1000_set_eeprom function by adding
> input validation for the requested length of the change in the EEPROM.
[...]

I don't see this causing any problems, but the same check already
existed in this function's caller ethtool_set_eeprom() so I don't think
there was any vulnerability here.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-2BHSEvwaaqnP3B5XN0n4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmjAg3EACgkQ57/I7JWG
EQkapxAArsC3y87BgiSCVPLPyiqA9MDX0EcZzG+5OC+rEtybNGYhTOovldQKryM2
bvSGoLUXPVSNsWJ0+IyAZyJBDDs7DEBC3DzN4XMm/1u99caLDp48j5fcpxeZ/JB6
ynVvwn4hLCbFTLlRy3hHEJKdYjsI3Kmt0BVfF3uT3wXUCxaKXVMNU1AYOtehqzCz
UyeKxGaWzQYjzkZPTdGZiGJkusfHyQcblouwMO2i1E7blXypz74WE+6088MPLkmT
JoIPaNnCR7DMefBNRB3FkQg9ZKmZ6VY0UI9AI/vwTfAnyAG98BJyErOf0b51977m
7Nnu1LBVqNjWN98CMlCQL+RH9aXUmgdTbbgbZlwRnPucFODwWt5jQJ1AxsHsxBiC
kSyM1J8ge9uaNR5oxoy2s990iJQUqdCaihs7SqG5777W+ELmHU4sFMiw16T7lkxe
tm6Wi41/kk5vJP7q67SPHaUrLE7cA6cfr6/uIPp1tUFCCdGLmKNG9gLu7IL9QKb6
5mHtRnXmpA51k682gQqEn1xlmnssCSj94KLdGQG2wC2lgA+uPTJsjt7jXUCBz5S/
QJYITlWO6SPzGe2H39ndgJmXueVilPYgDaKr1eDVFea3xfAL4p/Khhf+tM6ww8Uo
rHDVf/JBfdtPAXTgBmpppKk6bOxsvXg31grkrIocEzOgeE0suOo=
=I/be
-----END PGP SIGNATURE-----

--=-2BHSEvwaaqnP3B5XN0n4--
