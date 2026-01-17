Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8219CCEF;
	Sat, 17 Jan 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768663617; cv=none; b=tufUccSzTbdpEc7+9loyI8B8NMuWNIpialq2LWVMcprI7vRNDmCYNfioBg5zv8dtR9EkqF8bAbGgRXWQGxtlhnb1F/t1sTRjCbnKvtmqXJFQ6J2YRAQHD2f21fzzkzO3lAGlyP0ofXmRx2IqUhNMqBAK3UWwGo5KLLhopb0Z4Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768663617; c=relaxed/simple;
	bh=LhQnd9Tg4asR/yD71LS6h4OLY+t9PE2kQHDEZp9Fsts=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h4pncNeeD5AjpOpT6GSEjr8NURJJi1rbgyW2axTD/99uUY0Rl7Kv5+PALXx1JILzHJtId+BmDwbJtnSMsR7LYZpJOAocLzE9+DQMQdNKsdc8NGJIaQUBYG7AzrduXUDxrQciW/+FjGEJph+yGIV1/JTZun3RGXOYCpJmhOyt/F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8CU-000zvC-2y;
	Sat, 17 Jan 2026 15:26:53 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8CS-00000000geT-3i0u;
	Sat, 17 Jan 2026 16:26:52 +0100
Message-ID: <7b3853e84ff120b3d1a3cdb59e0269dfffff9648.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 114/451] mtd: lpddr_cmds: fix signed shifts in
 lpddr_cmds
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivan Stepchenko <sid@itb.spb.ru>
Cc: patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Date: Sat, 17 Jan 2026 16:26:48 +0100
In-Reply-To: <20260115164235.045669696@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164235.045669696@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IWDt+Fu2LZytzBkQwZLB"
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


--=-IWDt+Fu2LZytzBkQwZLB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ivan Stepchenko <sid@itb.spb.ru>
>=20
> [ Upstream commit c909fec69f84b39e63876c69b9df2c178c6b76ba ]
>=20
> There are several places where a value of type 'int' is shifted by
> lpddr->chipshift. lpddr->chipshift is derived from QINFO geometry and
> might reach 31 when QINFO reports a 2 GiB size - the maximum supported by
> LPDDR(1) compliant chips. This may cause unexpected sign-extensions when
> casting the integer value to the type of 'unsigned long'.
>=20
> Use '1UL << lpddr->chipshift' and cast 'j' to unsigned long before
> shifting so the computation is performed at the destination width.
[...]

In lpddr_point() and lpddr_unpoint(), chipnum is also shifted left by
lpddr->chipshift.  Don't those expressions also need to be changed?

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-IWDt+Fu2LZytzBkQwZLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlrqjgACgkQ57/I7JWG
EQloyBAAlk8FQlj3KhmnHyDszquOFniWSPcNj/zjwFrRlyZFDNpGFIFuN5qgvfoH
PSNoLzIl/YYd+j3NdREea/+jZCbqX06WaIOkdlY+4XhIjUjQJJ0bYC17yoNK49DQ
PeVEEbM8GpqI/2+3wUJ9OeFUpvpJpm4vlc/MgIZk7i/uBxWypdTb8HOuWKcGnS4Z
AZ9QMvl+rkzhFMRGgUimOvpX5GzAxQDLDMTE2E7pPM3AfdNm+5SjNHXN2/hAWdzy
Wa6LyAPkUsEIR1al009KLITfnrkcfhaIkulWUnwwHDkKIovsaBX6AT9GH7TnUOT/
y7x9qpGu8/juyj2C7ZnHpVBZOKr5iOpcmTctLcZRYIddZpuX/fXaLAEIhVHElJZ+
VyhyYtiNBzaAT8rArTvQ5nqa5BzQC9s1c3ox3hxAeFK6CKwJp7D2KQzLBn+KNADL
aYOUUQOYj/o9F9mJvShnFin18ANdUNwdz/8+4V3FWjgzxQyd8x5iuBi/SFI8+2hn
WYz+pToK9LlLSGmQsJSzqsaa5KLQQA1XqROIb78qi1GymfccLL/hD4Ekkzx7A2Th
uz/njLQD+5X7+77GdEQDY0k7kAUteUqAZpk8G////lvt2cDdx5ewh3sCZa1hVbjO
t9z/NecntPxjcPSkPjPDicQ1HTMHauMcZ+dE7/qPr9Xh6wbHkvc=
=XinA
-----END PGP SIGNATURE-----

--=-IWDt+Fu2LZytzBkQwZLB--
