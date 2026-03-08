Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A019CC28;
	Sun,  8 Mar 2026 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772965579; cv=none; b=tgQbxWtpmD6GtGxlkpqr7uV5KXd9Thky84bH4TG1AeTWyx80sq6kXwomk4kdLWGeL5Y/I20anXdD4Ht0v8S/4EMfX8CKXI37NM/0Q5BDVIIGadwYSESWfYZWU1yukV3SIQYtywKEWHDwwG9IgjbuQe5rZbaLEhJf/I+uXb+Jvyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772965579; c=relaxed/simple;
	bh=b3rzRo0DwMxUrQcfu+O99IUprRq8kIZLzUeZ/gqPrJg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OMyq+RVP49f2p65NTgmTocCvTpVdCMMfocppIC3jpDttC1s96Gp/DHgqqFnN4C1cUxHgFWHZwZI8s+GUe+H4EH51AovNSEECXPCbu1l+KmavLW3pWH5Py5QBwbMUNIjxs3YJrsuZ1QCw4xFNN12op8kyvPA3AsKPb3GfPpmyFiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vzBKp-004Y9Y-0W;
	Sun, 08 Mar 2026 10:26:07 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vzBKn-00000009J45-3iE0;
	Sun, 08 Mar 2026 11:26:05 +0100
Message-ID: <552119600ffc7b417c55c18d7fd8c236e0bb1626.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, 	shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, 	pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, 	sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, 	broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
Date: Sun, 08 Mar 2026 11:26:00 +0100
In-Reply-To: <aawmN6mkFZnv0Nd3@laps>
References: <20260302161007.2523181-1-sashal@kernel.org>
	 <992df439ca66e562353d285642c6ab8e1c69e2e6.camel@decadent.org.uk>
	 <aawmN6mkFZnv0Nd3@laps>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EcYjnyE4x1wAkZhwTAIf"
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


--=-EcYjnyE4x1wAkZhwTAIf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-03-07 at 08:20 -0500, Sasha Levin wrote:
> On Fri, Mar 06, 2026 at 08:19:01PM +0100, Ben Hutchings wrote:
> > On Mon, 2026-03-02 at 11:10 -0500, Sasha Levin wrote:
> > > This is the start of the stable review cycle for the 5.10.252 release=
.
> > > There are 334 patches in this series, all will be posted as a respons=
e
> > > to this one.
> >=20
> > And yet they were not.
>=20
> I don't think we ever did post the series for -rc2+, did we?
[...]

The patches for rc1 also weren't sent, or at least none of them reached
the stable list.  And rc2 normally only adds or removes a small number
of patches identified in the review of rc1, but this rc2 added nearly
200 for no clear reason.

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.

--=-EcYjnyE4x1wAkZhwTAIf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmtTrgACgkQ57/I7JWG
EQliUA//aJvKYHuzzwWsUaI2F5+vpT9HIbb2ZuQiUbjDnhBeauKbdG+W0yAgLSbs
aTJ8Vt4S2zYjrqS9PFBOzTiRUeZksJh7rUUKeAUjIVODIPVaiuffQC8UnhF6fL2G
pHRm76+jvDm1udi80F5DKQjtCtUlZNsR3uOH52E3IavwpeyeatiHDlUyQUFYvh4p
nFDTbs/7LgBLUkXBztTKQPT/7qV8G3BLvH8cS1ky3MLW4l4ucIr1q4DWJo89kUOB
cxaEkk1Ewm02SCV1sa4WL/aVDglKXYVtjVPXixO7VMWy7Edk0PQTGqMFqMDIiyYd
xVZrveTprrgvSnugbmUl0tpgGOjMKcuDXAD6uJxMquk43ZwRcwWoq6eMWcbn+cWS
jHlZHwyoV8lp+x8bKvf1Memf3SQBVkzZJSol9aMr7P7y6RBDqjSxLXyptR2dMUOD
b9bozFHAvW1sEA+MfiKSN7ZlWV0Rc9K9UIvZaTW6Xntebyv+FoErFKsBX1+KSmhh
r2COQQAIMXbLOIc993ujiKtoBs8A65bs2Fy28PGv+3dc1GvC6129RTT0Bc7JV/e/
0tSNiF6CegldwsgSdnfG1ZWs+ZNrOs8TXkHb/DQn+wJf0cZAemi9ZM1Z0XPXr9y+
hnN1hFjT18nkrbGqciykpRUbI42Z8nqzoMZAg/WiXgM/mrPtSVE=
=xHR8
-----END PGP SIGNATURE-----

--=-EcYjnyE4x1wAkZhwTAIf--
