Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A33B774C;
	Tue, 17 Mar 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755619; cv=none; b=NM8l6G6FkdEUyEF/K4nl4318SbZ3FBiP+O6u9rp7FC38/EFi4f08KXKXcU+9nDLLOrKWnITOmc5VisZsfpnON2tiQt+v4Bg4bKEQpUKqB5+G+jXLdmSEcLHgQv4yx2ZvwLMZ4MZg5lVy4rgDA+RC1/y4f0Jq4kr/Y8wAqfJwe1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755619; c=relaxed/simple;
	bh=jOnqU2pxeS1YuTq37zznl574bvgZiKbsUlEk6l+BmQQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iYqnE95tRXcCd3pZ5JN2NFh5zQXNwB/fNapKp0ZwqOal/10FoilooByXjk+mJ8yt8c188BNUSsw4N6m6V13P7aqsLQUu7xz+qMe5ZZa41//FUfYZJ1Clq4ukM53+1gUcDULEpU/X23ll5AvbTF4Q2uuX/B+5g1nIPq3/Ilr4m8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1w2UF3-000YSW-29;
	Tue, 17 Mar 2026 13:13:48 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1w2UF1-00000000tBy-11Cj;
	Tue, 17 Mar 2026 14:13:47 +0100
Message-ID: <f7285cc36ec39c4a6cef633add170518f2e34b3a.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 005/147] i3c: remove i2c board info from
 i2c_dev_desc
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev
Cc: Jamie Iles <quic_jiles@quicinc.com>, Alexandre Belloni
	 <alexandre.belloni@bootlin.com>, stable <stable@vger.kernel.org>
Date: Tue, 17 Mar 2026 14:13:42 +0100
In-Reply-To: <20260228181736.1605592-5-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
	 <20260228181736.1605592-5-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gnA3NBkeQBiX2stB0NEf"
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


--=-gnA3NBkeQBiX2stB0NEf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-02-28 at 13:15 -0500, Sasha Levin wrote:
> From: Jamie Iles <quic_jiles@quicinc.com>
>=20
> [ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]
>=20
> I2C board info is only required during adapter setup so there is no
> requirement to keeping a pointer to it once running.  To support dynamic
> device addition we can't rely on board info - user-space creation
> through sysfs won't have a boardinfo.
[...]

This was broken and needs commit 6cbf8b38dfe3 "i3c: fix uninitialized
variable use in i2c setup" as a follow-up.

Ben.


--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.

--=-gnA3NBkeQBiX2stB0NEf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmm5U4YACgkQ57/I7JWG
EQkSRw//U4sQc9VYDDtfrS1DgkSqANo5M2DSrtpG20cRiAyfbz13tx4uZSeC3Llw
/xK3ZRW1oIhbkEkqSNrA1MJpYUIiRklIRXToLrf/9lmvK/yKdiHIFmdUt7XM24qx
Z08gc7hZO/uI0rUxeiya5sItaOV+GJDB9068oGSmCAt+7aNZndK2lRowTdPDPFdF
6teA1PVB4rD5Vv7w1LsDxHhW0hBAb68LZP3cYC06b053tlMgpyn4mpfuiwMyxRuO
Zl3xAmpd+KldlSZTWfY0ULi1vynCOpOAXVkoO6OLI33hJFH1Dn3enBS9bst+NZ+G
r6tJrBwlb66YfNPg61rUNeW55Iz/EptWwOiAGO0+ayGBXnsk4n0Hx12SbpSrBDzK
OlyMx/AHmsAriMSPo6A7f0KqaUHjPYUon0d8yBUH/5bn1nuMeZD6Mr2kS2rutFSl
Z3k8Yg1957d5Oiul2hUp9y9XlcljvPAw4CUDewKAhy7vkwcwuZNe88aDzEPJW+pn
Nv8SiTVM7/zDubJOzaHlqX9nYwfbhnR5gv5fstdRDNuIojBSut5JqACg0XDGHkZc
CUaAi2zih9u05B1r7S4MWhtSRKLftVJRFRC6y2ys18/oBs+fE7WlFXSjYDDVUQyu
21w0ECfTWNMOm09JUljmazNWfm5/AG3qBAvjC0e6LQglZzafebs=
=jmul
-----END PGP SIGNATURE-----

--=-gnA3NBkeQBiX2stB0NEf--
