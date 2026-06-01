Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4C31F99F;
	Mon,  1 Jun 2026 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332369; cv=none; b=mAcn3XB5YYwp8DLTrrygekqYLT+4lV9wCWzXYOsNY0o/Is7LccmTAwugBhgb76mIYTWWeZJZRIvGUJ0GMGSwZ6zF8vGDU2K9jCxgluJZnphkJvCs2yXAPA4+xcE3aDSnyYTmtgBebTlGi9y5XDM0Nqdso3kyP+8obMT/spEQT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332369; c=relaxed/simple;
	bh=3cCCn7y9Xe2Dh4Yr8mYubeJd3ZRnIKQDLhRAIcYsUpI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eyl3/0yL1/ZDu0BLmyYrTFviSHkjvKij5GIk0JsArVSr6X33Y6Sl1bWvY2x34AQWrRaOy82V02sNNPl2HlgHOP7uuWstuVDtL0jVW/rSI4/DrY5vl56oMft/ODhg9keXtK6D3rj8tk5Ftxd8N4xaj8E3lzuxMushMsWMR+fYUzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU5m9-000Wam-1K;
	Mon, 01 Jun 2026 16:46:05 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU5m8-0000000Fj97-30kc;
	Mon, 01 Jun 2026 18:46:04 +0200
Message-ID: <7ccc26ea6552c9fcae1817e2601a96901f0ca261.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 245/589] cpuidle: powerpc: avoid double clear when
 breaking snooze
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Mukesh Kumar Chaurasiya (IBM)"
	 <mkchauras@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>
Date: Mon, 01 Jun 2026 18:46:00 +0200
In-Reply-To: <20260530160231.436997162@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160231.436997162@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2y5jHA2ElOQCtvOrzOpN"
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


--=-2y5jHA2ElOQCtvOrzOpN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Shrikanth Hegde <sshegde@linux.ibm.com>
>=20
> commit 64ed1e3e728afb57ba9acb59e69de930ead847d9 upstream.
>=20
> snooze_loop is done often in any system which has fair bit of
> idle time. So it qualifies for even micro-optimizations.
>=20
> When breaking the snooze due to timeout, TIF_POLLING_NRFLAG is cleared
> twice. Clearing the bit invokes atomics. Avoid double clear and thereby
> avoid one atomic write.
>=20
> dev->poll_time_limit indicates whether the loop was broken due to
> timeout. Use that instead of defining a new variable.

That is only true after commit 5ddcc03a07ae "powerpc/cpuidle: Set
CPUIDLE_FLAG_POLLING for snooze state".  So please drop this for 5.10,
5.15, and 6.1.

Ben.

>=20
> Fixes: 7ded429152e8 ("cpuidle: powerpc: no memory barrier after break fro=
m idle")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
> Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
> Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> Link: https://patch.msgid.link/20260311061709.1230440-1-sshegde@linux.ibm=
.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/cpuidle/cpuidle-powernv.c |    5 ++++-
>  drivers/cpuidle/cpuidle-pseries.c |    5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -93,7 +93,10 @@ static int snooze_loop(struct cpuidle_de
> =20
>  	HMT_medium();
>  	ppc64_runlatch_on();
> -	clear_thread_flag(TIF_POLLING_NRFLAG);
> +
> +	/* Avoid double clear when breaking */
> +	if (!dev->poll_time_limit)
> +		clear_thread_flag(TIF_POLLING_NRFLAG);
> =20
>  	local_irq_disable();
> =20
> --- a/drivers/cpuidle/cpuidle-pseries.c
> +++ b/drivers/cpuidle/cpuidle-pseries.c
> @@ -61,7 +61,10 @@ static int snooze_loop(struct cpuidle_de
>  	}
> =20
>  	HMT_medium();
> -	clear_thread_flag(TIF_POLLING_NRFLAG);
> +
> +       /* Avoid double clear when breaking */
> +	if (!dev->poll_time_limit)
> +		clear_thread_flag(TIF_POLLING_NRFLAG);
> =20
>  	local_irq_disable();
> =20
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-2y5jHA2ElOQCtvOrzOpN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodt0gACgkQ57/I7JWG
EQlZlA/+NIBzaU+8ml5d4b5meSjS4deXdfkhd8//cs24lh8hZpTsAepxkrIuQ14p
kG4H9dJ6UAmppFv4qSrUJOTPoL6+0KT/YfNEuW88NvK7rKK05O1hkUyXOEG01I4c
CwENRvIk2etB28A9YNtcjm+tauQrScyRaToyn43Nb2E2UopBt9eyyfaZPaNEnZMY
tzeSMCQSrO+EL47QTZXUujylgVhecpxeAzwaMopR3pexNCn/pTOemSc3stqJVrjR
FmExpm7As9s/bAVCd+APlxjNA8mzdIpWU4f+JMkR497QVC2ARZMUAi4LZ5McQZSL
NEmlNIfJfyF/wo3gqBbQfsEwSSrjNF55JL1pBcJPpk2bTFQayXNf0mfH08dwtZ+Q
OmWmE4/r2/zDmt2yIFMMgo/jI48ioJwQexnpMYIMEMPpnuE6IVe1gadm9kLqxrmR
G6H58A90np5D2ixui/h4qN+U406VepuXtbBD+SIZ05TQbmFU9h0bG2HLl+Ox88SD
5oolI7Ge4c9xYy7jdOLYg9gMASQNPVEte8+yyU1EJXOm5unTkfzY3WfLgR6Z/Zex
mYBhlNG/OQrpyW/t+HsFNpLbSM7gytvSEAX/DdeuA5Uajwc0tV/iL018hwHGQ6Bw
wDu49FZ4Ycau57NQL70UwfJF8tTXbzSwKnmToaNJIlGnxPhH7P8=
=LEz5
-----END PGP SIGNATURE-----

--=-2y5jHA2ElOQCtvOrzOpN--
