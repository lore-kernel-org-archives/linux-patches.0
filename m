Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B09A33F5A9;
	Wed, 24 Jun 2026 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321250; cv=none; b=pgGD170ANKiNVIRx7B9iGt7l3rCg9sQMkxP+T8PK68tJE6sQ/zn2xZqCltFh8sjIwA910G43aPkYmgS0E8ZrT+BKxTiHXBNuWGjs2QZVWURst6xwupin/Bc9iNFxa+YKGL9SP+FkNkKUeVVFtLRzmRLhuNQd8r9BX7FbnwEhW0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321250; c=relaxed/simple;
	bh=zOA+NRAC3fnoUFbbw5rsQgGbAmrqEGSkAVCK6P8mSvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RO8mdvbuTxBZ21vZY9DttUSOQFFJrd4LVVYO4T0QB9x8ZUq7zlxFL49lJyZr9WmFeSvOI7JnYDGs3ijUGRAkHov4K9jIawJ2iqqrOJxm2QNGyhjx4QIdpX6wfXGI9s85rw/azOeeL++b7Ou77LKdysJMhm7tdmmk3ed0SadB1R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcRAR-0042vN-0z;
	Wed, 24 Jun 2026 17:13:39 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcRAO-000000088WR-2hYd;
	Wed, 24 Jun 2026 19:13:36 +0200
Message-ID: <66cf4f95534aa5428a362857cf78dcb946c51672.camel@decadent.org.uk>
Subject: Re: [PATCH 5.15 323/411] spi: topcliff-pch: fix controller
 deregistration
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Masayuki Ohtake <masa-korg@dsn.okisemi.com>, 
 Johan Hovold <johan@kernel.org>, Mark Brown <broonie@kernel.org>, Sasha
 Levin <sashal@kernel.org>
Date: Wed, 24 Jun 2026 19:13:30 +0200
In-Reply-To: <20260616145118.324999322@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
	 <20260616145118.324999322@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4Hbk2u6isj5YWtDERwLc"
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


--=-4Hbk2u6isj5YWtDERwLc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:29 +0530, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Johan Hovold <johan@kernel.org>
>=20
> [ Upstream commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 ]
[...]

Aside from the issue already pointed out with this backport, the fix is
also missing from the 6.1 and 6.6 branches.

Ben.

--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

--=-4Hbk2u6isj5YWtDERwLc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo8EDsACgkQ57/I7JWG
EQk39BAAkBvHYG5NgAUy6GD8EWNHQhti4b/CS3m8zb9pk56yFbzm6Bfwe77ScShD
3psMgpOtazD/kBN56YEACPUp+iftg8+V9GTQ5MhX71LyAmDpdxd17Q7v/+mZsXUI
cjf5rJH8Ed6bWPqgJgCPaL+4Y+tSdv41ydxqPcKfYMCpFWpKM2Yqm7qSK7cYZ+A1
KN9SUenLZdaDp4wiJSkbUhr5to7xKh2CpJpLOeO6I+MMhkk/0gQ+YSkRJN8IOVZQ
LA0OP21ZSKtu/h9AzCqImt77k1pnpvkGK18lov7y9Nib8yIhFF6M5TCFNWYL7+Zm
1EmLa+iDC+/Qvnsc+snquja3kr7/OT6o30Gov/H7B1IOYK62WYVBWQIWcIV/Og3n
gmg6Goo4sBNXLmKp4EYo5Jx59nPMen7yZPw92sjVdbHWwPuAjtWRDMzXeM1njmQo
IEh58UJ+qhL31nHZwHWrUmT/KA4pEZ0c8NfXg+Jd1YumaYORQStboRT6+2S/3k9B
yYc7lDWtWC6Cybh2tkgyhVkm29idgFFVBWiEfG0unWDkM4lf5LcLdgYvGlHF0znS
wLjplfbzoTZ5vwP3gic9I8Sz2RVaJyNLNCIw2N+aIrs1h9Kd/mY4DOiAqoi1fAi/
2Np2w5y1l75FApHPhhdYF5SKXWFYp7Sn0AvbO1l8BjBiqg+bFys=
=ysk7
-----END PGP SIGNATURE-----

--=-4Hbk2u6isj5YWtDERwLc--
