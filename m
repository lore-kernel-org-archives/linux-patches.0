Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F8233721;
	Sun,  5 Jul 2026 20:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282518; cv=none; b=L10BG4+7aITbEaipsrXasNsLsdaMt/36myhO+Eb+fW89eiGU9We5FRwpK3DJ23IW82xVlByIOPMhGXIeMstRC77i4T4p3vmK30cqY6c8b5+ljsd/IQdQG+6rH1cmxfCZY2o5/LBmE7U8RUUd9OPdCLs/PCkiu2RbEmwpr9ELuyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282518; c=relaxed/simple;
	bh=7K3ufwKFVD4323zTFUVFgZ2GEeI1mMEXqrKhI2bpY/M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z53Di0cLmwCpC/Tpn1Gup6NM4fvi2PzfTglraXpeNAxB2jURVoBAilmdLYGWvwUQ4CMpYFT6M3/H85yTkbc34X+9q+GtEomAOHLJd4afzRvy4izZJFa7L49xU8EaMs8UGHcmbjIlhpe7W+YwTsNp0B7CuxXxRL/g7tYShsYouEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wgTF4-000Dx7-2h;
	Sun, 05 Jul 2026 20:15:06 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wgTF3-0000000CSIH-4AJd;
	Sun, 05 Jul 2026 22:15:05 +0200
Message-ID: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading
 princhashlen
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Dominik =?UTF-8?Q?Wo=C5=BAniak?=
	 <stalion@gmail.com>, Jeff Layton <jlayton@kernel.org>, Chuck Lever
	 <chuck.lever@oracle.com>
Date: Sun, 05 Jul 2026 22:15:00 +0200
In-Reply-To: <20260702155110.683851454@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
	 <20260702155110.683851454@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SbwbxIMGqu+NRlRe6o3a"
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


--=-SbwbxIMGqu+NRlRe6o3a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-07-02 at 18:20 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Dominik Wo=C5=BAniak <stalion@gmail.com>
>=20
> commit e186fa1c057f5eccb22afb1e83e34c0627085868 upstream.
>=20
> In __cld_pipe_inprogress_downcall(), the get_user() that reads
> princhashlen from the userspace cld_msg_v2 buffer does not check its
> return value. A failing copy leaves princhashlen with uninitialised
> stack contents, which are then used to drive memdup_user() and stored
> as princhash.len on the resulting reclaim record. The other get_user()
> calls in this function all check the return; only this one is missed,
> which is most likely a copy-paste oversight from when v2 upcalls were
> introduced.
>=20
> Mirror the existing pattern used a few lines above for namelen.
> namecopy is declared with __free(kfree) so the early return cleans up
> the already-allocated buffer automatically.
>=20
> Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominik Wo=C5=BAniak <stalion@gmail.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/nfsd/nfs4recover.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -815,7 +815,8 @@ __cld_pipe_inprogress_downcall(const str
>  			if (IS_ERR(name.data))
>  				return PTR_ERR(name.data);
>  			name.len =3D namelen;
> -			get_user(princhashlen, &ci->cc_princhash.cp_len);
> +			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
> +				return -EFAULT;

I think this depends on commit 4552f4e3f2c9 "nfsd: change
nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
older stable branches this failure path appears to leak name.data.

Ben.

>  			if (princhashlen > 0) {
>  				princhash.data =3D memdup_user(
>  						&ci->cc_princhash.cp_data,
>=20
>=20

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner

--=-SbwbxIMGqu+NRlRe6o3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmpKu0QACgkQ57/I7JWG
EQlVqBAAiZHWV9L660yL37qIUzWKGORHj8g8xtLhm+MWdv4MTKZSpjOFt03DN/AZ
bcH/O1oSGXWuVp81ryLbviX4vDbUGwQv4CdPOvc6rbgIq7yvHZwZNPOP5/MAxMjm
t2UFf0ynOPs2quoHc9CRFktSqKGmrfjRLT+U8iJBNQgolRL1gdQJLoniTkhhUIyO
bPyVPfScTG7rpqlYbQWwTzKoo7DgJqN4OQa+jKdVRDjRKQXuBwbjY4f2DpED1reD
rqpgmsoszCNNcYQp0oTqw4IUAoz0+btCVTsQTf942Ag7xLKGdazmEX0Wc/BHY/8y
q2HnG4WUGkognB3ddXgJ210VO2hjiw2jRpfOWtZnXWqmpFciiqQ8mwsBzqld58WQ
rV7Sa7ufIWqG2cQwCxPpSW6y6cBZF9lTswrb7mePop40ASJaxsxz8AQ02L0tWfRp
XXbgysLlPW5ujTN2hhssbL3r3fpjdkPCuMvbYk0GKIqO4wXlsV3NlgsPWiF1W6Jv
jeaKP3FeGZlKAy+Npaic2iYBwepT4mM0MTaEGpmMxb8JniJ4yOv0/iE1EobaloLW
6b3IveWS7WPaUgkeJlfcEM/9T9sZHol4R7SGx5Eo5Z0cO3aaihO0zhUgZ58befWk
Qn+355EgDf/bB/yXWhwV/mrHkdmO+zW7IqKP6FLbHxMfuds42dw=
=xPxv
-----END PGP SIGNATURE-----

--=-SbwbxIMGqu+NRlRe6o3a--
