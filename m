Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954C50094B;
	Sat, 17 Jan 2026 15:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768665038; cv=none; b=T2q9hoqdGhRju3f3IxlxvDwbSYSZL4M1xLeryTs8i1Vn/gbik8tBbLOYIye0tIkGxC/5ernwSzmyU0ZKGVByL8fGBvKSrP0fWkfzzDUOG/DUMFszNbOIACKou8T8Dev2wwHl8Rj0exf4Kyhp17OjYNwPg0A0qwAJoBs82rpGMlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768665038; c=relaxed/simple;
	bh=oC9ycDmb3QPZUpTtMYcPUXbGuVu9cIQhGee7FCFopNM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VYC/bnXUuev3jLp9NO0yz43o5Shl9V2DSrOiBuer4CXN5I24Msu0rnffAWrKPLkPWP+VM5dc3a3o6ATsUR44pnyKndzcS6rZc/5NpN1o4kI0wKIZJoZlUbuCzmikvjFGFZgMYg8mLT4aokASF3ntWkYWEhPxd6iWF5EmNq4/OpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8ZP-00102A-2P;
	Sat, 17 Jan 2026 15:50:34 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8ZN-00000000gwd-0hr0;
	Sat, 17 Jan 2026 16:50:33 +0100
Message-ID: <99bc0d89d837b64727ccfce7e93fe3bd89f29cb5.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 123/451] NFS: dont unhash dentry during
 unlink/rename
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, NeilBrown <neilb@suse.de>, Trond Myklebust
	 <trond.myklebust@hammerspace.com>, Sasha Levin <sashal@kernel.org>
Date: Sat, 17 Jan 2026 16:50:32 +0100
In-Reply-To: <20260115164235.372390370@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164235.372390370@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ykux3M16hE3ms+jjEOsi"
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


--=-Ykux3M16hE3ms+jjEOsi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: NeilBrown <neilb@suse.de>
>=20
> [ Upstream commit 3c59366c207e4c6c6569524af606baf017a55c61 ]
>=20
> NFS unlink() (and rename over existing target) must determine if the
> file is open, and must perform a "silly rename" instead of an unlink (or
> before rename) if it is.  Otherwise the client might hold a file open
> which has been removed on the server.
[...]

It looks like we need yet another fix after this:

commit 99bc9f2eb3f79a2b4296d9bf43153e1d10ca50d3
Author: NeilBrown <neil@brown.name>
Date:   Tue May 28 13:27:17 2024 +1000

    NFS: add barriers when testing for NFS_FSDATA_BLOCKED

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-Ykux3M16hE3ms+jjEOsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlrr8gACgkQ57/I7JWG
EQn8PQ/9GrN9/2fIag75Ur7vBHpy7LWdZDpVZNpuL7xSgESdXnaFo2RCVy3/mZ/o
/tQ3m/wlpo4FNZ9zxHzmNSYZHL91KdAaxuiehLFq1WkhfI+v4ePUrt8TS4k/wDJQ
U/HVTjn0OsBYeivL2KKXvqRj1SSpHdOXklnrQYkentKuwRfmLzsLT/rri0R5LgxF
8jGo3Q7qjZlZevcTK55OjBJA1hGia6BrJi9MxXUlcYyRjQbsz3OXISoxPAAikdhU
suJhOLg2VoMQhumsTX6z6OfziupZrmOxB3eNS3HWEz85TiwnMsAd9XkMJ9lctlCS
Y6Xz6aQAu0DC6I595KewVROiDRZ6DHAcQy2fgJQIJPdPQYqishbTrt6PjB7ifTtg
CKc/ojWxBvMIrPpsOAaQkh+fW7zRsJgkUGtcNQ+eWlrtdmFdLQp181sWatFWWYYL
9RBSzVImMIVibqEkJIU8qoMYzDVisa9GhtzRyrihahcx/n2EsxtybmKW1ts5sWIt
rluSmpNEDid+w+upaqqq9EwnTR479AIc0BbDE7AZ93se+9zTPYsHPgsnue7dX50a
Hxips10lOeqpK6GgH6X5KmtBq0nvyQME+T9Ydf60+C2+LpMmTarzo+tZ5BgYIzCI
LAA870R4c2HScCjFONKHGg7wm6knhKV5RdSj4RIaXiZc2MttqUI=
=Q34I
-----END PGP SIGNATURE-----

--=-Ykux3M16hE3ms+jjEOsi--
