Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F37631A551;
	Wed,  4 Feb 2026 19:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770232235; cv=none; b=W/fVeUYDKE/bK1H3JuWALUD/UJmDZ1AD2zTzBpLIdWx1rxTd5CVKLC58jDvUOg1xCWUs3REEF29O/kJowvBiTjOiw5Kuo6Xn4kJ5yoAFsk9ZsgKPzevROtlBOwY7zdY1i9kD+FSDVdY35OthihYM79FUPTjU1tpCezFaAJ0VnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770232235; c=relaxed/simple;
	bh=9u3TpbK8w1K/52y6osmChvPV8cT5NfL2XOGtxTZpVt8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nMk89aKOlx70YAS6VwNss1iGsyY9cblVEJSSqPWq7F2eMbETBVPARWOVjMf1YCGC7TMO3aXbi+OTbItZmhyuT32AYq9f3PshP40jgtFkhhEg/THNQAgviN0+zjbPS68/VyxxdwBCDy/pKmcVqMT7IH2OnTsG6bpeCEBUbKe92eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vnhcR-003mff-1y;
	Wed, 04 Feb 2026 18:28:50 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vnhcP-00000001Z6M-1D42;
	Wed, 04 Feb 2026 19:28:49 +0100
Message-ID: <03a74299797f4864d0e563cd9517276f690a4bf0.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 004/161] btrfs: send: check for inline extents in
 range_is_hole_in_parent()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>, Qu Wenruo	
 <wqu@suse.com>, David Sterba <dsterba@suse.com>, Sasha Levin
 <sashal@kernel.org>
Date: Wed, 04 Feb 2026 19:28:42 +0100
In-Reply-To: <20260204143851.919366239@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143851.919366239@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RFIWeTG+HjFqmv3KQ/AZ"
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


--=-RFIWeTG+HjFqmv3KQ/AZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-02-04 at 15:37 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Qu Wenruo <wqu@suse.com>
>=20
> [ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]
>=20
> Before accessing the disk_bytenr field of a file extent item we need
> to check if we are dealing with an inline extent.
> This is because for inline extents their data starts at the offset of
> the disk_bytenr field. So accessing the disk_bytenr
> means we are accessing inline data or in case the inline data is less
> than 8 bytes we can actually cause an invalid
> memory access if this inline extent item is the first item in the leaf
> or access metadata from other items.
>=20
> Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole write=
s for sparse files")
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/send.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index d86b4d13cae48..f144171ed6b7e 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5892,6 +5892,8 @@ static int range_is_hole_in_parent(struct send_ctx =
*sctx,
>  		extent_end =3D btrfs_file_extent_end(path);
>  		if (extent_end <=3D start)
>  			goto next;
> +		if (btrfs_file_extent_type(leaf, fi) =3D=3D BTRFS_FILE_EXTENT_INLINE)
> +			return 0;

This will leak path, unless (at least) commits 4c74a32ad323 "btrfs:
DEFINE_FREE for struct btrfs_path" and 4ca6f24a52c4 "btrfs: more trivial
BTRFS_PATH_AUTO_FREE conversions" are also backported.

That could be avoided by using { ret =3D 0; goto out; } here instead of
simply returning.

Ben.

>  		if (btrfs_file_extent_disk_bytenr(leaf, fi) =3D=3D 0) {
>  			search_start =3D extent_end;
>  			goto next;

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular.
                                                      - Adlai Stevenson

--=-RFIWeTG+HjFqmv3KQ/AZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmDj9oACgkQ57/I7JWG
EQncew/+Iyth7KNx3FDeNq+Afm9f/o3lbgKI62BFWgkB7KZ1s64q/PaJlUcP4dem
4k0so1SZJZhJJbvYP508hsJNaFdGwRiAHgvqk3KiryN/84b1tz5doqm95AS+mVig
u8hermHnGTrfzpGKXIvbmhMZnJqvg5occ5m6rsX0EXDbcas1WoatgiKlaRJWlwcO
yBDhb932v9aWoVobvXe/Bxh4ZQBaAd4IO10x2d2oEAiuijFw2qNpApCio6aQAhyE
7mPiZ8ov0+w5Ku7JXOWzQcq1tzC4d3LjV7LKwBcnPUGEaC+EvanlDZAQ8ZwDK/LZ
XoIbJ1s0f1xHhsP4DIG51hHfbxWAnqaQpLjeUjJdv6GjsGf9zVDwQTwQmQxV30Wq
4hhoK2vgtVhtLIRV2V7/JoZZAoMK5rfeQj6Eu8j0/Er1Wh7vwfwBNKrrpz7v4Ve8
PnqHCG2vkMKH+NMu4qQ9B7MwoS/2Sdf2p0AWUwl4Q2yg9Smkp/DJVDgeNv2z53ek
mhDwTYPDNDB2qGNIDsWAXBlOQ7JQ8aWVVEOGTRZIW3vyEyWRwEfracRZAaLP95VU
nMYpZzeuBjpwDVP4pm4pYJulE+4EXOPnIWc8cRUOG4TFH0H4DLZeHUqlyBFUiKFy
Xo0kCeMKGp47U9uNrr5GsTgVN5EGVpaNk+wMSkahJoj67GTVt6E=
=tjw6
-----END PGP SIGNATURE-----

--=-RFIWeTG+HjFqmv3KQ/AZ--
