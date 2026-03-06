Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C882202C29;
	Fri,  6 Mar 2026 19:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772826568; cv=none; b=HJWtzFnpF8S+EfBADKVe6SvD9/tw6Sjf49GblkhFT37T7kcC1V4UUAnE9jMhZ5YNv09GhG5mi/OmBUo3TvDYCJjl7tQVxI2i7icS/MncvINRa4hOKBBVvwPwcEEkVF+regzXSccxHuFjp5msvt6hfVzlMspo5ZesrEfV9GPBdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772826568; c=relaxed/simple;
	bh=Y4LpghtqTvBEToK1pnNheT0qGnqA2EQilqUMUYxz+s0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hqGoNaEt/5P+VwioLC/9nLsmdrHeLTuLibjZ4PB7PoxplGdyeGnviHl1kKCDiPeFiWD04OHX+5W9mHplcJGndHX4hiNmaed3MvPLzA0YKcPj3sjmU6JVSLBYXMeJpRPEjK2IRCCC8ooqafbTwxE9B6Of+ip6X8Cj0gsUvVqwsKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vyahZ-004HFB-1b;
	Fri, 06 Mar 2026 19:19:08 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vyahW-000000096WU-3Mh9;
	Fri, 06 Mar 2026 20:19:06 +0100
Message-ID: <992df439ca66e562353d285642c6ab8e1c69e2e6.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, 	shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, 	pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, 	sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, 	broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
Date: Fri, 06 Mar 2026 20:19:01 +0100
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
References: <20260302161007.2523181-1-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Rkz5Bqyseds8F/QVY6Lt"
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


--=-Rkz5Bqyseds8F/QVY6Lt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-03-02 at 11:10 -0500, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.

And yet they were not.

> If anyone has any issues with these being applied, please
> let me know.

I can some issues, such as these feature additions being backported:

[...]
> Rui Feng (1):
>   misc: rtsx: Add SD Express mode support for RTS5261
[...]
> Ulf Hansson (1):
>   mmc: core: Initial support for SD express card/host
[...]

supposedly as dependencies of:

> Matthew Schwartz (1):
>   mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

But it doesn't depend on them.  And it also got reverted in this same
series.  So backporting the "dependencies" just introduced risk with no
benefit.

Meanwhile, the stable-specific regressions in recent 5.10.y stable
releases (affecting ARM memset64() and IPv6 tunnels) were not addressed
in 5.10.252.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-Rkz5Bqyseds8F/QVY6Lt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmrKKUACgkQ57/I7JWG
EQliLg/+IU3vmvrRAhT8qTYuBWCCaVhqmnteqDBlT45GmCAEKR1EWSXjLPazN0d3
9/CJ+XSE5ZsGMp8xIU3qET9bJqAshnFfOheqrtgUSRUfwpLbXKCs1sbmSr7BLLWL
OUUrgGqx0svANn0iodybOP3LjtJ7GDzLKai0K24/UHlMXQzdeWaoDbIy9e0LS78S
dM0xs7BIrIIIo0+6LmfGu8h/P8jiW2O31ritqsJCq9L55HzyXBzwtHwZZ+eZLAqD
PVTaJV+L0dpkmOFQyKXCbc8EQMzQJxUS/2aTq4K9i/xvBKsKGDV0VolszIjlsZ16
QalWJbP3uG/ElPJ0Andx40YFX+NfITxmTsMZKCQmYI4QTnNZv/3MnUt7PDuVxH7M
oD5+iYlsOH8+bjNvb2tHJniPiBV2gjQ2wjhWWm4m9kCw7YhG/rGv+RRCCvsXcbH6
oDL+k8OdEXXA6UfUoTIhN3OvPKKKx11XHitR2JZ+xtYr7A4oxLpKhp9KK5M6tHIN
2gsKPlRVF/EiRItM4ZdZe7AlM8Wn+ryvj8eXcA94o89ZhFajwbepufSj0/XM59OI
eTYXkNcARVGeZ1ok7nOlYK46Cn+fNYdmGk0UcGC8bSxWpyRw5ZHnZKWcbvObkKQN
9fODHJfMvFUnkiD/SkXNhQHIdcyYN/sYyEZ3rT1CNpxoUv69dMY=
=nloe
-----END PGP SIGNATURE-----

--=-Rkz5Bqyseds8F/QVY6Lt--
