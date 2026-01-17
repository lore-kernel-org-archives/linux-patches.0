Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C041367;
	Sat, 17 Jan 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768655609; cv=none; b=d3Z+janrV+HZZcAzF8EOUlDdSbaTSI0krtoODMlvqJaA/b8ErnvW0+Uy0UKdLjpI1FIOQvCEka/i4j5TwZblBVsKvfB+0IedNI6VMXhy+ls5mdWHJnO2U2sssbVebHdzth1aOrbxQFUWNkgOwPLphuFe4N2zN2XEzZgOwn29LsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768655609; c=relaxed/simple;
	bh=3Df7sBeLGGJv2j+eIiVdFywCJ+56ZRZTAamg0iFIUwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YEdSEn5QMoqrG8VLlk8a7pxiNVHyrrA4AtyMu1qTStftgtK2JFzyRuQTbBT16QdouuQr2cPPOmizADVI3ZAIxVYfBlq9/pK6LW9Qkc4yuapkzfcCqMOIJ/jWTRy3mxm4MG2HV5smAOgWz/J3G3hxMqfGkrqJtPDXC+DP6NA2hyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh67K-000ylg-35;
	Sat, 17 Jan 2026 13:13:25 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh67I-00000000fIm-2zJY;
	Sat, 17 Jan 2026 14:13:24 +0100
Message-ID: <17ac573f3d57068d84078b5d0f0875f9a4f1f2f0.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 069/451] clk: renesas: r9a06g032: Export function
 to set dmamux
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>, 
 Stephen Boyd <sboyd@kernel.org>, Geert Uytterhoeven
 <geert+renesas@glider.be>, Vinod Koul <vkoul@kernel.org>,  Sasha Levin
 <sashal@kernel.org>
Date: Sat, 17 Jan 2026 14:13:19 +0100
In-Reply-To: <20260115164233.397731345@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164233.397731345@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+96RJdAlHmsklIHsqfmT"
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


--=-+96RJdAlHmsklIHsqfmT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:44 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Miquel Raynal <miquel.raynal@bootlin.com>
>=20
> [ Upstream commit 885525c1e7e27ea6207d648a8db20dfbbd9e4238 ]
>=20
> The dmamux register is located within the system controller.
>=20
> Without syscon, we need an extra helper in order to give write access to
> this register to a dmamux driver.
>=20
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Acked-by: Stephen Boyd <sboyd@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20220427095653.91804-5-miquel.raynal@boot=
lin.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Stable-dep-of: f8def051bbcf ("clk: renesas: r9a06g032: Fix memory leak in=
 error path")
[...]

Similarly, commit f8def051bbcf is a real fix but doesn't actually depend
on these supposed dependencies.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-+96RJdAlHmsklIHsqfmT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlriu8ACgkQ57/I7JWG
EQlWXw/7Bjz31tYHsgEdq9A2dF2qKemmtxTFrWKrPqvK8IYslVMy3yKKJge8K7Qs
qbA6LF7CUfGRDMW6VkgLhvYTF3SYqpA4zMktRIJtY7yyf4chSVA8d+f9LrHPbMfY
gVKPulAEp/5LKqugyFFUtMCUaLrbZo4dvPR6TieFZOGtwky0hJ2YlbslYdF1TSBp
GkA27wIK8CN+1O75+2MYVeOKH7yXZfuAaUk9rGDsc6iwp4wwIwMkECGyEWSSKWSq
JrTTg53vBeSRhBpqbcQkyGeSPdseFCC4VL0pMPI6Ax770Pafa3G7FoT4gWjQ6pa2
EQiPGBUI3vl5+bRSPd3nRGhrBsg/0MKgWJZ6vUh6qKcoPaiXXwAzYJydi2Eg5y5K
W4vRINMZyJjishwsWhzpTHP+Os66CQGSxuqGHrAuzRldLZK9v0UpZm+9FBVHEx7s
CRIR4MhEUoPFcyPHoprjxLaiiDflxxgAj327tEDyqzvxpsM+R3rwG0cUXppTWAi6
u8b2Rt27kIiYgIHgrAz7YIYWnM+uF5BNg2N4mKTi3Cu5vR6J4n1NCtXDJ7uWNm3Z
pON0Es3MzV3QiJ+6WyFUCSYF1DUFmBwhRn2NlouEDK0M0XELiwReWlT33qDfJn4T
aqh7BObDx6qIExx5ajQtOLmPiEFuZtGV20uKItWW+g1nlwpb7ic=
=y72A
-----END PGP SIGNATURE-----

--=-+96RJdAlHmsklIHsqfmT--
