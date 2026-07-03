Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929762C9D;
	Fri,  3 Jul 2026 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783113375; cv=none; b=rWGxSatmFPQivS7upNwiMXCVCk/VUcuDJsoSkUhhL9GKnqFuD+DKMaNcO7HLwIBpPDu7yWHGWHBIZBmOFHaDtjgeA5szej1VH0jvGro6VsHtmPO/sWFnDZ8EinJW3Q5lamlajbA2iXMGB5ribrS4IezVu8ZjcXdpUwcqILDMtVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783113375; c=relaxed/simple;
	bh=V6xaUuco4Hh9fpSCgAGLGPUfOLMdlzTPR/r/+FDcWJA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qwqGkVhAhUpPkymbWKuWHgM9tY/xCOVnikKh0Xv2s/BWpoAmYQF6WtgIxrpMzS61IxndYIsh71Pp25TFBi6HKiRJwdMsHueW8DBB0q7akMBjptbaxAUdCjJnL6BUeu8VFwnCGiNDnDd5ko6Sr2rlyMsS2d1O971Co9z6/PTBMbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wflF6-0001Ox-09;
	Fri, 03 Jul 2026 21:16:11 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wflF3-0000000BrSs-2y1n;
	Fri, 03 Jul 2026 23:16:09 +0200
Message-ID: <6359da4c14e0b4c6ffa068407a42c07e56ef9c5c.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 11/96] slimbus: qcom-ngd-ctrl: Register callbacks
 after creating the ngd
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, 
 Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>, Srinivas Kandagatla
 <srini@kernel.org>, Sasha Levin	 <sashal@kernel.org>
Date: Fri, 03 Jul 2026 23:16:03 +0200
In-Reply-To: <20260702155109.217063292@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
	 <20260702155109.217063292@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oDhnDsjeUF0d1srP2zHQ"
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


--=-oDhnDsjeUF0d1srP2zHQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-07-02 at 18:19 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
>=20
> [ Upstream commit 2a9d50e9ea406e0c8735938484adc20515ef1b47 ]
[...]

No objections, but this is missing from 5.15, 6.1, and 6.6.

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-oDhnDsjeUF0d1srP2zHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmpIJpQACgkQ57/I7JWG
EQlcLxAAxgAXYvkTSD0DOG/EhEEBsU/tYe4+hKgBlj4hL28QC3DzZFAKnOXCYEsT
9OAkxzK0QY5/WYWwL1jyFJGBKlN6JeyvvHb+EflaLvA/ueLhypJx1mxbeNfXfTZA
g2po4u+MH5uF64VFxa8lijCOI0D20L1fyBgx6d/UBXC5XuGf3iCq/sesZZfzOyzZ
2Mc4PYdNGWg257+raX2eI39sgk2xca2oZcSdZVOkXTfJkqWnNeqjJ8T3ZRMoU6lM
Ls4nermXvkdEbG3GVxm2huyagSCfHG4yKoZCJS3DKA5SqSaRgN0xWnNarYGIRwC2
RZbFlYLX+58xWBcBWFh6oJQvl7Kn6l8TkDn3VmN0rkQldP1v5SwYF5LhSAnlL88j
qQ2I3GzHb4xRyyzoF8DKfJfN2HcZYuJlFyTH4yfwl/DVeoBB1oik+1DAHn60px2L
/u06td6dN4ERDZn7hxx6rSqYnoGZA9bRZ+FX4UkQzy2XAZiQe/R+dDpDQfFNUr9S
pp3Pmtc9AsJFg6CFL+X19PbaJa8UYF2pA9f/vKgxX4yg1CKQzqUhH3H9+MOEwmJg
UwGiOA2DqR3zotPHUZgqLdxIo2vEVHowL5d3C78etf+gwjOgwHt/T84+akTy0fP7
Df38dnrV8KhXvBfpoCYFBO6tHsoM+fLfcXJNqIDoBEEFh+1lCjE=
=uReK
-----END PGP SIGNATURE-----

--=-oDhnDsjeUF0d1srP2zHQ--
