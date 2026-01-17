Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B5A21ABD0;
	Sat, 17 Jan 2026 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768680529; cv=none; b=Kjo0LZbyAK0g2h2xfObOosfsLrFMMg9l/2lloEf5zwYxYuWsJAmvRV0VaRoBD+tE5bn7qFrpKjLFVU97yCn6uvMVZr+aBS3la1bUJhJcyB6FOmdiG50LlWw63JTZjA+keU2fBucC2aAHVMzbmqbVUshMfjiF+mV0cb8PJLZmdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768680529; c=relaxed/simple;
	bh=YjsYtTXA7URf+8arvxtfe14eaUg3/J1i6XQsS6zF0rc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LJbnbDuA/Ojo7xOKNwb6IuD0hZ/y4CKCbYS9/YPA098H718/zYIkq//QZOFDG4rui4o4KmkS1NdfG0gub1Y4XukiAnXMIChtRlVEl6hKi7SVh+VdU4YN1R00AtRyIR8WKZ7SKGh6BPki5TSNvoYgOnMUIFGlEVjLJI/ekW1NFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCbH-0011bk-0d;
	Sat, 17 Jan 2026 20:08:45 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCbE-00000000jei-3Xy9;
	Sat, 17 Jan 2026 21:08:44 +0100
Message-ID: <b510c4fd58410b0d1125aedcae95a38f28990142.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 205/451] firmware: imx: scu-irq: Init workqueue
 before request mbox channel
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Frank Li <Frank.Li@nxp.com>, Peng Fan
	 <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Sat, 17 Jan 2026 21:08:35 +0100
In-Reply-To: <20260115164238.316830827@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164238.316830827@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y5WopWAc/PUe3YzvupBF"
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


--=-y5WopWAc/PUe3YzvupBF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Peng Fan <peng.fan@nxp.com>
>=20
> [ Upstream commit 81fb53feb66a3aefbf6fcab73bb8d06f5b0c54ad ]
>=20
> With mailbox channel requested, there is possibility that interrupts may
> come in, so need to make sure the workqueue is initialized before
> the queue is scheduled by mailbox rx callback.
[...]

This is an incomplete fix; you also need to pick:

commit ff3f9913bc0749364fbfd86ea62ba2d31c6136c8
Author: Peng Fan <peng.fan@nxp.com>
Date:   Fri Oct 17 09:56:27 2025 +0800
=20
    firmware: imx: scu-irq: Set mu_resource_id before get handle

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-y5WopWAc/PUe3YzvupBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlr7EMACgkQ57/I7JWG
EQksBRAApC11/rqnRdWxkOiIqo1QOi2bpimFHAwNGDYrMruw+n3gFh2+O0iSjism
+9TvfOqa8daU6SF+mCXH7jlIE6v6QkbwHk2Lkudd30wWGwXExKq4DNSN+ZQptqwG
dwVP7L7D4oO9ODH+bio8Lf8lmHC5CgouA/Wk2FRUIPROe/igjUd/1xC4Mg9Jhgn1
tBGdPzvfNnf01Fe2mIOTOLZv3fgj2S/G0L4mk3MHQiRXDu6LhoD6CqZL5A1swGMD
mYnPDKByHaUhfnRWCtcm7hNwuRuY+x7PVBAJ1TgV9DhWtwaWniL+R6Xferxb1gdP
NlchRsHOoJlI+u0oht+yBsi5XNSBMzaqkZ6cYDzGGWKKcYsQXsbkmcWCEGVTr00U
7gtp9256XEjnZRAFcFLn/I1SwiaEi+6X5gGO/uwtf9g7UD4JKVs/YlL9wTsDCyNs
eiVhxi1HRVnSMPKEWSa6RFz7teNS8JWJOHawU2emuv+lZcFrO2W51BIqpxNzE4jr
ui5XHLfPuAYKEzGrOOIJLZx4Kd7pwoOFJEQF4BU36+M24zqEZWytbEB17IJd47oa
85yG6sq3YA9pAUS2tki0nivdOhDNVIkGLPTkgoBwhTuBR6McHOmfKC2XRnEi0Jp6
Y3CeoYlVOBPt4cWlXRKHOtC5+j/VbJcc0vIJX+sTggwItbnN3lI=
=kOv+
-----END PGP SIGNATURE-----

--=-y5WopWAc/PUe3YzvupBF--
