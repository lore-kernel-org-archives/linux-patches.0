Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ED714D29B;
	Sun, 18 Jan 2026 11:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768734546; cv=none; b=dK/vhMXO/u6ktKrh0YI+52hbrE5J6JTIHbuCLTI4gld5TgrmSE58/L3IS2J5aJnXCdCP3la5j66aTfLLrgvs/K5VQE3d2vHTpESnP9bcxY6GZy6GYiDRTV1RLsx+TMHlfbmm3A61pAr1E4VGwJi3GUMda+3c3LTq4dnFnXhF3VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768734546; c=relaxed/simple;
	bh=Fu+mb3UvAhhhnJPY9c4QDc8GHrZ1k0mlayNZqCnUZzo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uJn4FaEJPbT6XCay8UuiyXzVAzsM2RV/pR+TYOYXEuQpg549Pgig29SUF6acquQPhorcOibELuMBqqG9UXDYsqQteeFYD8iWXemOV8pHtUTiOuZXWJ3JLcjwv6MGU31hv6xOF5Jxw3uSn/UH44pp94V2ZY9nbwH4r9C4Z2sZ2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhQeV-0016Lq-0i;
	Sun, 18 Jan 2026 11:09:01 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhQeS-00000000mP5-1Up3;
	Sun, 18 Jan 2026 12:09:00 +0100
Message-ID: <b50803c9347a3c49bff42608fc9c9ea9e117a96f.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 205/451] firmware: imx: scu-irq: Init workqueue
 before request mbox channel
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Frank Li
 <Frank.Li@nxp.com>,  Peng Fan <peng.fan@nxp.com>, Shawn Guo
 <shawnguo@kernel.org>, Sasha Levin <sashal@kernel.org>
Date: Sun, 18 Jan 2026 12:08:54 +0100
In-Reply-To: <2026011806-uncapped-marvelous-d81b@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164238.316830827@linuxfoundation.org>
	 <b510c4fd58410b0d1125aedcae95a38f28990142.camel@decadent.org.uk>
	 <2026011806-uncapped-marvelous-d81b@gregkh>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WnzPdpzxldFj1GtzC9Vo"
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


--=-WnzPdpzxldFj1GtzC9Vo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-01-18 at 09:42 +0100, Greg Kroah-Hartman wrote:
> On Sat, Jan 17, 2026 at 09:08:35PM +0100, Ben Hutchings wrote:
> > On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Peng Fan <peng.fan@nxp.com>
> > >=20
> > > [ Upstream commit 81fb53feb66a3aefbf6fcab73bb8d06f5b0c54ad ]
> > >=20
> > > With mailbox channel requested, there is possibility that interrupts =
may
> > > come in, so need to make sure the workqueue is initialized before
> > > the queue is scheduled by mailbox rx callback.
> > [...]
> >=20
> > This is an incomplete fix; you also need to pick:
> >=20
> > commit ff3f9913bc0749364fbfd86ea62ba2d31c6136c8
> > Author: Peng Fan <peng.fan@nxp.com>
> > Date:   Fri Oct 17 09:56:27 2025 +0800
> > =20
> >     firmware: imx: scu-irq: Set mu_resource_id before get handle
>=20
> How did you determine this?  There's no "Fixes:" tag to give us a clue
> as to if it's needed anywhere or not.

I looked at the first fix and asked myself "what other initialisation
does the interrupt handler depend on?", and then I found this.  I think
all versions of the driver need both fixes.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-WnzPdpzxldFj1GtzC9Vo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlsv0YACgkQ57/I7JWG
EQm1xw/8CNtbs9WNCs5gob2zDyiQJbrTfuUSA/POy7MFKWJKVu/Y6UN3YspSN/9n
wSGaP73GWZ7xYMIQnC9qMwbAx7puUw4zEISBeJQL4Vs/LCtCHL5aW75VnmXIlZ8Z
8AYWLB0wZkTbkIyBegtebs0X9+pt3CCa9Cd3yWtg0y8lWzeto0p47aduaBWOta4E
F8H+aO1NU5MtUdn0Y2rsEKvxQs3UHm5SmKXM/xaKFzNJtCP81jOUN26c8scL3eN/
uL51MwQowZQnbj4Md7jKnKJ5unsK9muB1DxP26AA9UyRcfbHClMqOfXBOPypO9Mo
xkl1Y2EAr5TP2QwVk8lM7jTSVnJXDtu5i0meZXq9VKxYAknTrte8Q/PB8KCmQh5A
trH+//1WIGO8wsaiF6xox3Oq/oQFHZGKDiW/czCLY2CvJpbNRmpl9/So/eouXVEZ
JwZFyoBk8xZCkQwnG7gs4M0dsCYg+8fLy1T4o1ymleqT0mtULWft07pVK3S8PlG/
slUAnXaXWuu5pjeSHh/IwcEa0zt4eSjCRT8Bc68AQ4BeC+diwISPC6GAKcnXhFMY
4+vtUUdNH6gSvt9yRCedDd5VunkPezxt/0NNMCLvSrxggVBhN/q2bnUTN9MzEz4n
gaP71oQAfuSKbb8V+HD4wX7otSHDScsshVt4JPqb5aPH/ZiRzqI=
=+rEr
-----END PGP SIGNATURE-----

--=-WnzPdpzxldFj1GtzC9Vo--
