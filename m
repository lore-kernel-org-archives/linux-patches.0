Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7134CEB
	for <patches@lists.linux.dev>; Tue, 16 May 2023 11:39:53 +0000 (UTC)
Date: Tue, 16 May 2023 13:29:42 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 6.3 224/246] parisc: Fix encoding of swp_entry due to
 added SWP_EXCLUSIVE flag
Message-ID: <1684236494@msgid.manchmal.in-ulm.de>
References: <20230515161722.610123835@linuxfoundation.org>
 <20230515161729.309596490@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="P15Zl2i1L+IUdXCm"
Content-Disposition: inline
In-Reply-To: <20230515161729.309596490@linuxfoundation.org>


--P15Zl2i1L+IUdXCm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg Kroah-Hartman wrote...

> commit 6f9e98849edaa8aefc4030ff3500e41556e83ff7 upstream.
>=20
> Fix the __swp_offset() and __swp_entry() macros due to commit 6d239fc78c0b
> ("parisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE") which introduced the
> SWP_EXCLUSIVE flag by reusing the _PAGE_ACCESSED flag.

Sucessfully re-tested for 6.3.3-rc1.

For the better-safe-than-sorry department,

    Christoph


--P15Zl2i1L+IUdXCm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAmRjaSMACgkQxCxY61kU
kv213BAA0vcpmLNjIBEXOXZlhsDTRuEaofITrERmG5ypLQ2fClisx5uicJ1ePm/T
DO8L2sMNw7SCABNjme6VnCoaLFdmozxtpDxmgKAOI//75glNlrSuzRwp0z0RNWde
DWoGC/6MQkZOIlk704LGnTRPVK+UCxbV+R0zxZpWKiwyelBd3kmOBAkasyJFC2Dw
/cuQnD0LnCQKNDXY0oqHPCpOAWO36HNOzfwMhZToHWmE7iLpfQKjOhDvYJuV6lIr
5GRSKD5D2WKrAgIpFJY6byjI5xkNANK72lLHhoyMV6wX6dsd4vNAt9lUhHq0xftO
7XkIBy4Xrf8BLF50f8hWuqQ68Oz6VaSnfXmo09dDy9vjQ3jybMtjmLmEMz0R5N8G
TpaEVjPyEIFIauferuy5TnMrlcg6EupOyIKBPAhuK3X6GTw1/Y4M34oICnNfs2QQ
zZ5qTUhae2HEVDcDvGN4FESqywByhUI8y+9WPcvg6nuBccuwU154ClpNGuJ8D9Oj
DGj5V3G7DzWV3u/CU+zN6GGoINzVNc6PnGqKzJVyWXWpmtYxlSZRweOXPg5WeaRD
gFxA4KtqLiSgjaoJuVGbfqS7DXT8jKH2DbulkKttzhk+Hh92adbFMqyh6SFjCd/w
xSawA7nRMevkQ+1WJzZI6qoq5RlGhXl0AMrkyArm6jSoHsKse/Y=
=go7u
-----END PGP SIGNATURE-----

--P15Zl2i1L+IUdXCm--
