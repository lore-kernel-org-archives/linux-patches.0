Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313AF3921EB;
	Thu,  5 Feb 2026 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770300588; cv=none; b=qkhBQas1NJJZeS/rta+b39VtRqU3XBweka7E0VBupstUM793pNtXXjjSPmlmUJ1OqXyUa4Sv6Vmm7IcNMaTqiQUz+aKhrb0qIeJOrBWnR20AR0X6MJq4fp25a7HzOqa0xqh1iAJlPRb8lUtg0U5l3G39kmaASS25i0CPpY95rd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770300588; c=relaxed/simple;
	bh=CJrBrXEWDBjn3BNARERX7EAaLp98ZACll3ncO8sR6pk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MHRNtxmnh5Rg1uA1AIL7YULNpuzr63wGii4wRpbKCHrNNDcAgaFfRGI4KSr6x0GLNBFurc9zCG+zMPLBCMAE3vMEpnIv3HFRjNW7Q39jAtBWm/AWxNx1fVUSHacCX3LrQOHnEoWQe7rZLseAf79/yzeFnlGh2d+xRQX3V8Xx+cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo03G-003u2t-00;
	Thu, 05 Feb 2026 14:09:45 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo03E-00000001efO-0VoL;
	Thu, 05 Feb 2026 15:09:44 +0100
Message-ID: <5cee4d2e571b3132a95cca6f6230c769b8618836.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 022/161] phy: rockchip: inno-usb2: fix
 communication disruption in gadget mode
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 =?ISO-8859-1?Q?Th=E9o?= Lebrun
	 <theo.lebrun@bootlin.com>, Vinod Koul <vkoul@kernel.org>
Date: Thu, 05 Feb 2026 15:09:39 +0100
In-Reply-To: <20260204143852.563376077@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143852.563376077@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MtUg/Q64zhTFrT8RX1G/"
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


--=-MtUg/Q64zhTFrT8RX1G/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Luca Ceresoli <luca.ceresoli@bootlin.com>
>=20
> commit 7d8f725b79e35fa47e42c88716aad8711e1168d8 upstream.
[...]

This one and the next one (phy-rockchip-inno-usb2-fix-communication-
disruption-in-gadget-mode.patch and phy-rockchip-inno-usb2-fix-
disconnection-in-gadget-mode.patch) have been swapped from their
original order in mainline.  Please swap them back to avoid a potential
build failure during bisection.

Ben.

--=20
Ben Hutchings
Horngren's Observation:
              Among economists, the real world is often a special case.

--=-MtUg/Q64zhTFrT8RX1G/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmEpKMACgkQ57/I7JWG
EQnrDhAAyfv44b9vw6v4re4fIDGj0lJ9dT65iix3J0y6pIdJLxBZ7QcwgzQHQm38
O3K6vmSlS15AYDTa6DEfN5jiP/p4niGJJxvE4N0WNp+oAK6cR5scsclqGd62X48z
s0HBFr2Gl5n2MlY2Z6blcy7Y0jmznD4sQmkOVzfbVL2KK7ROKyQHZBpmVR9freCw
PBiNi9x64O8h9xzaFsgq5kjo12WKUJsnfEknujkghaa9OUtNyB2YXkzGli/JIDYy
D/c1x2zG6qWH/I4HHk+toDcb2TXEQZka39N+lxBKjvkWJfvw+ZAeqfVpY16dBOL/
rIJt8O+hfe498i8ovpoupljTJHYb5vgV9YhOGj7cghYdgwyQVwwDpVAXHdb+LKnR
rp8n/UiUj8aOEOHqNjQeL6ZfM/aR4J+LgMrrBNt47lMOasgGpquplQp1b+KwDgxQ
6wj6qL5jsd8SZDt7uUYrGRkj5vxzaPQB8ra7RPwFvA6wa83yzJ4E95BiYTrpBinc
9QH1RqHyOKBZAwY4FwpbU67iRpbAFCdb/24By4BqB5k1aVihMvX03IHHNH8TpDUq
2a0rWtoNXZnNXRJY31np2PadjK4IyjOsxlLEsoQvxR8isSFFphdPr6Ke380YNMx3
WjfBObSF969jhCzWz27SXfkV/ZBDPBNJVXjyqJrPjfv1bMMjSew=
=qQXK
-----END PGP SIGNATURE-----

--=-MtUg/Q64zhTFrT8RX1G/--
