Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5DB34D90E;
	Tue, 21 Oct 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071985; cv=none; b=ippX5d42x2ULOtArS7XduM2xv6yhe8UZsR2nVSPmN7Szrm1nqX0exEfogONq40BPwxrK5Ohrny8VUZrMO/a1shlM8LA8u3ZD3oZHU8C9xNui+x0dC6I/tlJU6cEvPTBNXWNKIBu0Ct01LOxpoJnM+hU3OyHhppS6gzS/RjnEcQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071985; c=relaxed/simple;
	bh=tLuIYVR/oNVncCUmdWuUFkdC1hMwOk7CK2U+1G+bMKc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n7sLkmR+SG2sizQ1O2lWUGiwJ6cY02odcIv+e2dZTBSoTZ3KghLgbdmnKTE+SFj3NLd2JJK9cvb6Qp8lV8tAJH12bMG+kJ8u7IhX4JqjUsMleEraRfDMvdOdwiWVmp3pH6gt7/aDON/C9JTLTh6MWC/nR7QVJygtLvwE7IoS3CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vBGh2-000o0t-28;
	Tue, 21 Oct 2025 18:02:44 +0000
Received: from ben by deadeye with local (Exim 4.98.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1vBGh0-00000003O7g-2tKl;
	Tue, 21 Oct 2025 20:02:42 +0200
Message-ID: <92fe5b00bb5a4298d1a48c4c220e15a761e22a45.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 013/122] compiler.h: drop fallback overflow checkers
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Nick Desaulniers <ndesaulniers@google.com>, Kees Cook
 <keescook@chromium.org>, Nathan Chancellor <nathan@kernel.org>,  Linus
 Torvalds <torvalds@linux-foundation.org>, Eliav Farber <farbere@amazon.com>
Date: Tue, 21 Oct 2025 20:02:36 +0200
In-Reply-To: <20250930143823.531610305@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
	 <20250930143823.531610305@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yr5KOxO6GopMo2Ugrb04"
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-yr5KOxO6GopMo2Ugrb04
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-09-30 at 16:45 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Nick Desaulniers <ndesaulniers@google.com>
>=20
> [ Upstream commit 4eb6bd55cfb22ffc20652732340c4962f3ac9a91 ]
>=20
> Once upgrading the minimum supported version of GCC to 5.1, we can drop
> the fallback code for !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.
[...]

Well, that only happened in 5.15.  So either 5.10 should also have:

commit 76ae847497bc5207c479de5e2ac487270008b19b
Author: Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri Sep 10 16:40:38 2021 -0700
=20
    Documentation: raise minimum supported version of GCC to 5.1

or this should be reverted.  (I don't care about such ancient versions,
but I do want this to be a clear decision and not an accidental change.)

Ben.

--=20
Ben Hutchings
Editing code like this is akin to sticking plasters on the bleeding
stump of a severed limb. - me, 29 June 1999

--=-yr5KOxO6GopMo2Ugrb04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmj3yrwACgkQ57/I7JWG
EQnrJw/+JXGbvD0wZL+b39EptdFuaX+WhrRMa78BVSz65N/Fuca2g+kzCnGlR2/r
4IvEIMwMRfwx0ENFTmdD7xBSiZ+fjxILE64iYLBADXhYN76k4vh16ATpy4hHqvoa
LEU4pzqsG+MC6Lzwz2rS+wWZzjIWoMPsFqVZkPRxMWvGemywcAQcio92aLSeuIIM
+heeX9SUBw5DM9rHJ3NhGt+wFQUYgJmTXUTz1c0eSUL34wdqDQgqgf+RJsKRwG98
fJaLLFrhcFGrdxD9vgxBMhQOSsPvAxCt6OhoWwkD655fflyI06t0Dks894GuN0jb
y5x9BTAybTcO1WOpvitzpYSVxMxeV1wpp8OUQOxnajyIwYOQs0cwytvFYC3txUOU
SG1th5569pWoWzCdFtbC0WIcVVCJW9sJ2f2nTRZWXttExD7W5GXEdxrB/XKpcdZx
nMEWweo5j4bufToaCIqrORhgZj6cefn/ZoOHMaBpvirNUo9453A5QHRoMCaJierf
QqS19EssCq7L448caJow5zB6thUkhnumQuJNh4DpwAYFr4IneXwVLy3tQvCTMiaa
adScr5NXVPV0h96GcO9rl1BxJoG82JiMjGmxK3l/g7DiNx1Dw61JHv4hQEOqvlcQ
YyI4GLN48Kep8dGPmW96OQbnd2++5TqylmGIRXSkaujr5bpgupo=
=JCeg
-----END PGP SIGNATURE-----

--=-yr5KOxO6GopMo2Ugrb04--
