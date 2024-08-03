Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9733CF1;
	Sat,  3 Aug 2024 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722728825; cv=none; b=T/HNq+5kl3a9v/MX5HYVqW/WXtG7JTQKI7cmBaI5qvm5Q5MhmRYrHGCcHuhr7M1+6Jk7WBCP3XkdjFcIg/0JgM3FvvQDYegRNYgJ0P2rhsc521Rmv4a6mLUlnSg7aImppuv13wHzM5QN21XKho/xISt5T8HI7owkqIZTo4lKHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722728825; c=relaxed/simple;
	bh=R6K9nq15xBo+GehSNZFvLlClP1yu00WXnw4WNpoNQqg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PBMUQunPq85kBQ1oEJGbM62Z9ItQtiWYMt0JV5D+Km6Hf1RS9QRaCM+WoUrUXGR5cNzQB5kN0kxtTkYeJAZWJ3V3NvoUxG96E0jBfoGHuGH0LZmI79hz4P3/mr1wP7BUXWKYlUoLaayecCB080dGkuKRuCJlJw1DRW7y2p7jvOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1saOSb-001yal-1T;
	Sat, 03 Aug 2024 23:46:52 +0000
Received: from ben by deadeye with local (Exim 4.98)
	(envelope-from <ben@decadent.org.uk>)
	id 1saOSa-00000000fny-01DL;
	Sun, 04 Aug 2024 01:46:52 +0200
Message-ID: <d294468326cb036ca5f47697e28860530de12ce7.camel@decadent.org.uk>
Subject: Re: [PATCH 6.10 534/809] mm: huge_memory: use !CONFIG_64BIT to
 relax huge page alignment on 32 bit machines
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  cve@kernel.org
Cc: patches@lists.linux.dev, Yang Shi <yang@os.amperecomputing.com>, 
 Yves-Alexis Perez <corsac@debian.org>, David Hildenbrand
 <david@redhat.com>, Christoph Lameter <cl@linux.com>, Jiri Slaby
 <jirislaby@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Rik van Riel <riel@surriel.com>, Salvatore Bonaccorso <carnil@debian.org>,
 Suren Baghdasaryan <surenb@google.com>, Andrew Morton
 <akpm@linux-foundation.org>
Date: Sun, 04 Aug 2024 01:46:45 +0200
In-Reply-To: <20240730151745.829576651@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
	 <20240730151745.829576651@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sCaeamASO5v8UnH0+an/"
User-Agent: Evolution 3.52.3-1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-sCaeamASO5v8UnH0+an/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2024-07-30 at 17:46 +0200, Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Yang Shi <yang@os.amperecomputing.com>
>=20
> commit d9592025000b3cf26c742f3505da7b83aedc26d5 upstream.
>=20
> Yves-Alexis Perez reported commit 4ef9ad19e176 ("mm: huge_memory: don't
> force huge page alignment on 32 bit") didn't work for x86_32 [1].  It is
> because x86_32 uses CONFIG_X86_32 instead of CONFIG_32BIT.
>=20
> !CONFIG_64BIT should cover all 32 bit machines.
>=20
> [1] https://lore.kernel.org/linux-mm/CAHbLzkr1LwH3pcTgM+aGQ31ip2bKqiqEQ8=
=3DFQB+t2c3dhNKNHA@mail.gmail.com/
>=20
> Link: https://lkml.kernel.org/r/20240712155855.1130330-1-yang@os.ampereco=
mputing.com
> Fixes: 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on=
 32 bit")
[...]

The original breakage actually occurred in 5.18 with this commit:

commit 1854bc6e2420472676c5c90d3d6b15f6cd640e40
Author: William Kucharski <william.kucharski@oracle.com>
Date:   Sun Sep 22 08:43:15 2019 -0400
=20
    mm/readahead: Align file mappings for non-DAX

The previous fix referred to above (commit 4ef9ad19e176) was already
backported to 6.1 and 6.7, and CVE-2024-26621 was assigned to the bug.

This new fix also needs to be applied to 6.1.  *Both* fixes need to be
applied to 6.6 since the previous fix missed this branch.

I believe a new CVE ID also needs to be assigned to cover the
architectures missed in the previous fix.  So far as I can see, the
only architectures supporting huge pages on 32-bit CPUs (as of
6.11-rc1) are arc, arm, mips, and x86.  Of those only mips defines
CONFIG_32BIT in 32-bit configurations, and was covered by the previous
fix.  The other three are covered by the new fix.

To summarise:

CVE-2024-26621:
- covers 64-bit compat and mips32 native
- fixed by commit 4ef9ad19e176
- fix is needed in 6.6

CVE ID to be assigned:
- covers arc, arm, and x86_32 native
- fixed by commit d9592025000b
- fix is needed in 6.1 and 6.6

Ben.

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.


--=-sCaeamASO5v8UnH0+an/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmauwWYACgkQ57/I7JWG
EQljnRAAzFtIX6bgmndn1d8mbFbHN78xChiZ+eqk2Pf62Df421WIIz0gcx1bzhct
C2p+G5ILWPI8o4VAlvekOVtoUWL8roRkR86CprpPT919ScHc3t40D3xEOBuViyX1
6SmtO9qTYH7H1aDFpmuE9zIakBVgJNiCMk9Ei7ueGhIa0C7HUItUqH1QsUEjFdpy
CXlvJvuracj/vcH56t/TLCp9iqD7WPJ7mdRHrtoURdNZE0GUO5U1ZG4L2Vwdxo2D
U2Z5VevSNkjUr6gQ6L8ttbMnEfDCfYGLmt89sTXaEhWQdq/Zsxy1JNqhig1EdSkO
S69oMKLl9LyhuS0hCy1wl2XiMrYya5ZbUKWNkczJm1CEzVJ4QZ5KM+Cv57YnP/C+
7n0YRmVrbX/h5Z6TflIT6eKZXXZAOGEtOlf0d1k3NFlHL8wbFIZGzazsJFkvURgt
8uxhkBgtcbSTC2Z1jih8M8K7QjUje33Qf5GU2h3Fw68TZsWrV3FsixtBb1ESyw7l
olxl8FDhmr+nmEKMrCPmIVI12W81yz/a41z6m9NBNYOIGTwuNgzu+LQU0Gd7aYe/
CIElANTMr8oVFwHTVlVICv4OMP2qTc/AU0gkGZZV34eNDgXexD7v5MQJisUd1kWZ
RClN0xGmPvqW2d3ffvlWjglz7FuCC86ZnWa+pKLopN2QVaCHw4g=
=xAw8
-----END PGP SIGNATURE-----

--=-sCaeamASO5v8UnH0+an/--
