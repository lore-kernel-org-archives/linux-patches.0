Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B33220CCE4;
	Sat, 17 Jan 2026 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768664936; cv=none; b=LiOHEtFANUfjIfhpcUb2EGSj/lYMHptZ6R4qAvOI6YbBzMeB1KIO1rNnOaYjxYcWcfs66vIjEFFSY2YZHQVBa5W5ajVDCWRu/lhGzGzDHgKB4zseqX2hSo40apUrjrntbZ3m0lY4tWGgyj6cnzfpahv9Yj/bGn6Ig1mqOy2UBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768664936; c=relaxed/simple;
	bh=iga0S41NWhtqJbIm0S40MDluSzxpYWjcEg0D3BtJw4Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dnllaGFUW9/3hvVguguESooCc4BATZ6RhzgZ3h1+goWtOD//G95Mnm3FWUvboVOkUfn5RfgKJsulKtnUFqR14M2aJ9XSFck7VBNdy7WCYpe2Gt5BsUqoP+8ynqKVdzNZvkiq50V0zxW+rYsemnRieXV5IQxilSkTwagQeRmvRtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8Xm-00101K-1G;
	Sat, 17 Jan 2026 15:48:53 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh8Xk-00000000gs9-1P8E;
	Sat, 17 Jan 2026 16:48:52 +0100
Message-ID: <d33f96006e6641fe7a1adbd617dc6ed8a2adcf93.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 122/451] NFS: Label the dentry with a verifier in
 nfs_rmdir() and nfs_unlink()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Trond Myklebust
 <trond.myklebust@hammerspace.com>,  Sasha Levin <sashal@kernel.org>
Date: Sat, 17 Jan 2026 16:48:47 +0100
In-Reply-To: <20260115164235.336895912@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164235.336895912@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GoZhduSJoyUC1t8Fiklb"
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


--=-GoZhduSJoyUC1t8Fiklb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
>=20
> [ Upstream commit 9019fb391de02cbff422090768b73afe9f6174df ]
>=20
> After the success of an operation such as rmdir() or unlink(), we expect
> to add the dentry back to the dcache as an ordinary negative dentry.
> However in NFS, unless it is labelled with the appropriate verifier for
> the parent directory state, then nfs_lookup_revalidate will end up
> discarding that dentry and forcing a new lookup.
>=20
> The fix is to ensure that we relabel the dentry appropriately on
> success.
[...]

It looks like we would need a further fix on top of this:

commit f16857e62bac60786104c020ad7c86e2163b2c5b
Author: NeilBrown <neil@brown.name>
Date:   Fri Aug 19 09:55:59 2022 +1000
=20
    NFS: unlink/rmdir shouldn't call d_delete() twice on ENOENT

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-GoZhduSJoyUC1t8Fiklb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlrr18ACgkQ57/I7JWG
EQnaMA//UDh/MQaMNIpXACsJyV4sEPELofZLiR3LqxRMgG2j5/VL9DldI5EVQVCZ
jGc0d+fDMi61Wej4R+EJCSzfaWZbPHhyX3rg4jFIsQRHGuofpolTN0s2KcFvI2jL
UM3mJW8tBB3GvlF1RKXsElr7NWXKLvUx3awv6S6/1NlDV+wkV89GKFdAO1GVH5KO
vWQzV167Z+BQt2TQQynzyzXJ4LrV9qZkgqWlIFNx6F5umes/mJGrBaVf1JXnEDMZ
2yXSin2GDc/I/B2Ad5o5qloLv+xNwy3I7w+D7kOtCLivbn/BnkWyrZvB6d/gJie6
powkcfzKIVO+bIfk8BMGAFAz8Rng5xd2uXYPNMlchpMjuMBoyYyAHyyDEduJIz1V
YH9K8SvJa/vErcB9aKmu0liacBZjZirSVJvkT5UX13aKndjL6gL2ny3ugeqvb463
+WD+kGw6uhW+ULywYii7EYXOOEq3lzhNwWcupL3qR0PWH9u/W504aSuRaZj47F5H
Hcuz4TeAgCPXbk8p5hY2/G6XpQxu++jZ1hu4ph/o+EppQLU8/hv44xPy2JYXdR1r
SdpozD64BJMRzlN5sMlayD/xWbfPpVRThO1L3AVQUMdKLnLAUbZNgjOIAfufqyKu
QRDbKP2K0FyIK99OFokvvjkBCyo+ycnYn/MqK5Uh9V1aog39A3A=
=Mn8E
-----END PGP SIGNATURE-----

--=-GoZhduSJoyUC1t8Fiklb--
